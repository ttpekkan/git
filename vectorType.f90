module vectorType
    use precMod
    implicit none

    type vector
        integer(kind = 1) :: numOfElements
        real(prec), allocatable, dimension(:) :: element
    contains
        procedure :: magnitude, add, subtract
    end type

    type, extends(vector) :: vectorWithNationality
        character(len = 8) :: nationality
    end type

    type, extends(vector) :: vectorWithFavouriteAuthor
        character(len = 20) :: favouriteAuthor
    end type

contains
    subroutine magnitude(this, mag)
        class(vector), intent(in) :: this
        real(prec), intent(out) :: mag
        integer(kind = 1) :: i

        mag = 0.0
        do i = 1, this%numOfElements
            mag = mag + (this%element(i))**2
        end do
        mag = sqrt(mag)
        select type(this)
            type is (vectorWithNationality)
                this%nationality = 'Roman'
            type is (vectorWithFavouriteAuthor)
                this%favouriteAuthor = 'Don Rosa'
        end select
    end subroutine

    subroutine add(this, v1, v2)
        class(vector), intent(in) :: v1, v2
        class(vector), intent(out) :: this

        if(v1%numOfElements /= v2%numOfElements) then
            write(*,*) 'Dimensions do not match.'
            stop
        end if
        this%numOfElements = v1%numOfElements
        this%element = v1%element + v2%element
        select type(this)
            type is (vectorWithNationality)
                this%nationality = 'Greek'
            type is (vectorWithFavouriteAuthor)
                this%favouriteAuthor = 'Mika Waltari'
        end select
        select type(v1)
            type is (vectorWithNationality)
                v1%nationality = 'Greek'
            type is (vectorWithFavouriteAuthor)
                v1%favouriteAuthor = 'Mika Waltari'
        end select
        select type(v2)
            type is (vectorWithNationality)
                v2%nationality = 'Greek'
            type is (vectorWithFavouriteAuthor)
                v2%favouriteAuthor = 'Mika Waltari'
        end select
    end subroutine add

    subroutine subtract(this, v1, v2)
        class(vector), intent(in) :: v1, v2
        class(vector), intent(out) :: this

        if(v1%numOfElements /= v2%numOfElements) then
            write(*,*) 'Dimensions do not match.'
            stop
        end if
        this%numOfElements = v1%numOfElements
        this%element = v1%element - v2%element
        select type(this)
            type is (vectorWithNationality)
                this%nationality = 'Persian'
            type is (vectorWithFavouriteAuthor)
                this%favouriteAuthor = 'Charles Dickens'
        end select
        select type(v1)
            type is (vectorWithNationality)
                v1%nationality = 'Persian'
            type is (vectorWithFavouriteAuthor)
                v1%favouriteAuthor = 'Charles Dickens'
        end select
        select type(v2)
            type is (vectorWithNationality)
                v2%nationality = 'Persian'
            type is (vectorWithFavouriteAuthor)
                v2%favouriteAuthor = 'Charles Dickens'
        end select
    end subroutine subtract

    subroutine dotProduct(v1, v2, theProduct)
        class(vector), intent(in) :: v1, v2
        real(prec), intent(out) :: theProduct

        if(v1%numOfElements /= v2%numOfElements) then
            write(*,*) 'Dimensions do not match.'
            stop
        end if
        theProduct = dot_product(v1%element, v2%element)
    end subroutine dotProduct


end module vectorType
