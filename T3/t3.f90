program aWideArrayOfChoices
    implicit none
    integer, dimension(10000) :: x

    x = 7
    write(6,*) shape(x)
    write(6,*) shape(reshape(x, (/100, 100/)))
    write(6,*) shape(reshape(x, (/21, 21, 21/)))
    write(6,*) shape(reshape(x, (/10, 10, 10 , 10/)))
    write(6,*) shape(reshape(x, (/6, 6, 6, 6, 6/)))
    write(6,*) shape(reshape(x, (/4, 4, 4, 4, 4, 4/)))
    write(6,*) shape(reshape(x, (/3, 3, 3, 3, 3, 3, 3/)))
    !write(6,*) shape(reshape(x, (/2, 2, 2, 2, 2, 2, 2 ,2/)))

end program aWideArrayOfChoices

!The program won't compile when the last line is uncommented, because
!my compiler doesn't support arrays with rank higher than seven.

!Output

!       10000
!         100         100
!          21          21          21
!          10          10          10          10
!           6           6           6           6           6
!           4           4           4           4           4           4
!           3           3           3           3           3           3           3
