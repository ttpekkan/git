#FTST CODE# 
include("Parameters.jl")
include("UsefulFunctions.jl")
include("ReactionCoordinateAndPotential.jl")
using .Parameters
using .UsefulFunctions
using StaticArrays
using Dierckx
using Printf

##################################################Input Information######################################################### 
const global freqScaleFactor = 1.0 #scaling factor to approximate for anharmonic effects in conserved modes (harmonic)
const global ge = 1.0 #ratio of TS and reactant electronic partition functions. 
const global σ = 1.0 #ratio of TS and reactant symmetry numbers. 0.5 if the two reactants are indistuingshable, otherwise 1.0. 

const global Tmin = 1.0 #minimum temperature in K
const global Tmax = 2500.0 #maximum temperature in K
const global Tnum = 100   #Number of temperature points to evaluate. 

const global Rmin = 1.5 #minimum reaction-coordinate distance in Å
const global Rmax = 20.0 #maximum reaction-coordinate distance in Å

const global Emax = 25 * kB * Tmax / (h * c * 100) #Upper energy limit for integration in cm-1. ħ 
const global Jmin = 1.0e-4 #This is for nicer plots. 

const global Epoints = 160          #Number of Energy points to evaluate.                      
const global Jpoints = 160          #Number of Angular momentum points per energy to evaluate.  
const global Rnum = 160             #Number of reaction-coordinate-distance points to evaluate.
############################################################################################################################ 

##################################################Fragment Information##############################################   
const global I = SizedMatrix{3,2}(zeros(3, 2))
const global m1, I[:, 1] = readFragmentInput("fragment1.txt")
const global m2, I[:, 2] = readFragmentInput("fragment2.txt")
############################################################################################################################   

##################################################Need these for k(E)s.##############################################   
#const global freqs1 = Array{}(freqScaleFactor * [1580.0])
#const global freqs2 = Array{}(freqScaleFactor * [94.8553, 211.292, 401.518, 525.484, 553.463, 614.035, 685.315, 873.044, 996.878, 1089.42, 1150.7, 1381.63, 1393.73, 1459.8, 1480.18, 2015.81, 3044.2, 3094.23, 3162.57, 3204.41, 3487.32])
#const global freqs2 = Array{}(freqScaleFactor * [])
#const global freqs = Array{}(vcat(freqs1, freqs2))     #Make an array with all the frequencies. 
############################################################################################################################

const global μ = m1 * m2 / (m1 + m2) * 8π^2 * c * amu * 100 * (1.0e-10)^2 / h #reduced mass of the recombining framents. The latter part is conversion to more suitable units so that [μ*r^2] = cm. 

#Figure out the dimensionality of the system (atom – diatom, ..., or asymmetric rotor – asymmetry rotor). 
let counter = 0
    for j = 1:2
        for i = 1:3
            if I[i, j] < 1.0e-3             #check how many moments of inertia are zero 
                counter = counter + 1
            end
        end
    end
    if counter == 0
        const global n = 8
        println("non-linear top + non-linear top (n=8)")
    elseif counter == 1
        const global n = 7
        println("linear top + non-linear top (n=7)")
        if I[1, 1] < 1.0e-3             #Change order so that the first column is for the "more-dimensional" fragment
            tempArray = I[:, 1]
            I[:, 1] = I[:, 2]
            I[:, 2] = tempArray
        end
    elseif counter == 2
        const global n = 6
        println("linear top + linear top (n=6)")
    elseif counter == 3
        const global n = 5
        println("atom + non-linear top (n=5)")
        if I[3, 1] < 1.0e-3            #Change order so that the first column is for the "more-dimensional" fragment
            tempArray = I[:, 1]
            I[:, 1] = I[:, 2]
            I[:, 2] = tempArray
        end
    elseif counter == 4
        const global n = 4
        println("atom + linear top (n=4)")
        if I[3, 1] < 1.0e-3            #Change order so that the first column is for the "more-dimensional" fragment
            tempArray = I[:, 1]
            I[:, 1] = I[:, 2]
            I[:, 2] = tempArray
        end
    else
        throw(ArgumentError("Atom-atom system or something else strange"))
    end
