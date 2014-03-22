
program kkLabra

    real*8, dimension(:,:), allocatable :: hamiltoninMatriisi, muunnosMatriisi
    real*8 :: V
    integer :: i, j, m, iteraatiot

    write(*,'(a)', advance = 'no') 'Mikä on potentiaalivallin korkeus (cm-1)? '
    read(*,*) V
    write(*,'(a)', advance = 'no') 'Mihin m:n arvoon asti muodostetaan kantafunktiota? '
    read(*,*) m

    allocate(hamiltoninMatriisi(2*m+1,2*m+1))
    allocate(muunnosMatriisi(2*m+1,2*m+1))

    iteraatiot = 0
    hamiltoninMatriisi = 0.0d0
    do i = -m, m
        do j = -m, i
            if(i == j) then
                hamiltoninMatriisi(i+1+m,j+1+m) = j**2 * 27.65d0 + V/2
            else if(j-i == -3) then
                hamiltoninMatriisi(i+1+m,j+1+m) = -V/4.0d0
                hamiltoninMatriisi(j+1+m,i+1+m) = -V/4.0d0
            end if
        end do
    end do

    call printtaaMatriisi
    do
        call spinnaaJacobaanisesti
        iteraatiot = iteraatiot + 1
        call printtaaMatriisi
    end do

contains
    subroutine spinnaaJacobaanisesti
        real*8 :: kulma, isoin, a, b
        integer :: i, j, x, y

        muunnosMatriisi= 0.0d0
        isoin = 0.0d0
        do i = 2, size(hamiltoninMatriisi,1)
            do j = 1, i-1
                if(abs(hamiltoninMatriisi(i,j)) > abs(isoin)) then
                    isoin = hamiltoninMatriisi(i,j)
                    b = hamiltoninMatriisi(i,i)
                    a = hamiltoninMatriisi(j,j)
                    y = i
                    x = j
                end if
            end do
        end do
        write(*,*) abs(isoin)
        if(abs(isoin) < 1.0d-15) then
            write(*,*) 'Supistui!'
            write(*,*) 'Iteraatiot: ', iteraatiot
            do i = 1, size(hamiltoninMatriisi,1)
                write(*,*) hamiltoninMatriisi(i,i)
            end do
            stop
        end if

        kulma = datan(2.0d0 *isoin/(b-a))
        kulma = kulma/2.0d0
        muunnosMatriisi= 0.0d0
        do i = 1, size(hamiltoninMatriisi,1)
            muunnosMatriisi(i,i) = 1.0d0
        end do
        muunnosMatriisi(y,x) = -sin(kulma)
        muunnosMatriisi(x,y) = sin(kulma)
        muunnosMatriisi(x,x) = cos(kulma)
        muunnosMatriisi(y,y) = cos(kulma)

        hamiltoninMatriisi = matmul(transpose(muunnosMatriisi), matmul(hamiltoninMatriisi, muunnosMatriisi))

    end subroutine spinnaaJacobaanisesti

    subroutine printtaaMatriisi
        integer :: i, j

        do i = 1, size(hamiltoninMatriisi,1)
            do j = 1, size(hamiltoninMatriisi,2)
                write(*, '(F12.4)', advance = 'no') hamiltoninMatriisi(i,j)
            end do
            write(*,*)
        end do
        write(*,*)
        write(*,*)

    end subroutine printtaaMatriisi

end program

