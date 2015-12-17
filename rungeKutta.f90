program rungeKutta
    implicit none
    integer, parameter :: rprec = selected_real_kind(10, 10)
    integer, parameter :: iprec = selected_int_kind(8)
                                                                                 ![] denote Coarrays
    real(kind = rprec), dimension(3,5), codimension[*] :: positions, velocities  !record velocities and positions of objects in these
    real(kind = rprec), dimension(5) :: gravParams                               !gravitational constant times mass

    real(kind = rprec), dimension(3,4) :: rcoeff, vcoeff                         !Runge-Kutta parameters
    integer(kind = iprec) :: i, j, k, img, imgs
    integer(kind = rprec) :: t, dt, endT, au                                     !dt = time increment
    character(len = 1)  :: filename


    imgs = num_images()
    img = this_image()

    if(img == 1) then
        filename = 'a'
    else if(img == 2) then
        filename = 'b'
    else if(img == 3) then
        filename = 'c'
    else if(img == 4) then
        filename = 'd'
    else
        filename = 'e'
    end if

    au = 1.49597871d11
    !Set masses
    gravParams(1) = 1.56d0*1.327140808d20
    gravParams(2) = 7*1.266940606e17
    gravParams(3) = 10*1.266940606e17
    gravParams(4) = 10*1.266940606e17
    gravParams(5) = 9*1.266940606e17


    t = 0.0d0
    dt = 0.0001d0*31556926d0 !Time increment
    endT = 10000*31556926d0    !For how long do we calculate?
    j = 0

    !Star a initial data
    positions(1,1)[img] = 0.0d0
    positions(2,1)[img] = 0.0d0
    positions(3,1)[img] = 0.0d0
    velocities(1,1)[img] = 0.0d0
    velocities(2,1)[img] = 0.0d0
    velocities(3,1)[img] = 0.0d0

    !Planet b initial data
    positions(1,2)[img] = -au * 63.5d0     !x
    positions(2,2)[img] = au * 32.7d0      !y
    positions(3,2)[img] = au * 19.1d0      !z
    velocities(1,2)[img] = -4740.57172d0 * 0.46d0     !vx
    velocities(2,2)[img] = -4740.57172d0 * 0.893d0    !vy
    velocities(3,2)[img] = 4740.57172d0 * 0.27d0      !vz

    !Planet c initial data
    positions(1,3)[img] = au * 26.2d0
    positions(2,3)[img] = au * 29.7d0
    positions(3,3)[img] = 0.0d0
    velocities(1,3)[img] = -4740.57172d0 * 0.83d0
    velocities(2,3)[img] = 4740.57172d0 * 0.66d0
    velocities(3,3)[img] = 0.0d0

    !Planet d initial data
    positions(1,4)[img] = au * 10.9d0
    positions(2,4)[img] = -au * 24.1
    positions(3,4)[img] = 0.0d0
    velocities(1,4)[img] = 4740.57172d0 * 1.35d0
    velocities(2,4)[img] = 4740.57172d0 * 0.58d0
    velocities(3,4)[img] = 0.0d0

    !Planet e initial data
    positions(1,5)[img] = au * 12.7
    positions(2,5)[img] = -au * 8.38
    positions(3,5)[img] = 0.0d0
    velocities(1,5)[img] = 4740.57172d0*1.08d0
    velocities(2,5)[img] = 4740.57172d0*1.64d0
    velocities(3,5)[img] = 0.0d0

    !Each image opens own channel
    open(unit = 10+img, file = filename, action = 'write')

    do
        if(mod(j,10000) == 0) then
            write(10+img,*) positions(1,img)[img]/au, positions(2,img)[img]/au, positions(3,img)[img]/au !Write positions to a file
        end if

        if(t > endT) then
            exit
        end if

        call calcCoeffs !The Runge-Kutta factors are calculated in their own subroutine

        do i = 1, 3
            positions(i,img)[img] = positions(i,img)[img] + dt/6 * (rcoeff(i,1) + 2*rcoeff(i,2) + 2*rcoeff(i,3) + rcoeff(i,4))
            velocities(i,img)[img] = velocities(i,img)[img] + dt/6 * (vcoeff(i,1) + 2*vcoeff(i,2) + 2*vcoeff(i,3) + vcoeff(i,4))
        end do

        sync all !Wait for all the images to catch-up

        if(img == 1) then
            do k = 1, imgs
                do i = 1, imgs
                    positions(:,i)[k] = positions(:,i)[i]       !Update planet positions for all images
                    velocities(:,i)[k] = velocities(:,i)[i]
                end do
            end do
        end if

        t = t + dt
        j = j + 1
        sync all !Wait that all the positions are updated before continuing
    end do

    close(10+img)

    contains

    subroutine calcCoeffs
        real(kind = rprec) :: dx, dy, dz, r

        rcoeff = 0.0d0
        vcoeff = 0.0d0

        !k1, l1, m1
        do i = 1, 3
            rcoeff(i,1) = velocities(i,img)[img]
        end do
        do i = 1, imgs
            if(i == img) then
                cycle
            end if
            dx = positions(1,img)[img] - positions(1,i)[img]
            dy = positions(2,img)[img] - positions(2,i)[img]
            dz = positions(3,img)[img] - positions(3,i)[img]
            r = dsqrt(dx**2 + dy**2 + dz**2)
            vcoeff(1,1) = vcoeff(1,1) - gravParams(i)*dx/(r**3)
            vcoeff(2,1) = vcoeff(2,1) - gravParams(i)*dy/(r**3)
            vcoeff(3,1) = vcoeff(3,1) - gravParams(i)*dz/(r**3)
        end do

        !k2, l2, m2
        do i = 1, 3
            rcoeff(i,2) = velocities(i,img)[img] + dt/2 * vcoeff(i,1)
        end do
        do i = 1, imgs
            if(i == img) then
                cycle
            end if
            dx = (positions(1,img)[img] + rcoeff(1,1)*dt/2) - positions(1,i)[img]
            dy = (positions(2,img)[img] + rcoeff(2,1)*dt/2) - positions(2,i)[img]
            dz = (positions(3,img)[img] + rcoeff(3,1)*dt/2) - positions(3,i)[img]
            r = dsqrt(dx**2 + dy**2 + dz**2)
            vcoeff(1,2) = vcoeff(1,2) - gravParams(i)*dx/(r**3)
            vcoeff(2,2) = vcoeff(2,2) - gravParams(i)*dy/(r**3)
            vcoeff(3,2) = vcoeff(3,2) - gravParams(i)*dz/(r**3)
        end do

        !k3, l3, m3
        do i = 1, 3
            rcoeff(i,3) = velocities(i,img)[img] + dt/2 * vcoeff(i,2)
        end do
        do i = 1, imgs
            if(i == img) then
                cycle
            end if
            dx = (positions(1,img)[img] + rcoeff(1,2)*dt/2) - positions(1,i)[img]
            dy = (positions(2,img)[img] + rcoeff(2,2)*dt/2) - positions(2,i)[img]
            dz = (positions(3,img)[img] + rcoeff(3,2)*dt/2) - positions(3,i)[img]
            r = dsqrt(dx**2 + dy**2 + dz**2)
            vcoeff(1,3) = vcoeff(1,3) - gravParams(i)*dx/(r**3)
            vcoeff(2,3) = vcoeff(2,3) - gravParams(i)*dy/(r**3)
            vcoeff(3,3) = vcoeff(3,3) - gravParams(i)*dz/(r**3)
        end do

        !k4, l4, m4
        do i = 1, 3
            rcoeff(i,4) = velocities(i,img)[img] + dt * vcoeff(i,3)
        end do
        do i = 1, imgs
            if(i == img) then
                cycle
            end if
            dx = (positions(1,img)[img] + rcoeff(1,3)*dt) - positions(1,i)[img]
            dy = (positions(2,img)[img] + rcoeff(2,3)*dt) - positions(2,i)[img]
            dz = (positions(3,img)[img] + rcoeff(3,3)*dt) - positions(3,i)[img]
            r = dsqrt(dx**2 + dy**2 + dz**2)
            vcoeff(1,4) = vcoeff(1,4) - gravParams(i)*dx/(r**3)
            vcoeff(2,4) = vcoeff(2,4) - gravParams(i)*dy/(r**3)
            vcoeff(3,4) = vcoeff(3,4) - gravParams(i)*dz/(r**3)
        end do

    end subroutine calcCoeffs

end program



