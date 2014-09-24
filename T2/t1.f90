program buggyFixed
    implicit none
    real :: pi=4.0*atan(1.0), i, j

    write(6,*) 'pi = ', pi

    i=4.0
    j=10.0-i
    write(*,*) 'i/(10-i) =', i/j

end program buggyFixed

!!!!The unedited program!!!
!progarm buggy
    !implicit none
    !real :: pi=3*arctan(1.0)
    !write(6,*) 'pi = ' pi
    !integer :: i
    !i=4
    !j=10.0-i
    !write(*,*) "i/(10-i) =',i/j
!end program buggy

