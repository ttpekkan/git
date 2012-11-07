
program hello
    implicit none
    integer*16 :: row, column
    integer, dimension(50, 50) :: array

    call fillArray
    call printArray(50, 50)

contains

    subroutine fillArray
        integer :: i, j, someNumber

        do i = 1, 50
            do j = 1, 50
                someNumber = 0
                if(i == j) then
                    array(i,j) = 0
                else if(i == 1) then
                    array(1,j) = j-1
                else if(j == 1) then
                    array(i, 1) = i-1
                else
                    do
                        if(checkRowAndColumn(i, j, someNumber) == -1) then
                            array(i,j) = someNumber
                            exit
                        end if
                        someNumber = someNumber + 1
                    end do
                end if
            end do
            call printArray(50, 50)
            write(*,*)
            write(*,*)
            write(*,*)
            write(*,*)
            write(*,*)
            write(*,*)
        end do
    end subroutine fillArray

    function checkRowAndColumn(x,y, someNumber) result(exists)
        integer :: x, y, exists, i, someNumber

        do i = 1, y-1
            if(array(x,i) == someNumber) then
                exists = 1
                return
            end if
        end do
        do i = 1, x-1
            if(array(i,y) == someNumber) then
                exists = 1
                return
            end if
        end do
        exists = -1
    end function checkRowAndColumn

    subroutine printArray(x,y)
        integer :: i, j, x, y
        do i = 1, y
            do j = 1, x
                write(*,'(i3)', advance = 'no') array(i,j)
            end do
            write(*,*)
        end do
    end subroutine printArray
end program

