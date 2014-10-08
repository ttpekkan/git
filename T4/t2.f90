program moreMatrices
    implicit none
    integer :: i
    integer, dimension(3,4) :: array

    array(1,:) = [ (i, i = 1, 4) ]
    array(2,:) = [ (i, i = 5, 8) ]
    array(3,:) = -2

    do i = 1, 3
        write(6, '(10(I2))' ) array(i,:)
    end do

end program moreMatrices

!Output:

! 1 2 3 4
! 5 6 7 8
!-2-2-2-2
