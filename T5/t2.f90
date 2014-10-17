program disarray
    implicit none
    real :: randomNumber
    integer :: arraySize, i, errorNumber
    integer, allocatable, dimension(:) :: integerArray
    logical :: fileExists

    call init_random_seed()
    call random_number(randomNumber)
    arraySize = randomNumber*9 + 1
    allocate(integerArray(arraySize))

    inquire(file = 'PellePeloton', exist = fileExists)
    if(fileExists) then
        open(unit = 11, file = 'PellePeloton', iostat = errorNumber, status = 'replace', access = 'stream', form = 'unformatted')
    else
        open(unit = 11, file = 'PellePeloton', iostat = errorNumber, status = 'new', access = 'stream', form = 'unformatted')
    end if

    if(errorNumber /= 0) then
        write(6,'(a)') 'Räjähdys!'
        stop
    end if

    write(11), arraySize

    do i = 1, arraySize
        call random_number(randomNumber)
        integerArray(i) = randomNumber*99
    end do
    write(11), integerArray

    close(11)

    write(6,'(50(I4))') integerArray(:)   !For checking purposes.

end program disarray

!Example Array: 71  33  21  16  66  82  95  25

!Found this here:
!https://gcc.gnu.org/onlinedocs/gfortran/RANDOM_005fSEED.html

subroutine init_random_seed()
    use iso_fortran_env, only: int64
    implicit none
    integer, allocatable :: seed(:)
    integer :: i, n, un, istat, dt(8), pid
    integer(int64) :: t

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
        call system_clock(t)
        if (t == 0) then
            call date_and_time(values=dt)
            t = (dt(1) - 1970) * 365_int64 * 24 * 60 * 60 * 1000 &
                + dt(2) * 31_int64 * 24 * 60 * 60 * 1000 &
                + dt(3) * 24_int64 * 60 * 60 * 1000 &
                + dt(5) * 60 * 60 * 1000 &
                + dt(6) * 60 * 1000 + dt(7) * 1000 &
                + dt(8)
        end if
        pid = getpid()
        t = ieor(t, int(pid, kind(t)))
        do i = 1, n
            seed(i) = lcg(t)
        end do
    end if
    call random_seed(put=seed)
contains
    ! This simple PRNG might not be good enough for real work, but is
    ! sufficient for seeding a better PRNG.
    function lcg(s)
        integer :: lcg
        integer(int64) :: s
        if (s == 0) then
            s = 104729
        else
            s = mod(s, 4294967296_int64)
        end if
        s = mod(s * 279470273_int64, 4294967291_int64)
        lcg = int(mod(s, int(huge(0), int64)), kind(0))
    end function lcg
end subroutine init_random_seed
