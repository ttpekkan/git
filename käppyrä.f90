
program hello
    implicit none
    real*4 :: potential, De, a, e, averageDistance, distance, previous

    averageDistance = 2.98843618
    a = 1.967586733
    De = 4426.117839
    e = 2.718281828
    distance = 0
    potential = 0
    open(unit = 1, file = 'käppyrä')
    do
        distance = distance + 0.0001
        potential = De * (1 - e**(-a*(distance - averageDistance)))**2
        if(previous == potential) then
            exit
        end if
        previous = potential
        if(potential < 2 * De) then
            write(1,*) a*(distance - averageDistance), potential
        end if
    end do
    close(1)
end program

