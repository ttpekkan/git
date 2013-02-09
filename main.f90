program t10
    implicit none
    character(len = 100):: calculation, removeEmptySpaces, letsDoSomeMaths !Vain sadan merkin pituisia laskuja

    write(*,'(a)', advance = 'no') 'Anna lasku: '
    read(*,'(a)') calculation
    calculation = removeEmptySpaces(calculation) !Inputissa saa siis olla tyhjää tilaa.
    call checkSyntax(calculation)
    calculation = letsDoSomeMaths(calculation)
    write(*,*) 'Vastaus: ', calculation
end program



recursive function letsDoSomeMaths(calculation) result(theResult)
    character(len = 100):: calculation, theResult, removeEmptySpaces, letsDoSomeMoreMaths, currentCalculation
    character(len = 6) :: operatorsAndBrackets
    integer :: i, a, b

    operatorsAndBrackets = '+-*/()' !Tarkistaa onko operoitavaa enää.
    do i = 1, len_trim(calculation)
        do a = 1, 6
            if(calculation(i:i) == operatorsAndBrackets(a:a)) then
                if (i == 1 .and. calculation(i:i) == '-') then !Ensimmäinen merkki saa olla - vastauksessa.
                    continue
                else
                    go to 999
                end if
            end if
        end do
    end do
    return
    999 continue
    a = 1
    b = len_trim(theResult)
    do i = 1, b
        if(theResult(i:i) == '(') then
            a = i
        end if
    end do
    do i = a, len_trim(theResult)
        if(theResult(i:i) == ')') then
            b = i
            exit
        end if
    end do
    if(theResult(a:a) == '(') then
        theResult(a:a) = ''
        theResult(b:b) = ''
    end if
    currentCalculation = theResult(a:b)
    theResult = trim(theResult(1:a-1)) // trim(letsDoSomeMoreMaths(currentCalculation)) // theResult(b+1:len_trim(theResult))
    theResult = removeEmptySpaces(theResult)
    theResult = letsDoSomeMaths(theResult)
end function letsDoSomeMaths

function letsDoSomeMoreMaths(calculation) result(theResult)
    character(len = 100):: calculation, theResult, removeEmptySpaces
    integer i, j, counter, startPoint, k
    real*4, dimension(100) :: numberArray

    counter = 1
    startPoint = 1
    theResult = removeEmptySpaces(calculation)
    do i = 1, len_trim(theResult)
        if(theResult(i:i) == '-' .and. i == 1) then
            cycle
        end if
        if(theResult(i:i) == '-') then
            k = i-1
            if(theResult(k:k) == '+' .or. theResult(k:k) == '/' .or. theResult(k:k) == '*' .or. theResult(k:k) == '-') then
                cycle
            end if
        end if
        if(theResult(i:i) == '+' .or. theResult(i:i) == '/' .or. theResult(i:i) == '*' .or. theResult(i:i) == '-') then
            read(theResult(startPoint:i-1),*) numberArray(counter) !numberArray(counter) = Double.parseDouble(theResu.......)
            counter = counter + 1
            startPoint = i + 1
        end if
    end do
    write(*,*) theResult
    read(theResult(startPoint:len_trim(theResult)),*) numberArray(counter)
    call divideAndRule
    call beProductive
    call needSomeAdditionalHelp !Tämä hoitaa vähennyksen myös.
    if(numberArray(1) < 0.1 .and. numberArray(1) > -0.1) then
        write(theResult,'(f0.15)') numberArray(1) !Ei printtaa mitään, vaan sama kun theResult = Double.toString(numberArray(i))
    else if(numberArray(1) > 10000 .or. numberArray(1) < -10000) then
        write(theResult,'(f30.2)') numberArray(1)
    else !Leikitään formaattien kanssa, ettei tule potenssimuotoa.
        write(theResult,*) numberArray(1)
    end if

contains
    subroutine divideAndRule
        counter = 1
        do i = 1, len_trim(theResult)
            if(theResult(i:i) == '/') then
                numberArray(counter) = numberArray(counter) / numberArray(counter+1)
                call organiseArray
            else if(theResult(i:i) == '+' .or. theResult(i:i) == '*' .or. theResult(i:i) == '-') then
                if(theResult(i:i) == '-') then
                    k = i-1
                    if(theResult(k:k) == '+' .or. theResult(k:k) == '/' .or. theResult(k:k) == '*' .or. theResult(k:k) == '-') then
                        cycle
                    end if
                end if
                counter = counter + 1
            end if
        end do
    end subroutine divideAndRule

    subroutine beProductive
        counter = 1
        do i = 1, len_trim(theResult)
            if(theResult(i:i) == '*') then
                numberArray(counter) = numberArray(counter) * numberArray(counter+1)
                call organiseArray
            else if(theResult(i:i) == '+' .or. theResult(i:i) == '-') then
                if(theResult(i:i) == '-') then
                    k = i-1
                    if(theResult(k:k) == '+' .or. theResult(k:k) == '/' .or. theResult(k:k) == '*' .or. theResult(k:k) == '-') then
                        cycle
                    end if
                end if
                counter = counter + 1
            end if
        end do
    end subroutine beProductive

    subroutine needSomeAdditionalHelp
        counter = 2
        do i = 1, len_trim(theResult)
            if(theResult(i:i) == '-') then
                numberArray(counter) = -numberArray(counter)
                counter = counter + 1
            else if(theResult(i:i) == '+') then
                if(theResult(i:i) == '-') then
                    k = i-1
                    if(theResult(k:k) == '+' .or. theResult(k:k) == '/' .or. theResult(k:k) == '*' .or. theResult(k:k) == '-') then
                        cycle
                    end if
                end if
                counter = counter + 1
            end if
        end do
        counter = 1
        do i = 1, len_trim(theResult)
            if(theResult(i:i) == '+' .or. theResult(i:i) == '-') then
                numberArray(counter) = numberArray(counter) + numberArray(counter+1)
                call organiseArray
            end if
        end do
    end subroutine needSomeAdditionalHelp

    subroutine organiseArray
        do j = counter+1, len_trim(theResult)
            numberArray(j) = numberArray(j+1)
        end do
    end subroutine organiseArray

