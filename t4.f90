
program thirdOrderPolynomialRootFinder
    implicit none
    real*8 :: a, b, c, d, x1, x2, newton, secant, answer
    integer :: iterations
    character(len = 20) :: response
    common/a/  a, b, c, d, iterations

    iterations = 0
    do
        write(*,*) 'Type "N" for Newton method and "S" for secant method.'
        write(*,*)
        write (*,'(a)', advance = 'no') 'Response: '
        read(*,'(a)') response
        write(*,*)
        if(response == 'N' .or. response == 'n') then
            write(*,*) 'Give the parameters a, b, c and d and the initial value for x '
            write(*,*) 'for the polynomial a*x**3 + b*x**2 + c*x + d . It is preferable'
            write(*,*) 'that real roots for your polynomial exist.'
            write(*,*)
            write(*,'(a)', advance = 'no') 'a = '
            read(*,*) a
            write (*,'(a)', advance = 'no') 'b = '
            read(*,*) b
            write(*,'(a)', advance = 'no') 'c = '
            read(*,*) c
            write(*,'(a)', advance = 'no') 'd = '
            read(*,*) d
            write (*,'(a)', advance = 'no') 'x = '
            read(*,*) x1
            write(*,*)
            answer = newton(x1)
            write(*,'(a)', advance = 'no') 'One of the roots for the polynomial is x = '
            write(*,*) answer
            write(*,*) 'Iterations:', iterations
            exit
        else if(response == 'S' .or. response == 's') then
            write(*,*) 'Give the parameters a, b, c and d and the initial values for x2 and x1'
            write(*,*) 'for the polynomial a*x**3 + b*x**2 + c*x + d'
            write(*,*)
            write(*,'(a)', advance = 'no') 'a = '
            read(*,*) a
            write(*,'(a)', advance = 'no') 'b = '
            read(*,*) b
            write(*,'(a)', advance = 'no') 'c = '
            read(*,*) c
            write(*,'(a)', advance = 'no') 'd = '
            read(*,*) d
            write(*,'(a)', advance = 'no') 'x2 = '
            read(*,*) x2
            write(*,'(a)', advance = 'no') 'x1 = '
            read(*,*) x1
            write(*,*)
            answer = secant(x2, x1)
            write(*,'(a)', advance = 'no') 'One of the roots for the polynomial is x = '
            write(*,*) answer
            write(*,*) 'Iterations:', iterations
            exit
        else
            write(*,*) 'Please try again'
        end if
    end do
end program

function poly(x) result(thePoly)
    implicit none
    real*8 :: a, b, c, d, x, thePoly
    common/a/ a, b, c, d

    thePoly = a*x**3 + b*x**2 + c*x + d

end function poly

function differentiate(x) result(derivative)
    implicit none
    real*8 :: a, b, c, d, x, derivative
    common/a/ a, b, c, d

    derivative = 3*a*x**2 + 2*b*x + c

end function differentiate

recursive function newton(x1) result(zeroN)
    implicit none
    real*8 :: a, b, c, d, x1, x2, zeroN, poly, differentiate
    integer :: iterations
    common/a/  a, b, c, d, iterations

    if(differentiate(x1) == 0) then
        write(*,*) 'Divide by zero error, choose a better starting value for x (your polynomial may be shitty too).'
        stop
    end if

    x2 = x1 - poly(x1) / differentiate(x1)

    iterations = iterations + 1
    if(iterations > 2000) then
         write(*,*) 'Failed to converge (or converges very slowly), 2001 iterations,'
         write(*,*) 'choose a better starting value for x (your polynomial may be shitty too).'
        stop
    end if

    if(abs(x2 - x1) < 1e-13)  then
        zeroN = x1
        return
    end if
    zeroN = newton(x2)
    return

end function newton

recursive function secant(x2, x1) result(zeroS)
    implicit none
    real*8 :: a, b, c, d, x3, x2, x1, zeroS, poly, differentiate
    integer :: iterations
    common/a/  a, b, c, d, iterations

    if(poly(x2)-poly(x1) == 0) then
        write(*,*) 'Divide by zero error, choose a better starting value for x (your polynomial may be shitty too).'
        stop
    end if

    x3 = x2 - poly(x2) * ( (x2-x1)/(poly(x2)-poly(x1)) )

    iterations = iterations + 1
    if(iterations > 2000) then
        write(*,*) 'Failed to converge (or converges very slowly), 2001 iterations,'
        write(*,*) 'choose a better starting value for x (your polynomial may be shitty too).'
        stop
    end if

    if(abs(x3-x2) < 1e-13)  then
        zeroS = x3
        return
    end if
    zeroS = secant(x3, x2)
    return

end function secant
