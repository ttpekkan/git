
!Päätin etsiä A:n loppuvia sanoja. Z-loppuvia sanoja on tietysti
!yhtä paljon, josta johtuu kahdella kertominen muutamassa kohdassa.
!Ohjelma tuntuu toimivan kun pituus noin alle 150.

program hello
    implicit none
    integer :: length, lastChar, i, j
    integer*16 :: findWordsEndingWithA, total, bigNumber
    integer*16, dimension(10000, 26) :: array
    common /a/ array

    write(*,'(a)', advance = 'no') 'Anna length: '
    read(*,*) length

    if(length == 1) then
        write(*,*) 'Sanoja: 26'
        stop
    else if(length <= 0) then
        write(*,*) 'Sanoja: 0'
        stop
    end if
    !total = 26*(2**(length-1))              Liian iso lasku isoilla luvuilla.
    total = 2
    do i = 1, length-2                       !Kiertotapa tehdä sama asia.
        total = total * 2
    end do
    total = total*26                        !Max määrä vastauksia jos haaratumiselle ei rajotteita.
    total = total - 2*(2**(length-2))       !Max määrästä vähenettyt tulokset, koska A haarautuu yhteen suuntaan.
    do i = 2, length-1                      !Karsitaan max määrästä tuloksia kun löydetään haaroja, jotka loppuvat A:n
        !total = total - 2*(findWordsEndingWithA(i, 1)*2**(length-1-i))     Sama ongelma, kikkailu taas loopin avulla.
        bigNumber = 2
        if(i < length-1) then
            do j = 1, (length-2-i)
                bigNumber = bigNumber * 2
            end do
        else
            bigNumber = 1
        end if
        total = total - 2*(findWordsEndingWithA(i, 1)*bigNumber)
    end do
    write(*,*) 'Sanoja: ', total
end program

recursive function findWordsEndingWithA(length, lastChar) result(total)
    integer :: length, lastChar, i, j
    integer*16 :: total
    integer*16, dimension(10000, 26) :: array
    common /a/ array

    if(lastChar < 1 .or. lastChar > 26) then
        total = 0
        return
    end if
    if(length == 1) then
        total = 1
        return
    end if
    if(array(length, lastChar) /= 0) then
        total = array(length, lastChar)
        return
    else
        array(length, lastChar) = findWordsEndingWithA(length-1, lastChar-1) + findWordsEndingWithA(length-1, lastChar+1)
        total = array(length, lastChar)
        return
    end if

end function findWordsEndingWithA


