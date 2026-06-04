%% MEAN IK - multiple subjects, 4 repetitions

clear; clc; close all

%% -------------------- LOAD DATA --------------------
load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\P2_rep1_IK_finale.mat')
load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\P2_rep2_IK_finale.mat')
load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\P2_rep3_IK_finale.mat')
load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\P2_rep4_IK_finale.mat')


% (aggiungi altri soggetti qui se vuoi)



%% -------------------- MEDIA TRA SOGGETTI --------------------

rep1_IK = mean(Rep1_IK);
rep2_IK = mean(Rep2_IK);
rep3_IK = mean(Rep3_IK);
rep4_IK = mean(Rep4_IK);

%% -------------------- PREPARAZIONE SEGNALE --------------------

% vettori colonna
rep1_IK = rep1_IK(:);
rep2_IK = rep2_IK(:);
rep3_IK = rep3_IK(:);
rep4_IK = rep4_IK(:);

gapLength = 200;
gap = NaN(gapLength,1);

% concatenazione con gap
V = [rep1_IK;
     gap;
     rep2_IK;
     gap;
     rep3_IK;
     gap;
     rep4_IK];

%% -------------------- PLOT --------------------

figure; hold on; grid on;
plot(V, 'LineWidth', 1.5);

% lunghezza segmento
segmentLength = length(rep1_IK);

% posizioni gap
gap1_end = segmentLength + gapLength;
gap2_end = gap1_end + segmentLength + gapLength;
gap3_end = gap2_end + segmentLength + gapLength;

% linee verticali
xlines = [segmentLength, gap1_end, ...
          gap1_end + segmentLength, gap2_end, ...
          gap2_end + segmentLength, gap3_end];

for x = xlines
    xline(x, '--k');
end

% etichette centrate
center1 = segmentLength/2;
center2 = gap1_end + segmentLength/2;
center3 = gap2_end + segmentLength/2;
center4 = gap3_end + segmentLength/2;

xticks([center1 center2 center3 center4]);
xticklabels({'Lift 1','Drop 1','Lift 2','Drop 2'});

xlabel('Cycle');
ylabel('Angle [deg]');
title('Mean IK (no Exoskeleton)');

hold off;