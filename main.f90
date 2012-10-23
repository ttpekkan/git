
program t4
    implicit none
    integer, dimension(:,:), allocatable :: numberArray
    integer :: squareSize, counter, i, j

    write(*,'(a)', advance = 'no') 'Anna koko: '
    read(*,*) squareSize

    allocate(numberArray(squareSize, squareSize))

    do i = 1, squareSize
        if (mod(i,2) == 0) then
            counter = i**2
            do j = 1, i
                numberArray(i,j) = counter
                counter = counter - 1
            end do
            counter = (i - 1)**2 + 1
            do j = 1, i - 1
                numberArray(j,i) = counter
                counter = counter + 1
            end do
        else
            counter = (i - 1)**2 + 1
            do j = 1, i
                numberArray(i,j) = counter
                counter = counter + 1
            end do
            counter = i**2
            do j = 1, i - 1
                numberArray(j,i) = counter
                counter = counter - 1
            end do
        end if


    end do

    do i = 1, squareSize
        do j = 1, squareSize
            write(*,'(i5)', advance = 'no') numberArray(i,j) !Isoilla luvuilla printtiä pitää vähän säätää.
        end do
         write(*,*)
         write(*,*)
    end do

end program

