
program simpsonIntegration
    implicit none
    real*16 :: upperLimit, lowerLimit, sections, interval, point, integral, aFunction

    lowerLimit = 0.0q+0
    upperLimit = 2.0q+0
    sections = 100000.0q+0
    interval = (upperLimit - lowerLimit)/sections
    integral = 0.0q+0

    point = interval
    do while(point < upperLimit)
        integral = integral + (4.0q+0)*aFunction(point)
        point = point + 2*interval
    end do
    point = 2*interval
    do while(point < upperLimit-interval)
        integral = integral + (2.0q+0)*aFunction(point)
        point = point + 2*interval
    end do
    integral = (interval/(3.0q+0))*(aFunction(lowerLimit) + aFunction(upperLimit) + integral)

    write(*,*) integral
end program

function aFunction(x) result(theValue)
    implicit none
    real*16 :: x, e, theValue

    e = 2.7182818284590452353602874713526624977572470936999595q+0
    theValue = e**(x**(2.0q+0))
end function aFunction
