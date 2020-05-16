%%
% *************************************************************************
% *     functions: run the BSM for different soil mositure content        *
% *     Authors:   Peiqi Yang (p.yang@utwente.nl)                         *
% *     Date:      12/May/2020                                            *
% *     Faculty of Geo-Information Science and Earth Observation (ITC)    *
% *     University of Twente, 7500 AE Enschede, The Netherlands           *
% *************************************************************************
clear; close all; clc

%% 1) model input parameters 
soilpar.B   =  0.5;         % soil brightness [0-1]
soilpar.lat =  -10;           % spectral shape latitude (range = -30 - 30 deg)
soilpar.lon =  100;         % spectral shape longitude (range = 80 - 120 deg)
soilpar.SMp =  25;          % soil moisture volume percentage (5 - 55)

%% 2) model default configuration 
spec        =   readtable('BSM_coef.dat');
kw          =   spec.Kw;          % water absorption spectrum
nw          =   spec.nw;          % water refraction index spectrum
spec.GSV    =   [spec.GSV1,spec.GSV2,spec.GSV3]; % Global Soil Vectors spectra (nwl * 3)

emp.film    =   0.015;      % single water film optical thickness
emp.SMC     =   25;         % soil moisture capacity parameter
nwl         =   length(spec.wl);

%% 3) run the model; Example 1, different soil mositure 
SMp_all     =   [0,20,50];
nsim        =   length(SMp_all);
rwet        =   zeros(nwl,nsim);

for jj=1:length(SMp_all)
    soilpar.SMp     =   SMp_all(jj);
    rwet(:,jj)      =   BSM(soilpar,spec,emp);    
end 

%% 4) make a plot
figure(1)
pl          =   plot(spec.wl,rwet);
set(pl(1),'color',[0.1,0.1,0.1]*8,'linewidth',2)
set(pl(2),'color',[0.1,0.1,0.1]*5,'linewidth',2)
set(pl(3),'color',[0.1,0.1,0.1]*2,'linewidth',2)

xlabel('wl (nm)');      xlim([400,2400]);
ylabel('reflectance');  ylim([0,0.7])
title('soil reflectance from BSM')
legend('dry soil','soil mositure =20\%','soil mositure =50\%','location','northwest');
legend boxoff
set(gcf,'color','w','position',[30,30,1200,600])