module usefulFunctions
    use parameters
    implicit none
contains

    !Returns the centre-of-mass distance
    pure function rcm(r, theta, d) result(rcmout)
        implicit none
        real(kind = dp), intent(in) :: r, theta, d
        real(kind = dp) :: rcmout

        rcmout = d*cos(theta) + (r**2 - d**2 * (sin(theta))**2)**(1.0_dp/2)

    end function

    !Returns the d(rcm)/d(theta) derivative.
    pure function rcmDeriv(rcm, theta, d) result(rcmDerivOut)
        implicit none
        real(kind = dp), intent(in) :: rcm, theta, d
        real(kind = dp) :: rcmDerivOut

        rcmDerivOut = -d*sin(theta)*rcm/(rcm - d*cos(theta))

    end function

    !Returns the the value of the potential energy surface for a given r, rd (diatom bond distance), and theta.
    pure function potential(theta, r) result(V)
        implicit none
        real(kind = dp), intent(in) :: theta, r

        real(kind = dp), parameter:: r0 = 2.478_dp*a0
        real(kind = dp), parameter:: C0 = 1.0_dp
        real(kind = dp), parameter:: C1 = 3.944554_dp
        real(kind = dp), parameter:: C2 = 12.47792_dp
        real(kind = dp), parameter:: C3 = 18.92974_dp
        real(kind = dp), parameter:: C4 = -44.61170_dp
        real(kind = dp), parameter:: C5 = 26.80832_dp
        real(kind = dp), parameter:: C6 = -9.68818_dp
        real(kind = dp), parameter:: d0 = 0.022756_dp*2625.5_dp*1.0e3_dp/Na
        real(kind = dp), parameter:: A = 0.065660_dp*2625.5_dp*1.0e3_dp/Na

        real(kind = dp) :: Cr, x, y, Vr, gamma0, Vharm, V

        x = r-r0
        y = (r/r0)**6

        Vr = -d0*(C0 + C1*(x/a0) + C2*(x/a0)**2 + C3*(x/a0)**3 + C4*(x/a0)**4 + C5*(x/a0)**5 &
            & + C6*(x/a0)**6)*exp(-C1*x/a0) + A/y**2 - 2*A/y
        gamma0 = 0.63_dp + 0.37_dp*(1.0_dp + exp(-2.25_dp*(r-8.3_dp*a0)/a0))**(-1.0_dp) &
            & + 0.37_dp*exp(-0.75_dp*r/a0)
        Cr = 1.0e3_dp/Na*2625.5_dp*0.13129_dp*(r/a0)**(1.5_dp) * exp(-0.35_dp*r/a0)/(1+ (0.2688_dp*r/a0)**9)

        V = Vr + Cr*((cos(theta))**2 - gamma0**2)**2

    end function

    !Returns the translational partition function for a given T
    pure function Qt(T) result(partOut)
        implicit none
        real(kind = dp), intent(in) :: T
        real(kind = dp) :: partOut

        partOut = (2*pi*muRed*kb*T/h**2)**(1.5_dp)
    end function

    !Returns the rotational partition function for a given T
    pure function Qr(T) result(partOut)
        implicit none
        real(kind = dp), intent(in) :: T
        real(kind = dp) :: partOut

        partOut = 8*pi**2 * Idiatom*kB*T/(h**2)
    end function

    !Returns the vibrational partition function for a given T
    pure function Qv(T) result(partOut)
        implicit none
        real(kind = dp), intent(in) :: T
        real(kind = dp) :: partOut

        partOut = kB*T/(nuharm*h)
    end function

    !EJ-dependent sum of states for the transition state.
    function sumOfStatesEJ(r, E, J, d) result(sumOut)
        implicit none
        real(kind = dp), intent(in) :: r, E, J, d
        real(kind = dp) :: Ixx, Iyy, Izz !Moments of intertia
        real(kind = dp) :: Ired !Moment of inertia for radial motion
        real(kind = dp) :: sumOut,funcSumPrev, funcSum, func, dF
        real(kind = dp) :: Erot, Z, volume, bigConstant
        real(kind = dp) :: epsi, theta, nu, eta !Phase space coordinates over which is integrated.
        real(kind = dp) :: rcmVal, rcmDerivVal, potentialVal !Function values.
        integer(kind = iprec) :: points, counter

        bigConstant = 2.0_dp**(9.0_dp/2) * J**2 * pi**2 / (h**5 * nuharm) !Constant expression in front of N(E,J)
        volume = E * pi * 2*pi * 2 !Phase space volume
        points = 0
        counter = 0
        funcSum = 0.0_dp
        funcSumPrev = 0.0_dp
        dF = 0.0_dp

        do
            counter = counter + 1
            points = points + 1

            !Call random values for the phase space coordinates
            call random_number(epsi)
            call random_number(theta)
            call random_number(nu)
            call random_number(eta)
            epsi = epsi*E
            theta = theta*pi/2 
            eta = eta*2*pi
            nu = acos(2*nu-1.0_dp)

            rcmVal = rcm(r, theta, d)
            rcmDerivVal = rcmDeriv(rcmVal, theta, d)
            potentialVal = potential(theta, rcmVal)

            Ired = muRed*rcmVal**2
            Ixx = Ired + Idiatom
            Iyy = (Ired + Idiatom - (Ired**2 + Idiatom**2 + 2*Ired*Idiatom*((cos(theta))**2 - (sin(theta))**2))**(0.5_dp))/2
            Izz = (Ired + Idiatom + (Ired**2 + Idiatom**2 + 2*Ired*Idiatom*((cos(theta))**2 - (sin(theta))**2))**(0.5_dp))/2
            Z = ((Ired + Idiatom)/(muRed*(Ired + Idiatom) * rcmDerivVal**2 + Ired*Idiatom) )**(-0.5_dp)

            Erot = (((sin(eta))**2/Ixx + (cos(eta))**2/Iyy)*(sin(nu))**2 + (cos(nu))**2/Izz)*J**2 / 2 !Rotational Energy

            if((E - epsi - Erot - potentialVal) < 0.0_dp) then
                func = 0.0_dp
            else
                func = Z * (E - epsi - Erot - potentialVal)**(1.0_dp/2) !The integrated function. Z is the internal coordinate matrix element.
            end if

            funcSum = funcSum + func
            if(counter > 2000) then
                if(funcSum < 1.0e-100_dp) then !Check if the function appears to be always zero.
                    funcSum = 0.0_dp
                    exit
                end if
                dF = abs((funcSum/points - funcSumPrev)/(funcSum/points)) !Check if the value of the integral no longer changes.
                if(dF < 0.01_dp) then
                    exit
                else
                    counter = 0
                    funcSumPrev = funcSum/points
                end if
            end if
        end do
        sumOut = bigConstant*volume*funcSum/points !Final value for the state sum.

    end function

    !E-dependent sum of states for the transition state.
    function sumOfStatesE(r, E, d) result(sumOut)
        implicit none
        real(kind = dp), intent(in) :: r, E, d
        real(kind = dp) :: Ired
        real(kind = dp) :: sumOut,funcSumPrev, funcSum, func, dF
        real(kind = dp) :: bigConstant, A, volume
        real(kind = dp) :: epsi, theta
        real(kind = dp) :: rcmVal, rcmDerivVal, potentialVal
        integer(kind = iprec) :: points, counter

        bigConstant = 2.0_dp**4 * pi**4 / (h**5 * nuharm) !Constant expression in front of N(E)
        volume = E * pi !Phase space volume
        points = 0
        counter = 0
        funcSum = 0.0_dp
        funcSumPrev = 0.0_dp
        dF = 0.0_dp

        do
            !Call random values for the phase space coordinates
            counter = counter + 1
            points = points + 1
            call random_number(epsi)
            call random_number(theta)
            epsi = epsi*E
            theta = theta*pi/2

            rcmVal = rcm(r, theta, d)
            rcmDerivVal = rcmDeriv(rcmVal, theta, d)
            potentialVal = potential(theta, rcmVal)

            Ired = muRed*rcmVal**2
            A = ((muRed*(Ired+Idiatom) * rcmDerivVal**2 + Ired*Idiatom)*(Ired*Idiatom)*(sin(theta))**2)**(0.5_dp)

            if((E - epsi - potentialVal) < 0) then !Heaviside
                func = 0.0_dp
            else
                func = A * (E - epsi - potentialVal)**2
            end if
            funcSum = funcSum + func
            if(counter > 2000) then
                if(funcSum < 1.0e-200_dp) then !Check if the function appears to be always zero.
                    funcSum = 0.0_dp
                    exit
                end if
                dF = abs((funcSum/points - funcSumPrev)/(funcSum/points)) !Check if the value of the integral no longer changes.
                if(dF < 0.01_dp) then
                    exit
                else
                    counter = 0
                    funcSumPrev = funcSum/points
                end if
            end if
        end do
        sumOut = bigConstant*volume*funcSum/points !Final value for the state sum.

    end function

    !Calculates the canonical rate constant for a given r and T.
    function canonicalRateConstant(r, T, d) result(kT)
        implicit none
        real(kind = dp), intent(in) :: r, T, d
        real(kind = dp) :: Ired !Moment of inertia for radial motion
        real(kind = dp) :: kT,funcSumPrev, funcSum, func, dF
        real(kind = dp) :: A, volume, bigConstant, xponent
        real(kind = dp) :: theta !The phase coordinate over which it is integrated
        real(kind = dp) :: rcmVal, rcmDerivVal, potentialVal
        integer(kind = iprec) :: points, counter

        bigConstant = 2**5 *pi**4 * (kB*T)**3 / (h**5 * Qt(T) * Qr(T)) * 100**3 !Constant in front of kT.
        volume = pi
        points = 0
        counter = 0
        funcSum = 0.0_dp
        funcSumPrev = 0.0_dp
        dF = 0.0_dp

        do
            counter = counter + 1
            points = points + 1
            call random_number(theta)
            theta = theta*pi/2

            rcmVal = rcm(r, theta, d)
            rcmDerivVal = rcmDeriv(rcmVal, theta, d)
            potentialVal = potential(theta, rcmVal)
            xponent = -potentialVal/(kB*T)

            if(xponent < -100.0_dp) then !Check if the exponent is very negative
                cycle
            end if

            Ired = muRed*rcmVal**2
            A = ((muRed*(Ired+Idiatom) * rcmDerivVal**2 + Ired*Idiatom)*(Ired*Idiatom)*(sin(theta))**2)**(0.5_dp) !The matrix element A
            if(xponent > 500.0_dp) then !Check if the exponent is very positive
                func = A*exp(100.0_dp)
            else
                func = A*exp(xponent)
            end if
            funcSum = funcSum + func

            if(counter > 5000) then !Check if integral no longer changes.
                dF = abs((funcSum/points - funcSumPrev)/(funcSum/points))
                if(dF < 0.0001_dp) then
                    exit
                else
                    counter = 0
                    funcSumPrev = funcSum/points
                end if
            end if
        end do
        kT = bigConstant*volume*funcSum/points

    end function


end module usefulFunctions
