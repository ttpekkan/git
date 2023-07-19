module UsefulFunctions
include("Parameters.jl")
include("ReactionCoordinateAndPotential.jl")
using .Parameters
using .ReactionCoordinateAndPotential
using LinearAlgebra
using StaticArrays
using DelimitedFiles
using SpecialFunctions
using Dierckx

export readFragmentInput, sumOfStates, canonicalAverage
export Qt, Qr, Qv, QvClassical, ρEvClassical, convolve, convolveClassical

function readFragmentInput(fileName)

    cartesians = readdlm(fileName)
    mass = 0.0
    CM = SizedMatrix{3,1}(zeros(3, 1))

    #Get centre of mass
    for i in axes(cartesians, 1)
        mass = mass + masses[cartesians[i, 1]]
        CM = CM .+ masses[cartesians[i, 1]] * cartesians[i, 2:4]
    end
    CM = CM / mass

    #Subract it from the coordinates
    for i in axes(cartesians, 1)
        cartesians[i, 2:4] = cartesians[i, 2:4] .- CM
    end

    #Compute moments of inertia
    I = SizedMatrix{3,3}(zeros(3, 3))
    for i in axes(cartesians, 1)
        I[1, 1] = I[1, 1] + masses[cartesians[i, 1]] * (cartesians[i, 3]^2 + cartesians[i, 4]^2)
        I[2, 2] = I[2, 2] + masses[cartesians[i, 1]] * (cartesians[i, 2]^2 + cartesians[i, 4]^2)
        I[3, 3] = I[3, 3] + masses[cartesians[i, 1]] * (cartesians[i, 2]^2 + cartesians[i, 3]^2)
        I[2, 1] = I[2, 1] - masses[cartesians[i, 1]] * (cartesians[i, 2] * cartesians[i, 3])
        I[3, 1] = I[3, 1] - masses[cartesians[i, 1]] * (cartesians[i, 2] * cartesians[i, 4])
        I[3, 2] = I[3, 2] - masses[cartesians[i, 1]] * (cartesians[i, 3] * cartesians[i, 4])
    end
    I[1, 2] = I[2, 1]
    I[1, 3] = I[3, 1]
    I[2, 3] = I[3, 2]

    return mass, sort(eigvals(I)) * 8π^2 * c * amu * 100 * (1.0e-10)^2 / h    #Return total mass (amu) and inverses of rotational constants (cm), descending order
end

#Function to evalute N^‡ with crude Monte-Caro integration. 
function sumOfStates(E, J, rc, μ, I::SizedMatrix{3,2}, n)

    #!!!Adjust as needed!!!#
    tolerance = 1.0e-2 #If the relative change in the integral values is smaller than 'tolerance' after 'sampleSize' additional samples, the calculation has converged.  
    sampleSize = 1000
    ########################

    totalPoints = 0
    sampleCounter = 0
    MCsum = 0.0
    MCsumPrevious = 0.0

    B = SizedMatrix{3,3}(zeros(3, 3))
    while true
        ν = rand() * 2π
        η = acos(2 * rand() - 1.0)
        ϕ1 = rand() * 2π
        θ1 = acos(2 * rand() - 1.0)
        ϕ2 = rand() * 2π
        θ2 = acos(2 * rand() - 1.0)
        χ = rand() * 2π
        if (θ1 < 1.0e-10 || θ2 < 1.0e-10) #This is just to avoid division by zero issues. These events should be fantastically rare. 
            continue
        end
        sampleCounter = sampleCounter + 1
        totalPoints = totalPoints + 1

        MCsum = MCsum + MCFunction(E, J, ν, η, ϕ1, θ1, ϕ2, θ2, χ, rc, μ, I, B, n)

        if sampleCounter > sampleSize
            if MCsum < 1.0e-10                  #This can happen if there are no coordinate values that satisfy the E - Erot -V(q) > 0 condition. In this case the integral is set to zero. 
                MCsum = 0.0
                break
            end
            Δrel = abs((MCsum / totalPoints - MCsumPrevious) / (MCsum / totalPoints))
            if Δrel < tolerance                   #Calculation has converged 
                break
            else
                sampleCounter = 0
                MCsumPrevious = MCsum / totalPoints
            end
        end
    end
    if n == 4                   #Integration volumes for the different cases. 
        MCsum = MCsum * 8π
    elseif n == 5
        MCsum = MCsum * 16π^2
    elseif n == 6
        MCsum = MCsum * 32π^2
    elseif n == 7
        MCsum = MCsum * 64π^3
    else
        MCsum = MCsum * 128π^4
    end
    #return  2.0^(4.0-n) * π^((3.0-n)/2.0) / (Γ((n-1.0)/2.0)) * (J^2 / h) * MCsum / totalPoints  #This gives N(E,J) per unit J (SI units)
    return 2.0^(3.0 - n) * π^((1.0 - n) / 2.0) / (Γ((n - 1.0) / 2.0)) * J^2 * MCsum / totalPoints  #This gives N(E,J) per unit ħ. The above multiplied with h/2π.


