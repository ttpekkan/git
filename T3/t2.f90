program aProgramWithNoEqual
    implicit none
    real :: x, y, zero, minusOne

    zero = 0.0
    minusOne = -1.0

    x = sqrt(minusOne)
    y = zero/zero

    if(x /= x) then
        write(6,'(a)') 'x is not equal to x, ==> x = NaN'
    end if
    if(y /= y) then
        write(6,'(a)') 'y is not equal to y, ==> y = NaN'
    end if

end program aProgramWithNoEqual
