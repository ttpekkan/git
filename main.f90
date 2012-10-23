program t5
    implicit none
    integer :: squareSize, counter, i, j

    write(*,'(a)', advance = 'no') 'Anna koko: '
    read(*,*) squareSize

    do i = 1, squareSize
        if (mod(i,2) == 0) then
            counter = i**2
            do j = 1, i
                write(*,'(i5)', advance = 'no') counter
                counter = counter - 1
            end do
            do j = 1 + i, squareSize
                if (mod(j,2) /= 0) then
                    counter = j**2 - i + 1
                    write(*,'(i5)', advance = 'no') counter
                    if (j < squareSize) then
                        counter = counter + 2*i - 1
                        write(*,'(i5)', advance = 'no') counter
                    end if
                end if
            end do
        else
            counter = (i - 1)**2 + 1
            do j = 1, i
                write(*,'(i5)', advance = 'no') counter
                counter = counter + 1
            end do
            counter = counter - 1
            do j = i + 1, squareSize
                if (mod(j,2) == 0) then
                    counter = counter + 2*i - 1
                    write(*,'(i5)', advance = 'no') counter
                    if (j < squareSize) then
                        counter = (j + 1)**2 - i + 1
                        write(*,'(i5)', advance = 'no') counter
                    end if
                end if
            end do
        end if
        write(*,*)
        write(*,*)
    end do


end program
