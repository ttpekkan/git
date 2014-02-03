! CSC Summer School 2012
! Introduction to Fortran 95/2003 Exercise 3
module gol_io
    implicit none

contains

    subroutine read_data(iter, height, width)
        integer, intent(out) :: iter, height, width

        write(*,'(a)', advance = 'no') 'Give board heigth: '
        read(*,'(I10)') height
        write(*,'(a)', advance = 'no') 'Give board width: '
        read(*,'(I10)') width
        write(*,'(a)', advance = 'no') 'Give iterations: '
        read(*,'(I10)') iter
        if (iter < 1 .or. height < 1 .or. width < 1) then
            write(*,*) ' You gave shitty parameters'
            call abort()
        end if
       ! TODO: implement the command-line input parsing

    end subroutine read_data

    subroutine draw(board_1, iter)
        integer, parameter :: print_unit = 10
        integer, dimension(:,:) :: board_1
        integer, intent(in) :: iter
        character(len=16) :: filename
        character(len=16) :: a
        integer :: i, j, w, h, ios
        h = size(board_1,1)-2
        w = size(board_1,2)-2
        write(a,'(I4.4)') iter
        a = adjustl(a)
        filename = 'life_' // trim(a) // '.pbm'
        filename = adjustl(filename)
        open(unit = 11, file = filename)
        write(11,*) 'P1'
        write(11,*) w, h
        do i = 1, h
            do j = 1, w
               write(11,'(I2)', advance = 'no') board_1(i,j)
            end do
            write(11,*)
        end do
        close(11)
        ! TODO: implement dumping the board into a file
        ! life_NNNN.pbm where NNNN=iter in the netpbm format
    end subroutine draw

end module gol_io
