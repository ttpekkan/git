program hello
    implicit none
    character(len = 512) :: initialChain
    integer :: chainSize, point, i, counter

    write(*, '(a)', advance = 'no') 'Anna pituus: '
    read(*,*) chainSize
    point = chainSize
    initialChain = ''
    counter = 1

    do i = 1, chainSize
        initialChain = trim(initialChain) // 'A'
    end do

    write(*,*) trim(initialChain)
    do
        call changeLetter(initialChain) !Ohjelma suljetaan muualta. Rekursio pitää suorittaa pienissä osissa
    end do                              !että ei tule segmentation faulttia.

contains !Containissa olevat subroutiinit päävevät käsiksi ja voivat muuttaa alussa annettuja muuttujia.

    recursive subroutine changeLetter(chain)
        character(len = 512) :: chain

        if(counter > 20) then           !Rekursio tehdään 20-sanan pätkissä, yllä mainitusta syystä.
            counter = 0                 !Nyt voidaan laskea mikä tahansa pituus, tosin jos pituus yli 10,
            initialChain = chain        !homma melko hidasta. Ketjun pituus tosin voi olla max 512, mutta
            return                      !tätä voi tietenkin helposti muuttaa.
        end if
        if(chain(point:point) == 'A') then
            chain(point:point) = 'C'
            call recurse(chain)
        else if(chain(point:point) == 'C') then
            chain(point:point) = 'G'
            call recurse(chain)
        else if(chain(point:point) == 'G') then
            chain(point:point) = 'T'
            call recurse(chain)
        else
            chain(point:point) = 'A'
            point = point - 1
            if (point == 0) then
                stop                    !Lopettaa ohjelman.
            end if
            call changeLetter(chain)
        end if

    end subroutine changeLetter

    subroutine recurse(chain)
        character(len = 512) :: chain

        write(*,*) trim(chain)
        counter = counter + 1
        if (point < chainSize) then
            point = chainSize
            call changeLetter(chain)
        else
            call changeLetter(chain)
        end if

    end subroutine recurse

end program
