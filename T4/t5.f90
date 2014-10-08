program outWithOutput
    implicit none
    integer :: i1, i2
    character(len = 15) :: fname, c1, c2

    write(6, '(a)', advance = 'no') 'Give the name of the file (max 15 characters): '
    read(5, '(A15)') fname
    write(6, '(a)', advance = 'no') 'Give integer i1 (max 10 digits): '
    read(5, '(I10)') i1
    write(6, '(a)', advance = 'no') 'Give integer i2 (max 10 digits): '
    read(5, '(I10)') i2

    write(c1, '(I15)') i1**2
    write(c2, '(I15)') i2**2

    fname = adjustl(fname)
    c1 = adjustl(c1)
    c2 = adjustl(c2)

    open(unit = 11, file = fname)
        write(11, '(A15)') c1
        write(11, '(A15)') c2
    close(11)

end program outWithOutput

!Output

!Give the name of the file (max 15 characters): karhukopla
!Give integer i1 (max 10 digits): 43
!Give integer i2 (max 10 digits): 77
