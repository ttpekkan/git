
program t14
    implicit none
    integer :: i, j
    integer, dimension(26) :: lastLocationOfChar
    integer*16, dimension(:), allocatable :: sumOfSubsets
    character(len = 1), dimension(26) :: chars
    character(len = 26) :: alphabet
    character(len = 512) :: word

    alphabet = 'abcdefghijklmnopqrstuvwxyz'
    write(*,'(a)', advance = 'no') 'Anna Merkkijono: '
    read(*,*) word
    allocate(sumOfSubsets(len_trim(word)+1))
    chars = ''

    sumOfSubsets(1) = 1
    do i = 1, len_trim(word)
        sumOfSubsets(i+1) = 2*sumOfSubsets(i)
        do j = 1, 26
            if(chars(j) == word(i:i)) then
                sumOfSubsets(i+1) = sumOfSubsets(i+1) - sumOfSubsets(lastLocationOfChar(j))
                exit
            end if
        end do
        do j = 1, 26
            if(alphabet(j:j) == word(i:i)) then
                lastLocationOfChar(j) = i
                chars(j) = word(i:i)
                exit
            end if
        end do
    end do
    write(*,*) sumOfSubsets(len_trim(word)+1) - 2   !-2 koska tyhjä merkkijono ja itse sana eivät ilmeisesti ole alijonoja.
end program




