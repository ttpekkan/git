program Q5
    real :: I, U, P, n, H,G, e

    e = 2.718281828
    I = 0.0
    U = 0.0
    P = 0.0
    n = 1.0
    H  = 0.0
    G  = 0.0
    open(unit = 1, file = 'P')
    open(unit = 2, file = 'H')
    open(unit = 3, file = 'G')
    do
        write(1,*) I, P
        write(2,*) I, H
        write(3,*) I, G
        I = I + 0.0001
        U = (0.00026/I) -17.10548*I -1.8364e-32 * e**(450*I) + 3.31826
        P = U*I
        n = 6.90538e-6 - 2.05912e-5 * I
        H = P / (n*285830)
        G = P / (n*237140)
        if(U < 0) then
            exit
        end if
    end do
    close(1)
    close(2)
    close(3)
end program


