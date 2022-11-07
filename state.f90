program main
    implicit none
    integer, parameter :: iprec = selected_int_kind(8)
    integer, parameter :: dp = selected_real_kind(10, 10)
    integer(kind = iprec), parameter :: Emax = 3620000!cm-1

    integer(kind = iprec), parameter :: printPoints = 5000 !cm-1
    real(kind = dp), parameter :: scaleFactor = 1.0_dp
    real(kind = dp), parameter:: dE = log10(1.0_dp*Emax)/printPoints

    character(len=120) :: string

    integer(kind = iprec) :: i, j, u, statt
    real(kind = dp), dimension(:), allocatable :: coef1, coef2, coef3
    real(kind = dp), dimension(:,:), allocatable :: Ntrans
    real(kind = dp), dimension(0:Emax,2) :: rho, Ntot
    real(kind = dp), dimension(0:Emax) :: coef4, coef5, coef6
    integer(kind = iprec), dimension(:), allocatable :: freqs
    real(kind = dp) :: freq
    real(kind = dp) :: ispline, frotDens, rotDens

    i = 0
    open(newunit=u, file="freqs.dat", action="read") !read frequencies
    do
        read(u,*, iostat=statt)
        if (statt /= 0) then
            exit
        end if
        i = i + 1
    end do
    close(u)
    allocate(freqs(i))
    open(newunit=u, file="freqs.dat", action="read")
    do i = 1, size(freqs)
        read(u,*) freq
        freqs(i) = nint(scaleFactor*freq)
    end do
    close(u)

    do i = 0, (size(rho(:,1))-1) !densities of states for the free rotor
        rho(i,1) = 1.0_dp*i
        rho(i,2) = frotDens(1.0_dp*i)
    end do

    do j = 1, size(freqs)  !free rotor + harmonic frequencies densities of states (Beyer-Swineheart)
        do i = freqs(j), (size(rho(:,1))-1)
            rho(i,2) = rho(i,2) + rho(i-freqs(j),2)
        end do
    end do

    i = 0
    open(newunit=u, file="stateSum.dat", action="read")
    do
        read(u,*, iostat=statt)
        if (statt /= 0) then
            exit
        end if
        i = i + 1
    end do
    close(u)
    allocate(Ntrans(i,2))
    allocate(coef1(i))
    allocate(coef2(i))
    allocate(coef3(i))

    open(newunit=u, file="stateSum.dat", action="read") !state sum for transitional modes
    do i = 1, size(Ntrans(:,1))
        read(u,*) Ntrans(i,1), Ntrans(i,2)
    end do
    close(u)

    call spline(Ntrans(:,1), Ntrans(:,2), coef1, coef2, coef3, size(Ntrans(:,1))) !spline fit to transitional modes state sum


    !convolution integral of transitional modes state sum and free rotor + harmonic frequencies densities of states
    Ntot = 0.0_dp
    !$omp parallel shared(Ntrans, coef1, coef2, coef3, Ntot, rho) private(i, j)
    !$omp do
    do j = 0, (size(Ntot(:,1))-1)
        Ntot(j,1) = j*1.0_dp

        do i = 0, j
            if(i == 0) then
                Ntot(j,2) = ispline(i*1.0_dp, Ntrans(:,1), Ntrans(:,2), coef1, coef2, coef3, size(Ntrans(:,1)))*rho(j,2)
            else
                Ntot(j,2) = Ntot(j,2) + (&
                & ispline(i*1.0_dp, Ntrans(:,1), Ntrans(:,2), coef1, coef2, coef3, size(Ntrans(:,1)))*rho(j-i,2) &
                & + &
                 & ispline((i-1)*1.0_dp, Ntrans(:,1), Ntrans(:,2), coef1, coef2, coef3, size(Ntrans(:,1)))*rho(j-(i-1),2) &
                &)/2
            end if
        end do
    end do
    !$omp end do
    !$omp end parallel
    Ntot(:,2) = Ntot(:,2)* 2*0.85_dp/(2*6)

    !spline fit to total state sum
    call spline(Ntot(:,1), Ntot(:,2), coef4, coef5, coef6, size(Ntot(:,1)))

    !give MESMER input (5001 points)
    open(newunit=u, file="stateSumOut.dat", status="replace")
    do i = 0, 5000
        write(u,*) string(10**(i*dE), ispline(10**(i*dE), Ntot(:,1), Ntot(:,2), coef4, coef5, coef6, size(Ntot(:,1))))
    end do
    close(u)

end program main

function frotDens(E) result(rotDensOut)
    implicit none
    integer, parameter :: iprec = selected_int_kind(8)
    integer, parameter :: dp = selected_real_kind(10, 10)

    real(kind = dp), parameter :: B = 15.06683622_dp

    real(kind = dp), intent(in) :: E
    real(kind = dp) :: rotDensOut

    if(E < 1.0_dp) then
        rotDensOut = 1.0_dp
    else
        rotDensOut = sqrt(1.0_dp/(B*E))
    end if


end function

function string(energy, stateSum) result(str)
    implicit none
    integer, parameter :: iprec = selected_int_kind(8)
    integer, parameter :: dp = selected_real_kind(10, 10)

    real(kind = dp), intent(in) :: energy, stateSum
    character(len=120) :: E, N, str

    str = '<me:SumOfStatesPoint energy="'
    write(E,*) energy
    str = trim(str) // adjustl(E)
    str = trim(str) // '">'
    write(N,*) stateSum
    str = trim(str) // adjustl(N)
    str = trim(str) // '</me:SumOfStatesPoint>'