end function letsDoSomeMoreMaths

function removeEmptySpaces(calculation) result(trimmedCalculation)
    character(len = 100) :: calculation, trimmedCalculation
    integer :: i

    trimmedCalculation = ''
    do i = 1, len_trim(calculation)
        if(calculation(i:i) /= '') then
            trimmedCalculation = trim(trimmedCalculation) // calculation(i:i)
        end if
    end do
end function removeEmptySpaces


!Tästä tuli melko ruma. Ei kyllä ehkä löydä kaikkia mahdollisia syntaksivirheitä,
!mutta ehkä tavallisimmat kumminkin.

subroutine checkSyntax(calculation)
    character(len = 100) :: calculation
    character(len = 17) :: allowedChars
    integer :: i, j, bracketCounterA, bracketCounterB

    allowedChars = '0123456789/+*-().'
    bracketCounterA = 0
    bracketCounterB = 0
    do i = 1, len_trim(calculation)
        if(calculation(i:i) == '(') then
            bracketCounterA = bracketCounterA + 1
            if(i > 1) then
                do j = 11, 15
                    if(calculation(i-1:i-1) == allowedChars(j:j)) then
                        go to 888
                    end if
                end do
                call synError('No operator before (-bracket ')
                888 continue
            end if
            do j = 11, 14
                if(calculation(i+1:i+1) == allowedChars(j:j)) then
                    call synError('Operator right after (-bracket ')
                end if
            end do
        else if(calculation(i:i) == ')') then
            bracketCounterB = bracketCounterB + 1
            if(bracketCounterA == 0 .and. bracketCounterB > 0) then
                call synError('No (-bracket before )-bracket ')
            end if
        end if
        do j = 1, 17
            if (calculation(i:i) == allowedChars(j:j)) then
                go to 999
            end if
        end do
        call synError('Mysterious characters ')
        999 continue
        if(calculation(i:i) == '+' .or. calculation(i:i) == '-' .or. calculation(i:i) == '*' .or. calculation(i:i) == '/') then
            if(i == 1) then
                call synError('First char was not a number or a bracket ')
            end if
            j = i - 1
            if(calculation(j:j) == '+' .or. calculation(j:j) == '-' .or. calculation(j:j) == '*' .or. calculation(j:j) == '/') then
                call synError ('operator after operator ')
            end if
            j = i + 1
            if(calculation(j:j) == '+' .or. calculation(j:j) == '-' .or. calculation(j:j) == '*' .or. calculation(j:j) == '/') then
                call synError('operator after operator ')
            end if
        end if
    end do
    if (bracketCounterA /= bracketCounterB) then
        call synError('Bracket count does not match ')
    end if
    do i = 1, len_trim(calculation)
        if(calculation(i:i) == '(') then
            do j = i, len_trim(calculation)
                if(calculation(j:j) == ')') then
                    go to 666
                end if
            end do
            call synError('No )-bracket after (-bracket ')
        end if
        666 continue
    end do
    do i = 1, len_trim(calculation)
        if(calculation(i:i) == '.') then
            do j = 1, 10
                if(calculation(i+1:i+1) == allowedChars(j:j)) then
                    go to 555
                end if
            end do
            call synError('Need to have numbers around periods ')
            555 continue
            do j = 1, 10
                if(calculation(i-1:i-1) == allowedChars(j:j)) then
                    go to 444
                end if
            end do
            call synError('Need to have numbers around periods ')
            444 continue
        end if
    end do
    do i = 1, 10
        if(calculation(len_trim(calculation):len_trim(calculation)) == allowedChars(i:i)) then
            go to 777
        end if
    end do
    if(calculation(len_trim(calculation):len_trim(calculation)) == ')') then
        go to 777
    end if
    call synError('Mysterious last character ')
    777 continue

contains
    subroutine synError(message)
        character(len = 50) :: message
        write(*,*) 'Check Syntax! ', message
        stop
    end subroutine synError
end subroutine checkSyntax
