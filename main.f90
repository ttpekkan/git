program t6
    implicit none
    integer :: day, month, year, weekday, inquiryYear, numberOfDaysInMonth, counter, i, j
    integer, dimension(12,3) :: dayArray

    write(*,'(a)', advance = 'no') 'Anna vuosi: '
    read(*,*) inquiryYear

    weekday = 4 !Vertauspisteeksi valittu tämä (25.10.2012) päivä, jonka viikonpäivän tiedämme (toivottavasti).
    day = 25
    month = 10
    year = 2012
    counter = 1

    if (inquiryYear <= year) then
        do while (year >= inquiryYear)
            if (weekday == 5 .and. day == 13 .and. year == inquiryYear) then
                call addDay
            end if
            weekday = weekday - 1
            if (day == 1 .and. month == 1) then
                day = 31
                month = 12
                year = year - 1
            else
                day = day - 1
                if (day == 0) then
                    month = month - 1
                    day = numberOfDaysInMonth(month, year)
                end if
            end if
            if (weekday == 0) then
                weekday = 7
            end if
        end do
    end if

    weekday = 4 !Tämä kohta siltä varalta, että kysytty vuosi olisi tämä vuosi.
    day = 25    !Silloin perjantain 13. päiviä voisi olla myös loppuvuonna.
    month = 10  !Tehtävänannosta toki tiedämme, että näin ei ole.
    year = 2012 !Toisaalta nyt koodiin voisi laitaa lähtötiedoiksi minkä tahansa päivän tiedot.

    if (inquiryYear >= year) then
        do while (year <= inquiryYear)
            if (weekday == 5 .and. day == 13 .and. year == inquiryYear) then
                call addDay
            end if
            weekday = weekday + 1
            if (day == 31 .and. month == 12) then
                day = 1
                month = 1
                year = year + 1
            else
                day = day + 1
                if (day > numberOfDaysInMonth(month, year)) then
                    month = month + 1
                    day = 1
                end if
            end if
            if (weekday == 8) then
                weekday = 1
            end if
        end do
    end if

    counter = counter - 1
    write(*,*)
    write(*,'(a)') 'Day  Month  Year'
    do i = 1, 12
        do j = 1, counter
            if (dayArray(j,2) == i) then
                write(*,'(i2)', advance = 'no') dayArray(j,1)
                write(*,'(a)', advance = 'no') '  '
                write(*,'(i2)', advance = 'no') dayArray(j,2)
                write(*,'(a)', advance = 'no') '  '
                write(*,'(i8)', advance = 'no') dayArray(j,3)
                write(*,*)
            end if
        end do
    end do

contains

    subroutine addDay
        dayArray(counter,1) = day
        dayArray(counter,2) = month
        dayArray(counter,3) = year
        counter = counter + 1
    endsubroutine addDay

end program

function checkLeapYear(inputYear) result(isLeapYear) !Tämä oli OhPe:ssä.
    implicit none
    integer :: inputYear, isLeapYear

    if ((mod(inputYear, 400) == 0) .or. ((mod(inputYear, 4) == 0) .and. (mod(inputYear, 100) /= 0))) then
        isLeapYear = 1
    else
        isLeapYear = -1
    end if
end function checkLeapYear

function numberOfDaysInMonth(inputMonth, inputYear) result(days)
    implicit none
    integer :: inputMonth, inputYear, days, checkLeapYear

    if (inputMonth == 2) then
        if (checkLeapYear(inputYear) == 1) then
            days = 29
        else
            days = 28
        endif
    else if (inputMonth == 4 .or. inputMonth == 6 .or. inputMonth == 9 .or. inputMonth == 11) then
        days = 30
    else
        days = 31
    end if
end function numberOfDaysInMonth
