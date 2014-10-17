program inchingTowardsTruth
    implicit none
    real :: inches

    write(6,'(a)') '! Inch to millimetre conversion table: '
    write(6,'(a)') '!'

    inches = 0.0
    do
        if(inches > 12.0) then
            exit
        end if
        write(6,'(a)', advance = 'no') '! '
        write(6,'(F5.2)', advance = 'no') inches
        write(6,'(a)', advance = 'no') ' inches = '
        write(6,'(F6.2)', advance = 'no') inches*25.4
        write(6,'(a)') ' millimetres'
        inches = inches + 0.5
    end do

end program inchingTowardsTruth

!Output:

! Inch to millimetre conversion table:
!
!  0.00 inches =   0.00 millimetres
!  0.50 inches =  12.70 millimetres
!  1.00 inches =  25.40 millimetres
!  1.50 inches =  38.10 millimetres
!  2.00 inches =  50.80 millimetres
!  2.50 inches =  63.50 millimetres
!  3.00 inches =  76.20 millimetres
!  3.50 inches =  88.90 millimetres
!  4.00 inches = 101.60 millimetres
!  4.50 inches = 114.30 millimetres
!  5.00 inches = 127.00 millimetres
!  5.50 inches = 139.70 millimetres
!  6.00 inches = 152.40 millimetres
!  6.50 inches = 165.10 millimetres
!  7.00 inches = 177.80 millimetres
!  7.50 inches = 190.50 millimetres
!  8.00 inches = 203.20 millimetres
!  8.50 inches = 215.90 millimetres
!  9.00 inches = 228.60 millimetres
!  9.50 inches = 241.30 millimetres
! 10.00 inches = 254.00 millimetres
! 10.50 inches = 266.70 millimetres
! 11.00 inches = 279.40 millimetres
! 11.50 inches = 292.10 millimetres
! 12.00 inches = 304.80 millimetres
