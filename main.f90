
program t16
    implicit none
    integer*16 :: first, last, decimation, nthFibbinary, total
    integer :: checkConsecutiveOnes, i
    integer*16, dimension(64) :: conversionTable
    character(len = 64) :: binary, getNearestSmallerFibbinary
    integer*16, dimension(500) :: fibonacciArray
    common/a/ conversionTable
    common/b/ fibonacciArray

    total = 0
    fibonacciArray = 0
    conversionTable(1) = 1
    do i = 1, 63
        conversionTable(i+1) = conversionTable(i)*2
    end do

    write(*,'(a)', advance = 'no') 'Alku: '
    read(*,*) first
    write(*,'(a)', advance = 'no') 'Loppu: '
    read(*,*) last

    if(checkConsecutiveOnes(binary(first)) == 1) then
        first = decimation(getNearestSmallerFibbinary(binary(first)))
    else
        total = total + 1
    end if
    if(checkConsecutiveOnes(binary(last)) == 1) then
        last = decimation(getNearestSmallerFibbinary(binary(last)))
    end if
    total = total + nthFibbinary(binary(last)) - nthFibbinary(binary(first))
    write(*,*)
    write(*, '(a)', advance = 'no') 'Tulos: '
    write(*,*) total
end program

function binary(givenDecimal) result(binaryString)
    integer*16 :: toBinary, givenDecimal
    integer :: i
    character(len = 64) :: binaryString
    character(len = 1) :: nextChar

    toBinary = givenDecimal
    if(toBinary == 1) then
        binaryString = '1'
        return
    else if(toBinary == 0) then
        binaryString = '0'
        return
    end if
    binaryString = ''
    do
        write(nextChar, '(i1)') mod(toBinary, 2)
        binaryString = trim(nextChar) // trim(binaryString)
        toBinary = toBinary / 2
        if(toBinary == 1) then
            binaryString = '1' // trim(binaryString)
            exit
        end if
    end do
end function binary

function decimation(aBinary) result(anInteger)
    character(len = 64) :: aBinary
    integer*16 :: anInteger
    integer :: i
    integer*16, dimension(40) :: conversionTable
    common/a/ conversionTable

    anInteger = 0
    do i = 0, len_trim(aBinary)
        if(aBinary(i:i) == '1') then
            anInteger = anInteger + conversionTable(len_trim(aBinary)-i+1)
        end if
    end do
end function decimation

function checkConsecutiveOnes(aBinary) result(consecutiveOnes)
    character(len = 64) :: aBinary
    integer :: consecutiveOnes, i

    do i = 1, len_trim(aBinary)-1
        if(aBinary(i:i) == '1' .and. aBinary(i+1:i+1) == '1') then
            consecutiveOnes = 1
            return
        end if
    end do
    consecutiveOnes = -1
end function checkConsecutiveOnes

function getNearestSmallerFibbinary(aBinary) result(fibbinaryBinary)
    character(len = 64) :: aBinary, fibbinaryBinary
    integer :: i, j
    do i = 1, len_trim(aBinary) - 1
        if(aBinary(i:i) == '1' .and. aBinary(i+1:i+1) == '1') then
            fibbinaryBinary = trim(aBinary(1:i))
            do j = i+1, len_trim(aBinary)
                if(fibbinaryBinary(j-1:j-1) == '1') then
                    fibbinaryBinary = trim(fibbinaryBinary) // '0'
                else
                    fibbinaryBinary = trim(fibbinaryBinary) // '1'
                end if
            end do
            exit
        end if
    end do
end function getNearestSmallerFibbinary

function nthFibbinary(aBinary) result(n)
    character(len = 64) :: aBinary
    integer*16 :: i, fibonacci, n

    n = 0
    do i = 1, len_trim(aBinary)
        if(aBinary(i:i) == '1') then
            n = n + fibonacci(len_trim(aBinary) - i + 1)
        end if
    end do
end function nthFibbinary

recursive function fibonacci(nthFibonacci) result(fibonacciNumber)
    implicit none
    integer*16 :: nthFibonacci, fibonacciNumber
    integer*16, dimension(500) :: fibonacciArray
    common/b/ fibonacciArray

    if(nthFibonacci == 1 .or. nthFibonacci == 0) then
        fibonacciNumber = 1
        return
    end if
    if (fibonacciArray(nthFibonacci) /= 0) then
        fibonacciNumber = fibonacciArray(nthFibonacci)
        return
    end if
    fibonacciArray(nthFibonacci) = fibonacci(nthFibonacci-1) + fibonacci(nthFibonacci-2)
    fibonacciNumber = fibonacciArray(nthFibonacci)
end function fibonacci

