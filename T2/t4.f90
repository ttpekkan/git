program testRealKind
  implicit none
  integer :: i, rk

  do i=1,50
     rk=selected_real_kind(i,5)
     write(*,'(a)', advance = 'no') '! '
     write(6,'(I2)', advance = 'no') i
     write(*,'(a)', advance = 'no') '   '
     write(6,'(I2)') rk
  end do
end program testRealKind

!I take it this means my compiler supports quadratic precision (real*16).

!Output:
!  1    4
!  2    4
!  3    4
!  4    4
!  5    4
!  6    4
!  7    8
!  8    8
!  9    8
! 10    8
! 11    8
! 12    8
! 13    8
! 14    8
! 15    8
! 16   10
! 17   10
! 18   10
! 19   16
! 20   16
! 21   16
! 22   16
! 23   16
! 24   16
! 25   16
! 26   16
! 27   16
! 28   16
! 29   16
! 30   16
! 31   16
! 32   16
! 33   16
! 34   -1
! 35   -1
! 36   -1
! 37   -1
! 38   -1
! 39   -1
! 40   -1
! 41   -1
! 42   -1
! 43   -1
! 44   -1
! 45   -1
! 46   -1
! 47   -1
! 48   -1
! 49   -1
! 50   -1
