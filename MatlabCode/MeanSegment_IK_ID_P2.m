%% mean rep to 1 segment

clear; clc; close all

%% import rep1, 2, 3, 4
% 
load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep1_IK_ID.mat');
load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep2_IK_ID.mat');
load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep3_IK_ID.mat');
load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep4_IK_ID.mat');

% load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep1_IK_ID_yesExo.mat');
% load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep2_IK_ID_yesExo.mat');
% load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep3_IK_ID_yesExo.mat');
% load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep4_IK_ID_yesExo.mat');
rep1_IK_5 = rep1.IK;
rep2_IK_5 = rep2.IK;
rep3_IK_5 = rep3.IK;
rep4_IK_5  = rep4.IK;
% rep1_ID_5 = rep1.ID/75;
% rep2_ID_5 = rep2.ID/75;
% rep3_ID_5 = rep3.ID/75;
% rep4_ID_5  = rep4.ID/75;

% 
% load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep1_IK_ID_004.mat');
% load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep2_IK_ID_004.mat');
% load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep3_IK_ID_004.mat');
% load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep4_IK_ID_004.mat');
% load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep1_IK_ID_yesExo_004.mat');
% load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep2_IK_ID_yesExo_004.mat');
% load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep3_IK_ID_yesExo_004.mat');
% load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep4_IK_ID_yesExo_004.mat');
% rep1_IK_4 = rep1.IK;
% rep2_IK_4 = rep2.IK;
% rep3_IK_4 = rep3.IK;
% rep4_IK_4  = rep4.IK;
% rep1_ID_4 = rep1.ID/84;
% rep2_ID_4 = rep2.ID/84;
% rep3_ID_4 = rep3.ID/84;
% rep4_ID_4  = rep4.ID/84;
% 
% rep1_IK_all = [rep1_IK_5; rep1_IK_4];
% rep2_IK_all = [rep2_IK_5; rep2_IK_4];
% rep3_IK_all = [rep3_IK_5; rep3_IK_4];
% rep4_IK_all = [rep4_IK_5; rep4_IK_4];
% 
% rep1_ID_all = [rep1_ID_5; rep1_ID_4];
% rep2_ID_all = [rep2_ID_5; rep2_ID_4];
% rep3_ID_all = [rep3_ID_5; rep3_ID_4];
% rep4_ID_all = [rep4_ID_5; rep4_ID_4];
%% plot per irfan

reps   = {rep1_IK_5, rep2_IK_5, rep3_IK_5, rep4_IK_5};
titles = {'Lift 1 - station A', 'Drop 1 - station B', 'Lift 2 - station B', 'Drop 2 - station A'};

figure;
for i = 1:4
    subplot(2,2,i); hold on; grid on;
    
    data = reps{i};
    [nDoF, nSamples] = size(data);
    
    % time axis (here just sample index, change to real time if you have it)
    t = 1:nSamples;
    
    % plot all IK angles (each row = one DoF / joint)
    plot(t, data, LineWidth=2);
    
    xlabel('Samples');
    ylabel('Angle [deg]');
    title(titles{i});
end
sgtitle('IK angles for 4 repetitions');

%% IK
rep1_IK = mean(rep1_IK_all);
rep2_IK = mean(rep2_IK_all);
rep3_IK = mean(rep3_IK_all);
rep4_IK = mean(rep4_IK_all);

%% ID
rep1_ID = mean(rep1_ID_all);
rep2_ID = mean(rep2_ID_all);
rep3_ID = mean(rep3_ID_all);
rep4_ID = mean(rep4_ID_all);

%% PLOT IK
rep1_IK = rep1_IK(:);
rep2_IK = rep2_IK(:);
rep3_IK = rep3_IK(:);
rep4_IK = rep4_IK(:);
gapLength = 200;                     % lunghezza del gap (più corto dei 1001)
nCols     = size(rep1_IK, 2);        % numero di colonne

gap = NaN(gapLength, nCols);  
% Concatenazione dei vettori con gap
V = [rep1_IK; 
    gap;
    rep2_IK; 
    gap; 
    rep3_IK; 
    gap; 
    rep4_IK];

figure; hold on;
plot(V, 'LineWidth', 1.2);

% ---- Aggiunta linee verticali ----
% === Calcolo posizioni delle linee verticali ===
segmentLength = size(rep1_IK, 1);

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
ylabel('L5S1 Flex/Ext Angle [°]');
title('Mean Inverse Kinematics');
hold off;

%% PLOT ID

rep1_ID = rep1_ID(:);
rep2_ID = rep2_ID(:);
rep3_ID = rep3_ID(:);
rep4_ID = rep4_ID(:);
gapLength = 200;                     % lunghezza del gap (più corto dei 1001)
nCols     = size(rep1_ID, 2);        % numero di colonne

gap = NaN(gapLength, nCols);  
% Concatenazione dei vettori con gap
V = [rep1_ID; 
    gap;
    rep2_ID; 
    gap; 
    rep3_ID; 
    gap; 
    rep4_ID];

% V_exo =

figure; hold on;
plot(V, 'LineWidth', 1.2);

% ---- Aggiunta linee verticali ----
% === Calcolo posizioni delle linee verticali ===
segmentLength = size(rep1_ID, 1);

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


xlabel('Cycle');
ylabel('L5S1 Moment [Nm/kg]');
title('Mean Inverse Dynamics');
hold off;