end

function MCFunction(E, J, ν, η, ϕ1, θ1, ϕ2, θ2, χ, rc, μ, I::SizedMatrix{3,2}, B::SizedMatrix{3,3}, n)

    I1a = I[1, 1]
    I1b = I[2, 1]
    I1c = I[3, 1]
    I2a = I[1, 2]
    I2b = I[2, 2]
    I2c = I[3, 2]
    rcCM = F(ϕ1, θ1, ϕ2, θ2, χ, rc)                       #Reaction coordinate is user-defined 
    Iex = μ * rcCM^2

    Σ1Plus = I1b * cos(ϕ1)^2 + I1c * sin(ϕ1)^2
    Σ1Minus = I1b * sin(ϕ1)^2 + I1c * cos(ϕ1)^2
    Σ2Plus = I2b * cos(ϕ2)^2 + I2c * sin(ϕ2)^2
    Σ2Minus = I2b * sin(ϕ2)^2 + I2c * cos(ϕ2)^2
    ΔC1 = (I1c - I1b) * cos(θ1) * cos(ϕ1) * sin(ϕ1)
    ΔS1 = (I1c - I1b) * sin(θ1) * cos(ϕ1) * sin(ϕ1)
    ΔC2 = (I2c - I2b) * cos(θ2) * cos(ϕ2) * sin(ϕ2)
    ΔS2 = (I2c - I2b) * sin(θ2) * cos(ϕ2) * sin(ϕ2)

    B[1, 1] = I1a * sin(θ1)^2 + Σ1Minus * cos(θ1)^2 + (I2a * sin(θ2)^2 + Σ2Minus * cos(θ2)^2) - 2ΔC2 * cos(χ) * sin(χ) + Σ2Plus * sin(χ)^2 + Iex
    B[2, 1] = ΔC1 + ΔC2 * (2 * cos(χ)^2 - 1.0) + (Σ2Minus * cos(θ2)^2 - Σ2Plus + I2a * sin(θ2)^2) * sin(χ) * cos(χ)
    B[3, 1] = (Σ1Minus - I1a) * cos(θ1) * sin(θ1) - ΔS2 * sin(χ) + (Σ2Minus - I2a) * cos(θ2) * sin(θ2) * cos(χ)
    B[1, 2] = B[2, 1]
    B[2, 2] = Σ1Plus + Σ2Plus * cos(χ)^2 + I2a * sin(θ2)^2 * sin(χ)^2 + Σ2Minus * cos(θ2)^2 * sin(χ)^2 + 2ΔC2 * cos(χ) * sin(χ) + Iex
    B[3, 2] = ΔS1 + ΔS2 * cos(χ) + (Σ2Minus - I2a) * cos(θ2) * sin(θ2) * sin(χ)
    B[1, 3] = B[3, 1]
    B[2, 3] = B[3, 2]
    B[3, 3] = Σ1Minus * sin(θ1)^2 + I1a * cos(θ1)^2 + Σ2Minus * sin(θ2)^2 + I2a * cos(θ2)^2
    #Π = (Σ2Minus - I2a) * cos(θ2) * sin(θ2)

    Ia, Ib, Ic = eigvals(B)
    ϵ = E - Erot(J, Ia, Ib, Ic, ν, η) - Vtr(ϕ1, θ1, ϕ2, θ2, χ, rcCM) #The potential is user-defined.

    if Heaviside(ϵ) == 0
        return 0.0
    else
        if I1a > 1.0e-3
            G44 = 1.0 / (Iex * sin(θ1)^2) + 1.0 / I1a + (cos(θ1)^2 / sin(θ1)^2) * (sin(ϕ1)^2 / I1b + cos(ϕ1)^2 / I1c)
        else
            G44 = 0.0
        end
        G45 = ΔC1 / (I1b * I1c * sin(θ1))
        G46 = cos(χ) / (Iex * sin(θ1) * sin(θ2))
        G47 = sin(χ) / (Iex * sin(θ1))
        G48 = cos(θ1) / (Iex * sin(θ1)^2) + (cos(θ1) / sin(θ1)^2) * (sin(ϕ1)^2 / I1b + cos(ϕ1)^2 / I1c) - cos(θ2) * cos(χ) / (Iex * sin(θ1) * sin(θ2))

        G55 = (sin(ϕ1)^2 * I1b + cos(ϕ1)^2 * I1c) / (I1b * I1c) + 1.0 / Iex
        G56 = sin(χ) / (Iex * sin(θ2))
        G57 = cos(χ) / Iex
        G58 = cos(θ2) * sin(χ) / (Iex * sin(θ2)) + (1.0 / I1b - 1.0 / I1c) * cos(ϕ1) * sin(ϕ1) / sin(θ1)

        if I2a > 1.0e-3
            G66 = 1.0 / (Iex * sin(θ2)^2) + 1.0 / I2a + (cos(θ2)^2 / sin(θ2)^2) * (sin(ϕ2)^2 / I2b + cos(ϕ2)^2 / I2c)
        else
            G66 = 0.0
        end
        if I2b > 1.0e-3
            G67 = ΔC2 / (I2b * I2c * sin(θ2))
            G68 = cos(θ2) / (Iex * sin(θ2)^2) + (cos(θ2) / sin(θ2)^2) * (sin(ϕ2)^2 / I2b + cos(ϕ2)^2 / I2c) - cos(θ1) * cos(χ) / (Iex * sin(θ1) * sin(θ2))
            G77 = (sin(ϕ2)^2 * I2b + cos(ϕ2)^2 * I2c) / (I2b * I2c) + 1.0 / Iex
            G78 = cos(θ1) * sin(χ) / (Iex * sin(θ1)) + (1.0 / I2b - 1.0 / I2c) * cos(ϕ2) * sin(ϕ2) / sin(θ2)
            G88 = 1.0 / sin(θ1)^2 * (sin(ϕ1)^2 / I1b + cos(ϕ1)^2 / I1c) + 1.0 / sin(θ2)^2 * (sin(ϕ2)^2 / I2b + cos(ϕ2)^2 / I2c) + (1.0 - cos(2θ1) * cos(2θ2) + sin(2θ1) * sin(2θ2) * cos(χ)) / (2 * Iex * sin(θ1)^2 * sin(θ2)^2)
        else
            G67 = 0.0
            G68 = 0.0
            G77 = 0.0
            G78 = 0.0
            G88 = 0.0
        end
        ∂F_∂ϕ1, ∂F_∂θ1, ∂F_∂ϕ2, ∂F_∂θ2, ∂F_∂χ = ∇F(ϕ1, θ1, ϕ2, θ2, χ, rcCM)

        detA = 1.0 + μ * (∂F_∂ϕ1^2 * G44 + ∂F_∂θ1^2 * G55 + ∂F_∂ϕ2^2 * G66 + ∂F_∂θ2^2 * G77 + ∂F_∂χ^2 * G88 +
                          2 * (∂F_∂ϕ1 * ∂F_∂θ1 * G45 + ∂F_∂ϕ1 * ∂F_∂ϕ2 * G46 + ∂F_∂ϕ1 * ∂F_∂θ2 * G47 + ∂F_∂ϕ1 * ∂F_∂χ * G48 +
                               ∂F_∂θ1 * ∂F_∂ϕ2 * G56 + ∂F_∂θ1 * ∂F_∂θ2 * G57 + ∂F_∂θ1 * ∂F_∂χ * G58 +
                               ∂F_∂ϕ2 * ∂F_∂θ2 * G67 + ∂F_∂ϕ2 * ∂F_∂χ * G68 +
                               ∂F_∂θ2 * ∂F_∂χ * G78)
        )

        #println(∂F_∂ϕ1^2 * G44, ' ', ∂F_∂θ1^2 * G55, ' ', ∂F_∂ϕ2^2 * G66, ' ',∂F_∂θ2^2 * G77, ' ', ∂F_∂χ^2 * G88)
        #println(∂F_∂ϕ1 * ∂F_∂θ1 * G45, ' ', ∂F_∂ϕ1 * ∂F_∂ϕ2 * G46, ' ', ∂F_∂ϕ1 * ∂F_∂θ2 * G47, ' ', ∂F_∂ϕ1 * ∂F_∂χ * G48)
        #println(∂F_∂θ1 * ∂F_∂ϕ2 * G56, ' ', ∂F_∂θ1 * ∂F_∂θ2 * G57, ' ', ∂F_∂θ1 * ∂F_∂χ * G58)
        #println(∂F_∂ϕ2 * ∂F_∂θ2 * G67, ' ', ∂F_∂ϕ2 * ∂F_∂χ * G68)
        #println(∂F_∂θ2 * ∂F_∂χ * G78)
        #exit()

        if n == 8                                                       #The sin(θ)^2 elements are incorporated in the Monte-Carlo volume element. 
            detA = detA * (Iex^2 * I1a * I1b * I1c * I2a * I2b * I2c)
        elseif n == 7
            detA = detA * (Iex^2 * I1a * I1b * I1c * I2b * I2c)
        elseif n == 6
            detA = detA * (Iex^2 * I1b * I1c * I2b * I2c)
        elseif n == 5
            detA = detA * (Iex^2 * I1a * I1b * I1c)
        elseif n == 4
            detA = detA * (Iex^2 * I1b * I1c)
        end
        return (detA / det(B))^0.5 * ϵ^((n - 3.0) / 2.0)
    end
