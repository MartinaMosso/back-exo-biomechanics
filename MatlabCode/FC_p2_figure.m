load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep1_FC_all_exo.mat')
load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep2_FC_all_exo.mat')
load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep3_FC_all_exo.mat')
load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep4_FC_all_exo.mat')
rep1_FC_all(2:10,:) =[];

rep1_exo = rep1_FC_all/2;
rep2_exo = rep2_FC_all;
rep3_exo = rep3_FC_all;
rep4_FC_all(2:10,:) =[];
rep4_exo = rep4_FC_all/2;
load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep1_FC_all.mat')
load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep2_FC_all.mat')
load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep3_FC_all.mat')
load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep4_FC_all.mat')
rep1 = rep1_FC_all;
rep2 = rep2_FC_all;
rep3 = rep3_FC_all;
rep4 = rep4_FC_all;

%% ID
rep1_ID_e =movmean(mean(rep1_exo(1:2,:))', 30);
rep2_ID_e = mean(rep2_exo)';
rep3_ID_e = mean(rep3_exo)';
rep4_ID_e = movmean(mean(rep4_exo(2:3,:))',30);

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
set(gcf,'Renderer','opengl');   % make sure transparency works

%% --- SD bands (NoExo) ---
upper_noExo = V_noExo + SD_noExo;
lower_noExo = V_noExo - SD_noExo;

upper_exo   = V_exo   + SD_exo;
lower_exo   = V_exo   - SD_exo;

segmentLength = size(rep1_ID,1);
gapLength     = 200;
% Indici segmenti (stessi che usi per le xline)
seg1_idx = 1:segmentLength;

seg2_start = segmentLength + gapLength + 1;
seg2_end   = seg2_start + segmentLength - 1;
seg2_idx   = seg2_start:seg2_end;

seg3_start = seg2_end + gapLength + 1;
seg3_end   = seg3_start + segmentLength - 1;
seg3_idx   = seg3_start:seg3_end;

seg4_start = seg3_end + gapLength + 1;
seg4_end   = seg4_start + segmentLength - 1;
seg4_idx   = seg4_start:seg4_end;

allSegIdx = {seg1_idx, seg2_idx, seg3_idx, seg4_idx};%% --- Mean lines ---
plot(x, V_noExo, 'Color', col_noExo_edge, 'LineWidth', 1.5);
plot(x, V_exo,   'Color', col_Exo_edge,   'LineWidth', 1.5);

% --- funzione helper anonima per disegnare banda SD ---
drawBand = @(xseg, upperSeg, lowerSeg, col, alphaVal) ...
    patch([xseg; flipud(xseg)], ...
          [upperSeg; flipud(lowerSeg)], ...
          col, 'FaceAlpha', alphaVal, 'EdgeColor','none');

% --- Bande NoExo ed Exo per ogni segmento ---
for k = 1:numel(allSegIdx)
    idx = allSegIdx{k};

    xseg = x(idx);

    % NoExo
    upper_n = upper_noExo(idx);
    lower_n = lower_noExo(idx);
    drawBand(xseg, upper_n, lower_n, col_noExo, 0.25);

    % Exo
    upper_e = upper_exo(idx);
    lower_e = lower_exo(idx);
    drawBand(xseg, upper_e, lower_e, col_Exo, 0.5);
end
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
ylabel('L5S1 Compressive Forces [Nm\BW]');
title('Mean Compressive Forces');
% legend({'NoExo SD','Exo SD','NoExo mean','Exo mean'}, 'Location','best');

hold off;
