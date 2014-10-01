program infinitePleasure
    implicit none
    real :: posInf, aBigNumber

    aBigNumber = 1000.0
    PosInf = exp(aBigNumber)
    write(6,'(a)', advance = 'no') 'e**(1000) = '
    write(6,'(F9.0)') PosInf
    write(6,'(a)', advance = 'no') '(-1.0)*e**(1000) = '
    write(6,'(F9.0)') -1.0*PosInf
    write(6,'(a)', advance = 'no') '(e**(1000))*(-e**(1000)) = '
    write(6,'(F9.0)') PosInf*(-PosInf)
    write(6,'(a)', advance = 'no') '(-e**(1000))*(-e**(1000)) = '
    write(6,'(F9.0)') (-PosInf)*(-PosInf)

end program infinitePleasure

!Output

!e**(1000) =  Infinity
!(-1.0)*e**(1000) = -Infinity
!(e**(1000))*(-e**(1000)) = -Infinity
!(-e**(1000))*(-e**(1000)) =  Infinity
