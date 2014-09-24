program bitReader
    implicit none
    integer, parameter :: pr = selected_real_kind(4,20)
    real(kind = pr) :: a

    a = 0.875
    write(*,'(1ES12.3E4)', advance = 'no') a
    write(*,*)
    write(6,'(b32.32)') a
    write(*,*)

end program bitReader

!Output
! 8.750E-0001
!00111111011000000000000000000000


!sign bit:0
!binary exponent: 01111110
!mantissa: 11000000000000000000000
