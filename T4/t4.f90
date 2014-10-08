program ex4p4
    implicit none
    real :: a(6,10)
    character(len=10) :: c(4)
    complex :: z(20)
    integer :: i

    call assign_values()

    write(6,'(a)') '! The real array: '
    write(*,*)
    do i = 1, 6
        write(6, '(a)', advance = 'no') '! '
        write(6, '(100(F14.9))') a(i,:)
    end do
    write(*,*)
    write(*,*)

    write(6,'(a)') '! The character array: '
    write(*,*)
    write(6, '(a)', advance = 'no') '!   '
    write(6,'(50(A13))') c
    write(*,*)
    write(*,*)

    write(6,'(a)') '! The complex array printed as a column (would be a very long row): '
    write(*,*)
    do i = 1, 20
        write(6, '(a)', advance = 'no') '!   '
        write(6,'(F11.9)', advance = 'no') real(z(i))
        write(6, '(a)', advance = 'no') ' + '
        write(6,'(F11.9)', advance = 'no') aimag(z(i))
        write(6, '(a)', advance = 'no') 'i'
        write(*,*)
    end do




contains

    subroutine assign_values()
        ! Local subroutine to assign values to arrays
        integer :: s
        integer,allocatable :: seed(:)
        real :: zr(20),zi(20),zzr,zzi
        ! ---- Start of RNG setup
        ! Set up the seed
        call random_seed(size=s)
        allocate(seed(s))
        seed=1277345
        call random_seed(put=seed)
        ! Fill arrays a with random numbers
        ! in the interval [0,1[
        call random_number(a)
        call random_number(zr)
        call random_number(zi)
        z=cmplx(zr,zi)
        ! ---- End of RNG setup
        c=['0123456789','abcdefghij','ABCDEFGHIJ','klmnopqrst']
        return
    end subroutine assign_values

end program ex4p4

!Output:

! The real array:

!    0.599051893   0.702181399   0.125527322   0.874569774   0.636339962   0.351109445   0.608978450   0.770351648   0.339361668   0.007129610
!    0.870662928   0.503361762   0.509643257   0.998440146   0.813173354   0.314193428   0.791864097   0.015520990   0.804772258   0.484401584
!    0.725863338   0.883654177   0.147907436   0.308579028   0.916585207   0.935908079   0.225169063   0.579599202   0.577441216   0.684594512
!    0.342447579   0.209195733   0.014183581   0.515720665   0.106723309   0.795748234   0.423576117   0.518969178   0.723798931   0.614551604
!    0.065402746   0.058807313   0.480212152   0.724627912   0.019737780   0.503500521   0.887654483   0.480080903   0.235644817   0.210224628
!    0.618506134   0.399410605   0.643792689   0.804890275   0.781740546   0.268183649   0.521671414   0.981717825   0.938755751   0.018338919


! The character array:

!      0123456789   abcdefghij   ABCDEFGHIJ   klmnopqrst


! The complex array printed as a column (would be a very long row):

!   0.252013862 + 0.160318911i
!   0.930069387 + 0.212211192i
!   0.776741683 + 0.762825727i
!   0.385517001 + 0.790667653i
!   0.793726146 + 0.470240831i
!   0.790716112 + 0.996086955i
!   0.636855066 + 0.034333527i
!   0.555020571 + 0.396628916i
!   0.142230511 + 0.513589203i
!   0.533018887 + 0.969096959i
!   0.016977131 + 0.034320593i
!   0.314281523 + 0.867184699i
!   0.056036890 + 0.757902801i
!   0.933207631 + 0.035493791i
!   0.942992985 + 0.553615808i
!   0.520362318 + 0.080578208i
!   0.215957105 + 0.873683631i
!   0.398337066 + 0.539483428i
!   0.092683256 + 0.702602506i
!   0.014149725 + 0.767196894i