end

#For testing the easy atom-diatom case. 
function MCFunctionAtomDiatom(E, J, ν, η, ϕ1, θ1, ϕ2, θ2, χ, rc, μ, I::SizedMatrix{3,2}, B::SizedMatrix{3,3}, n)

    I1a = I[1, 1]
    I1b = I[2, 1]
    I1c = I[3, 1]
    I2a = I[1, 2]
    I2b = I[2, 2]
    I2c = I[3, 2]
    rcCM = F(ϕ1, θ1, ϕ2, θ2, χ, rc)                       #Reaction coordinate is user-defined 
    Iex = μ * rcCM^2

    B[1, 1] = I1c * cos(θ1)^2 + Iex
    B[2, 1] = 0.0
    B[3, 1] = I1c * cos(θ1) * sin(θ1)
    B[1, 2] = B[2, 1]
    B[2, 2] = I1c + Iex
    B[3, 2] = 0.0
    B[1, 3] = B[3, 1]
    B[2, 3] = B[3, 2]
    B[3, 3] = I1c * sin(θ1)^2

    Ia, Ib, Ic = eigvals(B)
    ϵ = E - Erot(J, Ia, Ib, Ic, ν, η) - Vtr(ϕ1, θ1, ϕ2, θ2, χ, rcCM) #The potential is user-defined.

    if Heaviside(ϵ) == 0
        return 0.0
    else
        ∂F_∂ϕ1, ∂F_∂θ1, ∂F_∂ϕ2, ∂F_∂θ2, ∂F_∂χ = ∇F(ϕ1, θ1, ϕ2, θ2, χ, rcCM)
        G55 = 1.0 / Iex + 1.0 / I1c
        return (1.0 + μ * (∂F_∂θ1^2 * G55)) * ((Iex^2 * I1b * I1c) / det(B))^0.5 * ϵ^((n - 3.0) / 2.0)
    end
