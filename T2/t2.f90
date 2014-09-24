program bitReader
    implicit none
    integer(kind = 1) :: i

    write(*,'(a)', advance = 'no') 'Give a one byte integer: '
    read(5, '(I8)') i
    write(*,'(I4)', advance = 'no') i
    write(*,'(a)', advance = 'no') '  '
    write(6,'(b8.8)') i

    write(*,*)
    do i = 1, 127, 13
        write(*,'(I4)', advance = 'no') -i
        write(*,'(a)', advance = 'no') '  '
        write(6,'(b8.8)') -i
    end do

end program bitReader

!Example output (with negative integer demonstration)

!Give a one byte integer: 5
!   5  00000101
!
!  -1  11111111
! -14  11110010
! -27  11100101
! -40  11011000
! -53  11001011
! -66  10111110
! -79  10110001
! -92  10100100
!-105  10010111
!-118  10001010
