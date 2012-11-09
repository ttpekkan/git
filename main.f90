
program t13
    implicit none
    integer, dimension(25) :: primes
    integer*16, dimension(100) :: array
    integer :: inputNumber, i
    integer*16 :: total, sumOfPrimeSums
    common/a/ array, primes

    primes = (/2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97/)
    write(*,'(a)', advance = 'no') 'Anna luku: '
    read(*,*) inputNumber
    total = 0

    do i = 1, 25
        if(primes(i) == inputNumber) then
            cycle
        end if
        total = total + sumOfPrimeSums((inputNumber-primes(i)))
    end do
    write(*,*) 'Tulos: ', total

end program

recursive function sumOfPrimeSums(someNumber) result(total)
    integer, dimension(25) :: primes
    integer*16, dimension(100) :: array
    integer :: someNumber, i
    integer*16 :: total
    common/a/ array, primes

    total = 0
    if(someNumber < 0) then
        return
    end if
    if(someNumber == 0) then
        total = 1
        return
    end if
    if(array(someNumber) /= 0) then
        total = array(someNumber)
        return
    end if
    do i = 1, 25
        array(someNumber) = array(someNumber) + sumOfPrimeSums((someNumber-primes(i)))
    end do
    total = array(someNumber)

end function sumOfPrimeSums
