!Eli tilanne on, että meillä on kaksi ympyrän muotoista varausta (toinen pos. toinen neg.) ja
!tarkoituksena olisi selvittää, minkälainen potentiaali on tutkittavan suorakulmion muotoisen
!alueen sisällä, kun ympyröiden säteet, varaustiheydet ja sijainnit tiedetään.


program poisson2D
    implicit none
    real, dimension(240, 200) :: potential, chargeDensity, oldPotential, checkConverge
    integer :: x, y, iterations
    real :: sphereRadius

    iterations = 0
    sphereRadius = 5.0
    potential  = 0.0   !Alkuarvauksena on, että potentiaali nolla joka kohdassa. Sovitaan, että potentiaalin arvo nolla laatikon reunoilla.

    !Tämä silmukka asettaa varaustiheyden tutkittavaan alueeseen.

    do x = 1, 240
        do y = 1, 200
            if(((x-100)**2 + (y-100)**2)**(0.5) <= sphereRadius) then
                chargeDensity(x,y) = (((x-100)**2 + (y-100)**2)**(0.5)/sphereRadius)**(20) !Lauseke positiivisen ympyrän varaustiheydelle.
            else if(((x-140)**2 + (y-100)**2)**(0.5) <= sphereRadius) then
                chargeDensity(x,y) = -(((x-140)**2 + (y-100)**2)**(0.5)/sphereRadius)**(20) !Lauseke negatiivisen ympyrän varaustiheydelle.
            else                                                                            !Eksponentin tarkoitus on, että suurin osa
                chargeDensity(x,y) = 0.0                                                    !varauksesta olisi ympyrän reunalla.
            end if
        end do
    end do

    oldPotential = potential

    !Iterointi silmukka.

    do
        do x = 2, 239
            do y = 2, 199
                potential(x,y) = (potential(x-1,y)+potential(x+1,y)+potential(x,y-1)+potential(x,y+1)+chargeDensity(x,y))/4
            end do
        end do
        checkConverge = abs(potential - oldPotential )
        oldPotential = potential
        iterations = iterations + 1
        if(maxval(checkConverge) == 0.0) then   !Edellinen iterointikerta antoi samat tuloksen potentiaalille. Poistutaan silmukasta.
            exit
        end if
    end do

    !Tämä silmukka kirjoittaa tiedostoon potentiaalin arvon jokaisessa xy-pisteessä, jotta tulosta voidaan tarkastella graafisesti.

    open(unit = 1, file = 'pisteet')
    do x = 1, 240
        do y = 1, 200
            write(1,*) x, y, potential(x,y)
        end do
    end do
    close(1)
    write(*,*) iterations
end program

