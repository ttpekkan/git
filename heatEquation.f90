program heatEquation
    implicit none
    integer, parameter :: rprec = selected_real_kind(15, 15)
    integer, parameter :: iprec = selected_int_kind(8)

    integer(kind = iprec) :: i, j, meshSize, tLim
    real(kind = rprec) :: a, radius, timeLimit, dr, dt, r, t
    real(kind = rprec), dimension(:), allocatable :: M, Mprev      !temperature matrix (time, radial coordinate, temperature)

    a = 18.5d-6                          !alpha [m**2 s**-1]
    radius = 4.0d-3                      !m
    timeLimit = 1.0d-1                   !s
    meshSize = 100                       !spatial discretization

    dr = radius/meshSize                 !spatial step
    dt = 1.0d-4 * (dr**2)/a              !time step
    tLim = IDNINT(timeLimit/dt)          !number of time steps.

    allocate(M(meshSize+1))              !initialise matrix
    allocate(Mprev(meshSize+1))
    M = 650.0d0                          !set initial gas temperature
    M(meshSize+1) = 550.0d0              !set initial surface temperature

    open(unit = 11, file = 'output3D.dat', action = 'write')
    open(unit = 12, file = 'outputAxial.dat', action = 'write')

    t = 0.0d0
    do i = 1, meshSize+1                                !write down initial conditions
        write(11,*) t, (i-1)*radius/meshSize, M(i)
    end do
    write(12,*) t, 650d0

    do j = 1, tLim                                      !solve dT/dt = alpha*[d**2 U/dr**2 + (1/r)dU/dr] (angular term is zero)
        t = t + dt
        Mprev = M
        do i = 1, meshSize+1
            r = (i-1)*radius/meshSize
            if(i == 1) then                                     !dT/dt = alpha*[d**2 U/dr**2 + (1/r)dU/dr] at r=0
                M(1) = Mprev(1) + 4*a*dt*(Mprev(2) - Mprev(1))/(dr**2)
            else if (i == meshSize+1) then                      !do nothing if at boundary (surface)
                continue
            else                                                !dT/dt = alpha*[d**2 U/dr**2 + (1/r)dU/dr] at r /= 0
                M(i) = Mprev(i) &
                        + (a*dt)*(Mprev(i+1) - 2*Mprev(i) + Mprev(i-1))/(dr**2) &
                        + (a*dt/r)*(Mprev(i+1) - Mprev(i-1))/(2*dr)
            end if
            if(mod(j,tLim/1000) == 0) then                      !don't save every point.
                write(11,*) t, (i-1)*radius/meshSize, M(i)
                if(i==1) then
                    write(12,*) t, M(1)
                end if
            end if
        end do
    end do
    close(11)
    close(12)

end program


