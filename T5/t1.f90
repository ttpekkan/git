program powersThatBe
    implicit none
    integer :: i
    real :: input
    real, dimension(6) :: theNumbers

    do
        write(6,'(a)', advance = 'no') '! Give a real number (give 0 to exit): '
        read(5,*) input

        if(abs(input) < 1e-4) then
            exit
        end if

        write(6,'(a)') '!'
        write(6,'(a)') '! The powers of 1-6 of the given number:'
        write(6,'(a)', advance = 'no') '!'
        theNumbers(:) = [ (input**i, i = 1, 6)]
        write(6,'(100(F15.4))') theNumbers(:)
        write(6,'(a)') '!'
    end do

end program powersThatBe

!Example output:

! Give a real number (give 0 to exit): 1
!
! The powers of 1-6 of the given number:
!         1.0000         1.0000         1.0000         1.0000         1.0000         1.0000
!
! Give a real number (give 0 to exit): 2
!
! The powers of 1-6 of the given number:
!         2.0000         4.0000         8.0000        16.0000        32.0000        64.0000
!
! Give a real number (give 0 to exit): 3
!
! The powers of 1-6 of the given number:
!         3.0000         9.0000        27.0000        81.0000       243.0000       729.0000
!
! Give a real number (give 0 to exit): 4
!
! The powers of 1-6 of the given number:
!         4.0000        16.0000        64.0000       256.0000      1024.0000      4096.0000
!
! Give a real number (give 0 to exit): 5
!
! The powers of 1-6 of the given number:
!         5.0000        25.0000       125.0000       625.0000      3125.0000     15625.0000
!
! Give a real number (give 0 to exit): 6
!
! The powers of 1-6 of the given number:
!         6.0000        36.0000       216.0000      1296.0000      7776.0000     46656.0000
!
! Give a real number (give 0 to exit): 7
!
! The powers of 1-6 of the given number:
!         7.0000        49.0000       343.0000      2401.0000     16807.0000    117649.0000
!
! Give a real number (give 0 to exit): 8
!
! The powers of 1-6 of the given number:
!         8.0000        64.0000       512.0000      4096.0000     32768.0000    262144.0000
!
! Give a real number (give 0 to exit): 9
!
! The powers of 1-6 of the given number:
!         9.0000        81.0000       729.0000      6561.0000     59049.0000    531441.0000
!
! Give a real number (give 0 to exit): 10
!
! The powers of 1-6 of the given number:
!        10.0000       100.0000      1000.0000     10000.0000    100000.0000   1000000.0000
!
! Give a real number (give 0 to exit): 0
