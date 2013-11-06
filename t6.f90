
program hello
    implicit none
    real :: A, B, C, D, k1, k2, k3, k4, t, f1, f2, f3, f4, g1, g2, g3, g4, h1, h2, h3, h4, dt

    A = 0.75
    B = 0.0
    C = 0.0
    D = 0.0
    k1 = 1.0
    k2 = 0.5
    k3 = 0.3
    k4 = 0.1
    t = 0.0
    dt = 0.05
    open(unit = 1, file = 'konsentraatiot')
    do while(t <= 25.0)
        write(1,*) t, A, B, C, D
        f1 = -k1*A + k2*B
        g1 = k1*A - k2*B - k3*B
        h1 = k3*B - k4*C
        f2 = -k1*(A+0.5*dt*f1) + k2*(B+0.5*dt*g1)
        g2 = k1*(A+0.5*dt*f1) - k2*(B+0.5*dt*g1)   - k3*(B+0.5*dt*g1)
        h2 = k3*(B+0.5*dt*g1) - k4*(C+0.5*dt*h1)
        f3 = -k1*(A+0.5*dt*f2) + k2*(B+0.5*dt*g2)
        g3 = k1*(A+0.5*dt*f2) - k2*(B+0.5*dt*g2) - k3*(B+0.5*dt*g2)
        h3 = k3*(B+0.5*dt*g2) - k4*(C+0.5*dt*h2)
        f4 = -k1*(A+dt*f3) + k2*(B+dt*g3)
        g4 = k1*(A+dt*f3) - k2*(B+dt*g3) - k3*(B+dt*g3)
        h4 = k3*(B+dt*g3) - k4*(C+dt*h3)
        A = A + (dt/6)*(f1 + 2*f2 + 2*f3 + f4)
        B = B + (dt/6)*(g1 + 2*g2 + 2*g3 + g4)
        C = C + (dt/6)*(h1 + 2*h2 + 2*h3 + h4)
        D = 0.75 - A - B - C
        t = t + dt
    end do
    close(1)


end program

