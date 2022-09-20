module parameters
    implicit none
    integer, parameter :: iprec = selected_int_kind(8)
    integer, parameter :: dp = selected_real_kind(10, 10)


    ! Physical constants
    real(kind = dp), parameter :: h = 6.62607015e-34_dp !Planck
    real(kind = dp), parameter :: Na = 6.02214076e23_dp !Avogadro
    real(kind = dp), parameter :: pi = 4.0_dp*atan(1.0_dp)
    real(kind = dp), parameter :: kb = 1.3806503e-23_dp !Boltzmann
    real(kind = dp), parameter :: a0 = 5.29177210903e-11_dp !Oxygen atom mass

    ! Molecule-related constants
    real(kind = dp), parameter :: mO = 15.99491461956_dp*1.6605390666050e-27_dp !Oxygen atom mass
    real(kind = dp), parameter :: mH = 1.007825031898_dp*1.6605390666050e-27_dp !Hydrogen atom mass
    real(kind = dp), parameter :: rDiatom =  1.2075e-10_dp !Experimental O2 bond length (NIST)
    real(kind = dp), parameter :: muDiatom = mO/2 !O2 reduced mass
    real(kind = dp), parameter :: Idiatom = muDiatom*rDiatom**2 !O2 moment of inertia
    real(kind = dp), parameter :: muRed = 2*mO*mH/(2*mO+mH) !Reduced mass of the associating pair
    real(kind = dp), parameter :: nuharm = 4.736720836e13_dp !Harmonic frequency of O2 (NIST)

    real(kind = dp), parameter :: FRtheta = 1.0_dp/(2.0_dp-2.0_dp**(1.0_dp/3)) !Parameter for the Forest-Ruth algorhitm

end module parameters

