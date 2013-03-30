
program f4
    implicit none

    real*8 :: interval, earthMass, moonMass, gravitationalConstant, endPoint, earthMoonDistance, moonRadius, earthRadius, KarmanLine

    gravitationalConstant = 6.67259e-11
    moonMass = 7.348e22
    earthMass = 5.974e24
    moonRadius = 1738.2*1000
    earthRadius = 6378.140*1000
    KarmanLine = 100*1000
    earthMoonDistance = 384400*1000

    endPoint = earthMoonDistance - moonRadius

    interval = 0.1          !Aika-askel

    call calculateMinSpeed(interval)

contains

    subroutine calculateMinSpeed(interval)
        real*8 :: interval, initialVelocity

        open(unit = 1, file = 'nopeudetJaAjat')
        write(1,*) 'Alkunopeus', '               ',  'Matka-aika (tunteina)'

        initialVelocity = 10950                            !Lähtee kokeilemaan alkunopeuksia tästä arvosta.
        do
            if(calculateTime(initialVelocity, interval) > 0) then   !Ottaa ylös tuloksen, jos päästään kuuhun.
                write(1,*) initialVelocity, calculateTime(initialVelocity, interval)/(60*60)
            end if
            if(initialVelocity >= 12200) then                !Lopettaa nopeuksien laskemisen.
                exit
            end if
            initialVelocity = initialVelocity + 0.1          !Nopeus-askel
        end do
        close(1)

    end subroutine calculateMinSpeed


    function calculateTime(initialVelocity, interval) result(time)
        real*8 :: time, initialVelocity, interval, velocity
        real*8 :: lastDistance, distanceFromEarth, distanceFromMoon, acceleration

        time = 0.0
        distanceFromEarth = earthRadius + KarmanLine
        distanceFromMoon = earthMoonDistance - distanceFromEarth
        velocity = initialVelocity
        lastDistance = distanceFromEarth

        do
            acceleration = gravitationalConstant * (moonMass/distanceFromMoon**2 - earthMass/distanceFromEarth**2)
            distanceFromEarth = distanceFromEarth + velocity*interval + 0.5*acceleration*interval**2
            distanceFromMoon = earthMoonDistance - distanceFromEarth
            time = time + interval
            if(distanceFromEarth >= endPoint) then
                return
            end if
            if(distanceFromEarth <= lastDistance) then  !Ei pääse perille, lopettaa laskemisen.
                time = -1.0
                return
            end if
            velocity = velocity + acceleration*interval
            lastDistance = distanceFromEarth
        end do

    end function calculateTime

end program


