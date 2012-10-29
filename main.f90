program t8
    implicit none
    character(len = 30) :: numberChain
    integer :: givenNumber, i

    write(*, '(a)', advance = 'no') 'Anna pituus: '
    read(*,*) givenNumber
    numberChain = ''
    call buildChain(givenNumber, givenNumber)

contains

    recursive subroutine buildChain(point, length)
        integer :: point, length
        if (point < 1) then
            do i = 1, length
                if(numberChain(i:i) == '1') then
                    write(*,'(i3)', advance = 'no') i
                end if
            end do
            write(*,*)
            return
        end if
        numberChain(point:point) = '0'
        call buildChain(point-1, length)
        numberChain(point:point) = '1'
        call buildChain(point-1, length)
    end subroutine buildChain

end program