end

function Heaviside(E)
    if E ≥ 0.0
        return 1
    else
        return 0
    end
end

function Γ(n)
    return gamma(n)
end

function Erot(J, Ia, Ib, Ic, ν, η)
    #return (J^2 / 2) * ((sin(ν)^2 / Ia + cos(ν)^2 / Ib) * sin(η)^2 + cos(η)^2 / Ic)
    return J^2 * ((sin(ν)^2 / Ia + cos(ν)^2 / Ib) * sin(η)^2 + cos(η)^2 / Ic)                    #Note! The factor 1/2 is missing due to us working in inverse rotational constants (Erot = (B^(-1)J^2, [B^{-1}] = cm ) 
end

function Qt(μ, β)                                     #Translational partition function value returned in 1/m^3 for the relative motion. 
    return (μ / (4π * 1.0e-10^2 * β))^1.5                               #Some unit conversions as μ was used in cm-1. 
end

function Qr(Ia, Ib, Ic, β)          #Rotational partition function. Symmetry numbers NOT included. 
    if Ib < 1.0e-3
        return 1.0      #atom 
    elseif Ia < 1.0e-3
        return Ic / β #linear molecule       
    else
        return (π * Ia * Ib * Ic / (β^3))^0.5  #non-linear polyatomic molecule
    end
