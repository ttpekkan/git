program epsilonFun
    implicit none
    real(kind = 16) :: a

    write(*,*) 1.0q0 + epsilon(a)
    write(*,*) 1.0q0 + epsilon(a)/2
    write(*,*)
    write(*,*) 1.0q0 - epsilon(a)
    write(*,*) 1.0q0 - epsilon(a)/2

end program epsilonFun

!Output

!1.00000000000000000000000000000000019   !1.0 + epsilon(a)
!1.00000000000000000000000000000000000   !1.0 + epsilon(a)/2 Doesn't add anything!!

!0.999999999999999999999999999999999807  !1.0 - epsilon(a)
!0.999999999999999999999999999999999904  !1.0 - epslilon(a)/2 This is a bit odd though.
