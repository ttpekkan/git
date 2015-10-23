program asteroidOrbit
    implicit none
    integer, parameter :: rprec = selected_real_kind(10, 10)
    integer, parameter :: iprec = selected_int_kind(8)

    interface
        subroutine invertMatrix(matrixIn, invertedMatrix)
            integer, parameter :: rprec = selected_real_kind(10, 10)
            real(kind = rprec), dimension(:,:), intent(in) :: matrixIn
            real(kind = rprec), dimension(:,:), intent(out) :: invertedMatrix

        end subroutine invertMatrix
    end interface

    real(kind = rprec), dimension(:,:), allocatable :: R, RminFA, Er    !R contains the data points, (R-FA), Err = errors (not used)
    real(kind = rprec), dimension(:,:), allocatable :: F                !Design matrix
    real(kind = rprec), dimension(1,1) :: RminFATWRminFA                !(R-FA)^T  W (R-FA)
    real(kind = rprec), dimension(4,1) :: A, FTWR                       !F^T WR, A = parameter matrix
    real(kind = rprec), dimension(4,4) :: FTWF, invFTWF, varA           !F^T WF, (FTWF)^(-1)
    real(kind = rprec), dimension(:,:), allocatable :: W                !Weight matrix
    real(kind = rprec) :: sigma2                                        !Scale factor
    integer(kind = iprec) :: io, n, i, j

    !Check how many data points we have.
    n = 0
    varA = 0
    open(unit = 11, file = 'data.dat', action = 'read')
    do
        read(11,*,iostat=io)
        if(io > 0) then
            write(*,*) 'Check input.  Something was wrong'
            stop
        else if(io < 0) then
            exit
        else
            n = n + 1
        end if
    end do
    close(11)

    !Allocate matrices according to the number of data points.
    allocate(R(2*n,1))
    allocate(Er(2*n,1))
    allocate(F(2*n,4))
    allocate(W(2*n,2*n))
    R = 0
    Er = 0
    F = 0
    W = 0

    !Read data into matrices.
    open(unit = 11, file = 'data.dat', action = 'read')
    do i = 1, 2*n, 2
        F(i,1) = 1.0
        F(i+1,2) = 1.0
        read(11,*) F(i,3), R(i,1), Er(i,1), W(i,i), R(i+1,1), Er(i+1,1), W(i+1,i+1)
        F(i+1,4) = F(i,3)
    end do
    close(11)

    !Solve the parameter matrix A
    FTWF = matmul(transpose(F), matmul(W,F))
    FTWR = matmul(transpose(F), matmul(W,R))
    call invertMatrix(FTWF, invFTWF)
    A = matmul(invFTWF, FTWR)

    !Solve the variance-covariance matrix of A
    RminFA = R - matmul(F,A)
    RminFATWRminFA = matmul(transpose(RminFA), matmul(W,RminFA))
    sigma2 = RminFATWRminFA(1,1)/(2.0*n-4.0)
    do j = 1, 4
        do i = 1, 4
            varA(i,j) = sigma2*invFTWF(i,j)
        end do
    end do

    write(*,*) 'Weighted Fit'
    write(*,*)
    write(*,'(a)') 'The orbital elements are:'
    write(*,'(a)', advance = 'no') 'x0 = '
    write(*,'(F8.2)', advance = 'no') A(1,1)
    write(*,'(a)', advance = 'no') ' +- '
    write(*,'(F6.2)', advance = 'no') sqrt(varA(1,1))
    write(*,'(a)', advance = 'no') ' m'
    write(*,*)
    write(*,'(a)', advance = 'no') 'y0 = '
    write(*,'(F8.2)', advance = 'no') A(2,1)
    write(*,'(a)', advance = 'no') ' +- '
    write(*,'(F6.2)', advance = 'no') sqrt(varA(2,2))
    write(*,'(a)', advance = 'no') ' m'
    write(*,*)
    write(*,'(a)', advance = 'no') 'vx = '
    write(*,'(F8.2)', advance = 'no') A(3,1)
    write(*,'(a)', advance = 'no') ' +- '
    write(*,'(F6.2)', advance = 'no') sqrt(varA(3,3))
    write(*,'(a)', advance = 'no') ' m/s'
    write(*,*)
    write(*,'(a)', advance = 'no') 'vy = '
    write(*,'(F8.2)', advance = 'no') A(4,1)
    write(*,'(a)', advance = 'no') ' +- '
    write(*,'(F6.2)', advance = 'no') sqrt(varA(4,4))
    write(*,'(a)', advance = 'no') ' m/s'
    write(*,*)
    write(*,*)
    write(*,*)
    write(*,*) 'Weightless Fit'
    write(*,*)
    do i = 1, 2*n
        W(i,i) = 1.0
    end do
    !Solve the parameter matrix A
    FTWF = matmul(transpose(F), matmul(W,F))
    FTWR = matmul(transpose(F), matmul(W,R))
    call invertMatrix(FTWF, invFTWF)
    A = matmul(invFTWF, FTWR)

    !Solve the variance-covariance matrix of A
    RminFA = R - matmul(F,A)
    RminFATWRminFA = matmul(transpose(RminFA), matmul(W,RminFA))
    sigma2 = RminFATWRminFA(1,1)/(2*n-4)
    do i = 1, 4
        do j = 1, 4
            varA(i,j) = sigma2*invFTWF(i,j)
        end do
    end do
    write(*,'(a)') 'The orbital elements are:'
    write(*,'(a)', advance = 'no') 'x0 = '
    write(*,'(F8.2)', advance = 'no') A(1,1)
    write(*,'(a)', advance = 'no') ' +- '
    write(*,'(F6.2)', advance = 'no') sqrt(varA(1,1))
    write(*,'(a)', advance = 'no') ' m'
    write(*,*)
    write(*,'(a)', advance = 'no') 'y0 = '
    write(*,'(F8.2)', advance = 'no') A(2,1)
    write(*,'(a)', advance = 'no') ' +- '
    write(*,'(F6.2)', advance = 'no') sqrt(varA(2,2))
    write(*,'(a)', advance = 'no') ' m'
    write(*,*)
    write(*,'(a)', advance = 'no') 'vx = '
    write(*,'(F8.2)', advance = 'no') A(3,1)
    write(*,'(a)', advance = 'no') ' +- '
    write(*,'(F6.2)', advance = 'no') sqrt(varA(3,3))
    write(*,'(a)', advance = 'no') ' m/s'
    write(*,*)
    write(*,'(a)', advance = 'no') 'vy = '
    write(*,'(F8.2)', advance = 'no') A(4,1)
    write(*,'(a)', advance = 'no') ' +- '
    write(*,'(F6.2)', advance = 'no') sqrt(varA(4,4))
    write(*,'(a)', advance = 'no') ' m/s'