end

function canonicalAverage(NESpline::Spline1D, β, Emax)
    BoltzmannAverage = 0.0
    for i = 1:round(Int, Emax)
        BoltzmannAverage = BoltzmannAverage + (NESpline(1.0 * (i - 1)) * exp(-(i - 1) * β) + NESpline(1.0 * i) * exp(-i * β)) / 2.0 #Integration grid 1 cm-1. 
    end
    return BoltzmannAverage
end

function Qv(ν::Array{}, β)                              #quantum-mechanical partition function for n harmonic oscillators 
    νtot = 1.0
    for i = 1:length(ν)
        #νtot = νtot * exp(-ν[i]*β/2) / (1 - exp(-ν[i]*β))
        νtot = νtot * 1.0 / (1 - exp(-ν[i] * β))
    end
    return νtot
end

function QvClassical(ν::Array{}, β)                    #Classical partition function for s harmonic oscillators 
    νtot = 1.0
    s = length(ν)
    for i = 1:s
        νtot = νtot * ν[i] * β
    end
    return νtot^(-1.0)
end

function ρEvClassical(ν::Array{}, E)                   #Classical densities of states for s harmonic oscillators. 
    s::Int32 = length(ν)
    if s == 1
        return ν[1]^(-1.0)
    else
        ρ = 1.0
        for i = 1:s
            ρ = ρ * ν[i]
        end
        return ρ^(-1.0) * E^(s - 1) / Γ(1.0 * s)
    end
end

function convolve(NE::Array{}, freqs::Array{}, Emax)     #Direct count convolution of harmonic and translational modes. 
    Ntr = Spline1D(NE[:, 1], NE[:, 2])
    NE = zeros(round(Int, Emax) + 1, 2)
    intArray = Array{Int32}(round.(freqs))
    for i = 0:size(NE, 1)-1
        NE[i+1, 1] = 1.0 * i
        NE[i+1, 2] = Ntr(1.0 * i)
    end
    for i = 1:size(intArray, 1)
        for j = intArray[i]:round(Int, Emax)
            NE[j+1, 2] = NE[j+1, 2] + NE[j+1-intArray[i], 2]
        end
    end
    return Spline1D(NE[:, 1], NE[:, 2])
end

function convolveClassical(NE::Array{}, freqs::Array{}, Emax)    #Classical convolution of harmonic and translational modes. 
    Ntr = Spline1D(NE[:, 1], NE[:, 2])
    NE = zeros(round(Int, Emax) + 1, 2)
    NE[1, 1] = 0.0
    NE[1, 2] = 0.0
    Threads.@threads for i = 1:size(NE, 1)-1
        NE[i+1, 1] = 1.0 * i
        for j = 1:i
            NE[i+1, 2] = NE[i+1, 2] + (Ntr(1.0 * j - 1) * ρEvClassical(freqs, (i - (j - 1)) * 1.0) + Ntr(1.0 * j) * ρEvClassical(freqs, (i - j) * 1.0)) / 2.0
        end
    end
    return Spline1D(NE[:, 1], NE[:, 2])
end

end