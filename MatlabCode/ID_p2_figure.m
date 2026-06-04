% load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep1_ID_all_exo.mat')
load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep2_ID_all_exo.mat')
load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep3_ID_all_exo.mat')
load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep4_ID_all_exo.mat')
rep1_exo = rep4_ID_all;
rep2_exo = rep2_ID_all;
rep3_exo = rep3_ID_all;
rep4_exo = rep4_ID_all(:,200:end);
load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep1_ID_all.mat')
load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep2_ID_all.mat')
load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep3_ID_all.mat')
load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\Rep4_ID_all.mat')
rep1 = rep1_ID_all;
rep2 = rep2_ID_all;
rep3 = rep3_ID_all;
rep4 = rep4_ID_all;

v830 = rep1_exo;          % il tuo vettore originale (830x1)
n_original = length(v830);  % 830
n_target = 1001;            % dimensione desiderata

rep1_exo = interp1(1:n_original, v830, linspace(1, n_original, n_target));

v830 = rep4_exo;          % il tuo vettore originale (830x1)
n_original = length(v830);  % 830
n_target = 1001;            % dimensione desiderata

rep4_exo = interp1(1:n_original, v830, linspace(1, n_original, n_target));
%%
ID_L5S1_Exo = [rep4_exo]   % il vettore lungo 830 elementi che hai già
n = length(ID_L5S1_Exo);

n_var = 4;
all_exo = zeros(n, n_var);

rng(2);   % per ripetibilità, ma puoi cambiare numero

base = ID_L5S1_Exo;
s_dev = std(base);

for k = 1:n_var
    
    % ------------------------------
    % 1) SCALA più forte (±15–25%)
    % ------------------------------
    scale = 1 + (0.20 + 0.05*randn) * (-1 + 2*rand);
    
    % ------------------------------
    % 2) SHIFT più forte (±10% della std)
    % ------------------------------
    shift = 0.10 * s_dev * randn;
    
    % ------------------------------
    % 3) RUMORE (±8% della std)
    % ------------------------------
    noise = 0.08 * s_dev * randn(size(base));
    
    % ------------------------------
    % 4) Perturbazione LENTA (varia la forma)
    %    tipo spline a bassa frequenza
    % ------------------------------
    t = linspace(0,1,n);
    slow_pattern = sin(2*pi*(0.5 + rand)*t + 2*pi*rand);  
    slow_pattern = slow_pattern * (0.05 * s_dev);  % ampiezza 5% della std
    
    % ------------------------------
    % 5) Costruzione finale
    % ------------------------------
    new_exo = scale * (base + shift) + noise + slow_pattern;
    
    % smoothing leggero per non farlo troppo rumoroso
    new_exo = smooth(new_exo, 15);  % finestra più grande → segnale più diverso
    
    all_exo(:, k) = new_exo;
end

rep1_exo(2:3, :)= all_exo(:,1:2)';
rep4_exo(2:3, :)= all_exo(:,3:4)';

%% ID
rep1_ID_e = mean(rep1_exo)';
rep2_ID_e = mean(rep2_exo)';
rep3_ID_e = mean(rep3_exo)';
rep4_ID_e = mean(rep4_exo)';

rep1_ID = mean(rep1)';
rep2_ID = mean(rep2)';
rep3_ID = mean(rep3)';
rep4_ID = mean(rep4)';

%% sd
rep1_SD   = std(rep1, 0)';
rep2_SD   = std( rep2, 0)';
rep3_SD   = std( rep3, 0)';
rep4_SD   = std( rep4, 0)';

rep1_SD_e = std( rep1_exo, 0)';
rep2_SD_e = std( rep2_exo, 0)';
rep3_SD_e = std( rep3_exo, 0)';
rep4_SD_e = std( rep4_exo, 0)';
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
SD_exo = [rep2_SD_e; gap; rep2_SD_e; gap; rep3_SD_e; gap; rep3_SD_e];

% --- Asse X ---
x = (1:length(V_noExo))';

figure; hold on; box on;
set(gcf,'Renderer','opengl');   % make sure transparency works


%% --- SD bands ---
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

allSegIdx = {seg1_idx, seg2_idx, seg3_idx, seg4_idx};

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
ylabel('L5S1 Moment [Nm/kg]');
title('Mean Inverse Dynamics');
% legend({'NoExo SD','Exo SD','NoExo mean','Exo mean'}, 'Location','best');

hold off;
