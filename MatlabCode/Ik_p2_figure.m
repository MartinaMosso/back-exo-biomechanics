clear; close all; clc

% load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep1_IK_all_exo.mat')
% load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep2_IK_all_exo.mat')
% load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep3_IK_all_exo.mat')
% load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep4_IK_all_exo.mat')
load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\P2_rep1_IK_finale.mat')
load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\P2_rep2_IK_finale.mat')
load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\P2_rep3_IK_finale.mat')
load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\P2_rep4_IK_finale.mat')
rep1 = Rep1_IK;
rep2 = Rep2_IK;
rep3 = Rep3_IK;
rep4 = Rep4_IK;


% rep1_exo = rep4_IK_all;
% rep2_exo = rep2_IK_all;
% rep3_exo = rep3_IK_all;
% rep4_exo = rep4_IK_all;
% load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep1_IK_all.mat')
% load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep2_IK_all.mat')
% load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep3_IK_all.mat')
% load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep4_IK_all.mat')
% rep1 = rep1_IK_all;
% rep2 = rep2_IK_all;
% rep3 = rep3_IK_all;
% rep4 = rep4_IK_all;

%% ID
rep1_ID_e =movmean(mean(rep1_exo(1:2,:))', 20);
rep2_ID_e = mean(rep2_exo)';
rep3_ID_e = mean(rep3_exo)';
rep4_ID_e = movmean(mean(rep4_exo(2:3,:))',20);

rep1_ID = mean(rep1)';
rep2_ID = mean(rep2)';
rep3_ID = mean(rep3)';
rep4_ID = mean(rep4)';

%% sd
rep1_SD   = std(rep1, 0)';
rep2_SD   = std( rep2, 0)';
rep3_SD   = std( rep3, 0)';
rep4_SD   = std( rep4, 0)';

rep1_SD_e = std( rep1_exo(1:2,:), 0)';
rep2_SD_e = std( rep2_exo, 0)';
rep3_SD_e = std( rep3_exo, 0)';
rep4_SD_e = std( rep4_exo(2:3,:), 0)';
%% PLOT ID - NoExo vs Exo con SD

% --- Colori ---
col_noExo = [0.96 0.76 0.86];   % rosino
col_Exo   = [0.70 0.87 0.70];   % verdino
col_noExo_edge = [0.90 0.50 0.70];   % più scuro per la linea
col_Exo_edge   = [0.40 0.70 0.40];

% --- GAP ---
gapLength = 200;
gap = NaN(gapLength,1);

% --- Concatenate mean NoExo ---
V_noExo = [rep1_ID; gap; rep2_ID; gap; rep3_ID; gap; rep4_ID];
% --- Concatenate SD NoExo ---
SD_noExo = [rep1_SD; gap; rep2_SD; gap; rep3_SD; gap; rep4_SD];

% --- Concatenate mean Exo ---
V_exo = [rep1_ID_e; gap; rep2_ID_e; gap; rep3_ID_e; gap; rep4_ID_e];
% --- Concatenate SD Exo ---
SD_exo = [rep1_SD_e; gap; rep2_SD_e; gap; rep3_SD_e; gap; rep4_SD_e];

% --- Asse X ---
x = (1:length(V_noExo))';


figure; hold on; box on;

%% --- SD bands (NoExo) ---
upper_noExo = V_noExo + SD_noExo;
lower_noExo = V_noExo - SD_noExo;

% patch([x; flipud(x)], ...
%       [upper_noExo; flipud(lower_noExo)], ...
%       col_noExo, 'FaceAlpha', 0.25, 'EdgeColor','none');

%% --- SD bands (Exo) ---
upper_exo = V_exo + SD_exo;
lower_exo = V_exo - SD_exo;

fill([x fliplr(x)], ...
      [upper_exo flipud(lower_exo)], ...
      col_Exo, 'FaceAlpha', 0.5, 'EdgeColor','none');
% fill([x fliplr(x)], ...
%     [media_task8 + std_task8; flipud(media_task8 - std_task8)]', ...
%     [159/256 200/256 200/256], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
%% --- Mean lines ---
plot(x, V_noExo, 'Color', col_noExo_edge, 'LineWidth', 1.5);
plot(x, V_exo,   'Color', col_Exo_edge,   'LineWidth', 1.5);

%% --- Vertical lines ---
segmentLength = size(rep1_ID,1);

gap1_start = segmentLength + 1;
gap1_end   = segmentLength + gapLength;

gap2_start = segmentLength + gapLength + segmentLength + 1;
gap2_end   = segmentLength + gapLength + segmentLength + gapLength;

gap3_start = segmentLength + 2*(gapLength + segmentLength) + 1;
gap3_end   = segmentLength + 2*(gapLength + segmentLength) + gapLength;

for xline_pos = [gap1_start gap1_end gap2_start gap2_end gap3_start gap3_end]
    xline(xline_pos,'--k','LineWidth',1);
end

%% --- X ticks ---
center1 = segmentLength/2;
center2 = gap1_end + segmentLength/2;
center3 = gap2_end + segmentLength/2;
center4 = gap3_end + segmentLength/2;

xticks([center1 center2 center3 center4]);
xticklabels({'Lift 1','Drop 1','Lift 2','Drop 2'});

xlabel('Cycle');
ylabel('L5S1 Flex-Ext Angle [°]');
title('Mean Inverse Kinematics');
% legend({'NoExo SD','Exo SD','NoExo mean','Exo mean'}, 'Location','best');

hold off;
