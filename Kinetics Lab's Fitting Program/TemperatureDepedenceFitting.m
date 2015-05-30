clc;
clear;
R = 8.3144621;
data = load('TvsK.txt') ; 

opts = statset('MaxIter',600000);

data(:,2) = data(:,2)*1e12;

initArrhenius(1) = 1.0;
initArrhenius(2) = -10000.0; 

arrhenius = @(params, T) params(1) * exp(-params(2) ./ (R*T)); 
[arrheniusParameters, Res, Jac, Cov, MSE] = nlinfit(data(:,1), data(:,2), arrhenius, initArrhenius, opts); 

arrheniusParamsErr = sqrt(diag(Cov)); 

arrheniusParameters(1) = arrheniusParameters(1)./(1e12);
arrheniusParamsErr(1) = arrheniusParamsErr(1)./(1e12);

display('Arrhenius Parameters and Errors') 

A = arrheniusParameters(1)
Ea = arrheniusParameters(2) 
dA = arrheniusParamsErr(1)
dEa = arrheniusParamsErr(2)

initLog(1) = 1.0; 
initLog(2) = -1.5;

logFit = @(params, T) params(1) * (T./300).^(params(2)); 
[logFitParameters, Res, Jac, Cov, MSE] = nlinfit(data(:,1), data(:,2), logFit, initLog, opts);

logFitParamsErr = sqrt(diag(Cov)); 

logFitParameters(1) = logFitParameters(1)./(1e12);
logFitParamsErr(1) = logFitParamsErr(1)./(1e12);

display('LogFit Parameters and Errors') 

k300 = logFitParameters(1)
n = logFitParameters(2) 
dk300 = logFitParamsErr(1)
dn = logFitParamsErr(2)


initmArrhenius(1) = 1.0;
initmArrhenius(2) = -6.0;
initmArrhenius(3) = 7000;

marrhenius = @(params, T) params(1) * (T./300).^(params(2)) .* exp(-params(3) ./ (R*T)); 
[marrheniusParameters, Res, Jac, Cov, MSE] = nlinfit(data(:,1), data(:,2), marrhenius, initmArrhenius, opts);

marrheniusParamsErr = sqrt(diag(Cov)); 

marrheniusParameters(1) = marrheniusParameters(1)./(1e12);
marrheniusParamsErr(1) = marrheniusParamsErr(1)./(1e12);

display('Modified Arrhenius Parameters and Errors') 

A = marrheniusParameters(1)
n = marrheniusParameters(2)
Ea = marrheniusParameters(3)  
dA = marrheniusParamsErr(1)
dn = marrheniusParamsErr(2)
dEa = marrheniusParamsErr(3)

data(:,2) = data(:,2)*1e-12;
x = 260 : 1 : 370 ; 
y1 = arrhenius(arrheniusParameters, x); 
y2 = logFit(logFitParameters, x); 
y3 = marrhenius(marrheniusParameters, x);

plot(data(:,1), data(:,2), 'd');
hold on; 
plot(x,y1, 'r') 
plot(x,y2, 'k') 
plot(x,y3, 'm') 

hold off; 
