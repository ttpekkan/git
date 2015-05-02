
program t78
    implicit none
    integer, parameter :: rprec = selected_real_kind(11, 11)    !Lukujen tarkkuus.

!---------------------Vakiot-------------------------------------------------------
    real(kind = rprec), parameter :: R = 0.082           !(l atm)/(mol K)
    real(kind = rprec), parameter :: temp = 298.0        !K
    real(kind = rprec), parameter :: H_H2O2 = 7.45d4     !mol/(l atm)
    real(kind = rprec), parameter :: H_SO2 = 1.23        !mol/(l atm)
    real(kind = rprec), parameter :: K_D1 = 1.3          !mol/l
    real(kind = rprec), parameter :: k_ox = 7.5d7        !l**2 / (s mol**2)
    real(kind = rprec), parameter :: dt = 1.0            !s
!----------------------------------------------------------------------------------

!---------------------Muuttujat----------------------------------------------------
    real(kind = rprec) :: DeltaC                         !mol/l
    real(kind = rprec) :: t                              !s
    real(kind = rprec) :: p_H2O2                         !atm
    real(kind = rprec) :: p_SO2                          !atm
    real(kind = rprec) :: c_H           !H = H^+         !mol/l
    real(kind = rprec) :: c_SO4         !SO4 = SO4^2-    !mol/l
!----------------------------------------------------------------------------------

!---------------------Alkuarvot----------------------------------------------------
    p_H2O2 = 1.0d-9
    p_SO2 = 1.0d-9

    c_H = dsqrt(K_D1 * H_SO2 * p_SO2)
    c_SO4 = 0.0
    DeltaC = 0
!----------------------------------------------------------------------------------

!-------------Paineiden ja konsentraatioiden muutokset ajan funktiona--------------
    open(unit = 11, file = 'konsentraatiot.txt', action = 'write')
    do t = 0, 7200, dt
        write(11,*) t, c_SO4, p_H2O2, p_SO2, -log10(C_H)
        DeltaC = k_ox*K_D1*H_H2O2*H_SO2*p_H2O2*p_SO2*dt

        c_SO4 = c_SO4 + DeltaC
        c_H = c_H + 2*DeltaC

        p_H2O2 = p_H2O2 - (DeltaC * 1.0d-7 * R*temp)
        p_SO2 = p_SO2 - (DeltaC * 1.0d-7 * R*temp)
    end do
    close(11)
!----------------------------------------------------------------------------------

end program

