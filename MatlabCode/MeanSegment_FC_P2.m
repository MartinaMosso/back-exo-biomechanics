%% mean rep to 1 segment

clear; clc; close all

%% import rep1, 2, 3, 4

load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep1_FC_yesExo.mat');
load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep2_FC_yesExo.mat');
load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep3_FC_yesExo.mat');
load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep4_FC_yesExo.mat');
rep1_FC_5 = rep1.FC/(75*9.81);
rep2_FC_5 = rep2.FC/(75*9.81);
rep3_FC_5 = rep3.FC/(75*9.81);
rep4_FC_5  = rep4.FC/(75*9.81);
load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep1_FC_yesExo_004.mat');
load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep2_FC_yesExo_004.mat');
load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep3_FC_yesExo_004.mat');
load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep4_FC_yesExo_004.mat');
rep1_FC_4 = rep1.FC/(84*9.81);
rep2_FC_4 = rep2.FC/(84*9.81);
rep3_FC_4 = rep3.FC/(84*9.81);
rep4_FC_4  = rep4.FC/(84*9.81);


rep1_FC_all = [rep1_FC_5; rep1_FC_4];
rep2_FC_all = [rep2_FC_5; rep2_FC_4];
rep3_FC_all = [rep3_FC_5; rep3_FC_4];
rep4_FC_all = [rep4_FC_5; rep4_FC_4];


%% FC
rep1_FC = mean(rep1_FC_all);
rep2_FC = mean(rep2_FC_all);
rep3_FC = mean(rep3_FC_all);
rep4_FC = mean(rep4_FC_all);


%% PLOT IK
rep1_FC = rep1_FC(:);
rep2_FC = rep2_FC(:);
rep3_FC = rep3_FC(:);
rep4_FC = rep4_FC(:);
gapLength = 200;                     % lunghezza del gap (più corto dei 1001)
nCols     = size(rep1_FC, 2);        % numero di colonne

gap = NaN(gapLength, nCols);  
% Concatenazione dei vettori con gap
V = [rep1_FC; 
    gap;
    rep2_FC; 
    gap; 
    rep3_FC; 
    gap; 
    rep4_FC];

figure; hold on;
plot(V, 'LineWidth', 1.2);

% ---- Aggiunta linee verticali ----
% === Calcolo posizioni delle linee verticali ===
segmentLength = size(rep1_FC, 1);

% Inizio/fine gap 1 (tra rep1 e rep2)
gap1_start = segmentLength + 1;
gap1_end   = segmentLength + gapLength;

% Inizio/fine gap 2 (tra rep2 e rep3)
gap2_start = segmentLength + gapLength + segmentLength + 1;
gap2_end   = segmentLength + gapLength + segmentLength + gapLength;

% Inizio/fine gap 3 (tra rep3 e rep4)
gap3_start = segmentLength + 2*(gapLength + segmentLength) + 1;
gap3_end   = segmentLength + 2*(gapLength + segmentLength) + gapLength;

% Raccogli posizioni linee
xlines = [gap1_start, gap1_end, ...
          gap2_start, gap2_end, ...
          gap3_start, gap3_end];

% Disegna le linee
for x = xlines
    xline(x, '--k', 'LineWidth', 1);
end
center1 = segmentLength/2;
center2 = gap1_end + segmentLength/2;
center3 = gap2_end + segmentLength/2;
center4 = gap3_end + segmentLength/2;

xticks([center1 center2 center3 center4]);
xticklabels({'Lift 1','Drop 1','Lift 2','Drop 2'});


xlabel('Cycle')
ylabel('L5S1 Comp Forces [Nm/BW]');
title('Mean Compressive Forces');
hold off;

