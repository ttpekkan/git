!The project two of the Molecular Modelling course.
!It simulates a box (L**3) with periodic boundary conditions.
!All balls interact with each other through the Lennard-Jones potential.
!Cutoff range (2.5*sigma) and minimum image convention are implemented.

!
! Usage: gfortran program.f90 ;
! ./a.out 100 1000 0.0001 1. 0.01
! 1st parameter: Number of particles
! 2nd : Number of steps
! 3rd : Timestep
! 4th : Sigma
! 5th : Epsilon
!

!Epsilon is called epsilon1 because epsilon is an intrinsic function in Fortran. 
program project2
    implicit none

    integer,parameter:: rk = selected_real_kind(4,20)
    real(rk):: sigma, epsilon1, m = 1.0, dt
    integer :: N, S, i, j, k, skip

    real(rk) :: L, cutoff, r, energy
    real(rk), dimension(:,:), allocatable :: q, v, qNext, vNext               !q(x,y,z), v(vx, vy, vz)
    real(rk), dimension(1,3) :: F, dq                                         !dq(x,y,z), F(Fx, Fy, Fz)
    real(rk), dimension(:), allocatable   :: energies
    real(rk) :: start, finish ! used for timing
    character(32) :: n_s, s_s, sigma_s, epsilon_s, dt_s

    ! Reading command line parameters
    call get_command_argument(1,n_s)
    call get_command_argument(2,s_s)
    call get_command_argument(3,dt_s)
    call get_command_argument(4,sigma_s)
    call get_command_argument(5,epsilon_s)

    read (n_s, *) N
    read (s_s, *) S
    read (sigma_s, *) sigma
    read (epsilon_s, *) epsilon1
    read (dt_s, *) dt

    print *, 'Simulation parameters: '
    print *, 'N: ', N, ' Steps: ', S,  'dt: ', dt
    print *, 'LJ parameters: Sigma: ', sigma, ' Epsilon: ', epsilon1

    call cpu_time(start)
    L = 10*sigma
    cutoff = 2.5*sigma

    skip = S/1000              !use skip = 1 if you want save all trajectory points. In this case, S has to be over 1000. 

    allocate(q(N,3), v(N,3), qNext(N,3), vNext(N,3), energies(S))

    call init_random_seed()
    call random_number(q) !random values for positions [0,1]
    call random_number(v) !random values for velocities [0,1]
    qNext = 0.0
    vNext = 0.0
    energies = 0.0

    !Set origin at center of mass and remove total momentum from the system.
    q(:,1) = (q(:,1) - sum(q(:,1))/N)*L
    q(:,2) = (q(:,2) - sum(q(:,2))/N)*L
    q(:,3) = (q(:,3) - sum(q(:,3))/N)*L
    v(:,1) = (v(:,1) - sum(v(:,1))/N)
    v(:,2) = (v(:,2) - sum(v(:,2))/N)
    v(:,3) = (v(:,3) - sum(v(:,3))/N)

    !Make sure all balls within unit cell.
    open(unit = 1,file = "output.xyz", action = 'write')
    write(1,*) N
    write(1,*)
    do i = 1, N
        do j = 1, 3
            if(q(i,j) < -L/2) then
                q(i,j) = q(i,j) + L
            else if(q(i,j) >= L/2) then
                q(i,j) = q(i,j) - L
            end if
        end do
        write(1,*) 'Ar', q(i,1), q(i,2), q(i,3)
    end do

    !Start changing positions
    do k = 1, S
        if(mod(k, skip) == 0) then                                      !This is here simply if one doesn't want to save all trajectories.
            write(1,*) N
            write(1,*)
        end if

        do i = 1, N
            F = 0.0
            dq = 0.0
            energies(k) = energies(k) + 0.5*m*norm2(v(i,:))**2          !add the kinetic energy of i'th particle to the total energy at K'th step
            do j = 1, N
                if(j == i) then       !No mystical self-interaction!
                    cycle
                end if
                dq(1,:) = q(j,:) - q(i,:)
                dq = closestImage(dq)                                  !Find closest image.
                r = sqrt(dq(1,1)**2 + dq(1,2)**2 + dq(1,3)**2)         !Distance to closest image sqrt(x**2 + y**2 + z**2)
                if(r <= cutoff) then
                    F = F + calcForce(dq, r)
                    if(i < j) then                                      !This if statement is here to prevent double counting the pair potential.
                        energies(k) = energies(k) +  4 * epsilon1 *((sigma/r)**12-(sigma/r)**6)
                    end if
                end if
            end do
            vNext(i,:) = v(i,:) + F(1,:)/m * dt                         !Leapfrog algorithm.
            qNext(i,:) = q(i,:) + vNext(i,:) * dt
        end do
        v = vNext                                                       !Update velocities.
        q = qNext                                                       !Update positions.

        !Make sure all balls within unit cell.
        do i = 1, N
            do j = 1, 3
                if(abs(q(i,j)) > L) then
                    write(*,*) 'Use smaller time-step', q(i,:), k   !This just in case a ball moves over L distance in a single time step.
                    stop
                end if
                if(q(i,j) < -L/2) then
                    q(i,j) = q(i,j) + L
                else if(q(i,j) >= L/2) then
                    q(i,j) = q(i,j) - L
                end if
            end do
            if(mod(k, skip) == 0) then
                write(1,*) 'Ar', q(i,1), q(i,2), q(i,3)
            end if
        end do
    end do

    close(1)
    call cpu_time(finish)
    write(*,*) 'Time (s):', finish-start

    open(unit = 1,file = "energies.txt", action = 'write')
    do i=1,S
        write(1,*) energies(i)
    end do
    close(1)

contains

    function calcForce(dq, r) result(F)
        real(rk), dimension(1,3), intent(in) :: dq
        real(rk), intent(in) :: r
        real(rk), dimension(1,3) :: F

        F(1,:) = -(dq(1,:)/r) * 4*epsilon1*(6*sigma**6 *r**(-7) - 12*sigma**(12)*r**(-13))
    end function

    function closestImage(dq) result(dqReturn)
        real(rk), dimension(1,3), intent(in) :: dq
        real(rk), dimension(1,3) :: dqReturn
        integer :: k

        do k = 1, 3
            if(dq(1,k) > L/2) then
                dqReturn(1,k) = dq(1,k) - L
            else if(dq(1,k) < -L/2) then
                dqReturn(1,k) = dq(1,k) + L
            else
                dqReturn(1,k) = dq(1,k)
            end if
        end do
    end function

end program project2

SUBROUTINE init_random_seed() !Shamelessly stolen from: https://gcc.gnu.org/onlinedocs/gcc-4.6.2/gfortran/RANDOM_005fSEED.html
    INTEGER :: i, n, clock
    INTEGER, DIMENSION(:), ALLOCATABLE :: seed

    CALL RANDOM_SEED(size = n)
    ALLOCATE(seed(n))

    CALL SYSTEM_CLOCK(COUNT=clock)

    seed = clock + 37 * (/ (i - 1, i = 1, n) /)
    CALL RANDOM_SEED(PUT = seed)

    DEALLOCATE(seed)
END SUBROUTINE
