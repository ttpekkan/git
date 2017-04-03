program calcCorrection
    implicit none
    integer, parameter :: rp = selected_real_kind(15, 307)
    integer, parameter :: i = selected_int_kind(4)
    real(rp), parameter :: R = 8.31441d0, kB = 1.380662d-23, h = 6.626176d-34, c = 2.99792458d8, pi = 3.141592654d0
    real(rp), parameter :: hartree = 2625500d0, cm = 100.0d0, amu = 1.66053904d-27, p = 100000.0d0
    real(rp), dimension(:), allocatable :: oxygenVibTemps, reactantVibTemps, productVibTemps
    real(rp), dimension(:), allocatable :: oxygenRotTemps, reactantRotTemps, productRotTemps
    real(rp), dimension(:), allocatable :: elecE, elecS, masses, symmNums, scalingFactor
    real(rp), dimension(:), allocatable :: temperatures, deltaH, deltaS, Fcorr
    real(rp), dimension(:,:), allocatable :: Evib, Svib, Srot
    real(rp), dimension(:,:), allocatable :: Hcorr, Entropies
    integer(i) :: j, molecule       !1 = oxygen, 2 = reactant, 3 = product

    real(rp), dimension(:,:), allocatable :: Results !T, deltaH, deltaS, Fcorr

    scalingFactor = readData('scalingFactor.dat')

    oxygenVibTemps = scalingFactor(1)*(c*h/kB)*cm*readData('oxygenFrequencies.dat')
    reactantVibTemps = scalingFactor(1)*(c*h/kB)*cm*readData('reactantFrequencies.dat')
    productVibTemps = scalingFactor(1)*(c*h/kB)*cm*readData('productFrequencies.dat')

    oxygenRotTemps = readData('oxygenRotTemps.dat')
    reactantRotTemps = readData('reactantRotTemps.dat')
    productRotTemps = readData('productRotTemps.dat')


    temperatures = readData('temperatures.dat')
    allocate(Evib(size(temperatures),3))
    allocate(Svib(size(temperatures),3))
    Evib = 0.0d0
    Svib = 0.0d0
    do j = 1, size(oxygenVibTemps)
        Evib(:,1) = Evib(:,1) + R*oxygenVibTemps(j)*(0.5d0 + (dexp(oxygenVibTemps(j)/temperatures) - 1.0d0)**(-1))
        Svib(:,1) = Svib(:,1) + R*( (oxygenVibTemps(j)/temperatures)/(dexp(oxygenVibTemps(j)/temperatures) - 1.0d0)) &
            - R*(dlog(1.0d0 - dexp(-oxygenVibTemps(j)/temperatures)))
    end do
    do j = 1, size(reactantVibTemps)
        Evib(:,2) = Evib(:,2) + R*reactantVibTemps(j)*(0.5d0 + (dexp(reactantVibTemps(j)/temperatures) - 1.0d0)**(-1))
        Svib(:,2) = Svib(:,2) + R*( (reactantVibTemps(j)/temperatures)/(dexp(reactantVibTemps(j)/temperatures) - 1.0d0))  &
            - R*(dlog(1.0d0 - dexp(-reactantVibTemps(j)/temperatures)))
    end do
    do j = 1, size(productVibTemps)
        Evib(:,3) = Evib(:,3) + R*productVibTemps(j)*(0.5d0 + (dexp(productVibTemps(j)/temperatures) - 1.0d0)**(-1))
        Svib(:,3) = Svib(:,3) + R*( (productVibTemps(j)/temperatures)/(dexp(productVibTemps(j)/temperatures) - 1.0d0))  &
            - R*(dlog(1.0d0 - dexp(-productVibTemps(j)/temperatures)))
    end do

    symmNums = readData('symmetryNumbers.dat')

    allocate(Srot(size(temperatures),3))
    Srot = 0.0d0

    Srot(:,1) = 1/(symmNums(1)) * (temperatures/oxygenRotTemps(1))
    Srot(:,1) = R*(dlog(Srot(:,1)) + 1.0d0)

    if(size(reactantRotTemps) == 1) then
        Srot(:,2) = 1/(symmNums(2)) * (temperatures/reactantRotTemps(1))
        Srot(:,2) = R*(dlog(Srot(:,2)) + 1.0d0)
    else
        Srot(:,2) = pi**(0.5d0)/(symmNums(2)) &
                    * (temperatures**(1.5d0)/(reactantRotTemps(1)*reactantRotTemps(2)*reactantRotTemps(3))**(0.5d0))
        Srot(:,2) = R*(dlog(Srot(:,2)) + 1.5d0)
    end if

    if(size(productRotTemps) == 1) then
        Srot(:,3) = 1/(symmNums(3)) * (temperatures/productRotTemps(1))
        Srot(:,3) = R*(dlog(Srot(:,3)) + 1.0d0)
    else
        Srot(:,3) = pi**(0.5d0)/(symmNums(3)) &
                    * (temperatures**(1.5d0)/(productRotTemps(1)*productRotTemps(2)*productRotTemps(3))**(0.5d0))
        Srot(:,3) = R*(dlog(Srot(:,3)) + 1.5d0)
    end if

    elecE = hartree*readData('electronicEnergies.dat')

    elecS = readData('elecSpinMultiplicity.dat') !qElec
    elecS = R*dlog(elecS)

    masses = amu*readData('masses.dat')


    allocate(Hcorr(size(temperatures), 3))
    allocate(Entropies(size(temperatures), 3))

    Hcorr = 0.0d0
    Entropies = 0.0d0
    Fcorr = 0.0d0

    Hcorr(:,1) = calcHcorr(temperatures, 'lin', Evib(:,1))
    Hcorr(:,2) = calcHcorr(temperatures, 'nonlin', Evib(:,2))
    Hcorr(:,3) = calcHcorr(temperatures, 'nonlin', Evib(:,3))

    molecule = 1
    Entropies(:,1) = calcEntropy(temperatures, Svib(:,1), Srot(:,1))
    molecule = 2
    Entropies(:,2) = calcEntropy(temperatures, Svib(:,2), Srot(:,2))
    molecule = 3
    Entropies(:,3) = calcEntropy(temperatures, Svib(:,3), Srot(:,3))

    allocate(deltaH(size(temperatures)))
    allocate(deltaS(size(temperatures)))
    allocate(Fcorr(size(temperatures)))

    do j = 1, size(temperatures)
        deltaH(j) = (elecE(3)+Hcorr(j,3)) - (elecE(2)+Hcorr(j,2) + elecE(1)+Hcorr(j,1))
        deltaS(j) = Entropies(j,3) - Entropies(j,2) - Entropies(j,1)
        Fcorr(j) = (deltaH(j)-deltaH(1))/(R*temperatures(j)) - (deltaS(j)-deltaS(1))/R
    end do

    allocate(Results(size(temperatures), 4))
    Results(:,1) = temperatures
    Results(:,2) = deltaH
    Results(:,3) = deltaS
    Results(:,4) = Fcorr

    open(unit = 11, file = 'Results.dat', action = 'write')
    do j = 1, size(temperatures)
        write(11,*) temperatures(j), deltaH(j), deltaS(j), Fcorr(j)
    end do
    close(11)

