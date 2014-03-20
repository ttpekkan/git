%Author: Timo Pekkanen 
%Feel free to do anything you want with this program, although there really is only one thing one can do with it. 

function fittingGUI 
   
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Preliminary actions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   %This simply creates the figure, onto which everything will  be placed. 
 
   clear; 
   set(0,'Units','Normalized');  
   ScreenResolution = get(0, 'Screensize'); 
   
   %f is the "foundation" for the GUI 
  
   f = figure; 
   set(f, 'NumberTitle', 'off'); 
   set(f, 'Name', 'Raimo''s Magical Fitting Program'); 
   set(f, 'Units', 'Normalized'); 
   set(f, 'Menubar', 'none');
   set(f, 'Position', [0, 0, ScreenResolution(3)/1.1,ScreenResolution(4)/1.2]);  
   set(f, 'PaperOrientation', 'landscape'); 
   set(f, 'InvertHardCopy', 'off');
   set(f, 'PaperPositionMode', 'auto');
   set(f, 'PaperUnits', 'centimeters'); 
   set(f, 'PaperSize', [27.7, 19.5]) 
   set(f, 'Paperposition', [0, 0, 27.7, 19.5]); 
   movegui(f, 'center');  
   
   background = axes('Parent', f); 
   set(background, 'Units', 'Normalized', 'FontUnits', 'Normalized');
   set(background, 'Position', [0, 0, 1, 1]); 
   bg = imread('background.png'); 
   imagesc(bg); 
   set(background, 'HandleVisibility', 'off', 'visible', 'off'); 
   uistack(background, 'bottom'); 
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% This Section Creates the Text/Edit Components %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
   functionString = uicontrol('Parent', f); 
   createText(functionString, 'text', [0.653, 0.88, 0.13, 0.03], 0.7, 'A + B*exp(-k*t)'); 
   
   initialCoefficientsString = uicontrol('Parent', f); 
   createText(initialCoefficientsString, 'text', [0.653, 0.845, 0.13, 0.03], 0.7, 'Initial Guess');  
   
   k0 = uicontrol('Parent', f); 
   createText(k0, 'text', [0.653, 0.81, 0.03, 0.03], 0.7, 'k0');   
   
   A0 = uicontrol('Parent', f); 
   createText(A0, 'text', [0.653, 0.78, 0.03, 0.03], 0.7, 'A0');  
   
   B0 = uicontrol('Parent', f); 
   createText(B0, 'text', [0.653, 0.75, 0.03, 0.03], 0.7, 'B0');  
   
   outputCoefficientsString = uicontrol('Parent', f); 
   createText(outputCoefficientsString, 'text', [0.653, 0.715, 0.13, 0.03], 0.8, 'Output');
   
   park = uicontrol('Parent', f); 
   createText(park, 'text', [0.653, 0.665, 0.03, 0.05], 0.7, 'k');   
   
   pardk = uicontrol('Parent', f); 
   createText(pardk, 'text', [0.653, 0.62, 0.03, 0.05], 0.6, 'dk');  
   
   parA = uicontrol('Parent', f); 
   createText(parA, 'text', [0.653, 0.60, 0.03, 0.03], 0.7, 'A');  
   
   pardA = uicontrol('Parent', f); 
   createText(pardA, 'text', [0.653, 0.57, 0.03, 0.03], 0.7, 'dA');   
   
   parB = uicontrol('Parent', f); 
   createText(parB, 'text', [0.653, 0.54, 0.03, 0.03], 0.7, 'B');  
   
   pardB = uicontrol('Parent', f); 
   createText(pardB, 'text', [0.653, 0.51, 0.03, 0.03], 0.7, 'dB'); 
   
   editk0 = uicontrol('Parent', f); 
   createText(editk0, 'edit', [0.685, 0.81, 0.1, 0.03], 0.7, '50.0');   
   
   editA0 = uicontrol('Parent', f); 
   createText(editA0, 'edit', [0.685, 0.78, 0.1, 0.03], 0.7, '15.0'); 
   
   editB0 = uicontrol('Parent', f); 
   createText(editB0, 'edit', [0.685, 0.75, 0.1, 0.03], 0.7, '120.0');
   
   editk = uicontrol('Parent', f); 
   createText(editk, 'text', [0.685, 0.663, 0.098, 0.05], 0.4, '1.0');   
   
   editdk = uicontrol('Parent', f); 
   createText(editdk, 'text', [0.685, 0.62, 0.098, 0.05], 0.4, '1.0'); 
   
   editA = uicontrol('Parent', f); 
   createText(editA, 'text', [0.685, 0.60, 0.098, 0.03], 0.65, '1.0'); 
   
   editdA = uicontrol('Parent', f); 
   createText(editdA, 'text', [0.685, 0.57, 0.098, 0.03], 0.65, '1.0'); 
   
   editB = uicontrol('Parent', f); 
   createText(editB, 'text', [0.685, 0.54, 0.098, 0.03], 0.65, '1.0'); 
   
   editdB = uicontrol('Parent', f); 
   createText(editdB, 'text', [0.685, 0.51, 0.098, 0.03], 0.65, '1.0'); 
   
   
   getPath = uicontrol('Parent', f); 
   createText(getPath, 'edit', [0.02, 0.91, 0.20, 0.03], 0.45, '/home/timo/');   
   
   
   xMin = uicontrol('Parent', f); 
   createText(xMin, 'text', [0.05, 0.24, 0.03, 0.025], 0.6, 'xMin');   
   
   xMax = uicontrol('Parent', f); 
   createText(xMax, 'text', [0.05, 0.21, 0.03, 0.025], 0.59, 'xMax');  
   
   yMin = uicontrol('Parent', f); 
   createText(yMin, 'text', [0.05, 0.18, 0.03, 0.025], 0.6, 'yMin');  
   
   yMax = uicontrol('Parent', f); 
   createText(yMax, 'text', [0.05, 0.15, 0.03, 0.025], 0.6, 'yMax');
   
   editxMin = uicontrol('Parent', f); 
   createText(editxMin, 'edit', [0.085, 0.24, 0.1, 0.025], 0.7, '1.0');   
   
   editxMax = uicontrol('Parent', f); 
   createText(editxMax, 'edit', [0.085, 0.21, 0.1, 0.025], 0.7, '1.0'); 
   
   edityMin = uicontrol('Parent', f); 
   createText(edityMin, 'edit', [0.085, 0.18, 0.1, 0.025], 0.7, '1.0'); 
   
   edityMax = uicontrol('Parent', f); 
   createText(edityMax, 'edit', [0.085, 0.15, 0.1, 0.025], 0.7, '1.0'); 
   
   
   Troom = uicontrol('Parent', f); 
   createText(Troom, 'text', [0.787, 0.95, 0.07, 0.035], 0.45, 'T(K) [room]'); 
   
   Proom = uicontrol('Parent', f); 
   createText(Proom, 'text', [0.787, 0.91, 0.07, 0.035], 0.45, 'P(Torr) [room]'); 
   
   FVol = uicontrol('Parent', f); 
   createText(FVol, 'text', [0.787, 0.87, 0.07, 0.035], 0.45, 'F-Volume (cm3)');
   
   time = uicontrol('Parent', f); 
   createText(time, 'text', [0.787, 0.83, 0.07, 0.035], 0.45, 'Time(s)');
   
   pinhole = uicontrol('Parent', f); 
   createText(pinhole, 'text', [0.787, 0.79, 0.07, 0.035], 0.45, 'Pinhole corr.');
   
   p1 = uicontrol('Parent', f); 
   createText(p1, 'text', [0.787, 0.75, 0.07, 0.035], 0.45, 'P1(torr)');
   
   T2 = uicontrol('Parent', f); 
   createText(T2, 'text', [0.787, 0.71, 0.07, 0.035], 0.45, 'T2(K)');
   
   L1 = uicontrol('Parent', f); 
   createText(L1, 'text', [0.787, 0.67, 0.07, 0.035], 0.45, 'L1(cm)');
   
   L2 = uicontrol('Parent', f); 
   createText(L2, 'text', [0.787, 0.63, 0.07, 0.035], 0.45, 'L2(cm)');
   
   reacDia = uicontrol('Parent', f); 
   createText(reacDia, 'text', [0.787, 0.59, 0.07, 0.035], 0.45, 'Reactor i.d.(cm)');
   
   MVol = uicontrol('Parent', f); 
   createText(MVol, 'text', [0.787, 0.55, 0.07, 0.035], 0.45, 'M-volume (cm3)');
   
   reacDil = uicontrol('Parent', f); 
   createText(reacDil, 'text', [0.787, 0.51, 0.07, 0.035], 0.45, 'Reac. Diluted to(%)');
   
   dP = uicontrol('Parent', f); 
   createText(dP, 'text', [0.787, 0.47, 0.07, 0.035], 0.45, 'dP(torr)');
   
   dt = uicontrol('Parent', f); 
   createText(dt, 'text', [0.787, 0.43, 0.07, 0.035], 0.45, 'dt(s)');
   
   editTroom = uicontrol('Parent', f); 
   createText(editTroom, 'edit', [0.86, 0.95, 0.06, 0.035], 0.5, '298.15'); 
   
   editProom = uicontrol('Parent', f); 
   createText(editProom, 'edit', [0.86, 0.91, 0.06, 0.035], 0.5, '760.0'); 
   
   editFVol = uicontrol('Parent', f); 
   createText(editFVol, 'edit', [0.86, 0.87, 0.06, 0.035], 0.5, '40.0'); 
   
   editTime = uicontrol('Parent', f); 
   createText(editTime, 'edit', [0.86, 0.83, 0.06, 0.035], 0.5, '12.95'); 
   
   editPinhole = uicontrol('Parent', f); 
   createText(editPinhole, 'edit', [0.86, 0.79, 0.06, 0.035], 0.5, '0.020'); 
   
   editp1 = uicontrol('Parent', f); 
   createText(editp1, 'edit', [0.86, 0.75, 0.06, 0.035], 0.5, '2.280'); 
   
   editT2 = uicontrol('Parent', f); 
   createText(editT2, 'edit', [0.86, 0.71, 0.06, 0.035], 0.5, '298.15'); 
   
   editL1 = uicontrol('Parent', f); 
   createText(editL1, 'edit', [0.86, 0.67, 0.06, 0.035], 0.5, '28.00');
   
   editL2 = uicontrol('Parent', f); 
   createText(editL2, 'edit', [0.86, 0.63, 0.06, 0.035], 0.5, '20.00'); 
   
   editReacDia = uicontrol('Parent', f); 
   createText(editReacDia, 'edit', [0.86, 0.59, 0.06, 0.035], 0.5, '1.70'); 
   
   editMVol = uicontrol('Parent', f); 
   createText(editMVol, 'edit', [0.86, 0.55, 0.06, 0.035], 0.5, '56.1');
   
   editReacDil = uicontrol('Parent', f); 
   createText(editReacDil, 'edit', [0.86, 0.51, 0.06, 0.035], 0.5, '16.98');
   
   editdP = uicontrol('Parent', f); 
   createText(editdP, 'edit', [0.86, 0.47, 0.06, 0.035], 0.5, '0.090');
   
   editdt = uicontrol('Parent', f); 
   createText(editdt, 'edit', [0.86, 0.43, 0.06, 0.035], 0.5, '13.10');
   
   errTroom = uicontrol('Parent', f); 
   createText(errTroom, 'edit', [0.925, 0.95, 0.06, 0.035], 0.5, '2'); 
   
   errProom = uicontrol('Parent', f); 
   createText(errProom, 'edit', [0.925, 0.91, 0.06, 0.035], 0.5, '5'); 
   
   errFVol = uicontrol('Parent', f); 
   createText(errFVol, 'edit', [0.925, 0.87, 0.06, 0.035], 0.5, '0'); 
   
   errTime = uicontrol('Parent', f); 
   createText(errTime, 'edit', [0.925, 0.83, 0.06, 0.035], 0.5, '0.1'); 
   
   errPinhole = uicontrol('Parent', f); 
   createText(errPinhole, 'edit', [0.925, 0.79, 0.06, 0.035], 0.5, '0.001'); 
   
   errp1 = uicontrol('Parent', f); 
   createText(errp1, 'edit', [0.925, 0.75, 0.06, 0.035], 0.5, '0'); 
   
   errT2 = uicontrol('Parent', f); 
   createText(errT2, 'edit', [0.925, 0.71, 0.06, 0.035], 0.5, '2'); 
   
   errL1 = uicontrol('Parent', f); 
   createText(errL1, 'edit', [0.925, 0.67, 0.06, 0.035], 0.5, '0');
   
   errL2 = uicontrol('Parent', f); 
   createText(errL2, 'edit', [0.925, 0.63, 0.06, 0.035], 0.5, '0'); 
   
   errReacDia = uicontrol('Parent', f); 
   createText(errReacDia, 'edit', [0.925, 0.59, 0.06, 0.035], 0.5, '0'); 
   
   errMVol = uicontrol('Parent', f); 
   createText(errMVol, 'edit', [0.925, 0.55, 0.06, 0.035], 0.5, '0');
   
   errReacDil = uicontrol('Parent', f); 
   createText(errReacDil, 'edit', [0.925, 0.51, 0.06, 0.035], 0.5, '0.849');
   
   errdP = uicontrol('Parent', f); 
   createText(errdP, 'edit', [0.925, 0.47, 0.06, 0.035], 0.5, '0');
   
   errdt = uicontrol('Parent', f); 
   createText(errdt, 'edit', [0.925, 0.43, 0.06, 0.035], 0.5, '0.2');
   
   
   SourceTrig = uicontrol('Parent', f); 
   createText(SourceTrig, 'text', [0.36, 0.96, 0.05, 0.035], 0.35, 'Source Of Triggering'); 
   
   DwellUnits = uicontrol('Parent', f); 
   createText(DwellUnits, 'text', [0.415, 0.96, 0.05, 0.035], 0.4, 'Dwell Units');
   
   Acq = uicontrol('Parent', f); 
   createText(Acq, 'text', [0.47, 0.96, 0.05, 0.035], 0.4, 'Acq. Mode');
   
   PassLength = uicontrol('Parent', f); 
   createText(PassLength, 'text', [0.525, 0.96, 0.05, 0.035], 0.4, 'Pass Length');
   
   PassCount = uicontrol('Parent', f); 
   createText(PassCount, 'text', [0.58, 0.96, 0.05, 0.035], 0.4, 'Pass Count');
   
   PassCountPre = uicontrol('Parent', f); 
   createText(PassCountPre, 'text', [0.635, 0.96, 0.06, 0.035], 0.35, 'Pass Count Preset');
   
   DwellTime = uicontrol('Parent', f); 
   createText(DwellTime, 'text', [0.70, 0.96, 0.05, 0.035], 0.4, 'Dwell Time');
   
   editSourceTrig = uicontrol('Parent', f); 
   createText(editSourceTrig, 'text', [0.36, 0.92, 0.05, 0.035], 0.4, '-'); 
   
   editDwellUnits = uicontrol('Parent', f); 
   createText(editDwellUnits, 'text', [0.415, 0.92, 0.05, 0.035], 0.4, '-');
   
   editAcq = uicontrol('Parent', f); 
   createText(editAcq, 'text', [0.47, 0.92, 0.05, 0.035], 0.4, '-');
   
   editPassLength = uicontrol('Parent', f); 
   createText(editPassLength, 'text', [0.525, 0.92, 0.05, 0.035], 0.4, '-');
   
   editPassCount = uicontrol('Parent', f); 
   createText(editPassCount, 'text', [0.58, 0.92, 0.05, 0.035], 0.4, '-');
   
   editPassCountPre = uicontrol('Parent', f); 
   createText(editPassCountPre, 'text', [0.635, 0.92, 0.06, 0.035], 0.35, '-');
   
   editDwellTime = uicontrol('Parent', f); 
   createText(editDwellTime, 'text', [0.70, 0.92, 0.05, 0.035], 0.4, '-');
   
   
   SignalAve = uicontrol('Parent', f); 
   createText(SignalAve, 'text', [0.27, 0.96, 0.06, 0.035], 0.35, 'Background Average');
   
   editSignalAve = uicontrol('Parent', f); 
   createText(editSignalAve, 'text', [0.27, 0.92, 0.06, 0.035], 0.5, '-');
   
   
   ResParams = uicontrol('Parent', f); 
   createText(ResParams, 'text', [0.2, 0.20, 0.15, 0.03], 0.6, 'Residual Parameters');   
   
   linearFunc = uicontrol('Parent', f); 
   createText(linearFunc, 'text', [0.2, 0.17, 0.15, 0.03], 0.6, 'Ax + B');
   
   theGrad = uicontrol('Parent', f); 
   createText(theGrad, 'text', [0.2, 0.13, 0.03, 0.03], 0.7, 'A');
   
   theConst = uicontrol('Parent', f); 
   createText(theConst, 'text', [0.2, 0.09, 0.03, 0.03], 0.7, 'B');
   
   editTheGrad = uicontrol('Parent', f); 
   createText(editTheGrad, 'text', [0.24, 0.13, 0.11, 0.03], 0.7, '-');
   
   editTheConst = uicontrol('Parent', f); 
   createText(editTheConst, 'text', [0.24, 0.09, 0.11, 0.03], 0.7, '-'); 
   
   
   v1 = uicontrol('Parent', f); 
   createText(v1, 'text', [0.57, 0.19, 0.1, 0.04], 0.6, 'v1(m/s)');
   
   p2 = uicontrol('Parent', f); 
   createText(p2, 'text', [0.57, 0.14, 0.1, 0.04], 0.6, 'p2(Torr)');
   
   v2 = uicontrol('Parent', f); 
   createText(v2, 'text', [0.57, 0.09, 0.1, 0.04], 0.6, 'v2(m/s)');
   
   Nreactant = uicontrol('Parent', f); 
   createText(Nreactant, 'text', [0.57, 0.04, 0.1, 0.04], 0.39, 'Nreactant(#/cm3)');
   
   editv1 = uicontrol('Parent', f); 
   createText(editv1, 'text', [0.68, 0.19, 0.12, 0.04], 0.485, '-');
   
   editp2 = uicontrol('Parent', f); 
   createText(editp2, 'text', [0.68, 0.14, 0.12, 0.04], 0.485, '-');
   
   editv2 = uicontrol('Parent', f); 
   createText(editv2, 'text', [0.68, 0.09, 0.12, 0.04], 0.485, '-');
   
   editNreactant = uicontrol('Parent', f); 
   createText(editNreactant, 'text', [0.68, 0.04, 0.12, 0.04], 0.49, '-');
   
   errv1 = uicontrol('Parent', f); 
   createText(errv1, 'text', [0.82, 0.19, 0.12, 0.04], 0.485, '-');
   
   errp2 = uicontrol('Parent', f); 
   createText(errp2, 'text', [0.82, 0.14, 0.12, 0.04], 0.485, '-');
   
   errv2 = uicontrol('Parent', f); 
   createText(errv2, 'text', [0.82, 0.09, 0.12, 0.04], 0.485, '-');
   
   errNreactant = uicontrol('Parent', f); 
   createText(errNreactant, 'text', [0.82, 0.04, 0.12, 0.04], 0.49, '-');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% This Section Creates the Buttons %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   browseButton = uicontrol('Parent', f); 
   createButton(browseButton, [0.02, 0.95, 0.13, 0.03], 0.6, 'Browse for File'); 
   set(browseButton, 'Callback', @lookForFile); 
   
   SelectFileButton = uicontrol('Parent', f); 
   createButton(SelectFileButton, [0.17, 0.95, 0.05, 0.03], 0.6, 'Select'); 
   set(SelectFileButton, 'Callback', @openFile);
   
   makeFitButton = uicontrol('Parent', f); 
   createButton(makeFitButton, [0.653, 0.47, 0.13, 0.035], 0.6, 'Normal Fit!'); 
   set(makeFitButton, 'Callback', @makeFit); 
   
   makeWallFitButton = uicontrol('Parent', f); 
   createButton(makeWallFitButton, [0.653, 0.425, 0.13, 0.035], 0.6, 'Wall Fit!'); 
   set(makeWallFitButton, 'Callback', @wallFit);
   
   changeLimitsButton = uicontrol('Parent', f); 
   createButton(changeLimitsButton, [0.05, 0.11, 0.13, 0.035], 0.4, 'Change Graph Limits'); 
   set(changeLimitsButton, 'Callback', @changeLimits); 
   
   calculateButton = uicontrol('Parent', f); 
   createButton(calculateButton, [0.81, 0.24, 0.13, 0.05], 0.4, 'Calculate!'); 
   set(calculateButton, 'Callback', @startToCalculate); 
   
   removePointButton = uicontrol('Parent', f); 
   createButton(removePointButton, [0.36, 0.195, 0.13, 0.05], 0.4, 'Remove a Point'); 
   set(removePointButton, 'Callback', @selectPoint); 
   
   writeTextButton = uicontrol('Parent', f); 
   createButton(writeTextButton, [0.36, 0.135, 0.13, 0.05], 0.35, 'Save Data (.txt)'); 
   set(writeTextButton, 'Callback', @saveFile); 
   
   printButton = uicontrol('Parent', f); 
   createButton(printButton, [0.36, 0.075, 0.13, 0.05], 0.35, 'Print GUI (b&w)'); 
   set(printButton, 'Callback', @printGUI); 
   
   SSButton = uicontrol('Parent', f); 
   createButton(SSButton, [0.36, 0.015, 0.13, 0.05], 0.35, 'Take Screenshot'); 
   set(SSButton, 'Callback', @takeScreenshot);
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% "Variables" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   %Here I'm simply naming stuff that I'm going to use later. Also, the axes are created. 
   theAxes = axes('Parent', f); 
   createAxes(theAxes); 
   theGraph = plot([], []);
   NLfit = plot([], []);  
   theData = []; 
   initParams = []; 
   exponentialFitInterval = []; 
   backgroundSignal = plot([],[]);  
   residual = plot([],[]); 
   residualData = []; 
   residualPoints = plot([],[]); 
   minLine = [];
   maxLine = [];  
   backgroundLine = []; 
   fitWall = -1; 

   %Make the GUI visible.
   set(f,'Visible','on')
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Internal Functions 

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Functions for listening and changing GUI-components %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Tries to open a given file 
    function openFile(obj, event) 
        
        %This rather long-winded navigation through the binary file is necessary to extract the information we want from the .mcs file headers.
        openedFile = fopen(get(getPath, 'String'), 'r'); 
        tempNumber = fread(openedFile, 1, 'int16');
        if(tempNumber ~= -4) 
            display('Suuri on Efesoksen Artemis. (Sure it is a mcs file?)') 
            return; 
        end 
        
        %Source of Triggering. 
        fseek(openedFile, 2, 'bof'); 
        tempNumber = fread(openedFile, 1, 'int8');
        if(tempNumber == 0) 
            set(editSourceTrig, 'String', 'Internal'); 
        else 
            set(editSourceTrig, 'String', 'External');
        end 
        
        %Dwell Units 
        fseek(openedFile, 4, 'bof');
        tempNumber = fread(openedFile, 1, 'int8');
        if(tempNumber == 0) 
            set(editDwellUnits, 'String', 'micro sec.');
        elseif(tempNumber == 1) 
            set(editDwellUnits, 'String', 'milli sec.');  
        elseif(tempNumber == 2) 
            set(editDwellUnits, 'String', 'sec.');
        end 
        
        %Acquisition Mode 
        fseek(openedFile, 5, 'bof');
        tempNumber = fread(openedFile, 1, 'int8');
        if(tempNumber ~= 0) 
            set(editAcq, 'String', 'Sum');
        else 
            set(editAcq, 'String', 'Replace');
        end 
        
        %Pass Length 
        fseek(openedFile, 10, 'bof');
        tempNumber = fread(openedFile, 1, 'uint16'); 
        numOfIntegers = tempNumber; 
        theData = zeros(numOfIntegers,2); 
        set(editPassLength, 'String', num2str(tempNumber));
        
        %Pass Count 
        fseek(openedFile, 12, 'bof');
        tempNumber = fread(openedFile, 1, 'uint32'); 
        set(editPassCount, 'String', num2str(tempNumber));
        
        %Pass Count Preset 
        fseek(openedFile, 16, 'bof');
        tempNumber = fread(openedFile, 1, 'uint32'); 
        set(editPassCountPre, 'String', num2str(tempNumber));
        
        %Dwell TIme 
        fseek(openedFile, 222, 'bof');
        tempNumber = fread(openedFile, 1, 'float'); 
        set(editDwellTime, 'String', num2str(tempNumber));
        
        %Finally, loading intensities from the .mcs file. 
        fseek(openedFile, 256, 'bof');
        theData(:,2) = fread(openedFile, numOfIntegers, 'int32=>float64'); 
        fclose(openedFile); 
        for i = 1:numOfIntegers 
            theData(i,1) = (i-1)*tempNumber*10^(-6) - 0.015; 
        end 
        
        %Here we remove the points, which are caused by the laser pulse. They have a much higher value than the others. 
        for i = 2:numOfIntegers-1   
            if(theData(i-1,2)*5 < theData(i,2) && theData(i+1,2)*5 < theData(i,2))
                theData = removePoint(theData, theData(i,1), theData(i,2)); 
                break;
            end 
        end
        plotPoints(theData); 
    end 

    %Browse for a file. 
    function lookForFile(obj, event) 
        [file, path] = uigetfile('*.*'); 
        set(getPath, 'String', strcat(path, file));
        openFile;
    end 

    %Save data to a text file. 
    function saveFile(obj, event) 
        if(size(theData,1) == 0)
            display('No data to save')
            return;
        end 
        [file, path] = uiputfile('*.txt'); 
        if(file ~= 0)          
            save(strcat(path, file), 'theData', '-ascii');  
        else 
            display('You need to give a location.') 
        end 
    end 

    %Takes a screenshot of the gui. 
    function takeScreenshot(obj, event) 
        [file, path] = uiputfile('*.png');  
        if(file ~= 0)
            saveas(f, strcat(path, file), 'psc2');  
        else 
            display('You need to give a location.') 
        end  
    end 

    %Open print dialog.
    function printGUI(obj, event)
        set(f, 'PaperPositionMode', 'manual');   
        printdlg(f); 
        set(f, 'PaperPositionMode', 'auto');
    end 

    %Wall fit specifier. 
    function wallFit(obj, event) 
        fitWall = 1; 
        makeFit; 
        fitWall = -1; 
    end 
    
    %Makes a fit to the graph, after "Fit" has been pressed. 
    function makeFit(obj, event) 
        if(isempty(theData) == 1) 
            display('No Data')
            return;
        end 
        
        %The order of the vertical green lines doesn't matter. 
        if(get(minLine, 'XData') == get(maxLine, 'XData'))
            display('Vertical lines on top of each other')
            return;
        end 
        if(get(minLine, 'XData') < get(maxLine, 'XData'))
            xmin = get(minLine, 'XData');
            xmax = get(maxLine, 'XData');
        else
            xmax = get(minLine, 'XData');
            xmin = get(maxLine, 'XData');
        end
        
        %Gets the x-value of the white vertical line. 
        backgroundMax = get(backgroundLine, 'XData'); 
        average = 0; 
        if(backgroundMax(1) <= theData(1,1))  
            display('The position of the white (background) line sucks')
            return;
        end
       
          
        %Sums the y-values of the data up until the white vertical line and then takes the average. 
        for i = 1:size(theData,1) 
            if(backgroundMax(1) < theData(i,1))
                average = average/(i-1); 
                set(editSignalAve, 'String', num2str(average)); 
                break;            
            end 
            average = average + theData(i,2); 
        end 
        
        %Deletes a possible previous background signal and plots the new one. 
        delete(backgroundSignal);
        hold on 
        backgroundSignal = plot([theData(1,1), backgroundMax(1)], [average, average], 'k', 'linewidth', 3); 
        hold off 
        
        %Gets the initial guess for the fit parameters from the text fields and then evaluates the optimised parameters 
        %from which the exponential function is plotted. 
        getInitParams(); 
        [exponentialFitInterval] = takeInterval(xmin(1), xmax(1), theData); 
        if(fitWall == -1) 
            outputParams = getExponentialFitParameters(exponentialFitInterval, initParams); 
        else
            initParams(2) = average; 
            outputParams = getWallFitParameters(exponentialFitInterval, initParams(1), initParams(2), initParams(3)); 
        end 
        plotFittedExponential(exponentialFitInterval, outputParams(1), outputParams(3), outputParams(5));
        
        set(minLine, 'XData', [min(exponentialFitInterval(:,1)), min(exponentialFitInterval(:,1))]); 
        set(maxLine, 'XData', [max(exponentialFitInterval(:,1)), max(exponentialFitInterval(:,1))]);
        set(backgroundLine, 'XData', [backgroundMax(1), backgroundMax(1)]);
        
        changeOutputParams(outputParams);
    end 
    
    %Changes the initial parameters to those in the text fields (or if they suck, changes back to the originals). 
    function getInitParams() 
        initParams = [str2double(get(editk0, 'String')), str2double(get(editA0, 'String')), str2double(get(editB0, 'String'))];
        if(isnan(initParams(1)) == 1)
            initParams(1) = 50.0; 
            set(editk0, 'String', '50.0'); 
            display('Numeric parameters work better!!') 
        end
        if(isnan(initParams(2)) == 1)
            initParams(2) = 15.0;
            set(editA0, 'String', '15.0'); 
            display('Numeric parameters work better!!')
        end
        if (isnan(initParams(3)) == 1)
            initParams(3) = 120.0; 
            set(editB0, 'String', '120.0'); 
            display('Numeric parameters work better!!')       
        end         
    end 
    
    %Change the output parameter text fields after fit
    function changeOutputParams(params)
        for i = 1:6 
            if(isnan(params(i)) == 1) 
                display('Bad output parameters.') 
                return;
            end 
        end 
        charArray = cell(6, 1); 
        for i = 1:6 
            charArray{i} = num2str(params(i)); 
        end 
        set(editk, 'String', charArray{1});
        set(editdk, 'String', charArray{2});
        set(editA, 'String',charArray{3});
        set(editdA, 'String', charArray{4});
        set(editB, 'String', charArray{5});
        set(editdB, 'String', charArray{6});     
    end 

    %Changes the limits to those in the text fields 
    function changeLimits(obj, event) 
        xmin = str2double(get(editxMin, 'String')); 
        xmax = str2double(get(editxMax, 'String')); 
        ymin = str2double(get(edityMin, 'String')); 
        ymax = str2double(get(edityMax, 'String')); 
        
        tick = (xmax-xmin)/500.0; 
        minLineX = get(minLine, 'XData'); 
        maxLineX = get(maxLine, 'XData'); 
        bgLineX = get(backgroundLine, 'XData'); 
        setLimits(xmin, xmax, ymin, ymax); 
        if(size(exponentialFitInterval,1) > 0) 
            set(minLine, 'XData', minLineX); 
            set(maxLine, 'XData', maxLineX);
            set(backgroundLine, 'XData', bgLineX);
        end 
        if(minLineX(1) > maxLineX(1)) 
            set(minLine, 'XData', maxLineX); 
            set(maxLine, 'Xdata', minLineX); 
            minLineX = get(minLine, 'XData'); 
            maxLineX = get(maxLine, 'XData'); 
        end 
        if(maxLineX(1) > xmax) 
            set(maxLine, 'XData', [xmax-tick, xmax-tick]); 
        end 
        if(minLineX(1) < xmin) 
            set(minLine, 'XData', [xmin+tick, xmin+tick]); 
        end 
        if(bgLineX(1) < xmin || bgLineX(1) > xmax) 
            set(backgroundLine, 'XData', [xmin+tick, xmin+tick]); 
        end
    end 

    %Gets the data from the textfields to send in for calculations. 
    function startToCalculate(obj, event) 
        inputData = zeros(1,14); 
        dataErrors = zeros(1,14);
        
        inputData(1) = str2double(get(editTroom, 'String'));
        inputData(2) = str2double(get(editProom, 'String'));
        inputData(3) = str2double(get(editFVol, 'String'));
        inputData(4) = str2double(get(editTime, 'String'));
        inputData(5) = str2double(get(editPinhole, 'String'));
        inputData(6) = str2double(get(editp1, 'String'));
        inputData(7) = str2double(get(editT2, 'String'));
        inputData(8) = str2double(get(editL1, 'String'));
        inputData(9) = str2double(get(editL2, 'String'));
        inputData(10) = str2double(get(editReacDia, 'String'));
        inputData(11) = str2double(get(editMVol, 'String'));
        inputData(12) = str2double(get(editReacDil, 'String'));
        inputData(13) = str2double(get(editdP, 'String'));
        inputData(14) = str2double(get(editdt, 'String'));
        
        dataErrors(1) = str2double(get(errTroom, 'String'));
        dataErrors(2) = str2double(get(errProom, 'String'));
        dataErrors(3) = str2double(get(errFVol, 'String'));
        dataErrors(4) = str2double(get(errTime, 'String'));
        dataErrors(5) = str2double(get(errPinhole, 'String'));
        dataErrors(6) = str2double(get(errp1, 'String'));
        dataErrors(7) = str2double(get(errT2, 'String'));
        dataErrors(8) = str2double(get(errL1, 'String'));
        dataErrors(9) = str2double(get(errL2, 'String'));
        dataErrors(10) = str2double(get(errReacDia, 'String'));
        dataErrors(11) = str2double(get(errMVol, 'String'));
        dataErrors(12) = str2double(get(errReacDil, 'String'));
        dataErrors(13) = str2double(get(errdP, 'String'));
        dataErrors(14) = str2double(get(errdt, 'String'));
        for i = 1:14
            if(isnan(inputData(i)) == 1)
                display('Check your parameters!'); 
                return; 
            end 
            if(isnan(dataErrors(i)) == 1)
                display('Check your errors!'); 
                return; 
            end 
        end 
        for i = 1:14 
            if(dataErrors(i) < 0) 
                display('Check your errors (negative?)!'); 
                return; 
            end 
        end 
        if(inputData(1) <= 0)
            set(editTroom, 'String', '<= 0?!'); 
            return;
        end  
        if(inputData(2) <= 0)
            set(editProom, 'String', '<= 0?!'); 
            return; 
        end  
        if(inputData(3) <= 0)
            set(editFVol, 'String', '<= 0?!'); 
            return; 
        end  
        if(inputData(4) <= 0)
            set(editTime, 'String', '<= 0?!'); 
            return; 
        end  
        if(inputData(5) >= 1 || inputData(5) < 0)
            set(editProom, 'String', '< 0 or > 1?!'); 
            return; 
        end
        if(inputData(6) <= 0)
            set(editp1, 'String', '<= 0?!'); 
            return; 
        end  
        if(inputData(7) <= 0)
            set(editT2, 'String', '<= 0?!'); 
            return; 
        end  
        if(inputData(8) <= 0)
            set(editL1, 'String', '<= 0?!'); 
            return; 
        end  
        if(inputData(9) <= 0)
            set(editL2, 'String', '<= 0?!'); 
            return; 
        end  
        if(inputData(10) <= 0)
            set(editReacDia, 'String', '<= 0?!'); 
            return; 
        end  
        if(inputData(11) <= 0)
            set(editMVol, 'String', '<= 0?!'); 
            return; 
        end  
        if(inputData(12) <= 0 || inputData(12) > 100.0)
            set(editReacDil, 'String', '<=0 or >100% ?!'); 
            return; 
        end  
        if(inputData(13) < 0)
            set(editdP, 'String', '< 0 ?!'); 
            return; 
        elseif(inputData(13) == 0) 
            set(editdt, 'String', '1.0');
            inputData(14) = 1.0; 
        end
        if(inputData(14) <= 0)
            set(editdt, 'String', '<= 0?!'); 
            return; 
        end  
 
        outputData = letsDoSomeMaths(inputData, dataErrors);  
        
        %Makes the results visible. 
        set(editv1, 'String', num2str(outputData(1))); 
        set(errv1, 'String', num2str(outputData(2)));
        set(editp2, 'String', num2str(outputData(3)));
        set(errp2, 'String', num2str(outputData(4)));
        set(editv2, 'String', num2str(outputData(5)));
        set(errv2, 'String', num2str(outputData(6)));
        set(editNreactant, 'String', num2str(outputData(7), '%E'));
        set(errNreactant, 'String', num2str(outputData(8), '%E'));
    end 

    %Selects a data point and then deletes it. 
    function selectPoint(obj, event) 
        if(size(theData,1) == 0) 
            display('No points to select') 
            return;
        end 
        
        %Scaling factors, so we delete the point that is "graphically" closest to the point selected by the cursor.  
        ySF = 1.0 / (str2double(get(edityMax, 'String')) - str2double(get(edityMin, 'String')));
        xSF = 1.0 / (str2double(get(editxMax, 'String')) - str2double(get(editxMin, 'String')));
        c = sqrt(2.0); 
        [x, y] = ginput(1); 
        xval = 0; 
        yval = 0; 
        
        %Goes through the data to find the data point closest to the point selected by the cursor. 
        %Not particularly efficient, as it goes through all the data points and the forms a matrix 
        %that is one size smaller and replaces the old data matrix with that. 
        for i = 1:size(theData,1)
            if(c > sqrt((xSF*(x-theData(i,1))).^2 + (ySF*(y-theData(i,2))).^2))
                c = sqrt((xSF*(x-theData(i,1))).^2 + (ySF*(y-theData(i,2))).^2); 
                xval = theData(i,1);
                yval = theData(i,2);
            end 
        end 
        theData = removePoint(theData, xval, yval);
        plotPoints(theData); 
    end 
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Functions for graphing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
    %Plots the data points. 
    function plotPoints(thePoints) 
        
           %Initially we delete everything in the graph and create everything anew. 
           createAxes(theAxes); 
           minLine = line;
           maxLine = line; 
           backgroundLine = line; 
           NLfit = plot([],[]);
           backgroundSignal = plot([],[]); 
           residualPoints = plot([],[]);  
           residual = plot([],[]); 
           hold on 
           theGraph = plot(thePoints(:,1), thePoints(:,2), 'd', 'Color', 'y'); 
           hold off
           setLimits(min(thePoints(:,1)), max(thePoints(:,1)), min(thePoints(:,2)) - 0.1*max(thePoints(:,2)), 1.1*max(thePoints(:,2)));
    end 

    %Plots the fit from solved parameters. Also plots the residual under the graph. 
    function plotFittedExponential(anInterval, k, A, B) 
        
        %Delete possible old data. 
        residualData = []; 
        delete(residualPoints); 
        delete(NLfit);
        delete(residual); 
        
        %x and y points for the exponential fit. 
        y1 = A + B*exp(-k*anInterval(:,1)); 
        x = anInterval(:,1); 
        
        %x and y points for the residual data. 
        residualData(:,1) = anInterval(:,1);  
        residualData(:,2) = anInterval(:,2) - y1; 
        
        %Make a linear fit for the residual data. 
        outputparams = polyfit(residualData(:,1),residualData(:,2),1); 
        set(editTheGrad, 'String', num2str(outputparams(1))); 
        set(editTheConst, 'String', num2str(outputparams(2)));
        y2 = outputparams(1)*x + outputparams(2); 
        
        %Plot both the exponential and linear function. 
        hold on 
        residual = plot(x, y2, 'linewidth', 3, 'Color', [0.6, 0.3, 0.3]); 
        NLfit = plot(x, y1, 'b', 'linewidth', 3); 
        residualPoints = plot(residualData(:,1), residualData(:,2), 'd', 'Color', [0.2, 0.5, 0.3]); 
        hold off 
        
        %Set new limits. 
        limits = xlim; 
        setLimits(limits(1), limits(2), 1.2*min(residualData(:,2)), 1.1*max(theData(:,2)));
    end 
    

    %Edit xy-limits to the  graph. 
    function setLimits(xmin, xmax, ymin, ymax)
        if(xmin >= xmax || ymin >= ymax) 
            display('Something funny about the given limits.') 
            return;
        end 
        if(isnan(xmin) == 1 || isnan(xmax) == 1 || isnan(ymin) == 1 || isnan(ymax) == 1) 
            display('You gave a null limit.') 
            return; 
        end 
        set(theAxes, 'XLim', [xmin, xmax], 'YLim', [ymin, ymax]); 
        
        %Changes the limit labels in the GUI. 
        set(editxMin, 'String', num2str(xmin)); 
        set(editxMax, 'String', num2str(xmax));
        set(edityMin, 'String', num2str(ymin));
        set(edityMax, 'String', num2str(ymax))
       
        createMinLine((xmax-xmin)*0.15+xmin, (xmax-xmin)*0.15+xmin, ymin, ymax); 
        createMaxLine((xmax-xmin)*0.9+xmin, (xmax-xmin)*0.9+xmin, ymin, ymax); 
        createBgLine((xmax-xmin)*0.05+xmin,  (xmax-xmin)*0.05+xmin, ymin, ymax); 
        draggable(minLine, 'h'); 
        draggable(maxLine, 'h');      
        draggable(backgroundLine, 'h'); 
    end

    function createMinLine(xmin, xmax, ymin, ymax)  
        set(minLine, 'XData', [], 'YData', []);
        minLine = line([xmin, xmax], [ymin, ymax], 'Color', 'g', 'LineWidth', 3);
        draggable(minLine, 'h'); 
    end 

    function createMaxLine(xmin, xmax, ymin, ymax) 
        set(maxLine, 'XData', [], 'YData', []);
        maxLine = line([xmin, xmax], [ymin, ymax], 'Color', 'g', 'LineWidth', 3);
        draggable(maxLine, 'h'); 
    end 

    function createBgLine(xmin, xmax, ymin, ymax)  
        set(backgroundLine, 'XData', [], 'YData', []);
        backgroundLine = line([xmin, xmax], [ymin, ymax], 'Color', 'w', 'LineWidth', 3);
        draggable(backgroundLine, 'h'); 
    end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%End Internal Functions
