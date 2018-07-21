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
     
   getPath = uicontrol('Parent', f); 
   createText(getPath, 'edit', [0.02, 0.91, 0.20, 0.03], 0.45, '/home/timo/');   
   
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
   createText(editSignalAve, 'text', [0.27, 0.92, 0.06, 0.035], 0.5, '-')
   
   
   xMin = uicontrol('Parent', f); 
   createText(xMin, 'text', [0.653, 0.88, 0.03, 0.025], 0.6, 'xMin');   
   
   xMax = uicontrol('Parent', f); 
   createText(xMax, 'text', [0.653, 0.85, 0.03, 0.025], 0.59, 'xMax');  
   
   yMin = uicontrol('Parent', f); 
   createText(yMin, 'text', [0.653, 0.82, 0.03, 0.025], 0.6, 'yMin');  
   
   yMax = uicontrol('Parent', f); 
   createText(yMax, 'text', [0.653, 0.79, 0.03, 0.025], 0.6, 'yMax');
   
   editxMin = uicontrol('Parent', f); 
   createText(editxMin, 'edit', [0.685, 0.88, 0.1, 0.025], 0.7, '1.0');   
   
   editxMax = uicontrol('Parent', f); 
   createText(editxMax, 'edit', [0.685, 0.85, 0.1, 0.025], 0.7, '1.0'); 
   
   edityMin = uicontrol('Parent', f); 
   createText(edityMin, 'edit', [0.685, 0.82, 0.1, 0.025], 0.7, '1.0'); 
   
   edityMax = uicontrol('Parent', f); 
   createText(edityMax, 'edit', [0.685, 0.79, 0.1, 0.025], 0.7, '1.0'); 
   
   
   Troom = uicontrol('Parent', f); 
   createText(Troom, 'text', [0.787, 0.95, 0.07, 0.035], 0.45, 'T(K) [room]'); 
   
   Proom = uicontrol('Parent', f); 
   createText(Proom, 'text', [0.787, 0.91, 0.07, 0.035], 0.45, 'p(Torr) [room]'); 
   
   FVol = uicontrol('Parent', f); 
   createText(FVol, 'text', [0.787, 0.87, 0.07, 0.035], 0.45, 'F-Volume (cm3)');
   
   time = uicontrol('Parent', f); 
   createText(time, 'text', [0.787, 0.83, 0.07, 0.035], 0.45, 'Time(s)');
   
   pinhole = uicontrol('Parent', f); 
   createText(pinhole, 'text', [0.787, 0.79, 0.07, 0.035], 0.45, 'Pinhole corr.');
   
   pTot = uicontrol('Parent', f); 
   createText(pTot, 'text', [0.787, 0.75, 0.07, 0.035], 0.45, 'pTot(torr)');
   
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
   
   dp = uicontrol('Parent', f); 
   createText(dp, 'text', [0.787, 0.47, 0.07, 0.035], 0.45, 'dp(torr)');
   
   dt = uicontrol('Parent', f); 
   createText(dt, 'text', [0.787, 0.43, 0.07, 0.035], 0.45, 'dt(s)');
   
   editTroom = uicontrol('Parent', f); 
   createText(editTroom, 'edit', [0.86, 0.95, 0.06, 0.035], 0.5, '298.15'); 
   
   editProom = uicontrol('Parent', f); 
   createText(editProom, 'edit', [0.86, 0.91, 0.06, 0.035], 0.5, '760.0'); 
   
   editFVol = uicontrol('Parent', f); 
   createText(editFVol, 'edit', [0.86, 0.87, 0.06, 0.035], 0.5, '20.0'); 
   
   editTime = uicontrol('Parent', f); 
   createText(editTime, 'edit', [0.86, 0.83, 0.06, 0.035], 0.5, '10.0'); 
   
   editPinhole = uicontrol('Parent', f); 
   createText(editPinhole, 'edit', [0.86, 0.79, 0.06, 0.035], 0.5, '0.030'); 
   
   editpTot = uicontrol('Parent', f); 
   createText(editpTot, 'edit', [0.86, 0.75, 0.06, 0.035], 0.5, '1.000'); 
   
   editT2 = uicontrol('Parent', f); 
   createText(editT2, 'edit', [0.86, 0.71, 0.06, 0.035], 0.5, '298.15'); 
   
   editL1 = uicontrol('Parent', f); 
   createText(editL1, 'edit', [0.86, 0.67, 0.06, 0.035], 0.5, '28.00');
   
   editL2 = uicontrol('Parent', f); 
   createText(editL2, 'edit', [0.86, 0.63, 0.06, 0.035], 0.5, '22.00'); 
   
   editReacDia = uicontrol('Parent', f); 
   createText(editReacDia, 'edit', [0.86, 0.59, 0.06, 0.035], 0.5, '1.70'); 
   
   editMVol = uicontrol('Parent', f); 
   createText(editMVol, 'edit', [0.86, 0.55, 0.06, 0.035], 0.5, '56.1');
   
   editReacDil = uicontrol('Parent', f); 
   createText(editReacDil, 'edit', [0.86, 0.51, 0.06, 0.035], 0.5, '100.0');
   
   editdp = uicontrol('Parent', f); 
   createText(editdp, 'edit', [0.86, 0.47, 0.06, 0.035], 0.5, '0.1');
   
   editdt = uicontrol('Parent', f); 
   createText(editdt, 'edit', [0.86, 0.43, 0.06, 0.035], 0.5, '10.0');
   
   TroomError = uicontrol('Parent', f); 
   createText(TroomError, 'edit', [0.925, 0.95, 0.06, 0.035], 0.5, '1'); 
   
   ProomError = uicontrol('Parent', f); 
   createText(ProomError, 'edit', [0.925, 0.91, 0.06, 0.035], 0.5, '15.2'); 
   
   FVolError = uicontrol('Parent', f); 
   createText(FVolError, 'edit', [0.925, 0.87, 0.06, 0.035], 0.5, '0'); 
   
   TimeError = uicontrol('Parent', f); 
   createText(TimeError, 'edit', [0.925, 0.83, 0.06, 0.035], 0.5, '0.2'); 
   
   PinholeError = uicontrol('Parent', f); 
   createText(PinholeError, 'edit', [0.925, 0.79, 0.06, 0.035], 0.5, '0.005'); 
   
   pTotError = uicontrol('Parent', f); 
   createText(pTotError, 'edit', [0.925, 0.75, 0.06, 0.035], 0.5, '0.01'); 
   
   T2Error = uicontrol('Parent', f); 
   createText(T2Error, 'edit', [0.925, 0.71, 0.06, 0.035], 0.5, '2'); 
   
   L1Error = uicontrol('Parent', f); 
   createText(L1Error, 'edit', [0.925, 0.67, 0.06, 0.035], 0.5, '0');
   
   L2Error = uicontrol('Parent', f); 
   createText(L2Error, 'edit', [0.925, 0.63, 0.06, 0.035], 0.5, '0'); 
   
   ReacDiaError = uicontrol('Parent', f); 
   createText(ReacDiaError, 'edit', [0.925, 0.59, 0.06, 0.035], 0.5, '0'); 
   
   MVolError = uicontrol('Parent', f); 
   createText(MVolError, 'edit', [0.925, 0.55, 0.06, 0.035], 0.5, '0');
   
   ReacDilError = uicontrol('Parent', f); 
   createText(ReacDilError, 'edit', [0.925, 0.51, 0.06, 0.035], 0.5, '0.5065');
   
   dpError = uicontrol('Parent', f); 
   createText(dpError, 'edit', [0.925, 0.47, 0.06, 0.035], 0.5, '0');
   
   dtError = uicontrol('Parent', f); 
   createText(dtError, 'edit', [0.925, 0.43, 0.06, 0.035], 0.5, '0.2');
   
   p1 = uicontrol('Parent', f); 
   createText(p1, 'text', [0.59, 0.20, 0.1, 0.035], 0.6, 'p1(Torr)');
   
   v1 = uicontrol('Parent', f); 
   createText(v1, 'text', [0.59, 0.16, 0.1, 0.035], 0.6, 'v1(m/s)');
   
   p2 = uicontrol('Parent', f); 
   createText(p2, 'text', [0.59, 0.12, 0.1, 0.035], 0.6, 'p2(Torr)');
   
   v2 = uicontrol('Parent', f); 
   createText(v2, 'text', [0.59, 0.08, 0.1, 0.035], 0.6, 'v2(m/s)');
   
   Nreactant = uicontrol('Parent', f); 
   createText(Nreactant, 'text', [0.59, 0.04, 0.1, 0.035], 0.39, 'Nreactant(#/cm3)');
   
   editp1 = uicontrol('Parent', f); 
   createText(editp1, 'text', [0.7, 0.20, 0.12, 0.035], 0.485, '-');
   
   editv1 = uicontrol('Parent', f); 
   createText(editv1, 'text', [0.7, 0.16, 0.12, 0.035], 0.485, '-');
   
   editp2 = uicontrol('Parent', f); 
   createText(editp2, 'text', [0.7, 0.12, 0.12, 0.035], 0.485, '-');
   
   editv2 = uicontrol('Parent', f); 
   createText(editv2, 'text', [0.7, 0.08, 0.12, 0.035], 0.485, '-');
   
   editNreactant = uicontrol('Parent', f); 
   createText(editNreactant, 'text', [0.7, 0.04, 0.12, 0.035], 0.49, '-');
   
   p1Error = uicontrol('Parent', f); 
   createText(p1Error, 'text', [0.83, 0.20, 0.12, 0.035], 0.485, '-');
   
   v1Error = uicontrol('Parent', f); 
   createText(v1Error, 'text', [0.83, 0.16, 0.12, 0.035], 0.485, '-');
   
   p2Error = uicontrol('Parent', f); 
   createText(p2Error, 'text', [0.83, 0.12, 0.12, 0.035], 0.485, '-');
   
   v2Error = uicontrol('Parent', f); 
   createText(v2Error, 'text', [0.83, 0.08, 0.12, 0.035], 0.485, '-');
   
   NreactantError = uicontrol('Parent', f); 
   createText(NreactantError, 'text', [0.83, 0.04, 0.12, 0.035], 0.49, '-');
   
   selectedCarrierGas = uicontrol('Parent', f); 
   createText(selectedCarrierGas, 'text', [0.805, 0.39, 0.08, 0.035], 0.5, 'Carrier Gas:');
   
   selectedReactant = uicontrol('Parent', f); 
   createText(selectedReactant, 'text', [0.805, 0.35, 0.08, 0.035], 0.6, 'Reactant:')
   
   
   fittingFunction = uicontrol('Parent', f); 
   createText(fittingFunction, 'text', [0.04, 0.22, 0.2, 0.03], 0.5, 'y = A + Bexp(-k''*t)');
   
   firstExp = uicontrol('Parent', f); 
   createText(firstExp, 'text', [0.04, 0.18, 0.035, 0.035], 0.9, 'k''');
   
   editFirstExp = uicontrol('Parent', f); 
   createText(editFirstExp, 'text', [0.08, 0.18, 0.1, 0.035], 0.7, '-');
   
   firstExpError = uicontrol('Parent', f); 
   createText(firstExpError, 'text', [0.185, 0.18, 0.1, 0.035], 0.7, '-');
   
   secondExp = uicontrol('Parent', f); 
   createText(secondExp, 'text', [0.04, 0.14, 0.035, 0.035], 0.9, 'kw');

   editSecondExp = uicontrol('Parent', f); 
   createText(editSecondExp, 'text', [0.08, 0.14, 0.1, 0.035], 0.7, '-');

   secondExpError = uicontrol('Parent', f); 
   createText(secondExpError, 'text', [0.185, 0.14, 0.1, 0.035], 0.7, '-');

   backgroundAverage = uicontrol('Parent', f); 
   createText(backgroundAverage, 'text', [0.04, 0.108, 0.03, 0.03], 0.9, 'A');

   editBackgroundAverage = uicontrol('Parent', f); 
   createText(editBackgroundAverage, 'text', [0.08, 0.108, 0.1, 0.03], 0.7, '-');

   backgroundAverageError = uicontrol('Parent', f); 
   createText(backgroundAverageError, 'text', [0.185, 0.108, 0.1, 0.03], 0.7, '-');

   firstAmplitude = uicontrol('Parent', f); 
   createText(firstAmplitude, 'text', [0.04, 0.075, 0.03, 0.03], 0.9, 'B');

   editFirstAmplitude = uicontrol('Parent', f); 
   createText(editFirstAmplitude, 'text', [0.08, 0.075, 0.1, 0.03], 0.7, '-');

   firstAmplitudeError = uicontrol('Parent', f); 
   createText(firstAmplitudeError, 'text', [0.185, 0.075, 0.1, 0.03], 0.7, '-');

   secondAmplitude = uicontrol('Parent', f); 
   createText(secondAmplitude, 'text', [0.04, 0.043, 0.03, 0.03], 0.9, 'C');

   editSecondAmplitude = uicontrol('Parent', f); 
   createText(editSecondAmplitude, 'text', [0.08, 0.043, 0.1, 0.03], 0.7, '-');

   secondAmplitudeError = uicontrol('Parent', f); 
   createText(secondAmplitudeError, 'text', [0.185, 0.043, 0.1, 0.03], 0.7, '-');

   forwardRate = uicontrol('Parent', f); 
   createText(forwardRate, 'text', [0.3, 0.185, 0.03, 0.03], 0.9, 'k''f');

   editForwardRate = uicontrol('Parent', f); 
   createText(editForwardRate, 'text', [0.34, 0.185, 0.1, 0.03], 0.65, '-');

   forwardRateError = uicontrol('Parent', f); 
   createText(forwardRateError, 'text', [0.45, 0.185, 0.1, 0.03], 0.65, '-');

   backwardRate = uicontrol('Parent', f); 
   createText(backwardRate, 'text', [0.3, 0.15, 0.03, 0.03], 0.9, 'k''b');

   editBackwardRate = uicontrol('Parent', f); 
   createText(editBackwardRate, 'text', [0.34, 0.15, 0.1, 0.03], 0.65, '-');

   backwardRateError = uicontrol('Parent', f); 
   createText(backwardRateError, 'text', [0.45, 0.15, 0.1, 0.03], 0.65, '-');

   firstWallRate = uicontrol('Parent', f); 
   createText(firstWallRate, 'text', [0.3, 0.118, 0.03, 0.03], 0.6, 'kw1');

   editFirstWallRate = uicontrol('Parent', f); 
   createText(editFirstWallRate, 'edit', [0.34, 0.118, 0.1, 0.03], 0.7, 'Give kw1');

   firstWallRateError = uicontrol('Parent', f); 
   createText(firstWallRateError, 'edit', [0.45, 0.118, 0.1, 0.03], 0.7, 'Give dkw1');

   secondWallRate = uicontrol('Parent', f); 
   createText(secondWallRate, 'text', [0.3, 0.085, 0.03, 0.03], 0.6, 'kw2');

   editSecondWallRate = uicontrol('Parent', f); 
   createText(editSecondWallRate, 'text', [0.34, 0.085, 0.1, 0.03], 0.7, '-');

   secondWallRateError = uicontrol('Parent', f); 
   createText(secondWallRateError, 'text', [0.45, 0.085, 0.1, 0.03], 0.7, '-');
   
   EQconstant = uicontrol('Parent', f); 
   createText(EQconstant, 'text', [0.3, 0.043, 0.035, 0.035], 0.6, 'ln(K)');

   editEQconstant = uicontrol('Parent', f); 
   createText(editEQconstant, 'text', [0.34, 0.043, 0.1, 0.035], 0.6, '-');

   EQconstantError = uicontrol('Parent', f); 
   createText(EQconstantError, 'text', [0.45, 0.043, 0.1, 0.035], 0.6, '-');
   
   
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% This Section Creates the Buttons %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   browseButton = uicontrol('Parent', f); 
   createButton(browseButton, [0.02, 0.95, 0.13, 0.03], 0.6, 'Browse for File'); 
   set(browseButton, 'Callback', @lookForFile); 
   
   SelectFileButton = uicontrol('Parent', f); 
   createButton(SelectFileButton, [0.17, 0.95, 0.05, 0.03], 0.6, 'Select'); 
   set(SelectFileButton, 'Callback', @openFile);
   
   makeFitButton = uicontrol('Parent', f); 
   createButton(makeFitButton, [0.653, 0.43, 0.13, 0.055], 0.9, 'Fit!'); 
   set(makeFitButton, 'Callback', @makeFit); 
 
   changeLimitsButton = uicontrol('Parent', f); 
   createButton(changeLimitsButton, [0.653, 0.75, 0.13, 0.035], 0.4, 'Change Graph Limits'); 
   set(changeLimitsButton, 'Callback', @changeLimits); 
   
   calculateButton = uicontrol('Parent', f); 
   createButton(calculateButton, [0.83, 0.26, 0.13, 0.05], 0.4, 'Calculate!'); 
   set(calculateButton, 'Callback', @startToCalculate); 
   
   removePointButton = uicontrol('Parent', f); 
   createButton(removePointButton, [0.653, 0.68, 0.13, 0.05], 0.4, 'Remove a Point'); 
   set(removePointButton, 'Callback', @selectPoint); 
   
   writeTextButton = uicontrol('Parent', f); 
   createButton(writeTextButton, [0.653, 0.625, 0.13, 0.05], 0.35, 'Save Data (.txt)'); 
   set(writeTextButton, 'Callback', @saveFile); 
   
   printButton = uicontrol('Parent', f); 
   createButton(printButton, [0.653, 0.57, 0.13, 0.05], 0.35, 'Print GUI (b&w)'); 
   set(printButton, 'Callback', @printGUI); 
   
   SSButton = uicontrol('Parent', f); 
   createButton(SSButton, [0.653, 0.515, 0.13, 0.05], 0.35, 'Take Screenshot'); 
   set(SSButton, 'Callback', @takeScreenshot);
   
   selectCarrierGas = uicontrol('Parent', f); 
   set(selectCarrierGas, 'Style', 'popup'); 
   set(selectCarrierGas, 'String', {'Helium', 'Nitrogen', 'Argon'}); 
   set(selectCarrierGas, 'Units', 'Normalized', 'FontUnits', 'Normalized');
   set(selectCarrierGas, 'Position', [0.89, 0.39, 0.09, 0.035]); 
   set(selectCarrierGas, 'FontSize', 0.6); 
   set(selectCarrierGas, 'BackgroundColor', [0.4, 0.0, 0.8]); 
   set(selectCarrierGas, 'ForegroundColor', [0.2, 1, 1]); 
   set(selectCarrierGas, 'SelectionHighlight', 'off');
   set(selectCarrierGas, 'Callback', @carrierGasChange); 
   
   selectReactant = uicontrol('Parent', f); 
   set(selectReactant, 'Style', 'popup'); 
   set(selectReactant, 'String', {'Other', 'Oxygen'}); 
   set(selectReactant, 'Units', 'Normalized', 'FontUnits', 'Normalized');
   set(selectReactant, 'Position', [0.89, 0.35, 0.09, 0.035]); 
   set(selectReactant, 'FontSize', 0.6); 
   set(selectReactant, 'BackgroundColor', [0.4, 0.0, 0.8]); 
   set(selectReactant, 'ForegroundColor', [0.2, 1, 1]); 
   set(selectReactant, 'SelectionHighlight', 'off');
   set(selectReactant, 'Callback', @reactantChange); 
   
   selectFittingFunction = uicontrol('Parent', f); 
   set(selectFittingFunction, 'Style', 'popup'); 
   set(selectFittingFunction, 'String', {'Radical decay, normal fit', ... 
                                         'Radical decay, wall fit', ... 
                                        'Reaction product that has a zero wall rate', ...
                                        'Reaction product that has a nonzero wall rate', ...
                                        'EQ: Radical decay, product wall rate is zero', ...
                                        'EQ: Radical decay, product wall rate is nonzero', ...
                                        'EQ: Reaction product'}); 
   set(selectFittingFunction, 'Units', 'Normalized', 'FontUnits', 'Normalized');
   set(selectFittingFunction, 'Position', [0.25, 0.22, 0.33, 0.03]); 
   set(selectFittingFunction, 'FontSize', 0.6); 
   set(selectFittingFunction, 'BackgroundColor', [0.4, 0.0, 0.8]); 
   set(selectFittingFunction, 'ForegroundColor', [0.2, 1, 1]); 
   set(selectFittingFunction, 'SelectionHighlight', 'off');
   set(selectFittingFunction, 'Callback', @fittingFunctionSelected); 
   
   
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% "Variables" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   %Here I'm simply naming stuff that I'm going to use later. Also, the axes are created and previously used variables loaded. 
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
   minBG = [];
   maxBG = []; 
   reactant = 'Other';  
   carrierGas = 'Helium'; 
   selectedFunction = 1; 
   
   fittingFunctionSelected; 
   variables = load('variables'); 
   positions = load('positions'); 
   
   set(editTroom, 'String', num2str(variables(1)));
   set(editProom, 'String', num2str(variables(2)));
   set(editFVol, 'String', num2str(variables(3)));
   set(editTime, 'String', num2str(variables(4)));
   set(editPinhole, 'String', num2str(variables(5)));
   set(editpTot, 'String', num2str(variables(6)));
   set(editT2, 'String', num2str(variables(7)));
   set(editL1, 'String', num2str(variables(8)));
   set(editL2, 'String', num2str(variables(9)));
   set(editReacDia, 'String', num2str(variables(10)));
   set(editMVol, 'String', num2str(variables(11)));
   set(editReacDil, 'String', num2str(variables(12)));
   set(editdp, 'String', num2str(variables(13)));
   set(editdt, 'String', num2str(variables(14)));
   set(TroomError, 'String', num2str(variables(15)));
   set(ProomError, 'String', num2str(variables(16)));
   set(FVolError, 'String', num2str(variables(17)));
   set(TimeError, 'String', num2str(variables(18)));
   set(PinholeError, 'String', num2str(variables(19)));
   set(pTotError, 'String', num2str(variables(20)));
   set(T2Error, 'String', num2str(variables(21)));
   set(L1Error, 'String', num2str(variables(22)));
   set(L2Error, 'String', num2str(variables(23)));
   set(ReacDiaError, 'String', num2str(variables(24)));
   set(MVolError, 'String', num2str(variables(25)));
   set(ReacDilError, 'String', num2str(variables(26)));
   set(dpError, 'String', num2str(variables(27)));
   set(dtError, 'String', num2str(variables(28)));
   
   set(editFirstWallRate, 'String', num2str(variables(29)));
   set(firstWallRateError, 'String', num2str(variables(30)));
   if(variables(29) == 999 || variables(30) == 999) 
       set(editFirstWallRate, 'String', 'Give kw1');
       set(firstWallRateError, 'String', 'Give dkw1');
   end
  
   %Make the GUI visible.
   set(f,'Visible','on')
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Internal Functions 

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Functions for listening and changing GUI-components %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Tries to open a given file.
    function openFile(obj, event) 
        
        %This rather long-winded navigation through the binary file is necessary to extract the information we want from the .mcs file headers.
        openedFile = fopen(get(getPath, 'String'), 'r'); 
        tempNumber = fread(openedFile, 1, 'int16');
        if(tempNumber ~= -4) 
            display('Sure it is a mcs file?') 
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
        
        %Here we remove the point, which is caused by the laser pulse. It has much higher value than the others.
        for i = 2:numOfIntegers-1   
            if(theData(i-1,2)*10 < theData(i,2) && theData(i+1,2)*10 < theData(i,2))
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
        [file, path] = uiputfile('*.eps');  
        if(file ~= 0)
            saveas(f, strcat(path, file), 'psc2');  
        else 
            display('You need to give a location.') 
        end  
    end 

    %Open print dialog.
    function printGUI(obj, event)  
        printdlg(f); 
    end 

    %Changes the fitting function.
    function fittingFunctionSelected(obj, event) 
        set(selectFittingFunction, 'Enable', 'off');
        drawnow; 
        set(selectFittingFunction, 'Enable', 'on');
        selection = get(selectFittingFunction, 'Value'); 
        
        resetFitParameterFields;
               
        if(selection == 1 || selection == 2 || selection == 3 || selection == 4 || selection == 7)       
            set(secondAmplitude, 'Visible', 'Off');
            set(editSecondAmplitude, 'Visible', 'Off');
            set(secondAmplitudeError, 'Visible', 'Off');             
            set(backwardRate, 'Visible', 'Off');
            set(editBackwardRate, 'Visible', 'Off');
            set(backwardRateError, 'Visible', 'Off');                 
            set(secondWallRate, 'Visible', 'Off');
            set(editSecondWallRate, 'Visible', 'Off');
            set(secondWallRateError, 'Visible', 'Off');    
            set(secondExp, 'Visible', 'Off'); 
            set(editSecondExp, 'Visible', 'Off');
            set(secondExpError, 'Visible', 'Off');
            set(EQconstant, 'Visible', 'Off'); 
            set(editEQconstant, 'Visible', 'Off');
            set(EQconstantError, 'Visible', 'Off');
            if(selection == 1) 
                set(fittingFunction, 'String', 'y = A + Bexp(-k''*t)') 
                selectedFunction = 1;      
            elseif(selection == 2) 
                set(fittingFunction, 'String', 'y = A + Bexp(-k''*t)')
                selectedFunction = 2; 
            elseif(selection == 3) 
                set(fittingFunction, 'String', 'y = A + B[1 - exp(-k''*t)]')
                selectedFunction = 3;
            elseif(selection == 4) 
                set(secondExp, 'Visible', 'On'); 
                set(editSecondExp, 'Visible', 'On');
                set(secondExpError, 'Visible', 'On');
                set(fittingFunction, 'String', 'y = A + B[exp(-kw*t) - exp(-k''*t)]')
                selectedFunction = 4; 
            else
                set(firstExp, 'String', 'r1');
                set(secondExp, 'String', 'r2');
                set(secondExp, 'Visible', 'On'); 
                set(editSecondExp, 'Visible', 'On');
                set(secondExpError, 'Visible', 'On');
                set(forwardRate, 'Visible', 'Off');
                set(editForwardRate, 'Visible', 'Off');
                set(forwardRateError, 'Visible', 'Off');
                set(firstWallRate, 'Visible', 'Off');
                set(editFirstWallRate, 'Visible', 'Off');
                set(firstWallRateError, 'Visible', 'Off');
                set(fittingFunction, 'String', 'y = A + B[exp(-r1*t) - exp(-r2*t)]')
                selectedFunction = 7; 
            end 
        else
            set(firstExp, 'String', 'r1');
            set(secondExp, 'String', 'r2');
            set(fittingFunction, 'String', 'y = A + Bexp(-r1*t) + Cexp(-r2*t)')
            if(selection == 5)                
                selectedFunction = 5;
            else
                selectedFunction = 6;
            end
        end
    end 

    %Resets the fitting parameters, when fitting function is changed. 
    function resetFitParameterFields
        set(firstExp, 'Visible', 'On'); 
        set(firstExp, 'String', 'k'''); 
        set(editFirstExp, 'Visible', 'On');
        set(editFirstExp, 'String', '-'); 
        set(firstExpError, 'Visible', 'On');
        set(firstExpError, 'String', '-'); 
        
        set(secondExp, 'Visible', 'On'); 
        set(secondExp, 'String', 'kw'''); 
        set(editSecondExp, 'Visible', 'On');
        set(editSecondExp, 'String', '-');  
        set(secondExpError, 'Visible', 'On');
        set(secondExpError, 'String', '-'); 
        
        set(backgroundAverage, 'Visible', 'On'); 
        set(editBackgroundAverage, 'Visible', 'On');
        set(editBackgroundAverage, 'String', '-');  
        set(backgroundAverageError, 'Visible', 'On');
        set(backgroundAverageError, 'String', '-'); 
        
        set(firstAmplitude, 'Visible', 'On'); 
        set(editFirstAmplitude, 'Visible', 'On');
        set(editFirstAmplitude, 'String', '-');  
        set(firstAmplitudeError, 'Visible', 'On');
        set(firstAmplitudeError, 'String', '-');
        
        set(secondAmplitude, 'Visible', 'On'); 
        set(editSecondAmplitude, 'Visible', 'On');
        set(editSecondAmplitude, 'String', '-');  
        set(secondAmplitudeError, 'Visible', 'On');
        set(secondAmplitudeError, 'String', '-');
        
        set(forwardRate, 'Visible', 'On'); 
        set(editForwardRate, 'Visible', 'On'); 
        set(forwardRateError, 'Visible', 'On');
        
        set(backwardRate, 'Visible', 'On'); 
        set(editBackwardRate, 'Visible', 'On');
        set(backwardRateError, 'Visible', 'On');
        
        set(firstWallRate, 'Visible', 'On'); 
        set(editFirstWallRate, 'Visible', 'On');  
        set(firstWallRateError, 'Visible', 'On');

        set(secondWallRate, 'Visible', 'On'); 
        set(editSecondWallRate, 'Visible', 'On');
        set(secondWallRateError, 'Visible', 'On');
        
        set(EQconstant, 'Visible', 'On'); 
        set(editEQconstant, 'Visible', 'On'); 
        set(EQconstantError, 'Visible', 'On');
    end

    %Makes a fit to the graph, after "Fit" has been pressed. 
    function makeFit(obj, event) 
        initParams = []; 
        if(isempty(theData) == 1) 
            display('No Data')
            return;
        end 
        
        %The order of the vertical green lines doesn't matter. Can't be on top of each other. 
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
                
        %The order of the vertical white lines doesn't matter. Can't be on top of each other. 
        if(get(minBG, 'XData') == get(maxBG, 'XData'))
            display('Vertical lines on top of each other')
            return;
        end 
        if(get(minBG, 'XData') < get(maxBG, 'XData'))
            BGmin = get(minBG, 'XData');
            BGmax = get(maxBG, 'XData');
        else
            BGmax = get(minBG, 'XData');
            BGmin = get(maxBG, 'XData');
        end
        
        average = 0; 
        if(BGmax(1) <= theData(1,1))  
            display('The position of the white (background) line sucks')
            return;
        end
               
        %Sums the y-values of the data up until the white vertical line and then takes the average. 
        pointCounter = 0; 
        for i = 1:size(theData,1) 
            if(BGmax(1) < theData(i,1))
                average = average/pointCounter;
                set(editSignalAve, 'String', num2str(average)); 
                break;            
            end 
            if(theData(i,1) >= BGmin(1)) 
                average = average + theData(i,2); 
                pointCounter = pointCounter + 1; 
            end 
        end 
        
        %Deletes a possible previous background signal and plots the new one. 
        delete(backgroundSignal);
        hold on 
        backgroundSignal = plot([BGmin(1), BGmax(1)], [average, average], 'k', 'linewidth', 3); 
        hold off 
        
        %Some sort a guess for initial parameters. They depend on fitting function of course. 
        initParams(1) = average;
        initParams(2) = max(theData(:,2)) - average;
        initParams(3) = 150;
        [exponentialFitInterval] = takeInterval(xmin(1), xmax(1), theData); 
             
        if(selectedFunction == 4) 
            initParams(2) = 2*initParams(2); 
            initParams(3) = 30; 
            initParams(4) = 150; 
        elseif(selectedFunction == 5 || selectedFunction == 6)
            initParams(2) = 2*initParams(2);
            initParams(4) = 0.7*initParams(2); 
            initParams(5) = 110;
        elseif(selectedFunction == 7)
            initParams(2) = 2*initParams(2);
            initParams(3) = 70;
            initParams(4) = 150;
        end
        
        %Get the fit parameters. 
        outputParams = getExponentialFitParameters(exponentialFitInterval, initParams, selectedFunction);
        %Plot the result. 
        plotFittedExponential(exponentialFitInterval, outputParams);
        
        %Set axis limits. 
        set(minLine, 'XData', [min(exponentialFitInterval(:,1)), min(exponentialFitInterval(:,1))]); 
        set(maxLine, 'XData', [max(exponentialFitInterval(:,1)), max(exponentialFitInterval(:,1))]);
        set(minBG, 'XData', [BGmin(1), BGmin(1)]);
        set(maxBG, 'XData', [BGmax(1), BGmax(1)]);
        
        %Save vertical line positions and x-axis limits.  
        position = zeros(1,6);
        
        position(1) = str2double(get(editxMin, 'String'));
        position(2) = str2double(get(editxMax, 'String'));
        position(3) = min(exponentialFitInterval(:,1)); 
        position(4) = max(exponentialFitInterval(:,1));
        position(5) = BGmin(1);
        position(6) = BGmax(1);
        
        %Save the positions to a text file. 
        save('positions', 'position',  '-ascii');
        positions = load('positions');
        
        %Show the fit parameters and data derived from them. 
        changeOutputParams(outputParams);   
    end 
    
    %Change the output parameter text fields after fit.
    function changeOutputParams(params)
        for i = 1:size(params, 2)
            if(isnan(params(i)) == 1) 
                display('Bad output parameters.') 
                return;
            end 
        end 
        
        %We need to know the reactant concentraiton to calculate other stuff (such as the EQ constant). 
        startToCalculate;
        T = str2double(get(editT2, 'String'));
        reactantC = str2double(get(editNreactant, 'String'));
        reactantCError = str2double(get(NreactantError, 'String'));
        wallRate = str2double(get(editFirstWallRate, 'String'));
        wallRateError = str2double(get(firstWallRateError, 'String'));
        
        if(isnan(reactantC) == 1)
            reactantC = 0;
        end
        if(isnan(reactantCError) == 1)
            reactantCError = 0;
        end
        if(isnan(wallRateError) == 1)
            wallRateError = 0;
        end
        if(isnan(wallRate) == 1)
            display('Give the wall rate!')
            kineticParams = zeros(1,8); 
        else 
            kineticParams = calculateKineticStuff(params, T, wallRate, wallRateError, reactantC, reactantCError, selectedFunction);
        end
        
        charArray = cell(size(params, 2), 1); 
        for i = 1:size(params,2) 
            charArray{i} = num2str(params(i)); 
        end 
        %Change the parameter text fields! 
        set(editBackgroundAverage, 'String', charArray{1});
        set(backgroundAverageError, 'String', charArray{2});
        set(editFirstAmplitude, 'String',charArray{3});
        set(firstAmplitudeError, 'String', charArray{4});
        set(editFirstExp, 'String', charArray{5});
        set(firstExpError, 'String', charArray{6});  
        if(selectedFunction == 1 || selectedFunction == 2 || selectedFunction == 3) 
            set(editForwardRate, 'String', num2str(kineticParams(1))); 
            set(forwardRateError, 'String', num2str(kineticParams(2)));  
        elseif(selectedFunction == 4) 
            set(editFirstExp, 'String', charArray{7});
            set(firstExpError, 'String', charArray{8});  
            set(editSecondExp, 'String', charArray{5});
            set(secondExpError, 'String', charArray{6});
            
            set(editForwardRate, 'String', num2str(kineticParams(1))); 
            set(forwardRateError, 'String', num2str(kineticParams(2)));  
        elseif(selectedFunction == 5 || selectedFunction == 6)
            set(editSecondAmplitude, 'String',charArray{7});
            set(secondAmplitudeError, 'String', charArray{8});
            set(editSecondExp, 'String', charArray{9});
            set(secondExpError, 'String', charArray{10});
            
            set(editForwardRate, 'String', num2str(kineticParams(1)));
            set(forwardRateError, 'String', num2str(kineticParams(2)));
            set(editBackwardRate, 'String', num2str(kineticParams(3)));
            set(backwardRateError, 'String', num2str(kineticParams(4)));
            set(editSecondWallRate, 'String', num2str(kineticParams(5)));
            set(secondWallRateError, 'String', num2str(kineticParams(6)));
            set(editEQconstant, 'String', num2str(kineticParams(7)));
            set(EQconstantError, 'String', num2str(kineticParams(8)));  
        else
            set(editSecondExp, 'String', charArray{7});
            set(secondExpError, 'String', charArray{8});
        end 
       
    end 

    %Changes the limits to those in the text fields. 
    function changeLimits(obj, event) 
        xmin = str2double(get(editxMin, 'String')); 
        xmax = str2double(get(editxMax, 'String')); 
        ymin = str2double(get(edityMin, 'String')); 
        ymax = str2double(get(edityMax, 'String')); 
        
        tick = (xmax-xmin)/500.0; 
        minLineX = get(minLine, 'XData'); 
        maxLineX = get(maxLine, 'XData'); 
        BGmin = get(minBG, 'XData'); 
        BGmax = get(maxBG, 'XData'); 
        
        setLimits(xmin, xmax, ymin, ymax); 
       
        if(minLineX(1) > maxLineX(1)) 
            set(minLine, 'XData', maxLineX); 
            set(maxLine, 'Xdata', minLineX); 
            minLineX = get(minLine, 'XData'); 
            maxLineX = get(maxLine, 'XData'); 
        end 
        
        if(BGmin > BGmax) 
            set(minBG, 'XData', BGmax); 
            set(maxBG, 'Xdata', BGmin); 
            BGmin = get(minBG, 'XData'); 
            BGmax = get(maxBG, 'XData'); 
        end 
        
        if(maxLineX(1) > xmax || minLineX(1) < xmin) 
            set(maxLine, 'XData', [xmax-tick*2, xmax-tick*2]); 
            set(minLine, 'XData', [xmin+tick*2, xmin+tick*2]);
        end 
        
        if(BGmax(1) > xmax || BGmin(1) < xmin) 
            set(maxBG, 'XData', [xmax-tick, xmax-tick]); 
            set(minBG, 'XData', [xmin+tick, xmin+tick]);
        end
    end 

    %Gets the data from the textfields to send in for calculations. Also saves variables to a text file. 
    function startToCalculate(obj, event) 
        allData = zeros(1,30); 
        inputData = zeros(1,14); 
        inputDataErrors = zeros(1,14);
        
        %Get the relevant info from the GUI.
        allData(1) = str2double(get(editTroom, 'String'));
        allData(2) = str2double(get(editProom, 'String'));
        allData(3) = str2double(get(editFVol, 'String'));
        allData(4) = str2double(get(editTime, 'String'));
        allData(5) = str2double(get(editPinhole, 'String'));
        allData(6) = str2double(get(editpTot, 'String'));
        allData(7) = str2double(get(editT2, 'String'));
        allData(8) = str2double(get(editL1, 'String'));
        allData(9) = str2double(get(editL2, 'String'));
        allData(10) = str2double(get(editReacDia, 'String'));
        allData(11) = str2double(get(editMVol, 'String'));
        allData(12) = str2double(get(editReacDil, 'String'));
        allData(13) = str2double(get(editdp, 'String'));
        allData(14) = str2double(get(editdt, 'String'));
        
        allData(15) = str2double(get(TroomError, 'String'));
        allData(16) = str2double(get(ProomError, 'String'));
        allData(17) = str2double(get(FVolError, 'String'));
        allData(18) = str2double(get(TimeError, 'String'));
        allData(19) = str2double(get(PinholeError, 'String'));
        allData(20) = str2double(get(pTotError, 'String'));
        allData(21) = str2double(get(T2Error, 'String'));
        allData(22) = str2double(get(L1Error, 'String'));
        allData(23) = str2double(get(L2Error, 'String'));
        allData(24) = str2double(get(ReacDiaError, 'String'));
        allData(25) = str2double(get(MVolError, 'String'));
        allData(26) = str2double(get(ReacDilError, 'String'));
        allData(27) = str2double(get(dpError, 'String'));
        allData(28) = str2double(get(dtError, 'String'));
        
        allData(29) = str2double(get(editFirstWallRate, 'String'));
        allData(30) = str2double(get(firstWallRateError, 'String'));
        
        inputData = allData(1:14);
        inputDataErrors = allData(15:28); 
        
        %Check that the values make sense. 
        for i = 1:14
            if(isnan(inputData(i)) == 1)
                display('Check your parameters!'); 
                return; 
            end 
            if(isnan(inputDataErrors(i)) == 1)
                display('Check your errors!'); 
                return; 
            end 
        end 
        if(isnan(allData(29)) == 1 || isnan(allData(30)) == 1)
                allData(29) = 999; 
                allData(30) = 999; 
        end 
        %Save the given value to a text file. 
        save('variables', 'allData',  '-ascii'); 
            
        for i = 1:14 
            if(inputDataErrors(i) < 0) 
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
            set(editPinhole, 'String', '< 0 or > 1?!'); 
            return; 
        end
        if(inputData(6) <= 0)
            set(editpTot, 'String', '<= 0?!'); 
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
            set(editdp, 'String', '< 0 ?!'); 
            return; 
        elseif(inputData(13) == 0) 
            set(editdt, 'String', '1.0');
            inputData(14) = 1.0; 
        end
        if(inputData(14) <= 0)
            set(editdt, 'String', '<= 0?!'); 
            return; 
        end  
    
        outputData = letsDoSomeMaths(inputData, inputDataErrors, carrierGas, reactant);  
        
        %Makes the results visible. 
        set(editp1, 'String', num2str(outputData(1))); 
        set(p1Error, 'String', num2str(outputData(2)));
        set(editv1, 'String', num2str(outputData(3))); 
        set(v1Error, 'String', num2str(outputData(4)));
        set(editp2, 'String', num2str(outputData(5)));
        set(p2Error, 'String', num2str(outputData(6)));
        set(editv2, 'String', num2str(outputData(7)));
        set(v2Error, 'String', num2str(outputData(8)));
        set(editNreactant, 'String', num2str(outputData(9), '%E'));
        set(NreactantError, 'String', num2str(outputData(10), '%E'));
    end 

    %The selected carrier gas may be useful in viscosity calculations. 
    function carrierGasChange(obj, event) 
        set(selectCarrierGas, 'Enable', 'off');
        drawnow; 
        set(selectCarrierGas, 'Enable', 'on');
        selection = get(selectCarrierGas, 'Value'); 
        if(selection == 1) 
            carrierGas = 'Helium'; 
        elseif(selection == 2) 
            carrierGas = 'Nitrogen'; 
        elseif(selection == 3) 
            carrierGas = 'Argon'; 
        end  
    end 

    %The selected reactant may be useful in viscosity calculations. 
    function reactantChange(obj, event) 
        set(selectReactant, 'Enable', 'off');
        drawnow; 
        set(selectReactant, 'Enable', 'on');
        selection = get(selectReactant, 'Value'); 
        if(selection == 1) 
            reactant = 'Other'; 
        elseif(selection == 2) 
            reactant = 'Oxygen'; 
        end 
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
        %Not particularly efficient, as it goes through all the data points and then forms a matrix 
        %that is one size smaller and replaces the old data matrix with that. 
        for i = 1:size(theData,1)
            if(c > sqrt((xSF*(x-theData(i,1))).^2 + (ySF*(y-theData(i,2))).^2))
                c = sqrt((xSF*(x-theData(i,1))).^2 + (ySF*(y-theData(i,2))).^2); 
                xval = theData(i,1);
                yval = theData(i,2);
            end 
        end 
        theData = removePoint(theData, xval, yval);
       
        positions(1) = str2double(get(editxMin, 'String'));
        positions(2) = str2double(get(editxMax, 'String'));
        
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
           minBG = line;
           maxBG = line;
           NLfit = plot([],[]);
           backgroundSignal = plot([],[]); 
           residualPoints = plot([],[]);  
           residual = plot([],[]); 
           hold on 
           theGraph = plot(thePoints(:,1), thePoints(:,2), 'd', 'Color', 'y'); 
           hold off
           setLimits(min(positions(1)), max(positions(2)), min(thePoints(:,2)) - 0.1*max(thePoints(:,2)), 1.1*max(thePoints(:,2)));
           
           set(editxMin, 'String', num2str(positions(1)));
           set(editxMax, 'String', num2str(positions(2)));
    end 

    %Plots the fit from solved parameters. Also plots the residual under the graph. 
    function plotFittedExponential(anInterval, params) 
        
        %Delete possible old data. 
        residualData = []; 
        delete(residualPoints); 
        delete(NLfit);
        delete(residual); 
  
        %The 'actual' graphs. 
        x = anInterval(:,1);
        if(selectedFunction == 1 || selectedFunction == 2) 
            y1 = params(1) + params(3)*exp(-params(5)*x);      
        elseif(selectedFunction == 3) 
            y1 = params(1) + params(3)*(1 - exp(-params(5)*x));
        elseif(selectedFunction == 4) 
            y1 = params(1) + params(3)*(exp(-params(5)*x) - exp(-params(7)*x));
        elseif(selectedFunction == 5 || selectedFunction == 6) 
            y1 = params(1) + params(3)*exp(-params(5)*x) + params(7)*exp(-params(9)*x); 
        else 
            y1 = params(1) + params(3)*(exp(-params(5)*x) - exp(-params(7)*x));
        end 
              
        %x and y points for the residual data. 
        residualData(:,1) = anInterval(:,1);  
        residualData(:,2) = anInterval(:,2) - y1;
        residualData(:,2) = residualData(:,2) - max(residualData(:,2)) + min(theData(:,2));
        
        %Make a linear fit for the residual data. 
        outputparams = polyfit(residualData(:,1),residualData(:,2),1); 
        y2 = outputparams(1)*x + outputparams(2); 
        
        %Plot both the exponential and the linear function. 
        hold on 
        residual = plot(x, y2, 'linewidth', 3, 'Color', [0.6, 0.3, 0.3]); 
        NLfit = plot(x, y1, 'b', 'linewidth', 3); 
        residualPoints = plot(residualData(:,1), residualData(:,2), 'd', 'Color', [0.2, 0.5, 0.3]); 
        hold off 
        
        %Set new limits. 
        limits = xlim;
        anInterval = takeInterval(limits(1), limits(2), theData); 
       % setLimits(limits(1), limits(2), min(residualData(:,2)), max(theData(:,2)) + 0.1*(max(theData(:,2)) - params(1)));
        setLimits(limits(1), limits(2), min(residualData(:,2)), max(anInterval(:,2)) + 0.1*(max(anInterval(:,2)) - params(1)));
        
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
        set(edityMin, 'String', num2str(ymin));
        set(edityMax, 'String', num2str(ymax))
       
        createMinLine(positions(3), positions(3), ymin, ymax); 
        createMaxLine(positions(4), positions(4), ymin, ymax); 
        createMinBG(positions(5), positions(5), ymin, ymax); 
        createMaxBG(positions(6), positions(6), ymin, ymax);
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

    function createMinBG(xmin, xmax, ymin, ymax)  
        set(minBG, 'XData', [], 'YData', []);
        minBG = line([xmin, xmax], [ymin, ymax], 'Color', 'w', 'LineWidth', 3);
        draggable(minBG, 'h'); 
    end 

    function createMaxBG(xmin, xmax, ymin, ymax)  
        set(maxBG, 'XData', [], 'YData', []);
        maxBG = line([xmin, xmax], [ymin, ymax], 'Color', 'w', 'LineWidth', 3);
        draggable(maxBG, 'h'); 
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
    
    %Gets the fit parameters for a given set of data and for a given fit function. 
    function [outputParams] = getExponentialFitParameters(theData, initParams, selection)
        outputParams = zeros(1, 2*size(initParams, 2));
        background = initParams(1);
        backgroundConstantParameters = initParams(2:size(initParams, 2));
        
        if(selection == 1)
            
            expFunc = @(params, x) params(1) + params(2)*exp(-params(3)*x);
            [parameters, Res, Jac, Cov, MSE] = nlinfit(theData(:,1), theData(:,2), expFunc, initParams);
            
            %Errors
            parameterErrors = sqrt(diag(Cov));
            %confidenceIntervals = nlparci(parameters, Res, 'cov', Cov)
            
            outputParams(1) = parameters(1);
            outputParams(2) = parameterErrors(1);
            outputParams(3) = parameters(2);
            outputParams(4) = parameterErrors(2);
            outputParams(5) = parameters(3);
            outputParams(6) = parameterErrors(3);
        elseif(selection == 2)
            
            expFunc = @(params, x) background + params(1)*exp(-params(2)*x);
            [parameters, Res, Jac, Cov, MSE] = nlinfit(theData(:,1), theData(:,2), expFunc, backgroundConstantParameters);
            
            parameterErrors = sqrt(diag(Cov));
            outputParams(1) = initParams(1);
            outputParams(2) = 0;
            outputParams(3) = parameters(1);
            outputParams(4) = parameterErrors(1);
            outputParams(5) = parameters(2);
            outputParams(6) = parameterErrors(2);
        elseif(selection == 3)
            
            expFunc = @(params, x) background + params(1)*(1 - exp(-params(2)*x));
            [parameters, Res, Jac, Cov, MSE] = nlinfit(theData(:,1), theData(:,2), expFunc, backgroundConstantParameters);
            
            parameterErrors = sqrt(diag(Cov));
            outputParams(1) = initParams(1);
            outputParams(2) = 0;
            outputParams(3) = parameters(1);
            outputParams(4) = parameterErrors(1);
            outputParams(5) = parameters(2);
            outputParams(6) = parameterErrors(2);
        elseif(selection == 4)
            
            expFunc = @(params, x) background + params(1)*(exp(-params(2)*x) - exp(-params(3)*x));
            [parameters, Res, Jac, Cov, MSE] = nlinfit(theData(:,1), theData(:,2), expFunc, backgroundConstantParameters);
            
            parameterErrors = sqrt(diag(Cov));
            outputParams(1) = initParams(1);
            outputParams(2) = 0;
            outputParams(3) = parameters(1);
            outputParams(4) = parameterErrors(1);
            outputParams(5) = parameters(2);
            outputParams(6) = parameterErrors(2);
            outputParams(7) = parameters(3);
            outputParams(8) = parameterErrors(3);
        elseif(selection == 5 || selection == 6)    
            
            expFunc = @(params, x) background + params(1)*exp(-params(2)*x) + params(3)*exp(-params(4)*x);
            [parameters, Res, Jac, Cov, MSE] = nlinfit(theData(:,1), theData(:,2), expFunc, backgroundConstantParameters);
           
            parameterErrors = sqrt(diag(Cov));
            outputParams(1) = initParams(1);
            outputParams(2) = 0;
            outputParams(3) = parameters(1);
            outputParams(4) = parameterErrors(1);
            outputParams(5) = parameters(2);
            outputParams(6) = parameterErrors(2);
            outputParams(7) = parameters(3);
            outputParams(8) = parameterErrors(3);
            outputParams(9) = parameters(4);
            outputParams(10) = parameterErrors(4);
        else 
            
            expFunc = @(params, x) background + params(1)*(exp(-params(2)*x) - exp(-params(3)*x));
            [parameters, Res, Jac, Cov, MSE] = nlinfit(theData(:,1), theData(:,2), expFunc, backgroundConstantParameters);
            
            parameterErrors = sqrt(diag(Cov));
            outputParams(1) = initParams(1);
            outputParams(2) = 0;
            outputParams(3) = parameters(1);
            outputParams(4) = parameterErrors(1);
            outputParams(5) = parameters(2);
            outputParams(6) = parameterErrors(2);
            outputParams(7) = parameters(3);
            outputParams(8) = parameterErrors(3);
        end
    end
    
    %Calculate the velocities, pressures and concentrations. 
    function [outputData] = letsDoSomeMaths(inputData, errorData, carrierGas, reactant)
        
        %Let's see what we are working with. 
        outputData = zeros(1,10); 
        
        Troom  = inputData(1); 
        Proom  = inputData(2);
        FVolume  = inputData(3);
        Time  = inputData(4);
        PinholeCorrection  = inputData(5);
        pCarrierGas  = inputData(6);
        T2  = inputData(7);
        L1  = inputData(8);
        L2  = inputData(9);
        reactorDiameter  = inputData(10);
        MVolume  = inputData(11);
        dilution  = inputData(12);
        dp  = inputData(13);
        dt  = inputData(14); 
        
        TroomError  = errorData(1); 
        ProomError  = errorData(2);
        FVolumeError  = errorData(3);
        TimeError  = errorData(4);
        PinholeCorrectionError  = errorData(5);
        pCarrierGasError  = errorData(6);
        T2Error  = errorData(7);
        L1Error  = errorData(8);
        L2Error  = errorData(9);
        ReactorDiameterError  = errorData(10);
        MVolumeError  = errorData(11);
        DilutionError  = errorData(12);
        dpError  = errorData(13);
        dtError  = errorData(14); 
        
        N = 6.02214129e23;
        R = 8.3144621; 
        
        %Change to SI units. 
        FVolume = FVolume * 1.0e-6;
        MVolume = MVolume * 1.0e-6;
        Proom = 133.3223684211*Proom; 
        pCarrierGas = 133.3223684211*pCarrierGas;   
        dp = 133.3223684211*dp; 
        reactorRadius = reactorDiameter / 200.0;
        L1 = L1/100.0; 
        L2 = L2/100.0;
        dilution = dilution/100.0;   
        
        FVolumeError = FVolumeError * 1.0e-6;
        MVolumeError = MVolumeError * 1.0e-6;
        ProomError = 133.3223684211*ProomError; 
        pCarrierGasError = 133.3223684211*pCarrierGasError;   
        dpError = 133.3223684211*dpError; 
        ReactorRadiusError = ReactorDiameterError / 200.0;
        L1Error = L1Error/100.0; 
        L2Error = L2Error/100.0;
        DilutionError = DilutionError/100.0;   

        PinholeCorrectionError = sqrt((1/(1-PinholeCorrection).^2).^2 *PinholeCorrectionError.^2); 
        PinholeCorrection = 1.0 / (1.0 - PinholeCorrection);
        
        %Calculate the molar flows. Carrier Gas flow obviously includes the precursor flow. 
        reactantFlow = (dp*MVolume)/(R*Troom*dt); 
        reactantFlowError = (MVolume/(R*Troom*dt)).^2 * dpError.^2 + ... 
                            (dp/(R*Troom*dt)).^2 * MVolumeError.^2 + ...
                            ((-dp*MVolume)/(R*Troom.^2 *dt)).^2 * TroomError.^2 + ... 
                            ((-dp*MVolume)/(R*Troom*dt.^2)).^2 * dtError.^2; 
        reactantFlowError = sqrt(reactantFlowError); 
                        
        carrierGasFlow = PinholeCorrection*(Proom*FVolume)/(R*Troom*Time);
        carrierGasFlowError = ((Proom*FVolume)/(R*Troom*Time)).^2 *PinholeCorrectionError.^2 + ... 
                          ((PinholeCorrection*FVolume)/(R*Troom*Time)).^2 * ProomError.^2 + ...
                          ((Proom*PinholeCorrection)/(R*Troom*Time)).^2 * FVolumeError.^2 + ...
                          ((-PinholeCorrection*Proom*FVolume)/(R*Troom.^2 *Time)).^2 * TroomError.^2 + ...
                          ((-PinholeCorrection*Proom*FVolume)/(R*Troom*Time.^2)).^2 * TimeError.^2;
        carrierGasFlowError = sqrt(carrierGasFlowError); 
    
        totalFlow = reactantFlow + carrierGasFlow;
        totalFlowError = sqrt(carrierGasFlowError.^2 + reactantFlowError.^2); 
        
        %Calculate total pressure and the velocity in the beginning of the reactor. 
        p1 = pCarrierGas + (reactantFlow/carrierGasFlow)*pCarrierGas;
        p1Error = (1 + reactantFlow/carrierGasFlow).^2 * pCarrierGasError.^2 + ...
                  (pCarrierGas/carrierGasFlow).^2 * reactantFlowError.^2 + ...
                  (-reactantFlow*pCarrierGas/(carrierGasFlow).^2).^2 * carrierGasFlowError.^2; 
        p1Error = sqrt(p1Error); 
        
        v1 = (totalFlow*R*Troom)/(p1*pi*reactorRadius.^2);
        v1Error = ((R*Troom)/(p1*pi*reactorRadius.^2)).^2 * totalFlowError.^2 + ... 
                  ((totalFlow*R)/(p1*pi*reactorRadius.^2)).^2 * TroomError.^2 + ...
                  ((-totalFlow*R*Troom)/(p1.^2 *pi*reactorRadius.^2)).^2 * p1Error.^2 + ...
                  ((-2*totalFlow*R*Troom)/(p1*pi*reactorRadius.^3)).^2 * ReactorRadiusError.^2; 
        v1Error = sqrt(v1Error); 
       
        [carrierGasViscosity, carrierGasViscosityError] = calculateViscosity(carrierGas, Troom, TroomError); 
        
        if(strcmp(reactant, 'Other') == 1 || dp == 0) 
            totalViscosity = carrierGasViscosity;
            totalViscosityError = carrierGasViscosityError; 
        else 
            [reactantViscosity, reactantViscosityError] = calculateViscosity(reactant, Troom, TroomError);   
            totalViscosity = (carrierGasFlow/totalFlow)*carrierGasViscosity + (reactantFlow/totalFlow)*reactantViscosity;
            totalViscosityError = (carrierGasViscosity/totalFlow).^2 * carrierGasFlowError.^2 + ... 
                                  (carrierGasFlow/totalFlow).^2 * carrierGasViscosityError.^2 + ... 
                                  (reactantViscosity/totalFlow).^2 * reactantFlowError.^2 + ... 
                                  (reactantFlow/totalFlow).^2 * reactantViscosityError.^2 + ... 
                                  ((-carrierGasFlow*carrierGasViscosity-reactantFlow*reactantViscosity)/(totalFlow.^2)).^2 * (totalFlowError).^2; 
            totalViscosityError = sqrt(totalViscosityError);        
        end 
        
        %Calculate pressure drop due to the Hagen–Poiseuille equation in the first section. 
        p2 = sqrt(p1.^2 - (16*totalFlow*L1*totalViscosity*R*Troom)/(reactorRadius.^4 * pi)); 
        p2Error = ((-8*L1*totalViscosity*R*Troom)/(reactorRadius.^4 * pi * p2)).^2 * totalFlowError.^2 + ... 
                  ((-8*totalFlow*totalViscosity*R*Troom)/(reactorRadius.^4 * pi * p2)).^2 * L1Error.^2 + ... 
                  ((-8*totalFlow*L1*R*Troom)/(reactorRadius.^4 * pi * p2)).^2 * totalViscosityError.^2 + ... 
                  ((-8*totalFlow*L1*totalViscosity*R)/(reactorRadius.^4 * pi * p2)).^2 * TroomError.^2 + ... 
                  ((32*totalFlow*L1*totalViscosity*R*Troom)/(reactorRadius.^5 * pi * p2)).^2 * ReactorRadiusError.^2 + ...
                  (p1/p2).^2 * p1Error.^2; 
        p2Error = sqrt(p2Error); 
         
        %Calculate viscosity with Sutherland's formula. 
        [carrierGasViscosity, carrierGasViscosityError] = calculateViscosity(carrierGas, T2, T2Error);
        
        if(strcmp(reactant, 'Other') == 1 || dp == 0) 
            totalViscosity = carrierGasViscosity;
            totalViscosityError = carrierGasViscosityError; 
        else 
            [reactantViscosity, reactantViscosityError] = calculateViscosity(reactant, T2, T2Error);   
            totalViscosity = (carrierGasFlow/totalFlow)*carrierGasViscosity + (reactantFlow/totalFlow)*reactantViscosity;
            totalViscosityError = (carrierGasViscosity/totalFlow).^2 * carrierGasFlowError.^2 + ... 
                                  (carrierGasFlow/totalFlow).^2 * carrierGasViscosityError.^2 + ... 
                                  (reactantViscosity/totalFlow).^2 * reactantFlowError.^2 + ... 
                                  (reactantFlow/totalFlow).^2 * reactantViscosityError.^2 + ... 
                                  ((-carrierGasFlow*carrierGasViscosity-reactantFlow*reactantViscosity)/(totalFlow.^2)).^2 * (totalFlowError).^2; 
            totalViscosityError = sqrt(totalViscosityError);        
        end 

        %Calculate the pressure drop in the second section.
        p3 = sqrt(p2.^2 - (16*totalFlow*L2*totalViscosity*R*T2)/(reactorRadius.^4 * pi)); 
        p3Error = ((-8*L2*totalViscosity*R*T2)/(reactorRadius.^4 * pi * p3)).^2 * totalFlowError.^2 + ... 
                  ((-8*totalFlow*totalViscosity*R*T2)/(reactorRadius.^4 * pi * p3)).^2 * L2Error.^2 + ... 
                  ((-8*totalFlow*L2*R*T2)/(reactorRadius.^4 * pi * p3)).^2 * totalViscosityError.^2 + ... 
                  ((-8*totalFlow*L2*totalViscosity*R)/(reactorRadius.^4 * pi * p3)).^2 * T2Error.^2 + ... 
                  ((32*totalFlow*L2*totalViscosity*R*T2)/(reactorRadius.^5 * pi * p3)).^2 * ReactorRadiusError.^2 + ...
                  (p2/p3).^2 * p2Error.^2; 
        p3Error = sqrt(p3Error); 
        
        %Calculate the final concetration, flow speed and pressure at the pinhole. 
        v2 = (totalFlow*R*T2)/(p3*pi*reactorRadius.^2); 
        v2Error = ((R*T2)/(p3*pi*reactorRadius.^2)).^2 * totalFlowError.^2 + ... 
                  ((totalFlow*R)/(p1*pi*reactorRadius.^2)).^2 * T2Error.^2 + ...
                  ((-totalFlow*R*T2)/(p1.^2 *pi*reactorRadius.^2)).^2 * p3Error.^2 + ...
                  ((-2*totalFlow*R*T2)/(p3*pi*reactorRadius.^3)).^2 * ReactorRadiusError.^2; 
        v2Error = sqrt(v2Error); 
        
        Nreactant = dilution * (reactantFlow*p3)/(totalFlow*R*T2) *(N*1.0e-6); 
        NreactantError = ((reactantFlow*p3)/(totalFlow*R*T2) *(N*1.0e-6)).^2 * DilutionError.^2 + ... 
                         ((dilution*p3)/(totalFlow*R*T2) *(N*1.0e-6)).^2 * reactantFlowError.^2 + ... 
                         ((reactantFlow*dilution)/(totalFlow*R*T2) *(N*1.0e-6)).^2 * p3Error.^2 + ... 
                         ((-dilution*reactantFlow*p3)/(totalFlow.^2 *R*T2) *(N*1.0e-6)).^2 * totalFlowError.^2 + ... 
                         ((-dilution*reactantFlow*p3)/(totalFlow*R*T2.^2) *(N*1.0e-6)).^2 * T2Error.^2; 
        NreactantError = sqrt(NreactantError); 
        
        p1 = p1/133.3223684211;
        p1Error = p1Error/133.3223684211;
        p3 = p3/133.3223684211; 
        p3Error = p3Error/133.3223684211; 
        
        %Send back the calculated values. 
        outputData(1) = p1; 
        outputData(2) = p1Error; 
        outputData(3) = v1; 
        outputData(4) = v1Error; 
        outputData(5) = p3; 
        outputData(6) = p3Error;
        outputData(7) = v2;
        outputData(8) = v2Error; 
        outputData(9) = Nreactant;
        outputData(10) = NreactantError;  
    end 
    
    %Calculate the rate constants and EQ constants 
    function [outputData] = calculateKineticStuff(params, T, wallRate, wallRateError, reactantC, reactantCError, selection)
       
        if(selection == 1 || selection == 2 || selection == 3) 
            if(reactantC == 0) 
                rateConstant = 0; 
                rateConstantError = 0; 
            else 
                rateConstant = (params(5) - wallRate)/(reactantC); 
                rateConstantError = (1/reactantC).^2 * (params(6)).^2  + ...
                                  (-1/reactantC).^2 * (wallRateError).^2 + ...
                                  ((wallRate - params(5))/(reactantC).^2).^2 * (reactantCError).^2;
                rateConstantError = sqrt(rateConstantError); 
            end 
            
            outputData(1) = rateConstant; 
            outputData(2) = rateConstantError;
        elseif(selection == 4) 
            if(reactantC == 0) 
                rateConstant = 0; 
                rateConstantError = 0; 
            else 
                rateConstant = (params(7) - wallRate)/(reactantC); 
                rateConstantError = (1/reactantC).^2 * (params(8)).^2  + ...
                                  (-1/reactantC).^2 * (wallRateError).^2 + ...
                                  ((wallRate - params(7))/(reactantC).^2).^2 * (reactantCError).^2;
                rateConstantError = sqrt(rateConstantError); 
            end 
            
            outputData(1) = rateConstant; 
            outputData(2) = rateConstantError;
            
        elseif(selection == 5 || selection == 6)  
            if(reactantC == 0) 
                outputData = zeros(1,8); 
            else 
                F = params(3)/params(7);
                Ferror = (1/params(7)).^2 * (params(4)).^2 + ... 
                       (-F/params(7)).^2 * (params(8)).^2;
                Ferror = sqrt(Ferror);
                
                alpha = (params(5)*F + params(9))/(1 + F) - wallRate;
                alphaError = (F/(F+1)).^2 * (params(6)).^2 + ...
                           ( params(5)/(F+1) - (params(5)*F+params(9))/((F+1).^2) ).^2 * (Ferror).^2 + ... 
                           (F/(F+1)).^2 * (params(10)).^2 + ...
                           (-1).^2 * (wallRateError).^2; 
                alphaError = sqrt(alphaError);
                
                if(selection == 6) 
                    delta = (params(5)*params(9) - wallRate * ((params(5) + params(9)*F)/(1+F)) )/(alpha);
                    deltaError = ( -delta/alpha ).^2 * (alphaError).^2 + ...
                               ( (params(9)/alpha - wallRate/(alpha*(1+F))) ).^2 * (params(6)).^2 + ...
                               ( (params(5)/alpha - wallRate*F/(alpha*(1+F))) ).^2 * (params(10)).^2 + ...  
                               ( -params(5)/(alpha*(1+F)) - params(9)*F/(alpha*(1+F)) ).^2 * (wallRateError).^2 + ... 
                               ( -(wallRate/alpha) * (params(9)/(1+F) - (params(5) + params(9)*F)/((1+F).^2)) ).^2 * (Ferror).^2 ;
                    deltaError = sqrt(deltaError);
                else 
                    delta = 0; 
                    deltaError = 0; 
                end 
                
                beta = params(5) + params(9) - alpha - wallRate - delta ;
                betaError = (params(6)).^2 + (params(10)).^2 + (alphaError).^2 + (wallRateError).^2 + (deltaError).^2; 
                betaError = sqrt(betaError); 
                rateConstantF = alpha/reactantC;
                rateConstantFerror = (1/reactantC).^2 * (alphaError).^2 + ... 
                                   (rateConstantF/reactantC).^2 * (reactantCError).^2; 
                rateConstantFerror = sqrt(rateConstantFerror);
                
                rateConstantB = beta ;
                rateConstantBerror = betaError;
                
                equilibriumConstant = rateConstantF/rateConstantB;
                equilibriumConstantError = (1/rateConstantB).^2 * (rateConstantFerror).^2 + ... 
                                         (equilibriumConstant/rateConstantB).^2 * (rateConstantBerror).^2; 
                equilibriumConstantError = sqrt(equilibriumConstantError);
                
                equilibriumConstant = 1.0e-1 * 6.02214129e23 * equilibriumConstant /(8.3144621*T);
                equilibriumConstantError = 1.0e-1 * 6.02214129e23 * equilibriumConstantError /(8.3144621*T);
                
                %Take the natural log of the EQ constant. 
                equilibriumConstantError = equilibriumConstantError/equilibriumConstant; 
                equilibriumConstant = log(equilibriumConstant); 
                
                outputData(1) = rateConstantF; 
                outputData(2) = rateConstantFerror;
                outputData(3) = rateConstantB; 
                outputData(4) = rateConstantBerror;
                outputData(5) = delta; 
                outputData(6) = deltaError;
                outputData(7) = equilibriumConstant; 
                outputData(8) = equilibriumConstantError;        
            end       
        else 
            outputData = zeros(1,8);
        end 
    end
        
    %Calculate the viscosity of a selected substance. 
    function [viscosity, viscosityError] = calculateViscosity(substance, T, dT) 
    
        if(strcmp(substance, 'Helium') == 1) 
            C = 79.4;                             %Sutherlands Constant
            T0 = 288.15;                          %Reference Temperature
            Visc0 = 1.9266e-5;                    %Reference Viscosity   
        elseif(strcmp(substance, 'Nitrogen') == 1) 
            C = 111;                           
            T0 = 300.55;                        
            Visc0 = 1.781e-5;   
        elseif(strcmp(substance, 'Argon') == 1) 
            C = 144.4;                           
            T0 = 273.11;                        
            Visc0 = 2.125e-5;   
        elseif(strcmp(substance, 'Oxygen') == 1) 
            C = 127;                           
            T0 = 292.25;                        
            Visc0 = 2.018e-5;                         
        end 
        viscosity = Visc0*(T0 + C)*T.^(1.5) / (T0.^(1.5)*(T + C));
        viscosityError = ( (Visc0*(T0 + C)/(T0.^(1.5))) * ... 
                             ( 1.5*T.^(0.5)*(T + C).^(-1.0)  - T.^(1.5)*(T + C).^(-2.0)) ).^2 * dT.^2; 
        viscosityError = sqrt(viscosityError);
    end 
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
%End External Functions
 
    
    
    