contains
    function readData(fileName) result(values)
        character(len=*), intent(in) :: fileName
        real(rp), dimension(:), allocatable :: values
        integer(i) :: j, n, io

        n = 0
        open(unit = 11, file = fileName, action = 'read')
        do
            read(11,*,iostat=io)
            if(io > 0) then
                write(*,*) 'Check input.  Something was wrong'
                stop
            else if(io < 0) then
                exit
            else
                n = n + 1
            end if
        end do
        allocate(values(n))
        close(11)

        open(unit = 11, file = fileName, action = 'read')
        do j = 1, n
            read(11,*) values(j)
        end do
        close(11)

    end function

    elemental function calcHcorr(T, symm, Evib) result(Hcorr)
        character(len=*), intent(in) :: symm
        real(rp), intent(in) :: T, Evib
        real(rp) :: E, Hcorr

        E = 0.0d0
        E = E + 3*R*T/2                 !Translational contribution
        if(symm == 'lin') then          !Rotational contribution
            E = E + R*T
        else
            E = E + 3*R*T/2
        end if
        E = E + Evib                    !Vibrational Contribution
        Hcorr = E + R*T

    end function

    elemental function calcEntropy(T, Svib, Srot) result(Stot)
        real(rp), intent(in) :: T, Svib, Srot
        real(rp) :: Stot, qtrans, qvib

        Stot = 0.0d0

        qtrans = (2*pi*kB*T*masses(molecule)/(h**2))**(1.5d0) * kB*T/p
        Stot = Stot + R*(dlog(qtrans)+ 2.5d0) !Translation
        Stot = Stot + elecS(molecule)
        Stot = Stot + Srot
        Stot = Stot + Svib

    end function



end program


