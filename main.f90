
program t15
    use big_integer_module
    implicit none
    integer :: checkDigitSum, expo , counter
    type(big_integer) :: num, limit
    common/a/ counter

    counter = 1
    write(*,'(a)') '1. 1**1'
    write(*,'(a)') '1'
    write(*,*)
    num = '2'
    limit = '10'
    limit = limit**50
 !   do while(num**2 < limit)  Tämä oli aivan liian hidas. Tuo num < 1000 on aika pitkälle hatusta vedetty.
    do while(num < 1000)       !Isommat num-arvot tuntuvat tarvitsevan koko ajan isompia eksponentin arvoja,
        expo = 1               !jotta sopivia numeroita löytyisi. En kyllä tiedä miksi.
        do while(num**expo < limit)
            if(checkDigitSum(expo, num**expo) == 1) then
                counter = counter + 1
                write(*,*)
            end if
            expo = expo + 1
        end do
        num = num + 1
    end do
end program

function checkDigitSum(power, givenNumber) result(isValid)
    use big_integer_module
    integer :: power, isValid, i, counter
    type(big_integer) :: givenNumber, tempNum, nextDigit
    character(len = 50) :: charNum, intToChar
    common/a/ counter

    charNum = givenNumber
    tempNum = '0'
    do i = 1, len_trim(charNum)
        nextDigit = charNum(i:i)
        tempNum = tempNum + nextDigit
    end do
    if(tempNum**power == givenNumber) then
        write(intToChar,*) counter
        write(*,'(a)', advance = 'no') trim(adjustl(intToChar))
        write(*,'(a)', advance = 'no') '. '
        call print_big(tempNum)
        write(*,'(a)', advance = 'no') '**'
        write(intToChar,*) power
        write(*,'(a)', advance = 'no') trim(adjustl(intToChar))
        write(*,*)
        call print_big(givenNumber)
        write(*,*)
        isValid = 1
    else
        isValid = -1
    end if
end function checkDigitSum
