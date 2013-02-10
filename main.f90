
program Q5
    implicit none
    integer :: internalEnergy

    open(unit = 1, file = 'käppyrä')
    do internalEnergy  = 0, 500
        call calculateMicrostatesAndEnergies
    end do
    close(1)

contains
    subroutine calculateMicrostatesAndEnergies
        integer :: i, j, l
        real :: k, total
        k = 1.380658e-23
        total = 0.0
        do i = 0, internalEnergy
            do j = 0, internalEnergy
                do l = 0, internalEnergy
                    if(i+j+l == internalEnergy) then
                        total = total + 1.0
                    end if
                end do
            end do
        end do
        if(internalEnergy >= 0 .and. internalEnergy <= 8) then
            write(*,*) total, '    ', k*log(total)             !Mikrotilat ja entropiat ensimmäiselle yhdeksälle sisäenergialle.
        end if
        write(1,*) internalEnergy, k*log(total)                !Pisteet kuvaajaa varten.
    end subroutine calculateMicrostatesAndEnergies
end program