end


const global ΔE = log10(Emax) / Epoints
const global Δr = (Rmax - Rmin) / Rnum

#Initialise arrays
global NE = zeros(Epoints + 2, 2)                                   #Save data in E, N‡(E)  (J-averaged TS state sum)
#global SplineArray = Array{Any}(nothing, Epoints + 2, 3)            #First column: E, Second column: Spline that gives N^‡(E,J), Third column: Spline that gives rTS(E,J). Mainly for plotting purposes if one wants. 
for i = 2:Epoints+2
    NE[i, 1] = 10^((i - 2) * ΔE)
    #SplineArray[i, 1] = NE[i, 1]
end

#This triple-loop loops over E, J, and reaction coordinate to find the optimal TS location for each E-J combination.
file = open("EJNrc.dat", "w")
@time begin
    let Jmax = -1.0
        for i = Epoints+2:-1:2
            if Jmax < 0.0                                                       #Set first Jmax for iterations
                ΔJ = 1.0                                                        #Adjust if needed. 
                JMaxCounter = 0
                while true
                    Jmax = ΔJ + ΔJ * JMaxCounter
                    if sumOfStates(Emax, Jmax, Rmin, μ, I, n) < 1.0e-20
                        break
                    end
                    JMaxCounter = JMaxCounter + 1
                end
            end
            ΔJ = Jmax / Jpoints
            Jvalues = zeros(Jpoints + 2, 3)                                      #Record here J, N^‡(J), and rc(J). Will be used for spline fitting. 
            for j = Jpoints+2:-1:2                                               #Find J-dependent state sum for TS                  
                Jvalues[j, 1] = (j - 2) * ΔJ + Jmin                              #Save J value. 
                rTS = Rmin                                                       #Initial guess for TS location
                NTS = 1.0e100                                                    #Initial guess for N‡(E,J) 
                Threads.@threads for k = 0:Rnum
                    rc = Rmin + k * Δr                                           #reaction-coordinate value. 
                    NEJ = sumOfStates(NE[i, 1], Jvalues[j, 1], rc, μ, I, n)
                    if NEJ < NTS
                        rTS = rc
                        NTS = NEJ
                    end
                    if NEJ < 1.0e-10
                        Jmax = (j - 2) * ΔJ                                   #Zero N‡(E,J). Exit loop and set max J for next iteration. 
                        break
                    end
                end
                Jvalues[j, 2] = NTS                                        #Save TS location
                Jvalues[j, 3] = rTS                                        #Save N‡(E,J) 
                write(file, @sprintf "%16.8e" NE[i, 1])
                write(file, @sprintf "%16.8e" Jvalues[j, 1])
                write(file, @sprintf "%16.8e" Jvalues[j, 2])
                write(file, @sprintf "%16.8e" Jvalues[j, 3])
                write(file, '\n')
            end
            write(file, '\n')
            #SplineArray[i, 2] = Spline1D(Jvalues[:, 1], Jvalues[:, 2])
            #SplineArray[i, 3] = Spline1D(Jvalues[(2:Jpoints), 1], Jvalues[(2:Jpoints), 3])
            NE[i, 2] = integrate(Spline1D(Jvalues[:, 1], Jvalues[:, 2]), 0.0, Jvalues[Jpoints+1, 1])
        end
    end
end
close(file)

NE = Spline1D(NE[:, 1], NE[:, 2])
ΔT = log10(Tmax - Tmin) / Tnum
file = open("canonicalRateCoefficients.dat", "w")
for i = 0:Tnum
    T = @sprintf "%16.8e" Tmin + 10^(i * ΔT) - 1.0
    write(file, T)
    β = h * c * 100 / (kB * (Tmin + 10^(i * ΔT) - 1.0))
    kβ = @sprintf "%16.8e" (ge / σ) * 1.0 / (Qt(μ, β) * Qr(I[1, 1], I[2, 1], I[2, 1], β) * Qr(I[1, 2], I[2, 2], I[2, 2], β)) * canonicalAverage(NE, β, Emax) * c * 100 * 100^3
    write(file, kβ)
    write(file, '\n')
end
close(file)



