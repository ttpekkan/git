!Kuumatka-ohjelma

!Periaatteesahan koodi on niin selvää, ettei sitä tarvitsisi kommentoida, mutta jos nyt tämän kerran.

!Ohjelma on melko hidas (noin 0.5 h), koska käytetyt aika-askeleet ja nopeusaskeleet ovat melko pieniä ja sisäkkäisiä
!silmukoita on muutama. Aika-askelia ja nopeusaskelia kasvattamalla ohjelma tietenkin nopeutuu huomattavasti.

program f4
    implicit none
    real*8 :: earthMass, moonMass, gravitationalConstant, endPoint, earthMoonDistance, moonRadius, earthRadius, KarmanLine
    real*8 :: timeInterval, minVelocity

    !Ohjelmassa käytetyt vakiot (MAOL:ista).

    gravitationalConstant = 6.67259e-11
    moonMass = 7.348e22
    earthMass = 5.974e24
    moonRadius = 1738.2*1000
    earthRadius = 6378.140*1000
    KarmanLine = 100*1000
    earthMoonDistance = 384400*1000

    endPoint = earthMoonDistance - moonRadius   !Kuun pinta.
    minVelocity = 12200                         !Ensimmäinen arvaus minimilähtönopeudelle on maan pakonopeus + 1000 m/s.
    timeInterval = 120                          !Aika-askel, jota myöhemmin pienennetään.

    !Silmukka laskee minimilähtönopeuden tietyllä aika-askeleella ja kirjoittaa tiedostoon aika-askeleen ja
    !sitä vastaavaan lähtönopeuden arvon. Tiedoston pohjalta voidaan myöhemmin muodostaa kuvaaja. Koska
    !aika-askeleen pienentäminen aina pienentää lähtönopeutta, niin ensimmäinen arvaus lähtönopeudelle on
    !aina edellinen tulos lähtönopeudelle. Tämä lyhentää laskuaikaa huomattavasti. Ensimmäinen aika-askel on
    !120 sekuntia. Silmukka lopettaa laskemisen, kun aika-askel on ~0.01 s. Lopuksi vielä laskee
    !lähtönopeuden, kun aika-askel on tarkalleen 0.01 s.

    open(unit = 1, file = 'alkunopeusAika-askeleenFunktiona')
    do while(timeInterval > 0.01)
        minVelocity = calculateMinVelocity(timeInterval, minVelocity)
        write(1,*) timeInterval, minVelocity
        timeInterval = timeInterval - 0.01
    end do
    close(1)
    timeInterval = 0.01
    minVelocity = calculateMinVelocity(timeInterval, minVelocity)

    !Seuraava kohta laskee ja tulostaa matka-ajan ja lähtönopeuden, kun lähtönopeus on minimilähtönopeus ja
    !kun lähtönopeus on 1.1-kertaa minimilähtönopeus.

    write(*,*) 'Aika-askel = 0.01 s'
    write(*,*) 'Lähtönopeus:', minVelocity, 'Matka-aika:', calculateTime(timeInterval, minVelocity)/(60*60)
    write(*,*) 'Lähtönopeus:', 1.1*minVelocity, 'Matka-aika:',calculateTime(timeInterval, 1.1*minVelocity)/(60*60)

    !Silmukka kirjoittaa tiedostoon lähtönopeuden ja sitä vastaavan matka-ajan. Ensimmäinen lähtönopeus on
    !minimilähtönopeus ja viimeinen lähtönopeus on ~20000 m/s. Lähtönopeutta kasvatetaan aina 1 m/s.

    open(unit = 1, file = 'matka-aikaAlkunopeudenFunktiona')
    do while (minVelocity < 20000)
        write(1,*) minVelocity, calculateTime(timeInterval, minVelocity)/(60*60)
        minVelocity = minVelocity + 1.0
    end do
    close(1)


contains

    !Funktiolle annetaan aika-askel ja arvaus minimilähtönopeudelle. Arvaus on aina enemmän kun varsinainen
    !minimilähtönopeus. Funktiossa oleva silmukka pienentää lähtönopeutta niin kauan, kunnes ei enää päästä
    !kuuhun. Sitten funktio palauttaa viimeisen lähtönopeuden, jolla päästiin kuuhun. Lähtönopeutta
    !pienennetään aina 0.01 m/s.

    function calculateMinVelocity(timeInterval, velocityGuess) result(minVelocity)
        real*8 :: timeInterval, velocityGuess, minVelocity, previousVelocity

        minVelocity = velocityGuess

        do
            if(calculateTime(timeInterval, minVelocity) < 0) then   !Jos aika < 0, tarkoittaa, ettei päästä kuuhun.
                minVelocity = previousVelocity
                return
            end if
            previousVelocity  = minVelocity
            minVelocity = minVelocity - 0.01
        end do

    end function calculateMinVelocity

    !Funktio laskee, päästäänkö annetulla lähtönopeudella ja aika-askeleella kuuhun ja jos päästään,
    !niin funktio palauttaa matka-ajan. Jos ei päästä, funktio palauttaa negatiivisen arvon matka-
    !ajalle. Funktiossa oleva silmukka päivittää raketin paikkaa, nopeutta ja kiihtyvyyttä jokaisen
    !aika-askeleen jälkeen. Silmukka tarkastaa myös, ollaanko perillä ja mennäänkö joka askeleella
    !eteenpäin. Jos ei mennä, silmukka ymmärtää lopettaa laskemisen.

    function calculateTime(timeInterval, initialVelocity) result(time)
        real*8 :: timeInterval, initialVelocity
        real*8 :: acceleration, velocity, time, distanceFromEarth, distanceFromMoon, lastDistance

        time = 0.0
        distanceFromEarth = earthRadius + KarmanLine
        distanceFromMoon = earthMoonDistance - distanceFromEarth
        velocity = initialVelocity
        lastDistance = distanceFromEarth

        do
            acceleration = gravitationalConstant * (moonMass/distanceFromMoon**2 - earthMass/distanceFromEarth**2)  !yhtälö 4
            distanceFromEarth = distanceFromEarth + velocity*timeInterval + 0.5*acceleration*timeInterval**2        !yhtälö 5
            distanceFromMoon = earthMoonDistance - distanceFromEarth
            time = time + timeInterval
            if(distanceFromEarth >= endPoint) then          !Perillä, palauttaa matka-ajan.
                return
            end if
            if(distanceFromEarth <= lastDistance) then      !Ei pääse perille, lopettaa laskemisen.
                time = -1.0
                return
            end if
            velocity = velocity + acceleration*timeInterval !yhtälö 6
            lastDistance = distanceFromEarth
        end do

    end function calculateTime
end program

