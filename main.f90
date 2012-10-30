
program hello
    implicit none
    integer, dimension(5,5) :: board
    integer :: i, j, total
    common /a/ total

    do i = 1, 5
        do j = 1, 5
            board(i,j) = 0
        end do
    end do
    total = 0

    call moveKnight(1, 1, 1, board, 0)
    write(*,*) total


end program

recursive subroutine moveKnight(i, j, counter, board)
    implicit none
    integer :: i, j, counter, checkIfOutside, total
    integer, dimension(5,5) :: board
    common /a/ total

    board(i,j) = counter
    if(counter == 25) then
        total = total + 1
        call printBoard(board)
    end if

    if(checkIfOutside(i+2, j+1) == -1) then
        if(board(i+2, j+1) == 0) then
            call moveKnight(i+2, j+1, counter+1, board)
        end if
    end if

    if(checkIfOutside(i+1, j+2) == -1) then
        if(board(i+1, j+2) == 0) then
            call moveKnight(i+1, j+2, counter+1, board)
        end if
    end if

    if(checkIfOutside(i-1, j+2) == -1) then
        if(board(i-1, j+2) == 0) then
            call moveKnight(i-1, j+2, counter+1, board)
        end if
    end if

    if(checkIfOutside(i-2, j+1) == -1) then
        if(board(i-2, j+1) == 0) then
            call moveKnight(i-2, j+1, counter+1, board)
        end if
    end if

    if(checkIfOutside(i-1, j-2) == -1) then
        if(board(i-1, j-2) == 0) then
            call moveKnight(i-1, j-2, counter+1, board)
        end if
    end if

    if(checkIfOutside(i+2, j-1) == -1) then
        if(board(i+2, j-1) == 0) then
            call moveKnight(i+2, j-1, counter+1, board)
        end if
    end if

    if(checkIfOutside(i+1, j-2) == -1) then
        if(board(i+1, j-2) == 0) then
            call moveKnight(i+1, j-2, counter+1, board)
        end if
    end if

    if(checkIfOutside(i-2, j-1) == -1) then
        if(board(i-2, j-1) == 0) then
            call moveKnight(i-2, j-1, counter+1, board)
        end if
    end if

    board(i,j) = 0
end subroutine moveKnight

subroutine printBoard(board)                !Kaikin puolin tyylikäs ratkaisu tulostukseen.
    integer :: i, j
    integer, dimension(5,5) :: board

    do i = 1, 5
        do j = 1, 5
            if(board(i,j) == 1) then
                write(*,'(a)', advance = 'no') 'A'
            else if(board(i,j) == 2) then
                write(*,'(a)', advance = 'no') 'B'
            else if(board(i,j) == 3) then
                write(*,'(a)', advance = 'no') 'C'
            else if(board(i,j) == 4) then
                write(*,'(a)', advance = 'no') 'D'
            else if(board(i,j) == 5) then
                write(*,'(a)', advance = 'no') 'E'
            else if(board(i,j) == 6) then
                write(*,'(a)', advance = 'no') 'F'
            else if(board(i,j) == 7) then
                write(*,'(a)', advance = 'no') 'G'
            else if(board(i,j) == 8) then
                write(*,'(a)', advance = 'no') 'H'
            else if(board(i,j) == 9) then
                write(*,'(a)', advance = 'no') 'I'
            else if(board(i,j) == 10) then
                write(*,'(a)', advance = 'no') 'J'
            else if(board(i,j) == 11) then
                write(*,'(a)', advance = 'no') 'K'
            else if(board(i,j) == 12) then
                write(*,'(a)', advance = 'no') 'L'
            else if(board(i,j) == 13) then
                write(*,'(a)', advance = 'no') 'M'
            else if(board(i,j) == 14) then
                write(*,'(a)', advance = 'no') 'N'
            else if(board(i,j) == 15) then
                write(*,'(a)', advance = 'no') 'O'
            else if(board(i,j) == 16) then
                write(*,'(a)', advance = 'no') 'P'
            else if(board(i,j) == 17) then
                write(*,'(a)', advance = 'no') 'Q'
            else if(board(i,j) == 18) then
                write(*,'(a)', advance = 'no') 'R'
            else if(board(i,j) == 19) then
                write(*,'(a)', advance = 'no') 'S'
            else if(board(i,j) == 20) then
                write(*,'(a)', advance = 'no') 'T'
            else if(board(i,j) == 21) then
                write(*,'(a)', advance = 'no') 'U'
            else if(board(i,j) == 22) then
                write(*,'(a)', advance = 'no') 'V'
            else if(board(i,j) == 23) then
                write(*,'(a)', advance = 'no') 'W'
            else if(board(i,j) == 24) then
                write(*,'(a)', advance = 'no') 'X'
            else
                write(*,'(a)', advance = 'no') 'Y'
            end if
          !  write(*,'(i3)', advance = 'no') board(i,j)
        end do
        write(*,*)
    end do
    write(*,*)
    write(*,*)
end subroutine printBoard

function checkIfOutside(i, j) result(outside)
    integer :: i, j, outside

    if (i > 5 .or. i < 1 .or. j > 5 .or. j < 1) then
        outside = 1
    else
        outside = -1
    end if
end function checkIfOutside