end program

subroutine invertMatrix(matrixIn, invertedMatrix)
    implicit none

    interface
        recursive subroutine getDeterminant(matrixIn, determinant)
            integer, parameter :: rprec = selected_real_kind(10, 10)
            real(kind = rprec), dimension(:,:), intent(in) :: matrixIn
            real(kind = rprec), intent(out) :: determinant

        end subroutine getDeterminant
    end interface

    integer, parameter :: rprec = selected_real_kind(10, 10)
    integer, parameter :: iprec = selected_int_kind(8)
    real(kind = rprec), dimension(:,:), intent(in) :: matrixIn
    real(kind = rprec), dimension(:,:), intent(out) :: invertedMatrix
    real(kind = rprec), dimension(:,:), allocatable :: detMatrix
    real(kind = rprec) :: determinant
    integer(kind = iprec) :: i, j, k, l, x, y, n, m

    n = size(matrixIn,1)                                    !Dimension of an n x n matrix.
    m = n-1                                                 !Dimension of an n-1 x -1 matrix.
    allocate(detMatrix(n-1,n-1))

    !Build the matrix of Cofactors.
    do j = 1 , n
        do i = 1 , n
            x = 0
            do l = 1, m
                if(l == j) then
                    x = 1
                end if
                y = 0
                do k = 1, m
                    if(k == i) then
                        y = 1
                    end if
                    detMatrix(k,l) = matrixIn(k+y,l+x)         !Get the Cofactor matrix values by solving the determinants.
                end do
            end do
            call getDeterminant(detMatrix, determinant)
            if(mod(i, 2) == 1) then                            !Assign correct signs to the cofactor matrix elements.
                if(mod(j, 2) == 1) then
                    invertedMatrix(i,j) = determinant
                else
                    invertedMatrix(i,j) = -determinant
                end if
            else
                if(mod(j, 2) == 1) then
                    invertedMatrix(i,j) = -determinant
                else
                    invertedMatrix(i,j) = determinant
                end if
            end if
        end do
    end do

    invertedMatrix = transpose(invertedMatrix)              !Adjugate the cofactor matrix.

    call getDeterminant(matrixIn, determinant)
    if(abs(determinant) < 1.0d-17) then
        write(*,*) 'Can not invert'
        stop
    end if
    invertedMatrix = invertedMatrix/determinant             !Divide the adjoint with the determinant of the original input matrix.

end subroutine invertMatrix

recursive subroutine getDeterminant(matrixIn, determinant)
    implicit none
    integer, parameter :: rprec = selected_real_kind(10, 10)
    integer, parameter :: iprec = selected_int_kind(8)
    real(kind = rprec), dimension(:,:), intent(in) :: matrixIn
    real(kind = rprec), dimension(:,:), allocatable :: subMatrix
    real(kind = rprec), intent(out) :: determinant
    real(kind = rprec) :: subDeterminant
    integer(kind = iprec) :: i, j, k, n, m, y

    determinant = 0
    subDeterminant = 0

    n = size(matrixIn, 1)                               !Dimension of an n x n matrix.
    m = n-1                                             !Dimension of an n-1 x -1 matrix.

    if(n == 1) then
        determinant = matrixIn(1,1)
        return
    end if
    if(n == 2) then
        determinant = matrixIn(1,1)*matrixIn(2,2) - matrixIn(1,2)*matrixIn(2,1)
        return
    end if
    allocate(subMatrix(m,m))

    !Split determinant into smaller determinants.
    do i = 1, n
        do k = 1, m
            y = 0
            do j = 1, m
                if(j == i) then
                    y = 1
                end if
                subMatrix(j,k) = matrixIn(j+y,k+1)
            end do
        end do
        call getDeterminant(subMatrix, subDeterminant)
        if(mod(i,2) == 1) then
            determinant = determinant + matrixIn(i,1)*subDeterminant
        else
            determinant = determinant - matrixIn(i,1)*subDeterminant
        end if
    end do

end subroutine getDeterminant

