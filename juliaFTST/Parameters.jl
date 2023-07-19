module Parameters
export a0, amu, c, h, kB, Na, masses

#Physical constants in SI units. Values as given by NIST
const a0 = 5.29177210903e-11
const amu = 1.66053906660e-27
const c = 299792458.0
const h = 6.62607015e-34
const kB = 1.380649e-23
const Na = 6.02214076e23

#Masses of most common isotope in amus. 
#reference page http://pntpm.ulb.ac.be/private/divers.htm
#Copied from MESMER's unitsConversion.cpp file. 
const masses = Dict(
    "H" => 1.007825032,
    "D" => 2.014101778,
    "T" => 3.016049268,
    "C" => 12.000000000,
    "13C" => 13.003354838,
    "14C" => 14.003241991,
    "13N" => 13.005738584,
    "N" => 14.003074007,
    "15O" => 15.003065460,
    "O" => 15.994914620,
    "17O" => 16.999131501,
    "F" => 18.998403220,
    "S" => 31.972071000,
    "Cl" => 34.968852680,
    "B" => 10.81,
    "Na" => 22.990,
    "Mg" => 24.305,
    "Al" => 26.982,
    "Si" => 28.085,
    "P" => 30.974,
    "K" => 39.098,
    "Ca" => 40.078,
    "Sc" => 44.956,
    "Ti" => 47.867,
    "V" => 50.942,
    "Cr" => 51.996,
    "Mn" => 54.938,
    "Fe" => 55.845,
    "Co" => 58.933,
    "Ni" => 58.693,
    "Cu" => 63.546,
    "Zn" => 65.38,
    "Ga" => 69.723,
    "Ge" => 72.63,
    "As" => 74.922,
    "Se" => 78.96,
    "Br" => 79.904,
    "Rb" => 85.468,
    "Sr" => 87.62,
    "Y" => 88.906,
    "Zr" => 91.224,
    "Nb" => 92.906,
    "Mo" => 95.96,
    "Tc" => 97.91,
    "Ru" => 101.07,
    "Rh" => 102.91,
    "Pd" => 106.43,
    "Ag" => 107.87,
    "Cd" => 112.41,
    "Ln" => 114.82,
    "Sn" => 118.71,
    "Sb" => 121.76,
    "Te" => 127.60,
    "I" => 126.9)

end
