program printCheckerBoard
    implicit none
    integer :: i, n
    integer, allocatable, dimension(:,:) :: squareArray

    write(6, '(a)', advance = 'no') 'Give the dimension of the square array ( < 100): '
    read(5, '(I10)') n

    allocate(squareArray(n,n))

    write(*,*)
    do i = 1, n
        if (mod(i,2) == 0) then
            squareArray(1:n:2, i) = 1
            squareArray(2:n:2, i) = 0
        else
            squareArray(1:n:2, i) = 0
            squareArray(2:n:2, i) = 1
        end if
        write(6,'(a)', advance = 'no') '!  '      !For example output comment.
        write(6, '(100(I1))') squareArray(:,i)    !Symmetric matrix, so we can print columns as rows.
    end do

end program printCheckerBoard


!Example output:

!Give the dimension of the square array ( < 100): 16

!  0101010101010101
!  1010101010101010
!  0101010101010101
!  1010101010101010
!  0101010101010101
!  1010101010101010
!  0101010101010101
!  1010101010101010
!  0101010101010101
!  1010101010101010
!  0101010101010101
!  1010101010101010
!  0101010101010101
!  1010101010101010
!  0101010101010101
!  1010101010101010




