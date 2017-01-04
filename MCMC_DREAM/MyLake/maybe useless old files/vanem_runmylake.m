                                % clear all
warning('off')
format compact
tic

dt = 1.0;

warning off all; 

mylakett = 1;                     %counting the number of runs

%%                       1);
nkind = 5
% nkind = size(observation, 2) - 5;
%% ndates = size(observation, 1);
m_start=[2003, 4, 1]
m_stop=[2010, 12, 31]
csvwrite('vanem_output/dateinformation.csv', [m_start; m_stop])
inputfile='vanem_c1_m1_input'
initfile='vanem_init_v12_20120215.txt' % 
parafile='vanem_para_v12_1b_20121119.txt'

[In_Z,In_Az,tt,In_Tz,In_Cz,In_Sz,In_TPz,In_DOPz,In_Chlz,...
 In_DOCz,In_TPz_sed,In_Chlz_sed,In_FIM,Ice0,Wt,Inflw,...
 Phys_par,Phys_par_range,Phys_par_names,...
 Bio_par,Bio_par_range,Bio_par_names]...
    = modelinputs_v12_1b(m_start,m_stop,...
                         initfile,'duh',...
                         inputfile,'duh',...
                         parafile,'duh',dt);
mylakett = tt;
clear tt
length(mylakett)
                                % Aeff_nom = In_Az(1);
                                % Aeff_nom = In_Az(1) * 0.1 ; % new 2012-02-15 the effective surface area
                                %                      % for these processes is actually much
                                %                      % smaller, probably about one tenth to
                                %                      % twentieth KTO koji
                                % Kz_N0_nom=Phys_par(4);
sizeWt = size(Wt)

PAR_sat_nom = Phys_par(10);
S_res_epi_nom = Bio_par(3);
Uz_Sz_nom = Bio_par(8);
Uz_Chl_nom = Bio_par(9);
m_twty_nom = Bio_par(11);
g_twty_nom = Bio_par(12);
Psat_Lang_nom = Bio_par(6);
                                %% Fmax_Lang_nom = Bio_par(7);
phys_par_2_nom = Phys_par(2);
                                %% phys_par_4_nom = Phys_par(4);
phys_par_5_nom = Phys_par(5);

phys_par_9_nom = Phys_par(9);


% %%%%%%%%
% newpar = dlmread('parameters.csv')%newpar = dlmread('newpar.csv')
% %%%%%%%%
% 
% 
% 
%                                 % Phys_par(2) = 0.00706*(Aeff_nom*(10^newpar(1))/1.0e+6)^0.56;             
%                                 % Phys_par(5) =  1-exp(-0.3*Aeff_nom*(10^newpar(2))/1.0e+6); 
%                                 % Phys_par(4) = Kz_N0_nom*(10^newpar(3)); 
% Phys_par(10) = PAR_sat_nom * (10 ^ newpar(1));
% Bio_par(3) = S_res_epi_nom * (10 ^ newpar(2));
% Bio_par(8) = Uz_Sz_nom * (10 ^ newpar(3));
% Bio_par(9) = Uz_Chl_nom * (10 ^ newpar(4));
% Bio_par(11) = m_twty_nom * (10 ^ newpar(5));
% Bio_par(12) = g_twty_nom * (10 ^ newpar(6));
% Bio_par(6) = Psat_Lang_nom * (10 ^ newpar(7));
%                                 %% Bio_par(7) = Fmax_Lang_nom * (10 ^ 0);
% Phys_par(2) = phys_par_2_nom * (10 ^ newpar(8));
%                                 %% Phys_par(4) = phys_par_4_nom * (10 ^ newpar(9));
% Phys_par(5) = phys_par_5_nom * (10 ^ newpar(9));
% 
% Phys_par(9) = newpar(10);

                                %% display(['the values are within prior distribution limit, right?'])
                                % tt_reserve = tt;
%% Inflw(:, 6) = repmat(newpar(8), size(Inflw, 1), 1);

inactivePinSS = Inflw(:, 4) * 655;
leftoverP = Inflw(:, 5) - inactivePinSS;
newDOP = min(Inflw(:, 6), leftoverP);
leftoverP = leftoverP - newDOP;
newChla = min(Inflw(:, 7), leftoverP);
leftoverP = leftoverP - newChla;
newC = min(Inflw(:, 3), leftoverP);
Inflw(:, 3) = newC;
Inflw(:, 6) = newDOP;
Inflw(:, 7) = newChla;




tt = mylakett;
                                %% length(tt)
                                %% size(Wt)
%asctime(localtime(time()))
Wt_reserve = Wt;
%% [zz,Az,Vz,tt,Qst,Kzt,Tzt,Czt,Szt,Pzt, ...
%%  Chlzt,PPzt,DOPzt,DOCzt,lambdazt, ...
%%  His,DoF,DoM,MixStat,Wt] ...
[zz,Az,Vz,tt,Qst,Kzt,Tzt,Czt,Szt,Pzt,Chlzt,PPzt,DOPzt,DOCzt,Qzt_sed,lambdazt,...
 P3zt_sed,P3zt_sed_sc,His,DoF,DoM,MixStat,Wt] ...
    = solvemodel_v12_1b(m_start,m_stop, ...
                        initfile,'duh', ...
                        inputfile,'duh', ...
                        parafile,'duh', ...
                        In_Z,In_Az,tt,In_Tz,In_Cz,In_Sz,In_TPz, ...
                        In_DOPz,In_Chlz,In_DOCz,In_TPz_sed, ...
                        In_Chlz_sed,In_FIM,Ice0,Wt,Inflw, ...
                        Phys_par,Phys_par_range,Phys_par_names, ...
                        Bio_par,Bio_par_range,Bio_par_names);
