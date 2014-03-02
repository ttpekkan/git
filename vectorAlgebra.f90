program vectorAlgebra
    use vectorType
    use precMod
    implicit none

    integer(kind = 1) :: vectorSize, i
    character(len = 8) :: num
    real(prec) :: resultScalar
    type(vector) :: v1
    type(vectorWithNationality) :: v2
    type(vectorWithFavouriteAuthor) :: resultVector

    write(*,'(a)', advance = 'no') 'Give the size of vectors v1 and v1 (size must be the same for both): '
    read(*,*) vectorSize

    v1%numOfElements = vectorSize
    v2%numOfElements = vectorSize
    allocate(v1%element(vectorSize))
    allocate(v2%element(vectorSize))

    write(*,*) 'Give the elements of the vectors: '
    do i = 1, 2*vectorSize
        if(i <= vectorSize) then
            write(num,'(i8)') i
            write(*,'(a)', advance = 'no') 'v1_' // trim(adjustl(num)) // ': '
            read(*,*) v1%element(i)
        else
            write(num,'(i8)') i-vectorSize
            write(*,'(a)', advance = 'no') 'v2_' // trim(adjustl(num)) // ': '
            read(*,*) v2%element(i-vectorSize)
        end if
    end do
    write(*,*)
    write(*,*)
    call v1%magnitude(resultScalar)
    write(*,*) 'Magitude of v1 : ', resultScalar
    write(*,*)
    write(*,*)
    call v2%magnitude(resultScalar)
    write(*,*) 'Magitude of v2 and the its nationality :',resultScalar, v2%nationality
    write(*,*)
    write(*,*)
    call resultVector%add(v1, v2)
    write(*,*) 'Sum vector of v1+v2 and its favourite author: ', resultVector%element
    write(*,*) 'Nationality of v2 and favourite author of sum vector: ', v2%nationality, resultVector%favouriteAuthor
    write(*,*)
    write(*,*)
    call resultVector%subtract(v1, v2)
    write(*,*) 'Subtraction vector of v1-v2 and its favourite author: ', resultVector%element
    write(*,*) 'Nationality of v2 and favourite author of subtraction vector: ', v2%nationality, resultVector%favouriteAuthor
    write(*,*)
    write(*,*)
    call dotProduct(v1, v2, resultScalar)
    write(*,*) 'The dot product of v1 and v2: ', resultScalar
end program vectorAlgebra
