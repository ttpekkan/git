program superMegaEfficientAverageVelocityCalculatorAdvancedEdition
    implicit none
    integer, parameter :: prec = selected_real_kind(5)              !Select precision for reals.
    real(kind = prec) :: velocity, distance, timeInterval           !Declare variables.


    write(6, '(A28)') 'Give a distance (in metres):'
    read(5,'(F10.0)') distance
    write(6, '(A30)') 'Give the elapsed (in seconds):'
    read(5,*) timeInterval
    write(*,*)
    velocity = distance/timeInterval         !Use knowledge from advanced physics courses to calculate the average speed.

    write(6, '(A25)', advance = 'no') 'The average velocity was '
    write(6, '(F4.1)',advance = 'no') 3.6 * velocity
    write(6, '(A6)', advance = 'no') ' km/h.'
    write(*,*)
end program superMegaEfficientAverageVelocityCalculatorAdvancedEdition
