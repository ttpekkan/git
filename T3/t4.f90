program fairAndSquare
    implicit none
    real, dimension(2,2) :: squares
    integer :: i, j

    do i = 1, 2
        do j = 1, 2
            write(6,'(a)', advance = 'no') 'Give the matrix element '
            write(6,'(I1)', advance = 'no') i
            write(6,'(a)', advance = 'no') ' x '
            write(6,'(I1)', advance = 'no') j
            write(6,'(a)', advance = 'no') ': '
            read(5,*) squares(i,j)
        end do
    end do
    squares = squares**2
    write(*,*)
    write(6,'(a)') 'The given values squared:'
    write(*,*)
    do i = 1, 2
        do j = 1, 2
            write(6, '(F10.4)', advance = 'no') squares(i,j)
        end do
        write(*,*)
    end do

end program fairAndSquare

! Output
!
!Give the matrix element 1 x 1: 2
!Give the matrix element 1 x 2: 3
!Give the matrix element 2 x 1: 4
!Give the matrix element 2 x 2: 5

!The given values squared:
!
!    4.0000    9.0000
!   16.0000   25.0000
