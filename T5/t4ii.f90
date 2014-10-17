program sumsAndSquares
    implicit none
    integer :: i
    real :: theSum, givenNumber

    theSum = 0.0

    write(6,'(a)') 'Give numbers and the program will calculate the sum of the squres of the numbers.'
    write(6,'(a)') 'Negative numbers will be ignored and zero will end the sum prematurely.'
    write(6,*)
    do i = 1, 100
        write(6,'(a)', advance = 'no') 'Give number '
        write(6,'(I3)', advance = 'no') i
        write(6,'(a)', advance = 'no') ': '

        read(5,*) givenNumber
        if(givenNumber < 0.0) then
            go to 999
        else if(abs(givenNumber) <= 1e-5) then
            exit
        else
            theSum = theSum + sqrt(givenNumber)
        end if
    999 continue
    end do

    write(6,*)
    write(6,'(a)', advance = 'no') 'The squre sum of the given numbers is: '
    write(6,'(F10.4)') theSum

end program sumsAndSquares

!Example output:

!Give numbers and the program will calculate the sum of the squres of the numbers.
!Negative numbers will be ignored and zero will end the sum prematurely.

!Give number   1: -5
!Give number   2: 2
!Give number   3: 0

!The squre sum of the given numbers is:     1.4142


