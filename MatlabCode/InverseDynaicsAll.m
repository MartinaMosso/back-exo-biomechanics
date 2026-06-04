%% INVERSE DYNAMICS

clear; close all; clc

%% import

% task = {'noExo_SQ_0', 'noExo_SQ_5', 'noExo_SQ_10', 'noExo_SQ_15', 'yesExo_SQ_10', 'noExo_ST_0', 'noExo_ST_5', 'noExo_ST_10', 'noExo_ST_15', 'yesExo_ST_10'};

sbj = {'SUB005', 'SUB006', 'SUB007', 'SUB008', 'SUB009', 'SUB010', 'SUB011', 'SUB012'};

task = {'noExo_SQ_10', 'yesExo_SQ_10',  'noExo_ST_10',  'yesExo_ST_10','noExo_BL_10', 'yesExo_BL_10'};

% per bilateral

% task = {'noExo_ST_10', 'yesExo_ST_10'};
% sbj = {'SUB005', 'SUB006','SUB008'}; %'SUB007', 'SUB008', 'SUB009', 'SUB010', 'SUB011', 'SUB012'};

%% save mean and std for each subject across the 10 rep

for t = 1:length(task)
    for s=1:length(sbj)
        load(['C:\Twente\IUVO\', sbj{s}, '\', sbj{s}, '_', task{t}, '.mat'])
        if t ==2
            Datastr = getMovementPhaseMoments(Datastr, 'ID_exo');
                    ID_mean(s,:,t) = Datastr.cutMovements.ID_exo.L5_S1_Flex_Ext_moment.Mean/(Datastr.Info.subjMass);

        else        
            Datastr = getMovementPhaseMoments(Datastr, 'ID');
                    ID_mean(s,:,t) = Datastr.cutMovements.ID.L5_S1_Flex_Ext_moment.Mean/(Datastr.Info.subjMass);

        end

        % trial =ID_mean(s,:,t); figure; plot(trial)
        ID_std(s,:,t)= Datastr.cutMovements.ID.L5_S1_Flex_Ext_moment.Std;

        % load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\ResultP1\ID_mean.mat')


        massimo(s,:,t)= max( ID_mean(s,:,t));
        minimo(s,:,t)= min( ID_mean(s,:,t));
    end
end


%% check normality

[H_squat_noexo_max, pValue_squat_noexo_max, W_squat_noexo_max] = swtest(squeeze(massimo(:,:,3))); % normalità ok
[H_squat_exo_max, pValue_squat_exo_max, W_squat_exo_max] = swtest(squeeze(massimo(:,:,5))); % normalità ok

[H_stoop_noexo_max, pValue_stoop_noexo_max, W_stoop_noexo_max] = swtest(squeeze(massimo(:,:,8))); % normalità ok
[H_stoop_exo_max, pValue_stoop_exo_max, W_stoop_exo_max] = swtest(squeeze(massimo(:,:,10))); % normalità ok

[H_squat_noexo_min, pValue_squat_noexo_min, W_squat_noexo_min] = swtest(squeeze(minimo(:,:,3))); % normalità ok
[H_squat_exo_min, pValue_squat_exo_min, W_squat_exo_min] = swtest(squeeze(minimo(:,:,5))); % normalità ok

[H_stoop_noexo_min, pValue_stoop_noexo_min, W_stoop_noexo_min] = swtest(squeeze(minimo(:,:,8))); % normalità ok
[H_stoop_exo_min, pValue_stoop_exo_min, W_stoop_exo_min] = swtest(squeeze(minimo(:,:,10))); % NON normalità


% bilateral
% [H_squat_noexo_max, pValue_squat_noexo_max, W_squat_noexo_max] = swtest(squeeze(massimo(:,:,1))); % normalità ok
% [H_squat_exo_max, pValue_squat_exo_max, W_squat_exo_max] = swtest(squeeze(massimo(:,:,2))); % normalità ok
% [H_stoop_noexo_min, pValue_stoop_noexo_min, W_stoop_noexo_min] = swtest(squeeze(minimo(:,:,1))); % normalità ok
% [H_stoop_exo_min, pValue_stoop_exo_min, W_stoop_exo_min] = swtest(squeeze(minimo(:,:,2))); % NON normalità

%% t-test rom
[~, p_max_squat, ci_rom_squat, stats_rom_squat] = ttest(squeeze(massimo(:,:,3)), squeeze(massimo(:,:,5)));
[~, p_max_stoopt, ci_rom_stoop, stats_rom_stoop] = ttest(squeeze(massimo(:,:,8)), squeeze(massimo(:,:,10)));
[~, p_min_squat, ci_min_squat, stats_min_squat] = ttest(squeeze(minimo(:,:,3)), squeeze(minimo(:,:,5)));
[~, p_min_stoopt, ci_min_stoop, stats_min_stoop] = ttest(squeeze(minimo(:,:,8)), squeeze(minimo(:,:,10)));
 p_min_stoop = ranksum(squeeze(massimo(:,:,8)), squeeze(massimo(:,:,10)));

% bilateral
% rom

% % massimo
% [~, p_max_squat, ci_max_squat, stats_max_squat] = ttest(squeeze(massimo(:,:,1)), squeeze(massimo(:,:,2)));
%
% %minimo
% [~, p_min_squat, ci_min_squat, stats_min_squat] = ttest(squeeze(minimo(:,:,1)), squeeze(minimo(:,:,2)));
%
% p_min_stoop = ranksum(squeeze(minimo(:,:,1)), squeeze(minimo(:,:,2)));


%%  barPLot
figure
tiledlayout(2,2)
nexttile
mean_values = [ mean(squeeze(massimo(:,:,3))); mean(squeeze(massimo(:,:,5)))]; % righe = condizioni, colonne = metriche
std_values  = [std(squeeze(massimo(:,:,3)));  std(squeeze(massimo(:,:,5)))];

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
% legend({'noExo', 'Exo'})
ylabel('L5S1 Moment [Nm]')
title('SQUAT - max')
nexttile
mean_values = [  mean(squeeze(minimo(:,:,3))) ;  mean(squeeze(minimo(:,:,5)))]; % righe = condizioni, colonne = metriche
std_values  = [std(squeeze(minimo(:,:,3))) ;std(squeeze(minimo(:,:,5)))];

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
% legend({'noExo', 'Exo'})
ylabel('L5S1 Moment [Nm]')
title('SQUAT - min')

nexttile
mean_values = [ mean(squeeze(massimo(:,:,8))); mean(squeeze(massimo(:,:,10)))]; % righe = condizioni, colonne = metriche
std_values  = [ std(squeeze(massimo(:,:,8)));  std(squeeze(massimo(:,:,10)))];

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
ylabel('L5S1 Moment [Nm]')
title('STOOP - max')

nexttile
mean_values = [ mean(squeeze(minimo(:,:,8)));   mean(squeeze(minimo(:,:,10)))]; % righe = condizioni, colonne = metriche
std_values  = [ std(squeeze(minimo(:,:,8))); std(squeeze(minimo(:,:,10)))];

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
ylabel('L5S1 Moment [Nm]')
title('STOOP - min')
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

for t = 1: length(task)


    ID_mean_allSBJ(:,t)= mean([ID_mean(1:5,:,t); ID_mean(7:8,:,t)]);

    ID_std_allSBJ(:,t)= std(ID_mean(:,:,t));
end
x = linspace(0, 100, size(ID_mean_allSBJ, 1)); % asse x da 0 a 100
x = [x; x; x; x; x]';
figure
% fill([x fliplr(x)], [ID_mean_allSBJ(:,1:5)+ID_std_allSBJ(:,1:5) fliplr(ID_mean_allSBJ(:,1:5)-ID_std_allSBJ(:,1:5))], [0.9 0.9 0.9],'FaceAlpha', 0.5, 'EdgeColor', 'none');
hold on; grid on
plot(ID_mean_allSBJ(:,1:5), LineWidth=2)
title('SQUAT LIFTING')
legend('0kg', '5kg', '10kg', '15kg', 'exo-10kg')
xlabel('Movement Cycle')
ylabel('L5S1 Flex-Ext Moment [Nm]')

figure
% fill([x fliplr(x)], [ID_mean_allSBJ(:,1:5)+ID_std_allSBJ(:,1:5) fliplr(ID_mean_allSBJ(:,1:5)-ID_std_allSBJ(:,1:5))], [0.9 0.9 0.9],'FaceAlpha', 0.5, 'EdgeColor', 'none');
hold on; grid on
plot(x, ID_mean_allSBJ(:,6:end),  LineWidth=2)
xlabel('Movement Cycle')
ylabel('L5S1 Flex-Ext Moment [Nm]')
title('STOOP LIFTING')
legend('0kg', '5kg', '10kg', '15kg', 'exo-10kg')

%% stoop 10 kg
% Estrai il task 8: matrice 8 x 1001

task8 = ID_mean(:, :, 3);
task10 = ID_mean(:, :, 4);

% Calcola la media tra soggetti (lunghezza 1001)
media_task8 = movmean(mean(task8, 1)',15);  % risultato 1 x 1001
media_task10 = movmean(mean(task10, 1)',15);  % risultato 1 x 1001

% Calcola la deviazione standard tra soggetti
std_task8 = movmean(std(task8, 0, 1)', 50);  % risultato 1 x 1001
std_task10 = movmean(std(task10, 0, 1)', 50);  % risultato 1 x 1001
% 
% media_task8 = squeeze(media_task8).';
% std_task8 = squeeze(std_task8).';
% media_task10 = squeeze(media_task10).';
% std_task10 = squeeze(std_task10).';

x = 1:1001;

% Plot
figure;
hold on;

% Fascia colorata (±1 std)
fill([x fliplr(x)], ...
    [media_task8 + std_task8; flipud(media_task8 - std_task8)]', ...
    [159/256 200/256 200/256], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
fill([x fliplr(x)], ...
    [media_task10 + std_task10; flipud(media_task10 - std_task10)]', ...
    [188/256 80/256 144/256], 'EdgeColor', 'none', 'FaceAlpha', 0.2);


% Linea della media
plot(x, media_task8, 'color', [159/256 200/256 200/256], 'LineWidth', 2);


plot(x, media_task10, 'color',[188/256 80/256 144/256], 'LineWidth', 2);

xlabel('Movement Cycle', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('L5S1 Moment', 'FontSize', 12, 'FontWeight', 'bold');
title('Stoop Lifting');
% grid on;
set(gca, 'FontSize', 12, 'LineWidth', 1.5);

legend('', '', 'NoExo', 'Exo');
xlim([0 1000]);                       % Limita asse X da 0 a 1000
xticks(0:100:1000);                   % Imposta i tick ogni 100
xticklabels(0:10:100);                % Etichette da 0% a 100%
xlabel('Lifting cycle (%)');         % Etichetta asse X

% hold off;print(gcf, 'StoopID.png', '-dpng', '-r600')


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
% plot(x, media_task8, 'color', '#298c8c', 'LineWidth', 3);


% plot(x, media_task10, 'color', '#bc5090', 'LineWidth', 3);
plot(x, media_task8, 'color', '#298c8c', 'LineWidth', 2);


plot(x, media_task10, 'color', '#bc5090', 'LineWidth', 2);
xlabel('Movement Cycle', 'FontSize', 12, 'FontWeight', 'bold'); % 18 per presentazione
ylabel('L5S1 Moment [Nm/BW]', 'FontSize', 12, 'FontWeight', 'bold');
title('Stoop Lifting');
% grid on;
set(gca, 'FontSize', 12, 'LineWidth', 1.5);
xlim([0 1000]);                       % Limita asse X da 0 a 1000
xticks(0:100:1000);                   % Imposta i tick ogni 100
xticklabels(0:10:100);                % Etichette da 0% a 100%
xlabel('Lifting cycle (%)');         % Etichetta asse X
legend('', '', 'NoExo', 'Exo');

hold off;
print(gcf, 'StoopIK.png', '-dpng', '-r600')
%% SQUAT 10 kg
% Estrai il task 8: matrice 8 x 1001

task8 = ID_mean(:, :, 1);
task10 = ID_mean(:, :, 2);

% Calcola la media tra soggetti (lunghezza 1001)
media_task8 = movmean(mean(task8, 1)',15);  % risultato 1 x 1001
media_task10 = movmean(mean(task10, 1)',15);  % risultato 1 x 1001

% Calcola la deviazione standard tra soggetti
std_task8 = movmean(std(task8, 0, 1)', 50);  % risultato 1 x 1001
std_task10 = movmean(std(task10, 0, 1)', 50);  % risultato 1 x 1001
% 
% media_task8 = squeeze(media_task8).';
% std_task8 = squeeze(std_task8).';
% media_task10 = squeeze(media_task10).';
% std_task10 = squeeze(std_task10).';

x = 1:1001;
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
% plot(x, media_task8, 'color', '#298c8c', 'LineWidth', 3);


% plot(x, media_task10, 'color', '#bc5090', 'LineWidth', 3);
plot(x, media_task8, 'color', '#298c8c', 'LineWidth', 2);


plot(x, media_task10, 'color', '#bc5090', 'LineWidth', 2);
xlabel('Movement Cycle', 'FontSize', 12, 'FontWeight', 'bold'); % 18 per presentazione
ylabel('L5S1 Moment [Nm/BW]', 'FontSize', 12, 'FontWeight', 'bold');
title('Squat Lifting');
% grid on;
set(gca, 'FontSize', 12, 'LineWidth', 1.5);
xlim([0 1000]);                       % Limita asse X da 0 a 1000
xticks(0:100:1000);                   % Imposta i tick ogni 100
xticklabels(0:10:100);                % Etichette da 0% a 100%
xlabel('Lifting cycle (%)');         % Etichetta asse X
legend('', '', 'NoExo', 'Exo');

hold off;
% print(gcf, 'StoopIK.png', '-dpng', '-r600')

% Plot
% figure;
% hold on;
% 
% % Fascia colorata (±1 std)
% fill([x fliplr(x)], ...
%     [media_task8 + std_task8; flipud(media_task8 - std_task8)]', ...
%     [159/256 200/256 200/256], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
% fill([x fliplr(x)], ...
%     [media_task10 + std_task10; flipud(media_task10 - std_task10)]', ...
%     [188/256 80/256 144/256], 'EdgeColor', 'none', 'FaceAlpha', 0.2);
% 
% 
% % Linea della media
% plot(x, media_task8, 'color', [159/256 200/256 200/256], 'LineWidth', 2);
% 
% 
% plot(x, media_task10, 'color',[188/256 80/256 144/256], 'LineWidth', 2);
% 
% xlabel('Movement Cycle', 'FontSize', 12, 'FontWeight', 'bold');
% ylabel('L5S1 Moment', 'FontSize', 12, 'FontWeight', 'bold');
% title('Squat Lifting');
% % grid on;
% set(gca, 'FontSize', 12, 'LineWidth', 1.5);
% 
% legend('', '', 'NoExo', 'Exo');
% xlim([0 1000]);                       % Limita asse X da 0 a 1000
% xticks(0:100:1000);                   % Imposta i tick ogni 100
% xticklabels(0:10:100);                % Etichette da 0% a 100%
% xlabel('Lifting cycle (%)');         % Etichetta asse X
% 
% hold off;
% 
% print(gcf, 'SquatID.png', '-dpng', '-r600')

%% BILATERAL 10 kg
% Estrai il task 8: matrice 8 x 1001

task8 = ID_mean(:, :, 1);
task10 = ID_mean(:, :, 2);

% Calcola la media tra soggetti (lunghezza 1001)
media_task8 = movmean(mean(task8, 1)',15);  % risultato 1 x 1001
media_task10 = movmean(mean(task10, 1)',15);  % risultato 1 x 1001

% Calcola la deviazione standard tra soggetti
std_task8 = movmean(std(task8, 0, 1)', 50);  % risultato 1 x 1001
std_task10 = movmean(std(task10, 0, 1)', 50);  % risultato 1 x 1001
% 
% media_task8 = squeeze(media_task8).';
% std_task8 = squeeze(std_task8).';
% media_task10 = squeeze(media_task10).';
% std_task10 = squeeze(std_task10).';

x = 1:1001;

% Plot
figure;
hold on;

% Fascia colorata (±1 std)
fill([x fliplr(x)], ...
    [media_task8 + std_task8; flipud(media_task8 - std_task8)]', ...
    [159/256 200/256 200/256], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
fill([x fliplr(x)], ...
    [media_task10 + std_task10; flipud(media_task10 - std_task10)]', ...
    [188/256 80/256 144/256], 'EdgeColor', 'none', 'FaceAlpha', 0.2);


% Linea della media
plot(x, media_task8, 'color', [159/256 200/256 200/256], 'LineWidth', 2);


plot(x, media_task10, 'color',[188/256 80/256 144/256], 'LineWidth', 2);

xlabel('Movement Cycle', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('L5S1 Moment', 'FontSize', 12, 'FontWeight', 'bold');
title('Squat Lifting');
% grid on;
set(gca, 'FontSize', 12, 'LineWidth', 1.5);

legend('', '', 'NoExo', 'Exo');
xlim([0 1000]);                       % Limita asse X da 0 a 1000
xticks(0:100:1000);                   % Imposta i tick ogni 100
xticklabels(0:10:100);                % Etichette da 0% a 100%
xlabel('Lifting cycle (%)');         % Etichetta asse X

hold off;

print(gcf, 'BilateralID.png', '-dpng', '-r600')

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
% plot(x, media_task8, 'color', '#298c8c', 'LineWidth', 3);


% plot(x, media_task10, 'color', '#bc5090', 'LineWidth', 3);
plot(x, media_task8, 'color', '#298c8c', 'LineWidth', 2);


plot(x, media_task10, 'color', '#bc5090', 'LineWidth', 2);
xlabel('Movement Cycle', 'FontSize', 12, 'FontWeight', 'bold'); % 18 per presentazione
ylabel('L5S1 Moment [Nm/BW]', 'FontSize', 12, 'FontWeight', 'bold');
title('Bilateral Lifting');
% grid on;
set(gcf, 'color', 'none');   
set(gca, 'color', 'none');
copygraphics(gcf, 'BackgroundColor', 'none', 'ContentType', 'vector');
set(gca, 'FontSize', 12, 'LineWidth', 1.5);
xlim([0 1000]);                       % Limita asse X da 0 a 1000
xticks(0:100:1000);                   % Imposta i tick ogni 100
xticklabels(0:10:100);                % Etichette da 0% a 100%
xlabel('Lifting cycle (%)');         % Etichetta asse X
legend('', '', 'NoExo', 'Exo');

hold off;
print(gcf, 'StoopIK.png', '-dpng', '-r600')

%% tiledlayout

% D.squat.t = linspace(0,100,101);       % opzionale; altrimenti lo deduce da N
D.squat.noexo.mean = movmean(mean(ID_mean(:,:,1), 1)',15)'; % [1xN]
D.squat.noexo.std  = movmean(std(ID_mean(:,:,1), 0, 1)', 50);  % [1xN]
D.squat.exo.mean   = movmean(mean(ID_mean(:,:,2), 1)',15);   % [1xN]
D.squat.exo.std    = movmean(std(ID_mean(:,:,2), 0, 1)', 50);    % [1xN]

% === STOOP ===
% D.stoop.t = linspace(0,100,101);
D.stoop.noexo.mean = movmean(mean(ID_mean(:,:,3), 1)',15);
D.stoop.noexo.std  = movmean(std(ID_mean(:,:,3), 0, 1)', 50);
D.stoop.exo.mean   = movmean(mean(ID_mean(:,:,4), 1)',15);
D.stoop.exo.std    = movmean(std(ID_mean(:,:,4), 0, 1)', 50);

% === BILATERAL ===
% D.bilateral.t = linspace(0,100,101);
D.bilateral.noexo.mean = movmean(mean([ID_mean(1:2,:,5); ID_mean(4,:,5)], 1)',15); 
D.bilateral.noexo.std  = movmean(std([ID_mean(1:2,:,5); ID_mean(4,:,5)], 0, 1)', 50);
D.bilateral.exo.mean   = movmean(mean([ID_mean(1:2,:,6); ID_mean(4,:,6)], 1)',15);
D.bilateral.exo.std    = movmean(std([ID_mean(1:2,:,6); ID_mean(4,:,6)], 0, 1)', 50);

% === CREA FIGURA ===
PLOT_L5S1_MOMENTS(D, './fig/Fig_L5S1_Moments');