end function

subroutine spline (x, y, b, c, d, n)
    !======================================================================
    !  Calculate the coefficients b(i), c(i), and d(i), i=1,2,...,n
    !  for cubic spline interpolation
    !  s(x) = y(i) + b(i)*(x-x(i)) + c(i)*(x-x(i))**2 + d(i)*(x-x(i))**3
    !  for  x(i) <= x <= x(i+1)
    !  Alex G: January 2010
    !----------------------------------------------------------------------
    !  input..
    !  x = the arrays of data abscissas (in strictly increasing order)
    !  y = the arrays of data ordinates
    !  n = size of the arrays xi() and yi() (n>=2)
    !  output..
    !  b, c, d  = arrays of spline coefficients
    !  comments ...
    !  spline.f90 program is based on fortran version of program spline.f
    !  the accompanying function fspline can be used for interpolation
    !======================================================================
    implicit none
    integer, parameter :: iprec = selected_int_kind(8)
    integer, parameter :: dp = selected_real_kind(10, 10)

    integer(kind = iprec) :: n
    integer(kind = iprec) :: i, j, gap
    real(kind = dp) :: x(n), y(n), b(n), c(n), d(n)
    real(kind = dp) :: h

    gap = n-1
    ! check input
    if ( n < 2 ) return
    if ( n < 3 ) then
        b(1) = (y(2)-y(1))/(x(2)-x(1))   ! linear interpolation
        c(1) = 0.0_dp
        d(1) = 0.0_dp
        b(2) = b(1)
        c(2) = 0.0_dp
        d(2) = 0.0_dp
        return
    end if
    !
    ! step 1: preparation
    !
    d(1) = x(2) - x(1)
    c(2) = (y(2) - y(1))/d(1)
    do i = 2, gap
        d(i) = x(i+1) - x(i)
        b(i) = 2.0_dp*(d(i-1) + d(i))
        c(i+1) = (y(i+1) - y(i))/d(i)
        c(i) = c(i+1) - c(i)
    end do
    !
    ! step 2: end conditions
    !
    b(1) = -d(1)
    b(n) = -d(n-1)
    c(1) = 0.0_dp
    c(n) = 0.0_dp
    if(n /= 3) then
        c(1) = c(3)/(x(4)-x(2)) - c(2)/(x(3)-x(1))
        c(n) = c(n-1)/(x(n)-x(n-2)) - c(n-2)/(x(n-1)-x(n-3))
        c(1) = c(1)*d(1)**2/(x(4)-x(1))
        c(n) = -c(n)*d(n-1)**2/(x(n)-x(n-3))
    end if
    !
    ! step 3: forward elimination
    !
    do i = 2, n
        h = d(i-1)/b(i-1)
        b(i) = b(i) - h*d(i-1)
        c(i) = c(i) - h*c(i-1)
    end do
    !
    ! step 4: back substitution
    !
    c(n) = c(n)/b(n)
    do j = 1, gap
        i = n-j
        c(i) = (c(i) - d(i)*c(i+1))/b(i)
    end do
    !
    ! step 5: compute spline coefficients
    !
    b(n) = (y(n) - y(gap))/d(gap) + d(gap)*(c(gap) + 2.0*c(n))
    do i = 1, gap
        b(i) = (y(i+1) - y(i))/d(i) - d(i)*(c(i+1) + 2.0*c(i))
        d(i) = (c(i+1) - c(i))/d(i)
        c(i) = 3.*c(i)
    end do
    c(n) = 3.0_dp*c(n)
    d(n) = d(n-1)
end subroutine spline

function ispline(u, x, y, b, c, d, n)
    !======================================================================
    ! function ispline evaluates the cubic spline interpolation at point z
    ! ispline = y(i)+b(i)*(u-x(i))+c(i)*(u-x(i))**2+d(i)*(u-x(i))**3
    ! where  x(i) <= u <= x(i+1)
    !----------------------------------------------------------------------
    ! input..
    ! u       = the abscissa at which the spline is to be evaluated
    ! x, y    = the arrays of given data points
    ! b, c, d = arrays of spline coefficients computed by spline
    ! n       = the number of data points
    ! output:
    ! ispline = interpolated value at point u
    !=======================================================================
    implicit none
    integer, parameter :: iprec = selected_int_kind(8)
    integer, parameter :: dp = selected_real_kind(10, 10)

    integer(kind = iprec) :: n
    integer(kind = iprec) :: i, j, k

    real(kind = dp) :: ispline
    real(kind = dp) :: u, x(n), y(n), b(n), c(n), d(n)
    real(kind = dp) :: dx

    ! if u is ouside the x() interval take a boundary value (left or right)
    if(u <= x(1)) then
        ispline = y(1)
        return
    end if
    if(u >= x(n)) then
        ispline = y(n)
        return
    end if

    !*
    !  binary search for for i, such that x(i) <= u <= x(i+1)
    !*
    i = 1
    j = n+1
    do while (j > i+1)
        k = (i+j)/2
        if(u < x(k)) then
            j=k
        else
            i=k
        end if
    end do
    !*
    !  evaluate spline interpolation
    !*
    dx = u - x(i)
    ispline = y(i) + dx*(b(i) + dx*(c(i) + dx*d(i)))
end function ispline
