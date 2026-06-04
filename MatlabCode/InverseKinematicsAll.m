%% INVERSE KINEMATICS

clear; close all; clc

%% import

task = {'noExo_SQ_10', 'yesExo_SQ_10'};
% task = {'noExo_SQ_0', 'noExo_SQ_5', 'noExo_SQ_10', 'noExo_SQ_15', 'yesExo_SQ_10', 'noExo_ST_0', 'noExo_ST_5', 'noExo_ST_10', 'noExo_ST_15', 'yesExo_ST_10'};
% per bilateral
% sbj = {'SUB005', 'SUB006','SUB008'}; %'SUB007', 'SUB008', 'SUB009', 'SUB010', 'SUB011', 'SUB012'};

sbj = {'SUB005', 'SUB006', 'SUB007', 'SUB008', 'SUB009', 'SUB010', 'SUB011', 'SUB012'};

%% save mean and std for each subject across the 10 rep

for t = 1:length(task)
    for s=1:length(sbj)
        load(['C:\Twente\IUVO\', sbj{s}, '\', sbj{s}, '_', task{t}, '.mat'])

        Datastr = getMovementPhaseMoments(Datastr, 'IK');

        IK_mean(s,:,t) = Datastr.cutMovements.IK.L5_S1_Flex_Ext_moment.Mean;

        IK_std(s,:,t)= Datastr.cutMovements.IK.L5_S1_Flex_Ext_moment.Std;
        % load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\ResultP1\IK_mean.mat')

        ROM(s,:,t)= max( IK_mean(s,:,t))-min( IK_mean(s,:,t));

        massimo(s,:,t)= max( IK_mean(s,:,t));
        minimo(s,:,t)= min( IK_mean(s,:,t));
        valore_medio(s,:,t)=mean(IK_mean(s,:,t));
    end
end

%% check normality
% bilatera
[H_squat_noexo, pValue_squat_noexo, W_squat_noexo] = swtest(squeeze(ROM(:,:,1))); % normalità ok
[H_squat_exo, pValue_squat_exo, W_squat_exo] = swtest(squeeze(ROM(:,:,2))); % normalità ok

[H_squat_noexo, pValue_m_noexo, W_squat_noexo] = swtest(squeeze(valore_medio(:,:,1))); % normalità ok
[H_squat_exo, pValue_m_exo, W_squat_exo] = swtest(squeeze(valore_medio(:,:,2))); % normalità ok

[H_squat_noexo_max, pValue_squat_noexo_max, W_squat_noexo_max] = swtest(squeeze(massimo(:,:,1))); % normalità ok
[H_squat_exo_max, pValue_squat_exo_max, W_squat_exo_max] = swtest(squeeze(massimo(:,:,1))); % normalità ok
[H_stoop_noexo_min, pValue_stoop_noexo_min, W_stoop_noexo_min] = swtest(squeeze(minimo(:,:,1))); % normalità ok
[H_stoop_exo_min, pValue_stoop_exo_min, W_stoop_exo_min] = swtest(squeeze(minimo(:,:,2))); % NON normalità

% squat stoop
[H_squat_noexo, pValue_squat_noexo, W_squat_noexo] = swtest(squeeze(ROM(:,:,3))); % normalità ok
[H_squat_exo, pValue_squat_exo, W_squat_exo] = swtest(squeeze(ROM(:,:,5))); % normalità ok

[H_squat_noexoM, pValue_squat_noexo, W_squat_noexo] = swtest(squeeze(valore_medio(:,:,3))); % normalità ok
[H_squat_exo, pValue_squat_exo, W_squat_exo] = swtest(squeeze(valore_medio(:,:,5))); % normalità ok

[H_stoop_noexo, pValue_stoop_noexo, W_stoop_noexo] = swtest(squeeze(ROM(:,:,8))); % normalità ok
[H_stoop_exo, pValue_stoop_exo, W_stoop_exo] = swtest(squeeze(ROM(:,:,10))); % normalità ok

[H_stoop_noexo, pValue_stoop_noexo, W_stoop_noexo] = swtest(squeeze(valore_medio(:,:,8))); % normalità ok
[H_stoop_exo, pValue_stoop_exo, W_stoop_exo] = swtest(squeeze(valore_medio(:,:,10))); % normalità ok


[H_squat_noexo_max, pValue_squat_noexo_max, W_squat_noexo_max] = swtest(squeeze(massimo(:,:,3))); % normalità ok
[H_squat_exo_max, pValue_squat_exo_max, W_squat_exo_max] = swtest(squeeze(massimo(:,:,5))); % normalità ok

[H_stoop_noexo_max, pValue_stoop_noexo_max, W_stoop_noexo_max] = swtest(squeeze(massimo(:,:,8))); % normalità ok
[H_stoop_exo_max, pValue_stoop_exo_max, W_stoop_exo_max] = swtest(squeeze(massimo(:,:,10))); % normalità ok

[H_squat_noexo_min, pValue_squat_noexo_min, W_squat_noexo_min] = swtest(squeeze(minimo(:,:,3))); % normalità ok
[H_squat_exo_min, pValue_squat_exo_min, W_squat_exo_min] = swtest(squeeze(minimo(:,:,5))); % normalità ok

[H_stoop_noexo_min, pValue_stoop_noexo_min, W_stoop_noexo_min] = swtest(squeeze(minimo(:,:,8))); % normalità ok
[H_stoop_exo_min, pValue_stoop_exo_min, W_stoop_exo_min] = swtest(squeeze(minimo(:,:,10))); % NON normalità

%% t-test
% rom
[~, p_rom_squat, ci_rom_squat, stats_rom_squat] = ttest(squeeze(ROM(:,:,3)), squeeze(ROM(4:end,:,5)));
[~, p_rom_stoopt, ci_rom_stoop, stats_rom_stoop] = ttest(squeeze(ROM(1:8,:,8)), squeeze(ROM(1:8,:,10)));

% valore medio
[~, p_m_squat, ci_rom_squat, stats_rom_squat] = ttest(squeeze(valore_medio(:,:,3)), squeeze(valore_medio(:,:,5)));
[~, p_m_stoopt, ci_rom_stoop, stats_rom_stoop] = ttest(squeeze(valore_medio(1:8,:,8)), squeeze(valore_medio(1:8,:,10)));

% massimo
[~, p_max_squat, ci_max_squat, stats_max_squat] = ttest(squeeze(massimo(:,:,3)), squeeze(massimo(:,:,5)));
[~, p_max_stoopt, ci_max_stoop, stats_max_stoop] = ttest(squeeze(massimo(:,:,8)), squeeze(massimo(:,:,10)));

%minimo
[~, p_min_squat, ci_min_squat, stats_min_squat] = ttest(squeeze(minimo(:,:,3)), squeeze(minimo(:,:,5)));
[~, p_min_stoopt, ci_min_stoop, stats_min_stoop] = ttest(squeeze(minimo(:,:,8)), squeeze(minimo(:,:,10)));

p_min_stoop = ranksum(squeeze(minimo(:,:,8)), squeeze(minimo(:,:,10)));

% % bilatera
% rom
[~, p_rom_squat, ci_rom_squat, stats_rom_squat] = ttest(squeeze(ROM(:,:,1)), squeeze(ROM(:,:,2)));
%mean
[~, p_valmedio_squat, ci_rom_squat, stats_rom_squat] = ttest(squeeze(valore_medio(:,:,1)), squeeze(valore_medio(:,:,2)));


% massimo
[~, p_max_squat, ci_max_squat, stats_max_squat] = ttest(squeeze(massimo(:,:,1)), squeeze(massimo(:,:,2)));

%minimo
[~, p_min_squat, ci_min_squat, stats_min_squat] = ttest(squeeze(minimo(:,:,1)), squeeze(minimo(:,:,2)));

p_min_stoop = ranksum(squeeze(ROM(:,:,1)), squeeze(ROM(:,:,2)));

%% correlation

% [R, P] = corr(squeeze(ROM(:,:,3)), squeeze(ROM(:,:,5)));
% R_squared = R^2;
%
% figure;
% scatter(squeeze(ROM(:,:,3)), squeeze(ROM(:,:,5)));
% lsline; % linea di regressione
% xlabel('No eso'); ylabel('Eso');
% title(['R = ' num2str(R) ', R^2 = ' num2str(R_squared)]);
%% boxplot
% figure
% tiledlayout(2,1)
% x = ["noExo"; "Exo"];
% nexttile
% bar( [mean(squeeze(ROM(:,:,3))) mean(squeeze(massimo(:,:,3))) mean(squeeze(minimo(:,:,3)));  mean(squeeze(ROM(:,:,5))) mean(squeeze(massimo(:,:,5))) mean(squeeze(minimo(:,:,5)))])
% title('SQUAT')
% 
% nexttile
% bar( [mean(squeeze(ROM(:,:,8))) mean(squeeze(massimo(:,:,8))) mean(squeeze(minimo(:,:,8)));  mean(squeeze(ROM(:,:,10))) mean(squeeze(massimo(:,:,10))) mean(squeeze(minimo(:,:,10)))])
% title('STOOP')
% 
% nexttile
% boxplot([squeeze(minimo(:,:,3)), squeeze(minimo(:,:,5))])
% title('SQUAT - MAX')
% % xlabel('noExo', 'Exo')
% figure
% boxplot([squeeze(ROM(:,:,8)), squeeze(ROM(:,:,10))])
% title('STOOP')
% % xlabel('noExo', 'Exo')

%%  barPLot
figure
tiledlayout(2,1)
nexttile
mean_values = [mean(squeeze(ROM(:,:,3))) mean(squeeze(ROM(:,:,5))) ; mean(squeeze(massimo(:,:,3))) mean(squeeze(massimo(:,:,5))); mean(squeeze(minimo(:,:,3)))   mean(squeeze(minimo(:,:,5)))]; % righe = condizioni, colonne = metriche
std_values  = [std(squeeze(ROM(:,:,3))) std(squeeze(ROM(:,:,5))); std(squeeze(massimo(:,:,3)))  std(squeeze(massimo(:,:,5))); std(squeeze(minimo(:,:,3))) std(squeeze(minimo(:,:,5)))];

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
ylabel('L5S1 Flex-Ext [°]')
title('SQUAT')
nexttile
mean_values = [mean(squeeze(ROM(:,:,8))) mean(squeeze(ROM(:,:,10))) ; mean(squeeze(massimo(:,:,8))) mean(squeeze(massimo(:,:,10))); mean(squeeze(minimo(:,:,8)))   mean(squeeze(minimo(:,:,10)))]; % righe = condizioni, colonne = metriche
std_values  = [std(squeeze(ROM(:,:,8))) std(squeeze(ROM(:,:,10))); std(squeeze(massimo(:,:,8)))  std(squeeze(massimo(:,:,10))); std(squeeze(minimo(:,:,8))) std(squeeze(minimo(:,:,10)))];

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
ylabel('L5S1 Flex-Ext [°]')
title('STOOP')

%% STOOP 10 kg
% Estrai il task 8: matrice 8 x 1001

task8 = IK_mean(:, :, 8);
task10 = IK_mean(:, :, 10);

% Calcola la media tra soggetti (lunghezza 1001)
media_task8 = mean(task8, 1);  % risultato 1 x 1001
media_task10 = mean(task10, 1);  % risultato 1 x 1001

% Calcola la deviazione standard tra soggetti
std_task8 = std(task8, 0, 1);  % risultato 1 x 1001
std_task10 = std(task10, 0, 1);  % risultato 1 x 1001

media_task8 = squeeze(media_task8).';
std_task8 = squeeze(std_task8).';
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
% plot(x, media_task8, 'color', '#298c8c', 'LineWidth', 3);


% plot(x, media_task10, 'color', '#bc5090', 'LineWidth', 3);
plot(x, media_task8, 'color', '#298c8c', 'LineWidth', 2);


plot(x, media_task10, 'color', '#bc5090', 'LineWidth', 2);
xlabel('Movement Cycle', 'FontSize', 12, 'FontWeight', 'bold'); % 18 per presentazione
ylabel('L5S1 Flex Ext Angle [°]', 'FontSize', 12, 'FontWeight', 'bold');
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

task8 = IK_mean(:, :, 3);
task10 = IK_mean(:, :, 5);

% Calcola la media tra soggetti (lunghezza 1001)
media_task8 = mean(task8, 1);  % risultato 1 x 1001
media_task10 = mean(task10, 1);  % risultato 1 x 1001

% Calcola la deviazione standard tra soggetti
std_task8 = std(task8, 0, 1);  % risultato 1 x 1001
std_task10 = std(task10, 0, 1);  % risultato 1 x 1001

media_task8 = squeeze(media_task8).';
std_task8 = squeeze(std_task8).';
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
ylabel('L5S1 Flex Ext Angle [°]', 'FontSize', 12, 'FontWeight', 'bold');
title('Squat Lifting');
% grid on;
set(gca, 'FontSize', 12, 'LineWidth', 1.5);
xlim([0 1000]);                       % Limita asse X da 0 a 1000
xticks(0:100:1000);                   % Imposta i tick ogni 100
xticklabels(0:10:100);                % Etichette da 0% a 100%
xlabel('Lifting cycle (%)');         % Etichetta asse X
legend('', '', 'NoExo', 'Exo');

hold off;
print(gcf, 'SquatIK.png', '-dpng', '-r600')

%% BILATERAL 10 kg
% Estrai il task 8: matrice 8 x 1001

task8 = IK_mean(:, :, 1);
task10 = IK_mean(:, :, 2);

% Calcola la media tra soggetti (lunghezza 1001)
media_task8 = mean(task8, 1);  % risultato 1 x 1001
media_task10 = mean(task10, 1);  % risultato 1 x 1001

% Calcola la deviazione sdtandard tra soggetti
std_task8 = std(task8, 0, 1);  % risultato 1 x 1001
std_task10 = std(task10, 0, 1);  % risultato 1 x 1001

media_task8 = squeeze(media_task8).';
std_task8 = squeeze(std_task8).';
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
ylabel('L5S1 Flex Ext Angle [°]', 'FontSize', 12, 'FontWeight', 'bold');
title('Bilateral Lifting');
% grid on;
set(gca, 'FontSize', 12, 'LineWidth', 1.5);
set(gcf, 'color', 'none');   
set(gca, 'color', 'none');
% copygraphics(gcf, 'BackgroundColor', 'none', 'ContentType', 'vector');
xlim([0 1000]);                       % Limita asse X da 0 a 1000
xticks(0:100:1000);                   % Imposta i tick ogni 100
xticklabels(0:10:100);                % Etichette da 0% a 100%
xlabel('Lifting cycle (%)');         % Etichetta asse X
legend('', '', 'NoExo', 'Exo');

hold off;
print(gcf, 'BilateralIK.png', '-dpng', '-r600')
%% mean for each task

for t = 1:length(task)


    IK_mean_allSBJ(:,t)= mean(IK_mean(:,:,t));

    IK_std_allSBJ(:,t)= std(IK_mean(:,:,t));
end
x = linspace(0, 100, size(IK_mean_allSBJ, 1)); % asse x da 0 a 100
figure
% fill([x fliplr(x)], [IK_mean_allSBJ(:,1:5)+IK_std_allSBJ(:,1:5) fliplr(IK_mean_allSBJ(:,1:5)-IK_std_allSBJ(:,1:5))], [0.9 0.9 0.9],'FaceAlpha', 0.5, 'EdgeColor', 'none');
hold on; grid on
plot(IK_mean_allSBJ(:,1:5))
title('SQUAT LIFTING')
legend('0kg', '5kg', '10kg', '15kg', 'exo-10kg')
xlabel('Movement Cycle')
ylabel('L5S1 Flex-Ext Angle [°]')

figure
% fill([x' fliplr(x)'], [IK_mean_allSBJ(:,8)+IK_std_allSBJ(:,8) fliplr(IK_mean_allSBJ(:,8)-IK_std_allSBJ(:,8))], [0.9 0.9 0.9],'FaceAlpha', 0.5, 'EdgeColor', 'none');
hold on; grid on
plot(x, IK_mean_allSBJ(:,6:end), LineWidth=2)
% fill([x' fliplr(x)'], [IK_mean_allSBJ(:,end)+IK_std_allSBJ(:,end) fliplr(IK_mean_allSBJ(:,end)-IK_std_allSBJ(:,end))], [0.9 0.9 0.9],'FaceAlpha', 0.5, 'EdgeColor', 'none');
% plot(IK_mean_allSBJ(:,10), LineWidth=2)
xlabel('Movement Cycle')
ylabel('L5S1 Flex-Ext Angle [°]')
title('STOOP LIFTING')
legend('0kg', '5kg', '10kg', '15kg', 'exo-10kg')

%%
x = linspace(0, 100, size(IK_mean_allSBJ, 1)); % asse x da 0 a 100
figure
hold on; grid on
plot(x, IK_mean_allSBJ(:,6:end))
title('STOOP LIFTING')
legend('0kg', '5kg', '10kg', '15kg', 'exo-10kg')
xlabel('Movement Cycle [%]')
ylabel('L5S1 Flex-Ext Angle [°]')