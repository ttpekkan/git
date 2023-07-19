module ReactionCoordinateAndPotential
using ForwardDiff

#The reaction-coordinate and potential definitions are system and case specific. You're on your own I'm afraid. 
export F, ∇F, Vtr

function F(ϕ1, θ1, ϕ2, θ2, χ, rc)
    d = 0.0
    if θ1 < π / 2.0
        return d * cos(θ1) + (rc^2 - d^2 * (sin(θ1))^2)^0.5
    else
        return -d * cos(θ1) + (rc^2 - d^2 * (sin(θ1))^2)^0.5
    end
end

#Can't specify anonymous functions in if blocks for some reason. This solution is not particularly elegant. 
function ∇F(ϕ1, θ1, ϕ2, θ2, χ, rc)
    d = 0.0
    if θ1 < π / 2.0
        return ∇F1(ϕ1, θ1, ϕ2, θ2, χ, rc, d)
    else
        return ∇F2(ϕ1, θ1, ϕ2, θ2, χ, rc, d)
    end

end

function ∇F1(ϕ1, θ1, ϕ2, θ2, χ, rc, d)

    rcm(ϕ1, θ1, ϕ2, θ2, χ, rc) = d * cos(θ1) + (rc^2 - d^2 * (sin(θ1))^2)^0.5

    ∂F_∂ϕ1(ϕ1, θ1, ϕ2, θ2, χ, rc) = ForwardDiff.derivative(ϕ1 -> rcm(ϕ1, θ1, ϕ2, θ2, χ, rc), ϕ1)
    ∂F_∂θ1(ϕ1, θ1, ϕ2, θ2, χ, rc) = ForwardDiff.derivative(θ1 -> rcm(ϕ1, θ1, ϕ2, θ2, χ, rc), θ1)
    ∂F_∂ϕ2(ϕ1, θ1, ϕ2, θ2, χ, rc) = ForwardDiff.derivative(ϕ2 -> rcm(ϕ1, θ1, ϕ2, θ2, χ, rc), ϕ2)
    ∂F_∂θ2(ϕ1, θ1, ϕ2, θ2, χ, rc) = ForwardDiff.derivative(θ2 -> rcm(ϕ1, θ1, ϕ2, θ2, χ, rc), θ2)
    ∂F_∂χ(ϕ1, θ1, ϕ2, θ2, χ, rc) = ForwardDiff.derivative(χ -> rcm(ϕ1, θ1, ϕ2, θ2, χ, rc), χ)

    return ∂F_∂ϕ1(ϕ1, θ1, ϕ2, θ2, χ, rc), ∂F_∂θ1(ϕ1, θ1, ϕ2, θ2, χ, rc), ∂F_∂ϕ2(ϕ1, θ1, ϕ2, θ2, χ, rc), ∂F_∂θ2(ϕ1, θ1, ϕ2, θ2, χ, rc), ∂F_∂χ(ϕ1, θ1, ϕ2, θ2, χ, rc)
end

function ∇F2(ϕ1, θ1, ϕ2, θ2, χ, rc, d)

    rcm(ϕ1, θ1, ϕ2, θ2, χ, rc) = -d * cos(θ1) + (rc^2 - d^2 * (sin(θ1))^2)^0.5

    ∂F_∂ϕ1(ϕ1, θ1, ϕ2, θ2, χ, rc) = ForwardDiff.derivative(ϕ1 -> rcm(ϕ1, θ1, ϕ2, θ2, χ, rc), ϕ1)
    ∂F_∂θ1(ϕ1, θ1, ϕ2, θ2, χ, rc) = ForwardDiff.derivative(θ1 -> rcm(ϕ1, θ1, ϕ2, θ2, χ, rc), θ1)
    ∂F_∂ϕ2(ϕ1, θ1, ϕ2, θ2, χ, rc) = ForwardDiff.derivative(ϕ2 -> rcm(ϕ1, θ1, ϕ2, θ2, χ, rc), ϕ2)
    ∂F_∂θ2(ϕ1, θ1, ϕ2, θ2, χ, rc) = ForwardDiff.derivative(θ2 -> rcm(ϕ1, θ1, ϕ2, θ2, χ, rc), θ2)
    ∂F_∂χ(ϕ1, θ1, ϕ2, θ2, χ, rc) = ForwardDiff.derivative(χ -> rcm(ϕ1, θ1, ϕ2, θ2, χ, rc), χ)

    return ∂F_∂ϕ1(ϕ1, θ1, ϕ2, θ2, χ, rc), ∂F_∂θ1(ϕ1, θ1, ϕ2, θ2, χ, rc), ∂F_∂ϕ2(ϕ1, θ1, ϕ2, θ2, χ, rc), ∂F_∂θ2(ϕ1, θ1, ϕ2, θ2, χ, rc), ∂F_∂χ(ϕ1, θ1, ϕ2, θ2, χ, rc)
end


function Vtr(ϕ1, θ1, ϕ2, θ2, χ, rcCM)
    a = 0.529177210903
    r0 = 2.478 * a
    C0 = 1.0
    C1 = 3.944554
    C2 = 12.47792
    C3 = 18.92974
    C4 = -44.61170
    C5 = 26.80832
    C6 = -9.68818
    d0 = 0.022756 * 219474.63  #To convert to cm-1. 
    A = 0.065660 * 219474.63

    x = rcCM - r0
    y = (rcCM / r0)^6

    Vr = -d0 * (C0 + C1 * (x / a) + C2 * (x / a)^2 + C3 * (x / a)^3 + C4 * (x / a)^4 + C5 * (x / a)^5 + C6 * (x / a)^6) * exp(-C1 * x / a) + A / y^2 - 2 * A / y
    γ0 = 0.63 + 0.37 * (1.0 + exp(-2.25 * (rcCM - 8.3 * a) / a))^(-1.0) + 0.37 * exp(-0.75 * rcCM / a)
    Cr = 219474.63 * 0.13129 * (rcCM / a)^(1.5) * exp(-0.35 * rcCM / a) / (1 + (0.2688 * rcCM / a)^9)
    
    return Vr + Cr * ((cos(θ1))^2 - γ0^2)^2
end

end


