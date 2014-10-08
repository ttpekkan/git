program inWithInput
    integer :: i1, i2
    character(len = 15) :: a1, a2

    open(unit = 11, file = 'karhukopla')
        read(11,*) i1
        read(11,*) i2
    close(11)

    write(a1, '(I15)') i1**2
    write(a2, '(I15)') i2**2

    write(6, '(a)', advance = 'no') 'i1**2 = '
    write(6, '(A15)') adjustl(a1)
    write(6, '(a)', advance = 'no') 'i2**2 = '
    write(6, '(A15)') adjustl(a2)

end program inWithInput

!Output

!i1**2 = 3418801
!i2**2 = 35153041
