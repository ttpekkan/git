program Q5
    real*8 :: I, U, dV, H,G, e, p, R, T

    e = 2.718281828
    p = 1.01325
    R = 0.0831451
    T = 298.0

    I = 0.0
    U = 0.0
    H  = 0.0
    G  = 0.0
    open(unit = 1, file = 'P')
    open(unit = 2, file = 'H')
    open(unit = 3, file = 'G')
    do
        write(1,*) I, U*I
        write(2,*) I, H
        write(3,*) I, G
        I = I + 0.00001
        U = (0.00026/I) -17.10548*I -1.8364e-32 * e**(450*I) + 3.31826
        dV = 2.00402e-6 + 5.01957e-4 * I
        H = U*I*R*T / (p*dV*285830)
        G = H*285.83/237.14
        if(U < 0) then
            exit
        end if
    end do
    close(1)
    close(2)
    close(3)
end program


