program tst
    use parameters
    use usefulFunctions
    implicit none

    integer(kind = iprec) :: u, a, b, c, f, t, start, finish, temp
    real(kind = dp) :: Jmax, dJ
    real(kind = dp) :: minr, kT
    real(kind = dp) :: sumE, sumEJ, minNE, minNEJ, minkT
    real(kind = dp), parameter :: rMin = 1.5e-10_dp
    real(kind = dp), parameter :: rMax = 20.0e-10_dp
    integer(kind = iprec), parameter :: NE = 1050
    integer(kind = iprec), parameter :: NJ = 1050
    integer(kind = iprec), parameter :: Nr = 1050
    integer(kind = iprec), parameter :: Ntemp = 280
    real(kind = dp), parameter :: Tmax = 2500.0_dp
    real(kind = dp), parameter :: Emax = 25*kB*Tmax
    real(kind = dp), parameter :: Jmin = (2*Idiatom*kB)**(0.5_dp)/NJ
    real(kind = dp), parameter :: dT = log10(Tmax)/Ntemp
    real(kind = dp), parameter :: dE = (log10(Emax)-log10(kb))/NE
    real(kind = dp), parameter :: dr = (rMax-rMin)/Nr
    real(kind = dp), parameter :: d = 0.60375e-10_dp

    real(kind = dp), dimension(Nr) :: rGrid
    real(kind = dp), dimension(NE) :: EGrid, NEarray
    real(kind = dp), dimension(NJ) :: NEJarray
    real(kind = dp), dimension(Ntemp) :: tempGrid

    call system_clock(start)

    !initialise grids
    EGrid = 0.0_dp
    tempGrid = 0.0_dp
    do t = 1, Ntemp
        tempGrid(t) = 10**((t-1)*dT)
    end do
    do a = 1, NE
        EGrid(a) = 10**((a-1)*dE) * kB
    end do
    do c = 1, Nr
        rGrid(c) = rMin + c*dr
    end do

    ! Canonical optimisation.
    open(newunit=u, file="canAVGD.dat", status="replace")
    do t = 1, Ntemp
        minkT = 1.0e20_dp
        !$omp parallel shared(t, tempGrid, minkT, rGrid, minr) private(c, kT)
        !$omp do
        do c = 1, Nr
            kT = canonicalRateConstant(rGrid(c), tempGrid(t), d)
            if(kT < minkT) then
                minkT = kT
                minr = rGrid(c)
            end if
        end do
        !$omp end do
        !$omp end parallel
        write(u,*) tempGrid(t), minr, minkT
    end do
    close(u)

    ! E optimisation.
    NEarray = 0.0_dp
    open(newunit=u, file="sumNED.dat", status="replace")
    do a = 1, NE
        minNE = 1.0e100_dp
        !$omp parallel shared(a, EGrid, rGrid, minr, minNE) private(c, sumE)
        !$omp do
        do c = 1, Nr
            sumE = sumOfStatesE(rGrid(c),EGrid(a),d)
            if(sumE < minNE) then
                minr = rGrid(c)
                minNE = sumE
            end if
        end do
        !$omp end do
        !$omp end parallel
        write(u,*) EGrid(a), minr, minNE
        NEarray(a) = minNE
    end do
    close(u)
    open(newunit=u, file="canEavgD.dat", status="replace")
    do t = 1, Ntemp
        write(u,*) tempGrid(t), canRate(tempGrid(t), EGrid, NEarray)
    end do
    close(u)

    ! EJ optimization
    NEarray = 0.0_dp
    NEJarray = 0.0_dp
    minr = rMax
    open(newunit=u, file="sumNEJD.dat", status="replace")
    do a = 1, NE
        do b = 0, NJ
            minNEJ = 1.0e100_dp
            !Jmax = (0.6_dp*EGrid(a)*(Idiatom+muRed*rMax**2))**(0.5_dp)
            Jmax = 1.1_dp*(2.1134e-23_dp*EGrid(a)**0.5_dp + 1.1389e-31_dp*EGrid(a)**0.11748_dp) !Based on testing
            dJ = Jmax/NJ
            !$omp parallel shared(a, b, EGrid, rGrid, minr, minNEJ, dJ) private(c, sumEJ)
            !$omp do
            do c = 1, Nr
                if(b < 1) then
                    sumEJ = sumOfStatesEJ(rGrid(c),EGrid(a),Jmin,d)
                else
                    sumEJ = sumOfStatesEJ(rGrid(c),EGrid(a),b*dJ,d)
                end if
                if(sumEJ < minNEJ) then
                    minr = rGrid(c)
                    minNEJ = sumEJ
                end if
            end do
            !$omp end do
            !$omp end parallel
            if(b < 1) then
                write(u,*) EGrid(a), Jmin, minr, minNEJ
                cycle
            end if
            write(u,*) EGrid(a), b*dJ, minr, minNEJ
            NEJarray(b) = minNEJ
            if(b == 1) then
                sumE = (dJ/2)*NEJarray(1)
            else
                sumE = sumE + (dJ/2)*(NEJarray(b) + NEJarray(b-1))
            end if
        end do
        NEarray(a) = sumE
        write(u,*)
    end do
    close(u)
    open(newunit=u, file="sumNEAVGJD.dat", status="replace")
    do a = 1, NE
        write(u,*) EGrid(a), NEarray(a)
    end do
    close(u)
    close(u)

    open(newunit=u, file="canEJavgD.dat", status="replace")
    do t = 1, Ntemp
        write(u,*) tempGrid(t), canRate(tempGrid(t), EGrid, NEarray)
    end do
    close(u)


    call system_clock(finish)
    write(*,*) real(finish-start)/1000, 'seconds'



contains

    function canRate(T, EGrid, NEarray) result(kT)
        implicit none
        real(kind = dp), intent(in) :: T
        real(kind = dp), dimension(NE), intent(in) :: EGrid, NEarray
        integer(kind = iprec) :: a
        real(kind = dp) :: intSum, kT

        intSum = (EGrid(1)/2)*NEarray(1) * exp(-(EGrid(1)/2)/(kB*T))
        do a = 2, NE
            intSum = intSum + ((EGrid(a)-EGrid(a-1))/2) * &
                (NEarray(a-1)+NEarray(a)) * exp(-((EGrid(a)+EGrid(a-1))/2)/(kB*T))
        end do
        kT = intSum/(h*Qt(T)*Qr(T)*Qv(T)) * 100**3

    end function

end program tst


