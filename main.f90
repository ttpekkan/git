
program t2
    implicit none
    character(len = :), allocatable :: word
    character(len = 2054) :: inputWord
    integer :: wordLength, inputSize, i, j, point, rowNumber

    write (*,'(a)', advance = 'no') 'Anna koko: '
    read (*,*) inputSize
    write (*,'(a)', advance = 'no') 'Anna sana: '
    read (*,'(a)') inputWord
    wordLength = len_trim(inputWord)
    word = inputword(1:wordLength)

    point = 1
    rowNumber = 1
    do i = 1, inputSize
        do j = 1, inputSize
            write(*,'(a)', advance = 'no') word(point:point)
            point = point + inputSize
            if (point > wordLength) then
                point = point - wordLength
            end if
        end do
        rowNumber = rowNumber + 1
        point = rowNumber
        write(*,'(a)')
    end do
end program
