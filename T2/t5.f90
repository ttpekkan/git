program testRealKind
  implicit none
  real(kind = 4) :: a
  real(kind = 8) :: b
  real(kind = 16) :: c

  write(*,*) huge(a)
  write(*,*) tiny(a)
  write(*,*) huge(b)
  write(*,*) tiny(b)
  write(*,*) huge(c)
  write(*,*) tiny(c)

end program testRealKind

!Output
!3.40282347E+38                                     !Largest real*4 positive number.
!1.17549435E-38                                     !Smallest real*4 positive number.
!1.7976931348623157E+308                            !Largest real*8 positive number.
!2.2250738585072014E-308                            !Smallest real*8 positive number.
!1.18973149535723176508575932662800702E+4932        !Largest real*16 positive number.
!3.36210314311209350626267781732175260E-4932        !Smallest real*16 positive number.
