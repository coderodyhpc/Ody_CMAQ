
!------------------------------------------------------------------------!
!  The Community Multiscale Air Quality (CMAQ) system software is in     !
!  continuous development by various groups and is based on information  !
!  from these groups: Federal Government employees, contractors working  !
!  within a United States Government contract, and non-Federal sources   !
!  including research institutions.  These groups give the Government    !
!  permission to use, prepare derivative works of, and distribute copies !
!  of their work in the CMAQ system to the public and to permit others   !
!  to do so.  The United States Environmental Protection Agency          !
!  therefore grants similar permission to use the CMAQ system software,  !
!  but users are requested to provide copies of derivative works or      !
!  products designed to operate in the CMAQ system to the United States  !
!  Government without restrictions as to use by others.  Software        !
!  that is used with the CMAQ system but distributed under the GNU       !
!  General Public License or the GNU Lesser General Public License is    !
!  subject to their copyright restrictions.                              !
!------------------------------------------------------------------------!

!------------------------------------------------------------------------!
! This module contains utility functions to support centralized I/O 
! implementation

! Revision History:
!  02/01/19, D. Wong: initial implementation
!  08/01/19, D. Wong: modified code to work with two-way model
!  11/20/19, F. Sidi: Modified time to sec to handle negative numbers
!  03/05/20, D. Wong: Expanded CIO functionalities to MPAS as well
!  07/07/20, D. Wong: Formulated a robust routine to compute JDATE1 - JDATE2
!                     and JDATE + NDAYS
!------------------------------------------------------------------------!

      module centralized_io_util_module

        implicit none

        private :: leap_year

        interface quicksort
          module procedure quicksort1d,
     &                     quicksort2d
        end interface

        contains

! -----------------------------------------------------------
        logical function leap_year (year)

          integer :: year

          if (mod(year, 4) .ne. 0) then
             leap_year = .false.
          else if (mod(year, 400) .eq. 0) then
             leap_year = .true.
          else if (mod(year, 100) .eq. 0) then
             leap_year = .false.
          else
             leap_year = .true.
          endif

        end function leap_year

! -------------------------------------------------------------------------
        recursive subroutine quicksort1d (name, begin, end)

          character (*), intent(out) :: name(:)
          integer, intent(in)         :: begin, end

          integer        :: i, j
          character (50) :: str1, str2
          logical        :: done

          str1 = name( (begin + end) / 2 )
          i = begin
          j = end
          done = .false.
          do while (.not. done)
             do while (name(i) < str1)
                i = i + 1
             end do
             do while (str1 < name(j))
                j = j - 1
             end do
             if (i .ge. j) then
                done = .true.
             else
                str2 = name(i)  
                name(i) = name(j)
                name(j) = str2
                i = i + 1
                j = j - 1
             end if
          end do
          if (begin < i-1) call quicksort(name, begin, i-1)
          if (j+1 < end)   call quicksort(name, j+1, end)

        end subroutine quicksort1d

! -------------------------------------------------------------------------
        recursive subroutine quicksort2d (name, begin, end)

          character (*), intent(out) :: name(:,:)
          integer, intent(in)         :: begin, end

          integer        :: i, j, dsize
          character (50) :: str1, str2(3)
          logical        :: done

          dsize = size(name,2)
          str1 = name( (begin + end) / 2, 1 )
          i = begin
          j = end
          done = .false.
          do while (.not. done)
             do while (name(i,1) < str1)
                i = i + 1
             end do
             do while (str1 < name(j, 1))
                j = j - 1
             end do
             if (i .ge. j) then
                done = .true.
             else
                str2(1:dsize) = name(i,:)  
                name(i,:) = name(j,:)
                name(j,:) = str2(1:dsize)
                i = i + 1
                j = j - 1
             end if
          end do
          if (begin < i-1) call quicksort(name, begin, i-1)
          if (j+1 < end)   call quicksort(name, j+1, end)

        end subroutine quicksort2d

! -------------------------------------------------------------------------
        function binary_search (name, list, n) result (loc)

          character (*), intent(in) :: name, list(:)
          integer, intent(in)        :: n
          integer :: loc

          logical :: found
          integer :: mid_loc, start_loc, end_loc

          start_loc = 1
          end_loc   = n
          found = .false.
          do while ((start_loc .le. end_loc) .and. (.not. found))
             mid_loc = start_loc + (end_loc - start_loc) / 2
             if (name .lt. list(mid_loc)) then
                end_loc = mid_loc - 1
             else if (name .gt. list(mid_loc)) then
                start_loc = mid_loc + 1
             else
                found = .true.
             end if
          end do

          if (found) then
             loc = mid_loc
          else
             loc = -1
          end if

        end function binary_search

