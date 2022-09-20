program traj
    use parameters
    use usefulFunctions
    implicit none

    integer(kind = iprec) :: start, finish
    integer(kind = iprec) :: u, v, w, i, counter, rcs, statt
    integer(kind = iprec) :: recross, norecross, reaction, noreaction, failed

    real(kind = dp) :: E, J, TSloc
    real(kind = dp) :: Eprev, Vmin, rCutOff, chi, chiPrev, reactive
    real(kind = dp) :: qK, theta, rD, r, K, pTheta, prD, pr
    real(kind = dp) :: qK0, theta0, rD0, r0, K0, pTheta0, prD0, pr0
    real(kind = dp) :: t, dt, dt0

    call system_clock(start)


    open(newunit=u, file="EJTSinput19.dat", action="read")
    open(newunit=v, file="errors19.dat", status="replace")
    open(newunit=w, file="chiEJ19.dat", status="replace")
    write(w,*) 'E, ', 'J, ', 'Chi, ', &
        & 'norecross, ', 'recross, ',  'reaction, ', 'noreaction, ', 'reactive, ', 'failed'
    write(w,*)
    do
        !Read TS location as a function of E and J.
        read(u,*, iostat=statt) E, J, TSloc
        if (statt /= 0) then
            exit
        end if

        !We keep track of the energy difference between successive steps
        Eprev = E

        !The conditions when a trajectory is terminated
        Vmin = -100.0_dp*1000/Na
        rCutOff = 30.0e-10_dp
        r = rCutOff

        !Keep track of reactive, unreactive, and failed trajectories.
        !Keep track of TS recrossings.
        counter = 0
        recross = 0
        norecross = 0
        reaction = 0
        noreaction = 0
        failed = 0
        chiPrev = 5.0_dp

        do
            !$omp parallel shared(recross, norecross, reaction, noreaction, failed, E, J, &
		!$omp & Vmin, rCutOff, TSloc, u, v, w) private(qK, theta, rD, r, K, pTheta, prD, pr, &
                !$omp & qK0, theta0, rD0, r0, K0, pTheta0, prD0, pr0, &
                !$omp & i, t, dt, dt0, rcs, Eprev, counter)
            !$omp do
            do i = 1, 560
                r = rCutOff
                call initialConditions(E, J, qK, theta, rD, r, K, pTheta, prD, pr)

                !t = 0.0_dp
                dt = 1.0e-17_dp
                rcs = 0    !Number of recrossings for a particular trajectory
                Eprev = E
                do  
                    !Check if the timestep is too small or large.
                    if(isnan(dt) .eqv. .true.) then
                        failed = failed + 1
                        !write(v,*) 'Nan Error'
                        !write(v,*) 'Previous Coordinates'
                        !write(v,*) 'E', E, 'J', J, 'dt', dt0
                        !write(v,*) 'qK', qK0, 'theta', theta0, 'rD', rD0, 'r', r0
                        !write(v,*) 'K', K0, 'pTheta', pTheta0, 'prD', prD0, 'pr', pr0
                        !write(v,*)
                        exit
                    end if

                    !Check if theta is out of bounds or if energy is not conserved
                    if(theta > pi .or. theta < 0.0_dp .or. & !Check for errors
                    & abs(Hamiltonian(J, qK, theta, rD, r, K, pTheta, prD, pr)-E)/E*100 > 2.0_dp) then
                    failed = failed + 1
                    !write(v,*) 'Error in trajectory calculation'
                    !write(v,*) 'E', E, 'J', J, 'dt', dt0
                    !write(v,*) 'r', r
                    !write(v,*) 'theta', theta
                    !write(v,*) 'J**2-K**2', J**2-K**2
                    !write(v,*) '(H-E)/E*100', abs(Hamiltonian(J, qK, theta, rD, r, K, pTheta, prD, pr)-E)/E*100
                    !write(v,*)
                    exit
                end if

                !Check if trajectory has reached one if its endpoints.
                if(potential(theta, rDiatom, r) < Vmin .or. r > 1.01_dp*rCutOff) then
                    if(r > 1.01_dp*rCutOff) then
                        noreaction = noreaction + 1
                        if(rcs > 0) then
                            recross = recross + 1
                        end if
                    else
                        reaction = reaction + 1
                        if(rcs == 0) then
                            norecross = norecross + 1
                        else
                            recross = recross + 1
                        end if
                    end if
                    exit
                end if

                !These 0 values are from the previous step.
                qK0 = qK
                theta0 = theta
                rD0 = rD
                r0 = r
                K0 = K
                pTheta0 = pTheta
                prD0 = prD
                pr0 = pr
                dt0 = dt

                counter = 0
                do
                    counter = counter + 1

                    !Check if the timestep is too small or large.
                    if(isnan(dt) .eqv. .true.) then
                        failed = failed + 1
                        !write(v,*) 'Nan Error'
                        !write(v,*) 'Previous Coordinates'
                        !write(v,*) 'E', E, 'J', J, 'dt', dt0
                        !write(v,*) 'qK', qK0, 'theta', theta0, 'rD', rD0, 'r', r0
                        !write(v,*) 'K', K0, 'pTheta', pTheta0, 'prD', prD0, 'pr', pr0
                        !write(v,*)
                        exit
                    end if

                    !Check if the timestep change gets stuck in an endless loop.
                    if(counter > 1000) then
                        !write(v,*) 'dt convergence error'
                        !write(v,*)
                        exit
                    end if

                    qK = qK0
                    theta = theta0
                    rD = rD0
                    r = r0
                    K = K0
                    pTheta = pTheta0
                    prD = prD0
                    pr = pr0

                    !update position and momenta
                    call ForestRuth(dt, J, qK, theta, rD, r, K, pTheta, prD, pr)

                    !timestep too large, make it smaller and recalculate positions and momenta
                    if(abs((Hamiltonian(J, qK, theta, rD, r, K, pTheta, prD, pr)-Eprev)/Eprev) > 1.0e-7_dp) then
                        dt = 0.99_dp*dt*(1.0e-7_dp/abs((Hamiltonian(J, qK, theta, rD, r, K, pTheta, prD, pr)-Eprev)/Eprev))**0.2_dp
                        cycle
                    !timestep too small, make it larger for next step
                    else
                        dt = 1.01_dp*dt*(1.0e-7_dp/abs((Hamiltonian(J, qK, theta, rD, r, K, pTheta, prD, pr)-Eprev)/Eprev))**0.2_dp
                        if(pTheta > 0.0_dp .and. (theta + pThetaDer(qK, rD, r, J, K, pTheta)*dt) > pi) then
                            dt = abs((pi-theta)/(2*pThetaDer(qK, rD, r, J, K, pTheta)))
                        else if(pTheta < 0.0_dp .and. (theta + pThetaDer(qK, rD, r, J, K, pTheta)*dt) < 0.0_dp) then
                            dt = abs((-theta)/(2*pThetaDer(qK, rD, r, J, K, pTheta)))
                        end if
                        !The value of K has reached its maximum value. This piece of code is here  to prevent
                        !the magnitude of K becoming larger than J.
                        if((abs(J-abs(K)))/J < 2.0e-2_dp) then
                            if(K < 0.0_dp) then
                                K = -J
                            else
                                K = J
                            end if
                        end if
                        exit
                    end if
                end do
                !Check if a trajectory recrosses the transition state.
                if(r > TSloc .and. r0 < TSloc) then
                    rcs = rcs + 1
                end if
                !t = t + dt
                !Save the energy of the current step. The energies of successive steps are compared.
                Eprev = Hamiltonian(J, qK, theta, rD, r, K, pTheta, prD, pr)
                end do
            end do
            !$omp end do
            !$omp end parallel
            chi = 1.0_dp*norecross/(norecross+recross) !The chi function
            if(abs(chi-chiPrev)/chi < 1.0e-2_dp) then  !Desired precision reached
                reactive = 1.0_dp*reaction/(reaction+noreaction) !The ratio of reactive and total trajectories
                exit
            else
                chiPrev = chi !Desired precision not reached.
                cycle
            end if
        end do

        !Output the results for a given E,J
        write(w,*) E, J, chi, norecross, recross,  reaction, noreaction, reactive, failed

    end do
    close(w)
    close(v)
    close(u)

    call system_clock(finish)
    write(*,*) real(finish-start)/1000, 'seconds'

end program traj