mylakett = tt;
clear tt
Wt = Wt_reserve;
                                % tt = tt_reserve;
                                %     for kind=1:nkind  % NEW KTO Koji 
ndays = size(Czt, 2);

modelseries = (Czt + Pzt + Chlzt + PPzt + DOPzt)';
modelseries1 = mean(modelseries(:, 1:4), 2);
dlmwrite('vanem_output/totalP.csv',         modelseries1,         'delimiter', ',',         'precision', 4);
modelseries2 = sum(modelseries(:, 1:4) .* (ones(ndays, 1) * [4 3 2 1]), 2) / 10; 
dlmwrite('vanem_output/totalPweighted.csv',          modelseries2,         'delimiter', ',',         'precision', 4);
modelseries = (Czt + Chlzt + PPzt)';
modelseries1 = mean(modelseries(:, 1:4), 2);
dlmwrite('vanem_output/POPandPIP.csv',          modelseries1,         'delimiter', ',',         'precision', 4);
         modelseries2 = sum(modelseries(:, 1:4) .* (ones(ndays, 1) * [4 3 2 1]), 2) / 10; 
dlmwrite('vanem_output/POPandPIPweighted.csv',          modelseries2,         'delimiter', ',',         'precision', 4);

modelseries = Szt' * 1000;
modelseries1 = mean(modelseries(:, 1:4), 2);
dlmwrite('vanem_output/SGR.csv',          modelseries1,         'delimiter', ',',         'precision', 4);
modelseries2 = sum(modelseries(:, 1:4) .* (ones(ndays, 1) * [4 3 2 1]), 2) / 10; 
dlmwrite('vanem_output/SGRweighted.csv',          modelseries2,         'delimiter', ',',         'precision', 4);

modelseries = (Czt + Chlzt)';
modelseries1 = mean(modelseries(:, 1:4), 2);
dlmwrite('vanem_output/POP.csv',          modelseries1,         'delimiter', ',',         'precision', 4);
modelseries2 = sum(modelseries(:, 1:4) .* (ones(ndays, 1) * [4 3 2 1]), 2) / 10; 
dlmwrite('vanem_output/POPweighted.csv',          modelseries2,         'delimiter', ',',         'precision', 4);

modelseries = Pzt';
modelseries1 = mean(modelseries(:, 1:4), 2);
dlmwrite('vanem_output/DIP.csv',          modelseries1,         'delimiter', ',',         'precision', 4);
modelseries2 = sum(modelseries(:, 1:4) .* (ones(ndays, 1) * [4 3 2 1]), 2) / 10; 
dlmwrite('vanem_output/DIPweighted.csv',          modelseries2,         'delimiter', ',',         'precision', 4);

modelseries = Tzt';
day1 = datenum(m_start);
day2 = datenum([2010, 5, 12]);
day3 = datenum([2010, 8, 18]);
position1 = day2 - day1 + 1;
position2 = day3 - day1 + 1;
dlmwrite('vanem_output/Tzt2010-05-12.csv',          modelseries(position1:position2, :),         'delimiter', ',',         'precision', 4);modelseries1 = mean(modelseries(:, 1:4), 2);
dlmwrite('vanem_output/temperature.csv',          modelseries1,         'delimiter', ',',         'precision', 4);
modelseries2 = sum(modelseries(:, 1:4) .* (ones(ndays, 1) * [4 3 2 1]), 2) / 10; 
dlmwrite('vanem_output/temperatureweighted.csv',          modelseries2,         'delimiter', ',',         'precision', 4);


modelseries = DOPzt';
modelseries1 = mean(modelseries(:, 1:4), 2);
dlmwrite('vanem_output/DOP.csv',          modelseries1,         'delimiter', ',',         'precision', 4);
modelseries2 = sum(modelseries(:, 1:4) .* (ones(ndays, 1) * [4 3 2 1]), 2) / 10; 
dlmwrite('vanem_output/DOPweighted.csv',          modelseries2,         'delimiter', ',',         'precision', 4);

modelseries = DOCzt';
modelseries1 = mean(modelseries(:, 1:4), 2);
dlmwrite('vanem_output/DOC.csv',          modelseries1,         'delimiter', ',',         'precision', 4);
modelseries2 = sum(modelseries(:, 1:4) .* (ones(ndays, 1) * [4 3 2 1]), 2) / 10; 
dlmwrite('vanem_output/DOCweighted.csv',          modelseries2,         'delimiter', ',',         'precision', 4);

dlmwrite('vanem_output/volumeflowout.csv',          Inflw(:, 1) + Wt(:, 7) * Az(1) / 1000,         'delimiter', ',',         'precision', 9); %% m3 day-1    

modelseries = lambdazt';
dlmwrite('lightattenuationdepths.csv',         modelseries,         'delimiter', ',',         'precision', 4);

modelseries = Qst';
dlmwrite('Qst.csv',          modelseries,         'delimiter', ',',         'precision', 4);

                                % system('Rscript calculateSS.R'); move out of script
