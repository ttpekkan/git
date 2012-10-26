
program hello
    implicit none
    character(len = 20) :: chain
    integer :: chainSize, point, i

    write(*, '(a)', advance = 'no') 'Anna pituus: '
    read(*,*) chainSize
    point = chainSize
    chain = ''

    do i = 1, chainSize
        chain = trim(chain) // 'A'
    end do

    write(*,*) trim(chain)
    call changeLetter(chain, chainSize, point)

end program

recursive subroutine changeLetter(chain, chainSize, point)
    character(len = 20) :: chain
    integer :: chainSize, point

    if(chain(point:point) == 'A') then
        chain(point:point) = 'C'
        call recurse
    else if(chain(point:point) == 'C') then
        chain(point:point) = 'G'
        call recurse
    else if(chain(point:point) == 'G') then
        chain(point:point) = 'T'
        call recurse
    else
        chain(point:point) = 'A'
        point = point - 1
        if (point == 0) then
            return
        end if
        call changeLetter(chain, chainSize, point)
    end if

contains
    subroutine recurse
        write(*,*) trim(chain)
        if (point < chainSize) then
            point = chainSize
            call changeLetter(chain, chainSize, point)
        else
            call changeLetter(chain, chainSize, point)
        end if
    end subroutine recurse

end subroutine changeLetter
