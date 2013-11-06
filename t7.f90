program MonteCarlo
    implicit none
    integer :: i, j, points, nIn, nTotal
    real*16 :: x, y, theFunction, integral, lowerLimit, upperLimit

    lowerLimit = 0.0
    upperLimit = 2.0
    nIn = 0
    nTotal = 0
    points = 100000

    call init_random_seed()

    open(unit = 1, file = 'pisteet')
    write(*,*) 'Monte Carlo results:'
    do i = 1, 10
        integral = 0.0
        do j = 1, points
            call random_number(x)
            x = upperLimit - (upperLimit - lowerLimit)*x
            call random_number(y)
            y = theFunction(upperLimit)*y
            nTotal = nTotal + 1
            if(y <= theFunction(x)) then
                nIn = nIn + 1
                write(1,*) real(x), real(y), -1.0
            else
                write(1,*) real(x), -1.0, real(y)
            end if
        end do
        integral = ((1.0*nIn)/nTotal)*theFunction(upperLimit)*(upperLimit-lowerLimit)
        write(*,*) integral
    end do
    close(1)
    write(*,*) 'Exact result: 6.389056099'

end program

function theFunction(x) result(aValue)
    real*16 :: x, aValue, e

    e = 2.7182818284590452353602874713526624977572470936999595q+0
    aValue = e**x
end function

subroutine init_random_seed()
    implicit none
    integer, allocatable :: seed(:)
    integer :: i, n, un, istat, dt(8), pid, t(2), s
    integer(8) :: count, tms

    call random_seed(size = n)
    allocate(seed(n))
    ! First try if the OS provides a random number generator
    open(newunit=un, file="/dev/urandom", access="stream", &
        form="unformatted", action="read", status="old", iostat=istat)
    if (istat == 0) then
        read(un) seed
        close(un)
    else
        ! Fallback to XOR:ing the current time and pid. The PID is
        ! useful in case one launches multiple instances of the same
        ! program in parallel.
        call system_clock(count)
        if (count /= 0) then
            t = transfer(count, t)
        else
            call date_and_time(values=dt)
            tms = (dt(1) - 1970) * 365_8 * 24 * 60 * 60 * 1000 &
                + dt(2) * 31_8 * 24 * 60 * 60 * 1000 &
                + dt(3) * 24 * 60 * 60 * 60 * 1000 &
                + dt(5) * 60 * 60 * 1000 &
                + dt(6) * 60 * 1000 + dt(7) * 1000 &
                + dt(8)
            t = transfer(tms, t)
        end if
        s = ieor(t(1), t(2))
        pid = getpid() + 1099279 ! Add a prime
        s = ieor(s, pid)
        if (n >= 3) then
            seed(1) = t(1) + 36269
            seed(2) = t(2) + 72551
            seed(3) = pid
            if (n > 3) then
                seed(4:) = s + 37 * (/ (i, i = 0, n - 4) /)
            end if
        else
            seed = s + 37 * (/ (i, i = 0, n - 1 ) /)
        end if
    end if
    call random_seed(put=seed)
end subroutine init_random_seed