end 

%External Functions

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Functions for creating GUI objects %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %These are simply to make creating gui objects faster. 

    %Creates the axes for the graph.             
    function createAxes(theAxes)
        cla(theAxes);                                                          %Clear current axes. 
        set(theAxes, 'Units', 'Normalized', 'FontUnits', 'Normalized'); 
        set(get(theAxes, 'XLabel'), 'FontUnits', 'Normalized');
        set(get(theAxes, 'YLabel'), 'FontUnits', 'Normalized'); 
        set(theAxes, 'FontSize', 0.03); 
        set(theAxes, 'Position', [0.05, 0.3, 0.6, 0.6]); 
        set(get(theAxes, 'XLabel'), 'String', 'time / s', 'FontSize', 0.04, 'Color', 'b');  
        set(get(theAxes, 'YLabel'), 'String', 'Intensity', 'FontSize', 0.04,'Color', 'b');
        set(theAxes, 'Color', [1, 0.4, 0.6]);       
    end

    %Creates a text object, editable or static, depending on input parameters
    function createText(name, style, position, fontSize, textField)
        set(name, 'Style', style); 
        set(name, 'Units', 'Normalized', 'FontUnits', 'Normalized');
        set(name, 'Position', position);
        set(name, 'FontSize', fontSize); 
        set(name, 'String', textField); 
        set(name, 'BackgroundColor', [0.8, 0.0, 0.8]); 
        set(name, 'ForegroundColor', [0.2, 1, 1]); 
    end 
    
    %Creates a GUI button 
    function createButton(name, position, fontSize, label) 
        set(name, 'Style', 'PushButton'); 
        set(name, 'Units', 'Normalized', 'FontUnits', 'Normalized');
        set(name, 'Position', position);
        set(name, 'FontSize', fontSize); 
        set(name, 'String', label); 
        set(name, 'BackgroundColor', [0.4, 0.0, 0.8]); 
        set(name, 'ForegroundColor', [0.2, 1, 1]);
    end           
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Functions for data manipulation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
    %This functions takes a given section of the data and returns it in matrix form.  
    function [partOfData] =  takeInterval(xmin, xmax, theData) 
        
        %First checks that the minimums or maximums are not beyond the data minimums or maximums.
        %If they are the, the interval min/max is set to the data min/max. 
        if(xmin >= xmax) 
            partOfData = theData; 
            return 
        end 
        if(xmax > theData(size(theData,1),1))
            xmax = theData(size(theData,1),1); 
        end  
        if(xmin < theData(1,1))
            xmin = theData(1,1); 
        end 
        
        %Look for the x-min limit. 
        for i = 1:size(theData,1)
            if(theData(i,1) >= xmin) 
                beginning = i;
                break
            end 
        end 
        %Look for the x-max limit. 
        for i = beginning:size(theData,1)
            if(xmax == max(theData(:,1)))
                ending = size(theData,1);
                break
            end 
            if(theData(i,1) > xmax) 
                ending = i-1;
                break
            end
        end 
        
        %Create and fill the data matrix for the desired interval. 
        partOfData = zeros(ending-beginning+1, 2);
        for i = 1:size(partOfData,1) 
            partOfData(i,1) = theData(beginning+i-1,1);
            partOfData(i,2) = theData(beginning+i-1,2);
        end 
    end 
    
    %Gets the fit parameters for a given set of data for the exponential of the form y = A + B*exp(-k*x). 
    function [outputParams] = getExponentialFitParameters(theData, initParams) 
        outputParams = zeros(1, 6); 
        expFunc = @(params, x) params(2) + params(3)*exp(-params(1)*x);
        [parameters, Res, Jac, Cov, MSE] = nlinfit(theData(:,1), theData(:,2), expFunc, initParams); 
        
        %The errors for the parameters is calculated here
        parameterErrors = sqrt(diag(Cov)); 
        
        %confidenceIntervals = nlparci(parameters, Res, 'cov', Cov)
        outputParams(1) = parameters(1); 
        outputParams(2) = parameterErrors(1); 
        outputParams(3) = parameters(2); 
        outputParams(4) = parameterErrors(2);
        outputParams(5) = parameters(3); 
        outputParams(6) = parameterErrors(3);
    end
    
    %Fit parameters for wall rate 
    function [outputParams] = getWallFitParameters(theData, k0, A0, B0) 
        outputParams = zeros(1, 6); 
        initParams = [k0, B0]; 
        expFunc = @(params, x) A0 + params(2)*exp(-params(1)*x);
        [parameters, Res, Jac, Cov, MSE] = nlinfit(theData(:,1), theData(:,2), expFunc, initParams); 
        
        %The errors for the parameters is calculated here
        parameterErrors = sqrt(diag(Cov)); 
        
        %confidenceIntervals = nlparci(parameters, Res, 'cov', Cov)
        outputParams(1) = parameters(1); 
        outputParams(2) = parameterErrors(1); 
        outputParams(3) = A0; 
        outputParams(4) = 0; 
        outputParams(5) = parameters(2); 
        outputParams(6) = parameterErrors(2);
    end
    
    %Function to delete a data point from the data. 
    function [dataMatrix] = removePoint(inputMatrix, xval,  yval) 
        step = 0; 
        dataMatrix = zeros(size(inputMatrix,1)-1, 2); 
        for i = 1:size(inputMatrix,1)-1
            if(xval == inputMatrix(i,1) && yval == inputMatrix(i,2) && step == 0) %step == 0 just in case that there are two identical points. 
                step = 1; 
            end 
            dataMatrix(i,1) = inputMatrix(i+step,1);
            dataMatrix(i,2) = inputMatrix(i+step,2);
        end 
    end 
    
    %Lets do some maths! 
    function [outputData] = letsDoSomeMaths(inputData, errorData)
        
        %Let's see what we are working with. 
        outputData = zeros(1,8); 
        
        Troom  = inputData(1); 
        Proom  = inputData(2);
        FVolume  = inputData(3);
        Time  = inputData(4);
        PinholeCorr  = inputData(5);
        p1  = inputData(6);
        T2  = inputData(7);
        L1  = inputData(8);
        L2  = inputData(9);
        reactorDiameter  = inputData(10);
        MVolume  = inputData(11);
        dilution  = inputData(12);
        dP  = inputData(13);
        dt  = inputData(14); 
        
        errTroom  = errorData(1); 
        errProom  = errorData(2);
        errFVolume  = errorData(3);
        errTime  = errorData(4);
        errPinholeCorr  = errorData(5);
        errp1  = errorData(6);
        errT2  = errorData(7);
        errL1  = errorData(8);
        errL2  = errorData(9);
        errReactorDiameter  = errorData(10);
        errMVolume  = errorData(11);
        errDilution  = errorData(12);
        errdP  = errorData(13);
        errdt  = errorData(14); 
        
        N = 6.02214129e23;
        R = 8.3144621; 
        
        %Change to SI units. 
        FVolume = FVolume * 1.0e-6;
        MVolume = MVolume * 1.0e-6;
        Proom = 133.322368*Proom; 
        p1 = 133.3223684211*p1;   
        dP = 133.3223684211*dP; 
        reactorRadius = reactorDiameter / 200.0;
        L1 = L1/100.0; 
        L2 = L2/100.0;
        dilution = dilution/100.0;   
        
        errFVolume = errFVolume * 1.0e-6;
        errMVolume = errMVolume * 1.0e-6;
        errProom = 133.322368*errProom; 
        errp1 = 133.3223684211*errp1;   
        errdP = 133.3223684211*errdP; 
        errReactorRadius = errReactorDiameter / 200.0;
        errL1 = errL1/100.0; 
        errL2 = errL2/100.0;
        errDilution = errDilution/100.0;   

        errPinholeCorr = sqrt((1/(1-PinholeCorr).^2).^2 * errPinholeCorr.^2); 
        PinholeCorr = 1.0 / (1.0 - PinholeCorr);
        
        %Calculate the molar flows. Helium flow obviously includes the precursor flow. 
        %The flow in the beginning of the reactor is also calculated. 
        reactantFlow = (dP*MVolume)/(R*Troom*dt);
        reactantFlowError = (MVolume/(R*Troom*dt)).^2 * errdP.^2 + ... 
                            (dP/(R*Troom*dt)).^2 * errMVolume.^2 + ...
                            ((-dP*MVolume)/(R*Troom.^2 *dt)).^2 * errTroom.^2 + ... 
                            ((-dP*MVolume)/(R*Troom*dt.^2)).^2 * errdt.^2; 
        reactantFlowError = sqrt(reactantFlowError); 
                        
        heliumFlow = PinholeCorr*(Proom*FVolume)/(R*Troom*Time);
        heliumFlowError = ((Proom*FVolume)/(R*Troom*Time)).^2 * errPinholeCorr.^2 + ... 
                          ((PinholeCorr*FVolume)/(R*Troom*Time)).^2 * errProom.^2 + ...
                          ((Proom*PinholeCorr)/(R*Troom*Time)).^2 * errFVolume.^2 + ...
                          ((-PinholeCorr*Proom*FVolume)/(R*Troom.^2 *Time)).^2 * errTroom.^2 + ...
                          ((-PinholeCorr*Proom*FVolume)/(R*Troom*Time.^2)).^2 * errTime.^2;
        heliumFlowError = sqrt(heliumFlowError); 
    
        totalFlow = reactantFlow + heliumFlow;
        totalFlowError = sqrt(heliumFlowError.^2 + reactantFlowError.^2); 
        
        v1 = (totalFlow*R*Troom)/(p1*pi*reactorRadius.^2);
        v1Error = ((R*Troom)/(p1*pi*reactorRadius.^2)).^2 * totalFlowError.^2 + ... 
                  ((totalFlow*R)/(p1*pi*reactorRadius.^2)).^2 * errTroom.^2 + ...
                  ((-totalFlow*R*Troom)/(p1.^2 *pi*reactorRadius.^2)).^2 * errp1.^2 + ...
                  ((-2*totalFlow*R*Troom)/(p1*pi*reactorRadius.^3)).^2 * errReactorRadius.^2; 
        v1Error = sqrt(v1Error); 
        
        %Calculate pressure drop due to the Hagen–Poiseuille equation in the first section.     
        heliumViscosity = 5.023e-7 * Troom.^(0.647); 
        heliumViscosityError = sqrt((0.647*5.023e-7 * Troom.^(-0.353)).^2 * errTroom.^2); 
        
        p2 = sqrt(p1.^2 - (16*totalFlow*L1*heliumViscosity*R*Troom)/(reactorRadius.^4 * pi)); 
        p2Error = ((-8*L1*heliumViscosity*R*Troom)/(reactorRadius.^4 * pi * p2)).^2 * totalFlowError.^2 + ... 
                  ((-8*totalFlow*heliumViscosity*R*Troom)/(reactorRadius.^4 * pi * p2)).^2 * errL1.^2 + ... 
                  ((-8*totalFlow*L1*R*Troom)/(reactorRadius.^4 * pi * p2)).^2 * heliumViscosityError.^2 + ... 
                  ((-8*totalFlow*L1*heliumViscosity*R)/(reactorRadius.^4 * pi * p2)).^2 * errTroom.^2 + ... 
                  ((32*totalFlow*L1*heliumViscosity*R*Troom)/(reactorRadius.^5 * pi * p2)).^2 * errReactorRadius.^2 + ...
                  (p1/p2).^2 * errp1.^2; 
        p2Error = sqrt(p2Error); 
        
        
        %Calculate the pressure drop in the second section. 
        heliumViscosity = 5.023e-7 * T2.^(0.647); 
        heliumViscosityError = sqrt((0.647*5.023e-7 * T2.^(-0.353)).^2 * errT2.^2);
        p3 = sqrt(p2.^2 - (16*totalFlow*L2*heliumViscosity*R*T2)/(reactorRadius.^4 * pi)); 
        p3Error = ((-8*L2*heliumViscosity*R*T2)/(reactorRadius.^4 * pi * p3)).^2 * totalFlowError.^2 + ... 
                  ((-8*totalFlow*heliumViscosity*R*T2)/(reactorRadius.^4 * pi * p3)).^2 * errL2.^2 + ... 
                  ((-8*totalFlow*L2*R*T2)/(reactorRadius.^4 * pi * p3)).^2 * heliumViscosityError.^2 + ... 
                  ((-8*totalFlow*L2*heliumViscosity*R)/(reactorRadius.^4 * pi * p3)).^2 * errT2.^2 + ... 
                  ((32*totalFlow*L2*heliumViscosity*R*T2)/(reactorRadius.^5 * pi * p3)).^2 * errReactorRadius.^2 + ...
                  (p2/p3).^2 * p2Error.^2; 
        p3Error = sqrt(p3Error); 
        
        %Calculate the final concetration, flow speed and pressure at the pinhole. 
        v2 = (totalFlow*R*T2)/(p3*pi*reactorRadius.^2); 
        v2Error = ((R*T2)/(p3*pi*reactorRadius.^2)).^2 * totalFlowError.^2 + ... 
                  ((totalFlow*R)/(p1*pi*reactorRadius.^2)).^2 * errT2.^2 + ...
                  ((-totalFlow*R*T2)/(p1.^2 *pi*reactorRadius.^2)).^2 * p3Error.^2 + ...
                  ((-2*totalFlow*R*T2)/(p3*pi*reactorRadius.^3)).^2 * errReactorRadius.^2; 
        v2Error = sqrt(v2Error); 
        
        %Ugly conversions back to non-SI units.
        Nreactant = dilution * (reactantFlow*p3)/(totalFlow*R*T2) *(N*1.0e-6); 
        NreactantError = ((reactantFlow*p3)/(totalFlow*R*T2) *(N*1.0e-6)).^2 * errDilution.^2 + ... 
                         ((dilution*p3)/(totalFlow*R*T2) *(N*1.0e-6)).^2 * reactantFlowError.^2 + ... 
                         ((reactantFlow*dilution)/(totalFlow*R*T2) *(N*1.0e-6)).^2 * p3Error.^2 + ... 
                         ((-dilution*reactantFlow*p3)/(totalFlow.^2 *R*T2) *(N*1.0e-6)).^2 * totalFlowError.^2 + ... 
                         ((-dilution*reactantFlow*p3)/(totalFlow*R*T2.^2) *(N*1.0e-6)).^2 * errT2.^2; 
        NreactantError = sqrt(NreactantError); 
      
        p3 = p3/133.3223684211; 
        p3Error = p3Error/133.3223684211; 
        
        %Send back the calculated values. 
        outputData(1) = v1; 
        outputData(2) = v1Error; 
        outputData(3) = p3; 
        outputData(4) = p3Error;
        outputData(5) = v2;
        outputData(6) = v2Error; 
        outputData(7) = Nreactant;
        outputData(8) = NreactantError;  
    end 
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
%End External Functions
 
    
    
    