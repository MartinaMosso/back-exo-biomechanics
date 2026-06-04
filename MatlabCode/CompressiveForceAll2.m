%% COMPRESSIVE FORCES

clear; close all; clc

%% import

% task = {'noExo_SQ_0', 'noExo_SQ_5', 'noExo_SQ_10', 'noExo_SQ_15', 'yesExo_SQ_10', 'noExo_ST_0', 'noExo_ST_5', 'noExo_ST_10', 'noExo_ST_15', 'yesExo_ST_10'};


sbj = {'SUB005', 'SUB006', 'SUB007', 'SUB008', 'SUB009','SUB010', 'SUB011', 'SUB012'};  %% tolto sbj 10

task = {'noExo_SQ_10', 'yesExo_SQ_10',  'noExo_ST_10',  'yesExo_ST_10','noExo_BL_10', 'yesExo_BL_10'};

% task = {'noExo_BL_10', 'yesExo_BL_10'};
% sbj = {'SUB005', 'SUB006','SUB008'}; %'SUB007', 'SUB008', 'SUB009', 'SUB010', 'SUB011', 'SUB012'};

%% save mean and std for each subject across the 10 rep

for t = 1:length(task)
    for s=1:length(sbj)
        load(['C:\Twente\IUVO\', sbj{s}, '\', sbj{s}, '_', task{t}, '.mat'])

        Datastr = getMovementPhaseMoments(Datastr, 'JRA_EMG');
        M = Datastr.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.Matrix;
        fs = 1000;         % Frequenza di campionamento (Hz), modifica se diversa
        fc = 10;           % Frequenza di taglio (Hz)
        order = 4;         % Ordine del filtro

        % Crea filtro Butterworth passa basso
        [b, a] = butter(order, fc/(fs/2), 'low');

        % Supponiamo che la matrice si chiami "M", di size 10x1001
        % Applica il filtro su ogni riga SENZA for
        M_filt = filtfilt(b, a, M')';   % trasponi, filtra per colonna, ritrasponi
        media_signal = mean(M_filt, 1);  % media lungo la dimensione 1 (righe)

        % FC_mean(s,:,t) = Datastr.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.Mean/(9.81*Datastr.Info.subjMass);
        FC_mean(s,:,t) = media_signal/(9.81*Datastr.Info.subjMass);

        FC_std(s,:,t)= Datastr.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.Std;

        massimo(s,:,t)= max(FC_mean(s,:,t));

        minimo(s,:,t)= min(FC_mean(s,:,t));
    media (s,:,t)=mean(FC_mean(s,:,t));
    end
end

%%
% Assuming 'data' is a 8x1001x10 matrix
% Dimensions: subjects x timepoints x tasks

% Create a new figure for each task
time = 1:1001; % time vector (adjust if you have actual time values)

for taskIdx = 1:10
    figure;
    hold on;
    for subjIdx = 1:8
        plot(time, squeeze(FC_mean(subjIdx, :, taskIdx)), 'DisplayName', ['Subject ' num2str(subjIdx)]);
    end
    title(['Task ' num2str(taskIdx)]);
    xlabel('Time');
    ylabel('Signal');
    legend('show');
    grid on;
    hold off;
end


%% check normality

[H_squat_noexo_max, pValue_squat_noexo_max, W_squat_noexo_max] = swtest(squeeze(massimo(:,:,3))); % normalità ok
[H_squat_exo_max, pValue_squat_exo_max, W_squat_exo_max] = swtest(squeeze(massimo(:,:,5))); % NON normalità 

[H_stoop_noexo_max, pValue_stoop_noexo_max, W_stoop_noexo_max] = swtest(squeeze(massimo(:,:,8))); % normalità ok
[H_stoop_exo_max, pValue_stoop_exo_max, W_stoop_exo_max] = swtest(squeeze(massimo(:,:,10))); % normalità ok

[H_squat_noexo_max, pValue_squat_noexo_max, W_squat_noexo_max] = swtest(squeeze(media(:,:,3))); % normalità ok
[H_squat_exo_max, pValue_squat_exo_max, W_squat_exo_max] = swtest(squeeze(media(:,:,5))); % NON normalità 
[H_stoop_noexo_max, pValue_stoop_noexo_max, W_stoop_noexo_max] = swtest(squeeze(media(:,:,8))); % normalità ok
[H_stoop_exo_max, pValue_stoop_exo_max, W_stoop_exo_max] = swtest(squeeze(media(:,:,10))); % normalità ok

[H_squat_noexo_min, pValue_squat_noexo_min, W_squat_noexo_min] = swtest(squeeze(minimo(:,:,3))); % normalità ok
[H_squat_exo_min, pValue_squat_exo_min, W_squat_exo_min] = swtest(squeeze(minimo(:,:,5))); % normalità ok

[H_stoop_noexo_min, pValue_stoop_noexo_min, W_stoop_noexo_min] = swtest(squeeze(minimo(:,:,8))); % normalità ok
[H_stoop_exo_min, pValue_stoop_exo_min, W_stoop_exo_min] = swtest(squeeze(minimo(:,:,10))); % NON normalità 

% bilateral 
% [H_squat_noexo_max, pValue_squat_noexo_max, W_squat_noexo_max] = swtest(squeeze(massimo(:,:,1))); % normalità ok
% [H_squat_exo_max, pValue_squat_exo_max, W_squat_exo_max] = swtest(squeeze(massimo(:,:,2))); % normalità ok
% [H_stoop_noexo_min, pValue_stoop_noexo_min, W_stoop_noexo_min] = swtest(squeeze(media(:,:,1))); % normalità ok
% [H_stoop_exo_min, pValue_stoop_exo_min, W_stoop_exo_min] = swtest(squeeze(media(:,:,2))); % NON normalità 
%% ttest peak
[~, p_max_squat, ci_rom_squat, stats_rom_squat] = ttest(squeeze(massimo(:,:,3)), squeeze(massimo(:,:,5)));
[~, p_max_stoopt, ci_rom_stoop, stats_rom_stoop] = ttest(squeeze(massimo(:,:,8)), squeeze(massimo(:,:,10)));

[~, p_max_squat, ci_rom_squat, stats_rom_squat] = ttest(squeeze(media(:,:,3)), squeeze(media(:,:,5)));
[~, p_max_stoopt, ci_rom_stoop, stats_rom_stoop] = ttest(squeeze(media(:,:,8)), squeeze(media(:,:,10)));

[~, p_min_squat, ci_rom_squat, stats_rom_squat] = ttest(squeeze(minimo(:,:,3)), squeeze(minimo(:,:,5)));
[~, p_min_stoopt, ci_rom_stoop, stats_rom_stoop] = ttest(squeeze(minimo(:,:,8)), squeeze(minimo(:,:,10)));

p_min_stoop = ranksum(squeeze(minimo(:,:,8)), squeeze(minimo(:,:,10)))
p_max_squat = ranksum(squeeze(massimo(:,:,3)), squeeze(massimo(:,:,5)))

% bilatera
% massimo
% [~, p_max_squat, ci_max_squat, stats_max_squat] = ttest(squeeze(massimo(:,:,1)), squeeze(massimo(:,:,2)));
% 
% %minimo
% [~, p_min_squat, ci_min_squat, stats_min_squat] = ttest(squeeze(media(:,:,1)), squeeze(media(:,:,2)));
% 
% p_min_stoop = ranksum(squeeze(minimo(:,:,1)), squeeze(minimo(:,:,2)));

%%  barPLot
figure
tiledlayout(2,1)
nexttile
mean_values = [mean(squeeze(massimo(:,:,3))) mean(squeeze(massimo(:,:,5))); mean(squeeze(minimo(:,:,3)))   mean(squeeze(minimo(:,:,5)))]; % righe = condizioni, colonne = metriche
std_values  = [ std(squeeze(massimo(:,:,3)))  std(squeeze(massimo(:,:,5))); std(squeeze(minimo(:,:,3))) std(squeeze(minimo(:,:,5)))];

% Bar plot
bar_handle = bar(mean_values);

hold on
% Aggiungi le barre di errore (deviazione standard)
num_groups = size(mean_values, 1);
num_bars = size(mean_values, 2);
groupwidth = min(0.8, num_bars/(num_bars + 1.5));

for i = 1:num_bars
    % Calcola la posizione delle barre
    x = (1:num_groups) - groupwidth/2 + (2*i-1) * groupwidth / (2*num_bars);
    errorbar(x, mean_values(:, i), std_values(:, i), 'k', 'linestyle', 'none', 'LineWidth', 1);
end

hold off
legend({'noExo', 'Exo'})
ylabel('L5S1 Compressive Force')
title('SQUAT')
nexttile
mean_values = [ mean(squeeze(massimo(:,:,8))) mean(squeeze(massimo(:,:,10))); mean(squeeze(minimo(:,:,8)))   mean(squeeze(minimo(:,:,10)))]; % righe = condizioni, colonne = metriche
std_values  = [ std(squeeze(massimo(:,:,8)))  std(squeeze(massimo(:,:,10))); std(squeeze(minimo(:,:,8))) std(squeeze(minimo(:,:,10)))];

% Bar plot
bar_handle = bar(mean_values);

hold on
% Aggiungi le barre di errore (deviazione standard)
num_groups = size(mean_values, 1);
num_bars = size(mean_values, 2);
groupwidth = min(0.8, num_bars/(num_bars + 1.5));

for i = 1:num_bars
    % Calcola la posizione delle barre
    x = (1:num_groups) - groupwidth/2 + (2*i-1) * groupwidth / (2*num_bars);
    errorbar(x, mean_values(:, i), std_values(:, i), 'k', 'linestyle', 'none', 'LineWidth', 1);
end

hold off
legend({'noExo', 'Exo'})
ylabel('L5S1 Compressive Force')
title('STOOP')
%% boxplot
figure
boxplot([squeeze(massimo(:,:,3)) squeeze(massimo(:,:,5))] )
title('SQUAT')
figure
boxplot([squeeze(massimo(:,:,8)) squeeze(massimo(:,:,10))] )
title('STOOP')

figure
boxplot([squeeze(minimo(:,:,3)) squeeze(minimo(:,:,5))] )
title('SQUAT')
figure
boxplot([squeeze(minimo(:,:,8)) squeeze(minimo(:,:,10))] )
title('STOOP')
%% mean for each task

for t = 1:length(task)
  

        FC_mean_allSBJ(:,t)= mean(FC_mean(:,:,t));

       FC_std_allSBJ(:,t)= std(FC_mean(:,:,t));
end
x = 1:length(FC_mean_allSBJ); % adatta x ai tuoi dati
x = [x; x; x; x; x]';
figure
% fill([x fliplr(x)], [FC_mean_allSBJ(:,1:5)+FC_std_allSBJ(:,1:5) fliplr(FC_mean_allSBJ(:,1:5)-FC_std_allSBJ(:,1:5))], [0.9 0.9 0.9],'FaceAlpha', 0.5, 'EdgeColor', 'none');
hold on; grid on
plot(movmean(FC_mean_allSBJ(:,1:5), 25))
title('SQUAT LIFTING')
legend('0kg', '5kg', '10kg', '15kg', 'exo-10kg')
xlabel('Movement Cycle')
ylabel('L5S1 Compressive Forces')

figure
% fill([x fliplr(x)], [FC_mean_allSBJ(:,1:5)+FC_std_allSBJ(:,1:5) fliplr(FC_mean_allSBJ(:,1:5)-FC_std_allSBJ(:,1:5))], [0.9 0.9 0.9],'FaceAlpha', 0.5, 'EdgeColor', 'none');
hold on; grid on
plot(movmean(FC_mean_allSBJ(:,6:end), 25))
xlabel('Movement Cycle')
ylabel('L5S1 Compressive Forces')
title('STOOP LIFTING')
legend('0kg', '5kg', '10kg', '15kg', 'exo-10kg')

%% STOOP

task8 = FC_mean(:, :, 8);
task10 = FC_mean(:, :, 10);

for i =1:size(task8,1)
    max8(i) = max(task8(i,:))
end
for i =1:size(task10,1)
    max10(i) = max(task10(i,:))
end

pvaluestoop = ranksum(max8, max10);


% Calcola la media tra soggetti (lunghezza 1001)
media_task8 = mean(task8, 1);  % risultato 1 x 1001
media_task10 = mean(task10, 1);  % risultato 1 x 1001

% Calcola la deviazione standard tra soggetti
std_task8 = std(task8, 0, 1);  % risultato 1 x 1001
std_task10 = std(task10, 0, 1);  % risultato 1 x 1001

media_task8 = movmean(squeeze(media_task8).', 25);
std_task8 = movmean(squeeze(std_task8).', 25);
media_task10 = squeeze(media_task10).';
std_task10 = squeeze(std_task10).';
x = 1:1001;

% Plot
figure;
hold on;
% Fascia colorata (±1 std)
fill([x fliplr(x)], ...
    [media_task8 + std_task8; flipud(media_task8 - std_task8)]', ...
    [159/256 200/256 200/256], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
fill([x fliplr(x)], ...
    [media_task10 + std_task10; flipud(media_task10 - std_task10)]',  ...
    [188/256 80/256 144/256], 'EdgeColor', 'none', 'FaceAlpha', 0.2);


% Linea della media
plot(x, media_task8, 'color', '#298c8c', 'LineWidth', 2);


plot(x, media_task10, 'color', '#bc5090', 'LineWidth', 2);



xlabel('Movement Cycle', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('L5S1 Compressive Force', 'FontSize', 12, 'FontWeight', 'bold');
title('Stoop Lifting');
% grid on;
set(gca, 'FontSize', 12, 'LineWidth', 1.5);

legend('', '', 'NoExo', 'Exo');
xlim([0 1000]);                       % Limita asse X da 0 a 1000
xticks(0:100:1000);                   % Imposta i tick ogni 100
xticklabels(0:10:100);                % Etichette da 0% a 100%
xlabel('Lifting cycle (%)');         % Etichetta asse X

hold off;
print(gcf, 'StoopFC.png', '-dpng', '-r600')

%% SQUAT

task8 = FC_mean(:, :, 3);
% task10 = [FC_mean(1:3, :, 5); FC_mean(5, :, 5); FC_mean(7, :, 5)];
task10 = FC_mean(:, :, 5)

for i =1:size(task8,1)
    max8(i) = max(task8(i,:))
end
for i =1:size(task10,1)
    max10(i) = max(task10(i,:))
end

pvaluestoop = ranksum(max8, max10);


% Calcola la media tra soggetti (lunghezza 1001)
media_task8 = mean(task8, 1);  % risultato 1 x 1001
media_task10 = mean(task10, 1);  % risultato 1 x 1001

% Calcola la deviazione standard tra soggetti
std_task8 = std(task8, 0, 1);  % risultato 1 x 1001
std_task10 = std(task10, 0, 1);  % risultato 1 x 1001

media_task8 = movmean(squeeze(media_task8).', 25);
std_task8 = movmean(squeeze(std_task8).', 25);
media_task10 = squeeze(media_task10).';
std_task10 = squeeze(std_task10).';
x = 1:1001;

% Plot
figure;
hold on;
% Fascia colorata (±1 std)
fill([x fliplr(x)], ...
    [media_task8 + std_task8; flipud(media_task8 - std_task8)]', ...
    [159/256 200/256 200/256], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
fill([x fliplr(x)], ...
    [media_task10 + std_task10; flipud(media_task10 - std_task10)]',  ...
    [188/256 80/256 144/256], 'EdgeColor', 'none', 'FaceAlpha', 0.2);


% Linea della media
plot(x, media_task8, 'color', '#298c8c', 'LineWidth', 2);


plot(x, media_task10, 'color', '#bc5090', 'LineWidth', 2);



xlabel('Movement Cycle', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('L5S1 Compressive Force', 'FontSize', 12, 'FontWeight', 'bold');
title('Squat Lifting');
% grid on;
set(gca, 'FontSize', 12, 'LineWidth', 1.5);

legend('', '', 'NoExo', 'Exo');
xlim([0 1000]);                       % Limita asse X da 0 a 1000
xticks(0:100:1000);                   % Imposta i tick ogni 100
xticklabels(0:10:100);                % Etichette da 0% a 100%
xlabel('Lifting cycle (%)');         % Etichetta asse X

hold off;
print(gcf, 'SquatFC.png', '-dpng', '-r600')


%% BILATERAL
task8 = FC_mean(:, :, 1);
% task10 = [FC_mean(1:3, :, 5); FC_mean(5, :, 5); FC_mean(7, :, 5)];
task10 = FC_mean(:, :, 2)

for i =1:size(task8,1)
    max8(i) = max(task8(i,:))
end
for i =1:size(task10,1)
    max10(i) = max(task10(i,:))
end

pvaluestoop = ranksum(max8, max10);


% Calcola la media tra soggetti (lunghezza 1001)
media_task8 = mean(task8, 1);  % risultato 1 x 1001
media_task10 = mean(task10, 1);  % risultato 1 x 1001

% Calcola la deviazione standard tra soggetti
std_task8 = std(task8, 0, 1);  % risultato 1 x 1001
std_task10 = std(task10, 0, 1);  % risultato 1 x 1001

media_task8 = movmean(squeeze(media_task8).', 25);
std_task8 = movmean(squeeze(std_task8).', 25);
media_task10 = squeeze(media_task10).';
std_task10 = squeeze(std_task10).';
x = 1:1001;

% Plot
figure;
hold on;
% Fascia colorata (±1 std)
fill([x fliplr(x)], ...
    [media_task8 + std_task8; flipud(media_task8 - std_task8)]', ...
    [159/256 200/256 200/256], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
fill([x fliplr(x)], ...
    [media_task10 + std_task10; flipud(media_task10 - std_task10)]',  ...
    [188/256 80/256 144/256], 'EdgeColor', 'none', 'FaceAlpha', 0.2);


% Linea della media
plot(x, media_task8, 'color', '#298c8c', 'LineWidth', 2);


plot(x, media_task10, 'color', '#bc5090', 'LineWidth', 2);



xlabel('Movement Cycle', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('L5S1 Compressive Force [BW]', 'FontSize', 12, 'FontWeight', 'bold');
title('Bilateral Lifting');
% grid on;
set(gca, 'FontSize', 12, 'LineWidth', 1.5);

legend('', '', 'NoExo', 'Exo');
xlim([0 1000]);                       % Limita asse X da 0 a 1000
xticks(0:100:1000);                   % Imposta i tick ogni 100
xticklabels(0:10:100);                % Etichette da 0% a 100%
xlabel('Lifting cycle (%)');         % Etichetta asse X

hold off;
print(gcf, 'SquatFC.png', '-dpng', '-r600')