! -------------------------------------------------------------------------
        function search (name, list, n) result (loc)

          character (*), intent(in) :: name, list(:)
          integer, intent(in)        :: n
          integer :: loc

          logical :: found
          integer :: lloc

          lloc = 0
          found = .false.
          do while ((lloc .le. n) .and. (.not. found))
             lloc = lloc + 1
             if (name .eq. list(lloc)) then
                found = .true.
             end if
          end do

          if (found) then
             loc = lloc
          else
             loc = -1
          end if

        end function search

! -------------------------------------------------------------------------
        integer function time_to_sec (time)

          integer, intent(in) :: time
          integer :: neg_time
          integer :: time_in_sec, hr, min, sec

          if (time .gt. 0) then
             hr = time / 10000
             min = mod(time/100, 100)
             sec = mod(time, 100)
             time_to_sec = hr * 3600 + min * 60 + sec
          else
             neg_time = abs(time)
             hr = neg_time / 10000
             min = mod(neg_time/100, 100)
             sec = mod(neg_time, 100)
             time_to_sec = -1*(hr * 3600 + min * 60 + sec)
          end if
          
        end function time_to_sec

! -------------------------------------------------------------------------
        integer function time_diff (time1, time2)

          integer, intent(in) :: time1, time2

          time_diff = time_to_sec(time1) - time_to_sec(time2)

        end function time_diff

!--------------------------------------------------------------------------
        integer function next_day (jday)

! This function determermins the next day for time interpolation 
          implicit none
          
          integer, intent(in) :: jday 
          integer year, day

          day  = MOD(jday,1000)
          year = INT(jday/1000)

          If( day .LT. 365 ) Then
             next_day = jday+1
          Else
             If( MOD(year,4) .Eq. 0 .And. MOD(year,100) .Ne. 0 ) Then
! Leap Year        
                If( day .Eq. 365 ) Then
                   next_day = jday + 1
                Else
                   next_day = (INT(jday/1000)+1)*1000+1
                End If
             Else If(MOD(year,400) .Eq. 0 ) Then
! also a leap year, e.g. 2000 but not 2100
                If( day .Eq. 365 ) Then
                   next_day = jday + 1
                Else
                   next_day = (INT(jday/1000)+1)*1000+1
                End If
             Else
! not a leap year
                next_day = (INT(jday/1000)+1)*1000+1
             End If
          End If

        end function next_day

! -------------------------------------------------------------------------
        integer function cal_date (date1, date2, operator)

          integer, intent(in)   :: date1, date2
          character, intent(in) :: operator

          integer :: ldate1, ldate2, yr1, yr2, day1, day2, dsum, y,
     &               adj, adj_yr, remainder, ndays
          logical :: done

          if (operator == '-') then
             if (date1 <= date2) then
                ldate1 = date1
                ldate2 = date2
                adj    = -1
             else
                ldate1 = date2
                ldate2 = date1
                adj    = 1
             end if

             yr1  = ldate1 / 1000
             yr2  = ldate2 / 1000
             day1 = mod(ldate1, 1000)
             day2 = mod(ldate2, 1000)

             dsum = 0
             do y = yr1, yr2
                if (leap_year(y)) then
                   dsum = dsum + 366
                else
                   dsum = dsum + 365
                end if
             end do

             dsum = dsum - day1
             if (leap_year(yr2)) then
                dsum = dsum - 366 + day2
             else
                dsum = dsum - 365 + day2
             end if
           
             cal_date = dsum * adj

          else if (operator == '+') then

             yr1  = date1 / 1000
             day1 = mod(date1, 1000)
             if (date2 < 0) then
                adj_yr = -1
                adj    =  1
             else
                adj_yr =  1
                adj    = -1
             end if

             day1 = day1 + date2
             done = .false.
             do while (.not. done)
                if (leap_year(yr1)) then
                   ndays = 366
                else
                   ndays = 365
                end if
                if ((day1 > 0) .and. (day1 <= ndays)) then
                   done = .true.
                else
                   yr1 = yr1 + adj_yr
                   day1 = day1 + ndays * adj
                end if
             end do

             if ((date2 < 0) .and. (leap_year(yr1))) then
                cal_date = yr1 * 1000 + day1 + 1
             else
                cal_date = yr1 * 1000 + day1
             end if

          else
             call m3exit ( 'cal_date', 0, 0, ' Abort: Invalid operator', 2)
          end if

        end function cal_date

      end module centralized_io_util_module
