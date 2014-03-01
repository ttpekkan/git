module png_snapshot_module
  use ISO_C_BINDING
  use ISO_FORTRAN_ENV
  implicit none
  private
  public :: png_snapshot
  interface
     subroutine png_snapshot_interop(matrix, maxValue, shapeOfArray, fname, px_size) bind(c, name = 'png_snapshot_interop') 
       ! TODO: define the interface
	use, intrinsic :: iso_c_binding
	real(kind = c_double) :: matrix(*)
	real(kind = c_double), value :: maxValue
	integer(kind = c_int) :: shapeOfArray(0:1)
	integer(kind = c_int), value :: px_size
	character(kind = c_char) :: fname(*)
     end subroutine png_snapshot_interop
  end interface
  
  interface png_snapshot
     module procedure dpng_snapshot
     module procedure spng_snapshot
  end interface png_snapshot
  
contains
  ! spng ei ilmeisesti tee mitään, koska syötetty matriisi on tyyppiä real64. Jos se olisi real32, niin silloin se muutettaisiin muotoon real64,
  ! jonkä jälkeen se syötetään dpng-rutiiniin. dpng-rutiinin avulla yksinkertaisesti syötetään mainissa muodostetu matriisi (+ muutama muu muuttuja
  ! c-funktioon, jossa kuva varsinaisesti muodostetaan. Leikitään myös vähän merkkijonojen kanssa, jotta Fortran merkkijonoa voidaan käyttää 
  ! c-funktiossa. 
  subroutine dpng_snapshot(matrix, fname)
    real(REAL64), intent(in) :: matrix(:,:)
    character(*), intent(in) :: fname
    character(len=1, kind=C_CHAR) :: fname_interop(len(fname)+1)
    integer :: i
    
    ! Enforce interoperability of strings with C
    forall (i=1:len(fname)) fname_interop(i:i) = fname(i:i)
    fname_interop(len(fname)+1) = c_null_char
    
    call png_snapshot_interop(matrix,&
         maxval(matrix),&
         shape(matrix),&
         fname_interop,&
         1)
  end subroutine dpng_snapshot

  subroutine spng_snapshot(matrix, fname)
    real(REAL32), intent(in) :: matrix(:,:)
    character(*), intent(in) :: fname 
    call dpng_snapshot(real(matrix, kind=REAL64), fname)
  end subroutine spng_snapshot
end module png_snapshot_module
