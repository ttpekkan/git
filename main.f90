program t3
    implicit none
    character(len = 512) :: inputWord
    character(len = :), allocatable :: word, temporaryWord
    character(len = 50), dimension(:), allocatable :: palindromeArray
    integer :: wordLength, palindromeFunction, palindromeCounter, point, i, j, k

    write(*,'(a)', advance = 'no') 'Anna Merkkijono: '
    read(*,'(a)') inputWord
    wordLength = len_trim(inputWord)
    word = inputWord(1:wordLength)

    palindromeCounter = 0
    temporaryWord = ''

    do i = 1, wordLength  !Tämä vasta laskee palindromien määrän, jotta voidaan tehdä oikean kokoinen array.
        point = i
        do j = i, wordLength
            temporaryWord = temporaryWord // word(point:point)
            point = point + 1
            if (palindromeFunction(temporaryWord, len(temporaryWord)) == 1) then
                palindromeCounter = palindromeCounter + 1
            end if
        end do
        temporaryWord = ''
    end do

    allocate(palindromeArray(palindromeCounter))
    palindromeCounter = 1
    temporaryWord = ''

    do i = 1, wordLength  !Tämä samannäköinen looppi sitten lisää sanat listaan. Tarkistaa myös mahdolliset toistot.
        point = i
        do j = i, wordLength
            temporaryWord = temporaryWord // word(point:point)
            point = point + 1
            if (palindromeFunction(temporaryWord, len(temporaryWord)) == 1) then
                do k = 1, palindromeCounter
                    if (palindromeArray(k) == temporaryWord) then
                        goto 45
                    end if
                end do
                palindromeArray(palindromeCounter) = temporaryWord
                palindromeCounter = palindromeCounter + 1
45         end if
        end do
        temporaryWord = ''
    end do

    write(*,'(i8)',advance = 'no') (palindromeCounter - 1) !Numero ei tulostu, jos palindromeja on yli 8-numeroinen luku
    write(*,'(a)') ' palindromia'
    do i = 1, wordLength                !Kaksi looppia tarpeellista vain, jos haluaa listata sanat kokojärjestyksessä.
        do j = 1, palindromeCounter - 1
            if (len_trim(palindromeArray(j)) == i) then
                write(*,*) palindromeArray(j)
            end if
        end do
    end do

end program

function palindromeFunction(givenWord, givenLength) result(isPalindrome)
    implicit none
    integer :: givenLength, isPalindrome, startPoint
    character(len = givenLength) :: givenWord, testWord

    testWord = ''
    startPoint = givenLength
    do while (startPoint > 0)
        testWord = trim(testWord) // givenWord(startPoint:startPoint)
        startPoint = startPoint - 1
    end do
    if (testWord == givenWord) then
        isPalindrome = 1
    else
        isPalindrome = -1
    end if
end function palindromeFunction




