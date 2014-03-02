module gol_ioPar
    implicit none

contains

    subroutine draw(board_1, iter, imNum)
        integer, parameter :: print_unit = 10
        integer, dimension(:,:) :: board_1
        integer, intent(in) :: iter
        character(len=24) :: filename
        character(len=4) :: a, b
        integer :: i, j, w, h, ios, imNum
        h = size(board_1,1)-2
        w = size(board_1,2)-2
        write(a,'(I4.4)') iter
        write(b,'(I4.4)') imNum
        a = adjustl(a)
        b = adjustl(b)
        filename = 'life_' // trim(a) // '_' // trim(b) // '.pbm'
        filename = adjustl(filename)
        open(unit = 11, file = filename)
        write(11,*) 'P1'
        write(11,*) w, h
        do i = 2, h+1
            do j = 2, w+1
                write(11,'(I2)', advance = 'no') board_1(i,j)
            end do
            write(11,*)
        end do
        close(11)
    end subroutine draw

end module gol_ioPar
