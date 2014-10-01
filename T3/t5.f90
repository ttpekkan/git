program inAnyShapeOrForm
    implicit none
    integer :: a(4),b(3,3),c(2,2,2)

    write(6,*) shape(a(1::2))
    write(6,*) shape(a(1:2))
    write(6,*) shape(a(2:1))
    write(6,*) shape(b(1:3:2,1:3:2))
    write(6,*) shape(b(1:2:3,1:2:3))


end program inAnyShapeOrForm

! Output (The shapes that were asked):

!          2
!          2
!          0
!          2           2
!          1           1
