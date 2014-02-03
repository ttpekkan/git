program GameOfLife
! 2D cellular automaton ("Game of Life")
  use gol_io
  implicit none
  integer, parameter :: &
      freq = 1           ! after how many iterations we print the board
  integer, dimension(:,:), allocatable :: &
      board_1, board_2     ! boards
  integer :: &
      height, width, &     ! board dimensions
      iter, i, &
      t0, t1, cnt, cnt_max

  ! read in the initial configuration
  call read_data(iter, height, width)
  ! initialize boards
  call init_board(board_1, board_2, height, width)
  ! develop the automaton
  call system_clock(t0,cnt,cnt_max)
  do i = 1, iter
    call iterate(board_1, board_2)
    if (mod(i,freq)==0) call draw(board_1, i)
  end do
  call system_clock(t1,cnt,cnt_max)
  write(*,'(A,I4,A,F6.2,A)') 'Completed ', iter, ' iterations in ', &
       real(t1-t0)/real(cnt), ' seconds.'

contains

  subroutine init_board(board_1, board_2, height, width)
    integer, dimension(:,:), allocatable :: board_1, board_2
    integer, intent(in) :: height, width

    allocate(board_1(0:height+1,0:width+1))
    allocate(board_2(0:height+1,0:width+1))
    ! start from a plus-sign shaped pattern
    board_1(:,:) = 0
    board_2(:,:) = 0
    board_1(height/2,:) = 1
    board_1(:,width/2) = 1
    call draw(board_1, 0)
  end subroutine init_board

  subroutine iterate(board_1, board_2)
    integer, parameter :: ALIVE = 1, DEAD = 0
    integer, dimension(:,:) :: board_1, board_2
    integer, dimension(size(board_1,1),size(board_2,2)) :: temp_board
    integer :: hl, hu, wl, wu
    integer :: i, j, nsum

    hl = lbound(board_1,1)
    hu = ubound(board_1,1)
    wl = lbound(board_1,2)
    wu = ubound(board_1,2)

    ! Copy border areas into extra spaces reserved for "ghost" layers
    ! This will make the computation periodic
    board_1(:,wl) = board_1(:,wu-1)
    board_1(:,wu) = board_1(:,wl+1)
    board_1(hl,:) = board_1(hu-1,:)
    board_1(hu,:) = board_1(hl+1,:)

    do j = wl+1, wu-1
      do i = hl+1, hu-1
! determine the number of alive neighbor cells
        nsum = board_1(i-1,j-1) + board_1(i,j-1) + board_1(i+1,j-1) + &
            board_1(i-1,j) + board_1(i+1,j) + &
            board_1(i-1,j+1) + board_1(i,j+1) + board_1(i+1,j+1)
! set the status of a cell in the next iteration
        if(nsum < 2 .or. nsum > 3) then
          board_2(i,j) = DEAD
        else if (nsum .eq. 3) then
          board_2(i,j) = ALIVE
        else
          board_2(i,j) = board_1(i,j)
        end if
      end do
    end do

! swap the contents of board_1 and board_2
    temp_board = board_1
    board_1 = board_2
    board_2 = temp_board
  end subroutine iterate

end program GameOfLife
