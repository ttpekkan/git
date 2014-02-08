module vectorAlgebraMod
    implicit none
    type vector
        real*8 :: x, y, z
    end type vector

    interface operator(+)
        module procedure vectorSum
    end interface
    interface operator(-)
        module procedure vectorSub
    end interface
    interface operator(*)
        module procedure vectorDotProduct
    end interface
    interface operator(.x.)
        module procedure vectorCrossProduct
    end interface
    interface abs
        module procedure vectorMag
    end interface

contains

    pure function vectorSum(v1, v2) result(v3)
        type(vector), intent(in) :: v1, v2
        type(vector) :: v3

        v3%x = v1%x + v2%x
        v3%y = v1%y + v2%y
        v3%z = v1%z + v2%z
    end function vectorSum

    pure function vectorSub(v1, v2) result(v3)
        type(vector), intent(in) :: v1, v2
        type(vector) :: v3

        v3%x = v1%x - v2%x
        v3%y = v1%y - v2%y
        v3%z = v1%z - v2%z
    end function vectorSub

    pure function vectorDotProduct(v1, v2) result(d)
        type(vector), intent(in) :: v1, v2
        real*8 :: d

        d = v1%x*v2%x + v1%y*v2%y + v1%z*v2%z
    end function vectorDotProduct

    pure function vectorCrossProduct(v1, v2) result(v3)
        type(vector), intent(in) :: v1, v2
        type(vector) :: v3

        v3%x = v1%y*v2%z - v1%z*v2%y
        v3%y = -(v1%x*v2%z - v1%z*v2%x)
        v3%z = v1%x*v2%y - v1%y*v2%x
    end function vectorCrossProduct

    pure function vectorMag(v) result(l)
        type(vector), intent(in) :: v
        real*8 :: l

        l = sqrt(v%x**2 + v%y**2 + v%z**2)
    end function vectorMag

end module vectorAlgebraMod
