program vectorAlgebra
    use vectorAlgebraMod
    implicit none
    type(vector) :: v1, v2
    character(len=*), parameter :: output_format = '(A,3G10.4)'

    parser: do
        write(*,'(A)', advance='no') '> v1='
        read (*,*) v1%x, v1%y, v1%z
        write(*,'(A)', advance='no') '> v2='
        read (*,*) v2%x, v2%y, v2%z
        write(*,output_format) ' |v1|=', abs(v1)
        write(*,output_format) ' |v2|=', abs(v2)
        write(*,output_format) ' v1 + v2 =', v1+v2
        write(*,output_format) ' v1 - v2 =', v1-v2
        write(*,output_format) ' v1 . v2 =', v1*v2
        write(*,output_format) ' v1 x v2 =', v1.x.v2
    end do parser


end program vectorAlgebra
