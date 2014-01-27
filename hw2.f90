
program optimization
    implicit none
    integer, parameter :: n = 2, p = 50, max_iter = 1000, step = 10 !n = dimensions, p = population size
    real*16, dimension(n,p) :: pop, new_pop
    real*16, dimension(p) :: cost
    real*16, parameter :: c = 0.7q+0, r = 0.1q+0, low = -1000.0q+0, up = 1000.0q+0
    integer :: i

    call initialize
    call optimize
    write(*,*) 'Minimiarvo: ', minval(cost)
    do i = 1, n
           if(aFunction(pop(:,i)) == minval(cost)) then
                write(*,*) 'Minimikohta: ', pop(:,i)
                stop
            end if
    end do

contains

    function aFunction(x) result(aValue)
        implicit none
        real*16, parameter :: e = 2.7182818284590452353602874713526624977572470936999595q+0
        real*16, parameter :: pi = 3.1415926535897932384626433832795028841971693993751049q+0
        real*16, dimension(n) :: x
        real*16 :: aValue

        aValue = -cos(x(1))*cos(x(2))*(e**(-((x(1)-pi)**2 + (x(2)-pi)**2)))  !Easom function
    end function


    subroutine initialize
        implicit none
        integer :: pop_size, i

        pop_size = size(pop,2)

        if (size(cost) /= pop_size) then
            write(*,*) 'wrong sizes'
            stop
        end if

        call random_number(pop)
        pop = low + (up - low)*pop
        do i = 1, pop_size
            cost(i) = aFunction(pop(:,i))
        end do
    end subroutine

    subroutine optimize
        integer :: n, pop_size, iter, i, idx1, idx2, idx3
        real*16, dimension(size(pop,1)) :: trial
        real*16 :: score
        logical, dimension(size(pop,1)) :: mask

        n = size(pop,1)
        pop_size = size(pop,2)
        write (*,'(A,I2,/,A,I4,/,A,F5.3,/,A,F5.3)') &
            'Dimension: ', n, &
            'Population size: ', pop_size, &
            'c=', c, &
            'r=', r
        write (*,'(A,I4,G14.6)') &
            'Initial values, cost', 0, minval(cost)
        do iter = 1, max_iter
            do i = 1, pop_size
                call triple(i, pop_size, idx1, idx2, idx3)
                mask = rnd(n) < r
                mask(idx(n)) = .true.
                where (mask)
                    trial = pop(:,idx3) + c*(pop(:,idx1)-pop(:,idx2))
                elsewhere
                    trial = pop(:,i)
                end where
                score = aFunction(trial)
                if (score < cost(i)) then
                    new_pop(:,i) = trial
                    cost(i) = score
                else
                    new_pop(:,i) = pop(:,i)
                end if
            end do
            pop = new_pop
            if (mod(iter,step) == 0) then
                write (*,'(A,I4,G14.6)') 'Iteration, minimum: ', &
                    iter, minval(cost)
            end if
        end do
    end subroutine optimize

    subroutine triple(i, n, i1, i2, i3)
        implicit none
        integer, intent(IN) :: i, n
        integer, intent(OUT) :: i1, i2, i3
        do
            i1 = idx(n)
            if (i1 /= i) exit
        end do
        do
            i2 = idx(n)
            if (i2 /= i .and. i2 /= i1) exit
        end do
        do
            i3 = idx(n)
            if (all(i3 /= (/i,i1,i2/))) exit
        end do
    end subroutine triple

    function rnd(n)
        implicit none
        integer, intent(IN) :: n
        real, dimension(n) :: rnd
        call random_number(rnd)
    end function rnd

    integer function idx(n)
        implicit none
        integer, intent(IN) :: n
        real :: x
        call random_number(x)
        idx = n*x + 1
    end function idx

end program






