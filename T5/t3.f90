program openArray
    implicit none
    integer :: i, arraySize, errorNumber
    integer, allocatable, dimension(:) :: integerArray
    logical :: fileExists

    inquire(file = 'PellePeloton', exist = fileExists)
    if(fileExists) then
        open(unit = 11, file = 'PellePeloton', iostat = errorNumber, status = 'old', access = 'stream', form = 'unformatted')
    else
        write(*,'(a)') 'File ''PellePeloton'' does not exist.'
        stop
    end if

    if(errorNumber /= 0) then
        write(6,'(a)') 'Räjähdys!'
        stop
    end if

    read(11) arraySize
    allocate(integerArray(arraySize))

    do i = 1, arraySize
        read(11) integerArray(i)
    end do

    close(11)

    write(6,'(50(I4))') integerArray(:)   !For checking purposes.

end program openArray

!Was able to reproduce the array: 71  33  21  16  66  82  95  25

