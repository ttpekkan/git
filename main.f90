
program t1
    implicit none
    character(len = :), allocatable :: word, longWord
    character(len = 2054) :: inputWord
    integer :: wordLength, inputSize, i, fromPoint, toPoint

    write (*,'(a)', advance = 'no') 'Anna koko: '
    read (*,*) inputSize
    write (*,'(a)', advance = 'no') 'Anna sana: '
    read (*,'(a)') inputWord
    wordLength = len_trim(inputWord)
    word = inputword(1:wordLength)

    longWord = ''
    do while (len(longWord) < (inputSize * inputSize))
        longWord = longWord // word
    enddo

    fromPoint = 1
    toPoint = inputSize
    do i = 1, inputSize
        write(*,'(a)') longWord(fromPoint:toPoint)
        fromPoint = toPoint + 1
        toPoint = toPoint + inputSize
    enddo
end program
