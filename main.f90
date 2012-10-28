
program hello
    implicit none
    integer :: givenNumber, i, point, counter
    integer, dimension(:), allocatable :: array

    write(*,'(a)', advance = 'no') 'Anna luku: '
    read(*,*) givenNumber
    allocate(array(givenNumber))
    do i = 1, givenNumber
        array(i) = 0
    end do
    point = 1
    counter = 0

    do
        counter = 0                     !Piti tehdä taas paloissa rekursio, ettei tule segmentation faulttia.
        call modifyArray                !Ei kyllä mitään hajua mikä sen aiheuttaa.
    end do

contains

    recursive subroutine modifyArray
        counter = counter + 1
        if(counter > 20) then
            return
        end if
        if(array(point) == 0) then
            array(point) = 1
            do i = 1, givenNumber
                if(array(i) == 1) then
                    write(*,'(i8)', advance = 'no') i
                end if
            end do
            write(*,*)
            if(point > 1) then
                point = 1
                call modifyArray
            end if
            call modifyArray
        else
            array(point) = 0
            point = point + 1
            if (point > givenNumber) then
                stop                !Lopettaa ohjelman.
            end if
            call modifyArray
        end if
    end subroutine modifyArray

end program

