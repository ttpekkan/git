
program t12
    implicit none
    integer*16 :: row, column, increment, columnCounter, rowCounter
    integer :: x, y
    integer*16, dimension(8,8) :: baseSquare, changingSquare

    baseSquare= reshape( (/ 0,1,2,3,4,5,6,7, 1,0,3,2,5,4,7,6, 2,3,0,1,6,7,4,5, 3,2,1,0,7,6,5,4, &
        4,5,6,7,0,1,2,3, 5,4,7,6,1,0,3,2, 6,7,4,5,2,3,0,1, 7,6,5,4,3,2,1,0  /), (/ 8, 8 /) )

    write(*,'(a)', advance = 'no') 'Anna rivi: '
    read(*,*) row
    write(*,'(a)', advance = 'no') 'Anna sarake: '
    read(*,*) column
    changingSquare = baseSquare
    columnCounter = 0
    rowCounter = 0

    do while(row > changingSquare(1,8) .or. column > changingSquare(1,8))
        changingSquare = 8*changingSquare
    end do

    increment = changingSquare(1,2)-changingSquare(1,1)
    do while(increment /= 1)
        x = 1
        y = 1
        do while(columnCounter + increment < column)
            x = x + 1
            columnCounter = columnCounter + increment
        end do
        do while(rowCounter + increment < row)
            y = y + 1
            rowCounter = rowCounter + increment
        end do
        changingSquare = baseSquare*increment/8 + changingSquare(x,y)
        increment = changingSquare(1,2)-changingSquare(1,1)
    end do

    write(*,*) 'Luku: ', changingSquare(column-columnCounter, row-rowCounter)

end program

