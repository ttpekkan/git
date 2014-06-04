display('sample') 

%%%%%%%%%%%%%%%    Input Variables    %%%%%%%%%%%%%%%%%%%%%%%%%% 

A = 2.709           %What the device gives you. Dont subtract background. 
reactantC =   5.257642e13 %Use fitting program to calculate
reactantCerr = 2.044811e12
p = 30.55      %Torr 
T = 298.15           %T2, K 
kw = 3.3
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

A = A - 0.5                     %background subtraction
sigma = 1.146e-17;              %From Hitran. Absorption coefficient
l = 14.5;                       %Cuvette length 

ozoneC = A*log(10)/(sigma*l);   
ozoneCerr = 0.05*log(10)/(sigma*l);

R = 8.3144621; 
N = 6.02214129e23; 
Troom = 300.0; 
p = p*133.322368;               %Convert to SI units 

totalC = p/(R*Troom)*N*1.0e-6;
totalCerr = totalC/Troom * 2;    %delta T = 2 K 


%%%%% Calculate these by hand for each new sample of ozone %%%%%%

xO3I = 0.036428017;          %These are the I = initial mole fractions. 
dxO3I = 7.536233727e-4;

xO2I = 0.018788268;
dxO2I = 7.536233727e-4; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



xO3 = ozoneC/totalC 
dxO3 = (1/totalC).^2 * (ozoneCerr).^2 + ... 
       (-xO3/totalC).^2 * (totalCerr).^2; 
dxO3 = sqrt(dxO3) 

xO2 = xO2I + 1.5*(xO3I - xO3)  
dxO2 = (dxO2I).^2 + ... 
       (3/2).^2 * (dxO3I).^2 + ... 
       (-3/2).^2 * (dxO3).^2 ; 
dxO2 = sqrt(dxO2) 

display('reactor') 

cO2 = xO2*reactantC
dcO2 = (1/reactantC).^2 * (dxO2).^2 + ... 
       (-cO2/reactantC).^2 * (reactantCerr).^2; 
dcO2 = sqrt(dcO2)

cO3 = xO3*reactantC
dcO3 = (1/reactantC).^2 * (dxO3).^2 + ... 
       (-cO3/reactantC).^2 * (reactantCerr).^2; 
dcO3 = sqrt(dcO3)


display('C2H3') 

measuredRate = 25.5;
oxygenRate = 8.16e-12; 
ozoneRate = (measuredRate - oxygenRate*cO2 - kw)/(cO3) 

display('Other C2H3') 

measuredRate = 45.43224;
wallRate = 4.3; 
oxygenRate = 8.16e-12; 
ozoneRate = (measuredRate - oxygenRate*oxygenConcentration - wallRate)/(ozoneConcentration) 


display('CH3') 

measuredRate = 37;
wallRate = 0.0; 
oxygenRate = 6.31363701e-14; 
ozoneRate = (measuredRate - oxygenRate*oxygenConcentration - wallRate)/(ozoneConcentration) 


    