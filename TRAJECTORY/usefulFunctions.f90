module usefulFunctions
    use parameters
    implicit none
contains

    !Returns the the value of the potential energy surface for a given r, rd (diatom bond distance), and theta.
    pure function potential(theta, rD, r) result(V)
        implicit none
        real(kind = dp), intent(in) :: theta, rD, r

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

        Vharm = 2*muDiatom*pi**2*nuharm**2*(rD-rDiatom)**2

        V = Vr + Cr*((cos(theta))**2 - gamma0**2)**2 + Vharm
        if(theta > pi .or. theta < 0.0_dp) then
            V = Vr + Cr*((cos(pi))**2 -gamma0**2)**2 + Vharm
        end if

    end function

    pure function potentialDerR(theta, r) result(derivative)
        implicit none
        real(kind = dp), intent(in) :: theta, r
        real(kind = dp), parameter:: h = 1.0e-17_dp

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

        real(kind = dp) :: derivative, dr1, dr2, dr3
        real(kind = dp) :: Cr, x, y, Vr, gamma0, Vharm, V

        x = r-r0
        y = (r/r0)**6

        dr1 = -d0*(C1*(x/a0)/x + 2*C2*(x/a0)**2/x + 3*C3*(x/a0)**3/x + 4*C4*(x/a0)**4/x + 5*C5*(x/a0)**5/x &
            & + 6*C6*(x/a0)**6/x)*exp(-C1*x/a0)
        dr1 = dr1 + (C1/a0)*d0*(C0 + C1*(x/a0) + C2*(x/a0)**2 + C3*(x/a0)**3 + C4*(x/a0)**4 + C5*(x/a0)**5 &
            & + C6*(x/a0)**6)*exp(-C1*x/a0) - 2*A/y**3 * 6*(r**5/r0**6)  + 2*A/y**2 * 6*(r**5/r0**6)

        Cr = 1.0e3_dp/Na*2625.5_dp*0.13129_dp*(r/a0)**(1.5_dp) * exp(-0.35_dp*r/a0)/(1+ (0.2688_dp*r/a0)**9)
        gamma0 = 0.63_dp + 0.37_dp*(1.0_dp + exp(-2.25_dp*(r-8.3_dp*a0)/a0))**(-1.0_dp) &
            & + 0.37_dp*exp(-0.75_dp*r/a0)
        dr2 = -0.35_dp*Cr/a0
        dr2 = dr2 + 1.5_dp*Cr/r
        dr2 = dr2 - 9*1.0e3_dp/Na*2625.5_dp*0.13129_dp*(0.2688_dp/a0)**9*(r/a0)**(1.5_dp)*r**8 * &
            & exp(-0.35_dp*r/a0)/(1+ (0.2688_dp*r/a0)**9)**2
        dr2 = dr2*((cos(theta))**2 - gamma0**2)**2

        gamma0 = 0.63_dp + 0.37_dp*(1.0_dp + exp(-2.25_dp*(r-8.3_dp*a0)/a0))**(-1.0_dp) &
            & + 0.37_dp*exp(-0.75_dp*r/a0)

        dr3 = -4*gamma0*Cr*(cos(theta)**2-gamma0**2) * (-0.37_dp*0.75_dp*exp(-0.75_dp*r/a0)/a0 &
            &  + 2.25_dp*0.37_dp*exp(-2.25_dp*(r-8.3_dp*a0)/a0)/a0*(1.0_dp + exp(-2.25_dp*(r-8.3_dp*a0)/a0))**(-2.0_dp))

        derivative = dr1 + dr2 + dr3
    end function

    pure function potentialDerTheta(theta, r) result(derivative)
        implicit none
        real(kind = dp), intent(in) :: theta, r

        real(kind = dp) :: Cr, gamma0, derivative

        gamma0 = 0.63_dp + 0.37_dp*(1.0_dp + exp(-2.25_dp*(r-8.3_dp*a0)/a0))**(-1.0_dp) &
            & + 0.37_dp*exp(-0.75_dp*r/a0)
        Cr = 1.0e3_dp/Na*2625.5_dp*0.13129_dp*(r/a0)**(1.5_dp) * exp(-0.35_dp*r/a0)/(1+ (0.2688_dp*r/a0)**9)

        derivative = -4*Cr*((cos(theta))**2 - gamma0**2) * cos(theta) * sin(theta)
    end function

    pure function potentialDerRdiatom(rD) result(derivative)
        implicit none
        real(kind = dp), intent(in) :: rD
        real(kind = dp) :: derivative

        derivative = 4*muDiatom*pi**2*nuharm**2*(rD-rDiatom)
    end function

    !The Hamiltonian after the Augustin-Miller transformation
    function Hamiltonian(J, qK, theta, rD, r, K, pTheta, prD, pr) result(energy)
        implicit none
        real(kind = dp), intent(in) :: J, qK, theta, rD, r, K, pTheta, prD, pr
        real(kind = dp) :: energy

        energy = 1/(2*muRed*r**2)*(J**2-K**2 &
            & + (2*K*(J**2-K**2)**(0.5_dp)*cos(qK)*cos(theta))/sin(theta) &
            & + K**2*cos(theta)**2/sin(theta)**2 &
            & + ptheta**2 &
            & - 2*(J**2-K**2)**(0.5_dp)*sin(qK)*ptheta) &
            & + 1/(2*muDiatom*rD**2)*(ptheta**2 + K**2/sin(theta)**2) &
            & + pr**2/(2*muRed) + prD**2/(2*muDiatom) + potential(theta, rD, r)
    end function

    pure function KDer(qK, theta, rD, r, J, K, pTheta) result(derivative)
        implicit none
        real(kind = dp), intent(in) :: qK, theta, rD, r, J, K, pTheta
        real(kind = dp) :: derivative

        if( (abs(J-abs(K)))/J < 2.0e-2_dp) then
            derivative = 0.0_dp
        else
            derivative = (-K + (J**2-K**2)**0.5_dp*cos(qK)*cos(theta)/sin(theta) &
                & - K**2*cos(qK)*cos(theta)/(sin(theta)*(J**2-K**2)**0.5_dp) &
                & + K*cos(theta)**2/sin(theta)**2 &
                & + K*sin(qK)*pTheta/((J**2-K**2)**0.5_dp) &
                & )/(muRed*r**2) &
                & + K/(muDiatom*rD**2*sin(theta)**2)
        end if
    end function

    pure function pThetaDer(qK, rD, r, J, K, pTheta) result(derivative)
        implicit none
        real(kind = dp), intent(in) :: qK, rD, r, J, K, pTheta
        real(kind = dp) :: derivative

        derivative = (pTheta-(J**2-K**2)**(0.5_dp)*sin(qK))/(muRed*r**2) + ptheta/(muDiatom*rD**2)
    end function

    pure function prDDer(prD) result(derivative)
        implicit none
        real(kind = dp), intent(in) :: prD
        real(kind = dp) :: derivative

        derivative = prD/muDiatom
    end function

    pure function pRDer(pr) result(derivative)
        implicit none
        real(kind = dp), intent(in) :: pR
        real(kind = dp) :: derivative

        derivative = pr/muRed
    end function

    pure function qKDer(qK, theta, r, J, K, pTheta) result(derivative)
        implicit none
        real(kind = dp), intent(in) :: qK, theta, r, J, K, pTheta
        real(kind = dp) :: derivative

        derivative = -1/(muRed*r**2)*(K*(J**2-K**2)**(0.5_dp)*sin(qK)*cos(theta)/sin(theta)) &
            &-1/(muRed*r**2)*((J**2-K**2)**(0.5_dp)*ptheta*cos(qK))

    end function

    pure function thetaDer(qK, theta, rD, r, J, K, pTheta) result(derivative)
        implicit none
        real(kind = dp), intent(in) :: qK, theta, rD, r, J, K, pTheta
        real(kind = dp) :: derivative

        derivative = ( -K*(J**2-K**2)**0.5_dp*cos(qK)*cos(theta)**2/sin(theta)**2 &
            & - K*(J**2-K**2)**0.5_dp*cos(qK)  &
            & - K**2*cos(theta)/sin(theta) &
            & - K**2*cos(theta)**3/sin(theta)**3 &
            & )/(muRed*r**2) &
            & - K**2*cos(theta)/(muDiatom*rD**2*sin(theta)**3) &
            & + potentialDerTheta(theta, r)
    end function

    pure function rDDer(theta, rD, K, pTheta) result(derivative)
        implicit none
        real(kind = dp), intent(in) :: theta, rD, K, pTheta
        real(kind = dp) :: derivative

        derivative = -1.0_dp/(muDiatom*rD**3)*(pTheta**2 + K**2/sin(theta)**2) + potentialDerRdiatom(rD)
    end function

    pure function rDer(qK, theta, rD, r, J, K, pTheta) result(derivative)
        implicit none
        real(kind = dp), intent(in) :: qK, theta, rD, r, J, K, pTheta
        real(kind = dp) :: derivative

        derivative = -1/(muRed*r**3)*(J**2-K**2+(2*K*(J**2-K**2)**(0.5_dp)*cos(qK)*cos(theta))/sin(theta)) &
            &  -1/(muRed*r**3)*((K**2*cos(theta)**2/sin(theta)**2) + ptheta**2) &
            &  + 1/(muRed*r**3)*(2*(J**2-K**2)**(0.5_dp)*sin(qK)*ptheta) &
            & + potentialDerR(theta, r)
    end function


    subroutine initialConditions(E, J, qK, theta, rD, r, K, pTheta, prD, pr)
        implicit none
        real(kind = dp), intent(in) :: E, J, r
        real(kind = dp), intent(inout) :: qK, theta, rD, K, pTheta, prD, pr
        real(kind = dp) :: Etrans, Erot, Eint, Evib, rnd

        do
            rD = rDiatom
            pTheta = 0.0_dp
            prD = 0.0_dp
            pr = 0.0_dp

            call random_number(rnd)
            qK = 2*pi*rnd
            call random_number(rnd)
            K = (2*rnd-1.0_dp)*J
            call random_number(rnd)
            theta = rnd*pi
            if(Hamiltonian(J, qK, theta, rD, r, K, pTheta, prD, pr) > E) then
                cycle
            end if

            Erot = Hamiltonian(J, qK, theta, rD, r, K, pTheta, prD, pr) - potential(theta, rD, r)
            call random_number(rnd)
            Evib = (E-Erot)*rnd
            !Evib = (E-Erot)*(1.0_dp-rnd**(1.0_dp/(3-1)))
            call random_number(rnd)
            rD = rDiatom + (Evib/(2*muDiatom*pi**2*nuharm**2))**(0.5_dp)*cos(2*pi*rnd)
            prD = -(2*muDiatom*Evib)**(0.5_dp)*sin(2*pi*rnd)
            if(Hamiltonian(J, qK, theta, rD, r, K, pTheta, prD, pr) > E) then
                cycle
            end if

            call random_number(rnd)
            Eint = (E-Erot-Evib)*rnd
            !Eint = (E-Erot-Evib)*(1.0_dp-rnd**(1.0_dp/(3-2)))
            call random_number(rnd)
            if(rnd >= 0.5_dp) then
                pTheta = 4*(1/(2*muRed*r**2)+1/(2*muDiatom*rD**2))* &
                    & (K**2/(2*muDiatom*rD**2*sin(theta)**2) - Eint)
                pTheta = (J**2-K**2)*sin(qK)**2/(muRed*r**2)**2 - pTheta
                if(pTheta < 0) then
                    cycle
                end if
                pTheta = (pTheta)**0.5_dp
                pTheta = (J**2-K**2)**0.5_dp*sin(qK)/(muRed*r**2) + pTheta
                pTheta = pTheta/(1/(muRed*r**2)+1/(muDiatom*rD**2))
            else
                pTheta = 4*(1/(2*muRed*r**2)+1/(2*muDiatom*rD**2))* &
                    & (K**2/(2*muDiatom*rD**2*sin(theta)**2) - Eint)
                pTheta = (J**2-K**2)*sin(qK)**2/(muRed*r**2)**2 - pTheta
                if(pTheta < 0) then
                    cycle
                end if
                pTheta = (pTheta)**0.5_dp
                pTheta = (J**2-K**2)**0.5_dp*sin(qK)/(muRed*r**2) - pTheta
                pTheta = pTheta/(1/(muRed*r**2)+1/(muDiatom*rD**2))
            end if
            if(Hamiltonian(J, qK, theta, rD, r, K, pTheta, prD, pr) > E) then
                cycle
            end if

            Etrans = E - Hamiltonian(J, qK, theta, rD, r, K, pTheta, prD, pr)
            pr = -(2*muRed*Etrans)**(0.5_dp)
            if(abs((Hamiltonian(J, qK, theta, rD, r, K, pTheta, prD, pr)-E)/E) > 1.0e-10_dp) then
                cycle
            end if
            exit
        end do
        !qK = Erot
        !K = Evib
        !theta = Eint
        !pTheta = Etrans

    end subroutine

    subroutine ForestRuth(dt, J, qK, theta, rD, r, K, pTheta, prD, pr)
        implicit none
        real(kind = dp), intent(in) :: dt, J
        real(kind = dp), intent(inout) :: qK, theta, rD, r, K, pTheta, prD, pr

        qK = qK + FRtheta*KDer(qK, theta, rD, r, J, K, pTheta)*dt/2
        theta = theta + FRtheta*pThetaDer(qK, rD, r, J, K, pTheta)*dt/2
        rD = rD + FRtheta*prDDer(prD)*dt/2
        r = r + FRtheta*pRDer(pr)*dt/2

        pr = pr - FRtheta*rDer(qK, theta, rD, r, J, K, pTheta)*dt
        K = K - FRtheta*qKDer(qK, theta, r, J, K, pTheta)*dt
        pTheta = pTheta - FRtheta*thetaDer(qK, theta, rD, r, J, K, pTheta)*dt
        prD = prD - FRtheta*rDDer(theta, rD, K, pTheta)*dt

        rD = rD + (1.0_dp-FRtheta)*prDDer(prD)*dt/2
        r = r + (1.0_dp-FRtheta)*pRDer(pr)*dt/2
        qK = qK + (1.0_dp-FRtheta)*KDer(qK, theta, rD, r, J, K, pTheta)*dt/2
        theta = theta + (1.0_dp-FRtheta)*pThetaDer(qK, rD, r, J, K, pTheta)*dt/2

        pTheta = pTheta - (1.0_dp-2*FRtheta)*thetaDer(qK, theta, rD, r, J, K, pTheta)*dt
        prD = prD - (1.0_dp-2*FRtheta)*rDDer(theta, rD, K, pTheta)*dt
        pr = pr - (1.0_dp-2*FRtheta)*rDer(qK, theta, rD, r, J, K, pTheta)*dt
        K = K - (1.0_dp-2*FRtheta)*qKDer(qK, theta, r, J, K, pTheta)*dt

        qK = qK + (1.0_dp-FRtheta)*KDer(qK, theta, rD, r, J, K, pTheta)*dt/2
        theta = theta + (1.0_dp-FRtheta)*pThetaDer(qK, rD, r, J, K, pTheta)*dt/2
        rD = rD + (1.0_dp-FRtheta)*prDDer(prD)*dt/2
        r = r + (1.0_dp-FRtheta)*pRDer(pr)*dt/2

        pr = pr - FRtheta*rDer(qK, theta, rD, r, J, K, pTheta)*dt
        K = K - FRtheta*qKDer(qK, theta, r, J, K, pTheta)*dt
        pTheta = pTheta - FRtheta*thetaDer(qK, theta, rD, r, J, K, pTheta)*dt
        prD = prD - FRtheta*rDDer(theta, rD, K, pTheta)*dt

        rD = rD + FRtheta*prDDer(prD)*dt/2
        r = r + FRtheta*pRDer(pr)*dt/2
        qK = qK + FRtheta*KDer(qK, theta, rD, r, J, K, pTheta)*dt/2
        theta = theta + FRtheta*pThetaDer(qK, rD, r, J, K, pTheta)*dt/2

    end subroutine

    subroutine implicitEuler(dt, J, qK, theta, rD, r, K, pTheta, prD, pr)
        implicit none
        real(kind = dp), intent(in) :: dt, J
        real(kind = dp), intent(inout) :: qK, theta, rD, r, K, pTheta, prD, pr

        qK = qK + KDer(qK, theta, rD, r, J, K, pTheta)*dt
        pr = pr - rDer(qK, theta, rD, r, J, K, pTheta)*dt
        theta = theta + pThetaDer(qK, rD, r, J, K, pTheta)*dt
        prD = prD - rDDer(theta, rD, K, pTheta)*dt
        rD = rD + prDDer(prD)*dt
        pTheta = pTheta - thetaDer(qK, theta, rD, r, J, K, pTheta)*dt
        r = r + pRDer(pr)*dt
        K = K - qKDer(qK, theta, r, J, K, pTheta)*dt

    end subroutine

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


end module usefulFunctions
