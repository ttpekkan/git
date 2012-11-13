
program hello
    implicit none
    character(len = 100) :: inputWord, startChar
    character(len = 1), dimension(26) :: chars
    integer, dimension(26) :: location
    integer :: i, counter
    common/a/ inputWord, counter

    write(*,'(a)', advance = 'no') 'Anna merkkijono: '
    read(*,*) inputWord

    call uniqueChars(inputWord, chars, location)
    do i = 1, 26
        if(chars(i) == '') then
            exit
        end if
        startChar = inputWord(i:i)
        call getSubstrings(startChar, location(i))
    end do
    write(*,*) counter

end program

recursive subroutine getSubstrings(substring, point)
    implicit none
    character(len = 100) :: substring, inputWord, nextWord
    character(len = 1), dimension(26) :: chars
    integer, dimension(26) :: location
    integer :: point, i, counter
    common/a/ inputWord, counter

    if(substring == inputWord) then
        return
    end if
    counter = counter + 1
    write(*,*) substring
    if(point == len_trim(inputWord)) then
        return
    end if
    call uniqueChars(inputWord(point+1:len_trim(inputWord)), chars, location)
    do i = 1, 26
        if(chars(i) == '') then
            exit
        end if
        nextWord = trim(substring) // chars(i)
        call getSubstrings(nextWord, location(i)+point)
    end do

end subroutine getSubstrings

subroutine uniqueChars(someString, chars, location)
    character(len = 100), intent(in) :: someString
    character(len = 1), dimension(26), intent(out) :: chars
    integer, dimension(26), intent(out) :: location
    integer :: i, j, counter

    counter = 0
    chars = ''
    location = 0
    do i = 1, len_trim(someString)
        do j = 1, counter
            if(someString(i:i) == chars(j)) then
                goto 999
            end if
        end do
        counter = counter + 1
        chars(counter) = someString(i:i)
        location(counter) = i
        999 continue
    end do
end subroutine uniqueChars


