%% mean rep to 1 segment

clear; clc; close all

%% import rep1, 2, 3, 4

% load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep1_EMG.mat');
% load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep2_EMG.mat');
% load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep3_EMG.mat');
% load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep4_EMG.mat');

% load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep1_EMG_004.mat');
% load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep2_EMG_004.mat');
% load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep3_EMG_004.mat');
% load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep4_EMG_004.mat');

load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep1_EMG_yesExo.mat');
load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep2_EMG_yesExo.mat');
load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep3_EMG_yesExo.mat');
load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep4_EMG_yesExo.mat');

%% BACK
rep1_bk = [mean(rep1.back(:,1:1001)); mean(rep1.back(:,1002:2002)); mean(rep1.back(:,2003:end))]';
rep2_bk = [mean(rep2.back(:,1:1001)); mean(rep2.back(:,1002:2002)); mean(rep2.back(:,2003:end))]';
rep3_bk = [mean(rep3.back(:,1:1001)); mean(rep3.back(:,1002:2002)); mean(rep3.back(:,2003:end))]';
rep4_bk = [mean(rep4.back(:,1:1001)); mean(rep4.back(:,1002:2002)); mean(rep4.back(:,2003:end))]';


%% ABD
rep1_abd = [mean(rep1.abd(:,1:1001)); mean(rep1.abd(:,1002:2002)); mean(rep1.abd(:,2003:end))]';
rep2_abd = [mean(rep2.abd(:,1:1001)); mean(rep2.abd(:,1002:2002)); mean(rep2.abd(:,2003:end))]';
rep3_abd = [mean(rep3.abd(:,1:1001)); mean(rep3.abd(:,1002:2002)); mean(rep3.abd(:,2003:end))]';
rep4_abd = [mean(rep4.abd(:,1:1001)); mean(rep4.abd(:,1002:2002)); mean(rep4.abd(:,2003:end))]';

%% LEG

rep1_leg = [mean(rep1.leg(:,1:1001)); mean(rep1.leg(:,1002:2002))]';
rep2_leg = [mean(rep2.leg(:,1:1001)); mean(rep2.leg(:,1002:2002))]';
rep3_leg = [mean(rep3.leg(:,1:1001)); mean(rep3.leg(:,1002:2002))]';
rep4_leg = [mean(rep4.leg(:,1:1001)); mean(rep4.leg(:,1002:2002))]';


%% PLOT BACK
gapLength = 200;                     % lunghezza del gap (più corto dei 1001)
nCols     = 3;        % numero di colonne

gap = NaN(gapLength, nCols);  
% Concatenazione dei vettori con gap
V = [rep1_bk; 
    gap;
    rep2_bk; 
    gap; 
    rep3_bk; 
    gap; 
    rep4_bk];

figure; hold on;
plot(V, 'LineWidth', 1.2);

% ---- Aggiunta linee verticali ----
% === Calcolo posizioni delle linee verticali ===
segmentLength = size(rep1_bk, 1);

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
ylabel('Norm EMG');
title('Back Muscles');
hold off;

%% PLOT ABD
gapLength = 200;                     % lunghezza del gap (più corto dei 1001)
nCols     = 3;        % numero di colonne

gap = NaN(gapLength, nCols);  
% Concatenazione dei vettori con gap
V = [rep1_abd; 
    gap;
    rep2_abd; 
    gap; 
    rep3_abd; 
    gap; 
    rep4_abd];

figure; hold on;
plot(V, 'LineWidth', 1.2);

% ---- Aggiunta linee verticali ----
% === Calcolo posizioni delle linee verticali ===
segmentLength = size(rep1_abd, 1);

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
ylabel('Norm EMG');
title('Abd Muscles');
hold off;

%% PLOT LEG

gapLength = 200;                     % lunghezza del gap (più corto dei 1001)
nCols     = 2;        % numero di colonne

gap = NaN(gapLength, nCols);  
% Concatenazione dei vettori con gap
V = [rep1_leg; 
    gap;
    rep2_leg; 
    gap; 
    rep3_leg; 
    gap; 
    rep4_leg];

figure; hold on;
plot(V, 'LineWidth', 1.2);

% ---- Aggiunta linee verticali ----
% === Calcolo posizioni delle linee verticali ===
segmentLength = size(rep1_leg, 1);

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
ylabel('Norm EMG');
title('Leg Muscles');
hold off;