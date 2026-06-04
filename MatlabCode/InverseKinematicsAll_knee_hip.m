%% INVERSE KINEMATICS -- KNEE - HIP

clear; close all; clc

%% impor
%t

% task = {'noExo_BL_10', 'yesExo_BL_10'};
task = {'noExo_SQ_0', 'noExo_SQ_5', 'noExo_SQ_10', 'noExo_SQ_15', 'yesExo_SQ_10', 'noExo_ST_0', 'noExo_ST_5', 'noExo_ST_10', 'noExo_ST_15', 'yesExo_ST_10'};

sbj = {'SUB005', 'SUB006', 'SUB007', 'SUB008', 'SUB009', 'SUB010', 'SUB011', 'SUB012'};

%% save mean and std for each subject across the 10 rep

for t =1:length(task)
    for s=1:length(sbj)
        load(['C:\Twente\IUVO\', sbj{s}, '\', sbj{s}, '_', task{t}, '.mat'])

        Datastr = getMovementPhaseMoments(Datastr, 'IK_knee');
        Datastr = getMovementPhaseMoments(Datastr, 'IK_hip');
            Datastr = getMovementPhaseMoments(Datastr, 'IK');
        IK_mean_Knee(s,:,t) = Datastr.cutMovements.IK_knee.L5_S1_Flex_Ext_moment.Mean;
        IK_mean_hip(s,:,t) = Datastr.cutMovements.IK_hip.L5_S1_Flex_Ext_moment.Mean;
        IK_mean(s,:,t) = Datastr.cutMovements.IK.L5_S1_Flex_Ext_moment.Mean;

        IK_std(s,:,t)= Datastr.cutMovements.IK_knee.L5_S1_Flex_Ext_moment.Std;

        % load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\ResultP1\IK_mean.mat')

        % figure; plot(IK_mean_Knee(s,:,t))
        % figure; plot(IK_mean_hip(s,:,t))
        % figure; plot(IK_mean(s,:,t))
        %  figure;plot(Datastr.Resample.IKAngData(:,12));hold on, plot(Datastr.Resample.IKAngData(:,8));plot(Datastr.Resample.IKAngData(:,24));

        ROM_knee(s,:,t)= max( IK_mean_Knee(s,:,t))-min( IK_mean_Knee(s,:,t));

        massimo_knee(s,:,t)= max( IK_mean_Knee(s,:,t));
        minimo_knee(s,:,t)= min( IK_mean_Knee(s,:,t));
        valore_medio_knee(s,:,t)= mean( IK_mean_Knee(s,:,t));

        ROM_hip(s,:,t)= max( IK_mean_hip(s,:,t))-min( IK_mean_hip(s,:,t));

        massimo_hip(s,:,t)= max( IK_mean_hip(s,:,t));
        minimo_hip(s,:,t)= min( IK_mean_hip(s,:,t));
        valore_medio_hip(s,:,t)= mean( IK_mean_hip(s,:,t));
    end
end

%% mean for each task

for t = 1:length(task)
    %knee
    IK_mean_allSBJ_knee(:,t)= mean(IK_mean_Knee(:,:,t));

    IK_std_allSBJ_Knee(:,t)= std(IK_mean_Knee(:,:,t));

    %hip
    IK_mean_allSBJ_hip(:,t)= mean(IK_mean_hip(:,:,t));

    IK_std_allSBJ_hip(:,t)= std(IK_mean_hip(:,:,t));

    % L5S1
    IK_mean_allSBJ(:,t)= mean(IK_mean(:,:,t));

    IK_std_allSBJ(:,t)= std(IK_mean(:,:,t));
end

x = 1:length(IK_mean_allSBJ_knee); % adatta x ai tuoi dati
figure
% fill([x fliplr(x)], [IK_mean_allSBJ(:,1:5)+IK_std_allSBJ(:,1:5) fliplr(IK_mean_allSBJ(:,1:5)-IK_std_allSBJ(:,1:5))], [0.9 0.9 0.9],'FaceAlpha', 0.5, 'EdgeColor', 'none');
hold on; grid on
plot(IK_mean_allSBJ_knee(:,1:5),'LineWidth',2)
title('SQUAT LIFTING')
legend('0kg', '5kg', '10kg', '15kg', 'exo-10kg')
xlabel('Movement Cycle')
ylabel('Knee Flex-Ext Angle [°]')

figure
% fill([x fliplr(x)], [IK_mean_allSBJ(:,1:5)+IK_std_allSBJ(:,1:5) fliplr(IK_mean_allSBJ(:,1:5)-IK_std_allSBJ(:,1:5))], [0.9 0.9 0.9],'FaceAlpha', 0.5, 'EdgeColor', 'none');
hold on; grid on
plot(IK_mean_allSBJ_hip(:,1:5),'LineWidth',2)
title('SQUAT LIFTING')
legend('0kg', '5kg', '10kg', '15kg', 'exo-10kg')
xlabel('Movement Cycle')
ylabel('Hip Flex-Ext Angle [°]')

figure
% fill([x fliplr(x)], [IK_mean_allSBJ(:,1:5)+IK_std_allSBJ(:,1:5) fliplr(IK_mean_allSBJ(:,1:5)-IK_std_allSBJ(:,1:5))], [0.9 0.9 0.9],'FaceAlpha', 0.5, 'EdgeColor', 'none');
hold on; grid on
plot(IK_mean_allSBJ(:,1:5),'LineWidth',2)
title('SQUAT LIFTING')
legend('0kg', '5kg', '10kg', '15kg', 'exo-10kg')
xlabel('Movement Cycle')
ylabel('L5S1 Flex-Ext Angle [°]')


figure
% fill([x fliplr(x)], [IK_mean_allSBJ(:,1:5)+IK_std_allSBJ(:,1:5) fliplr(IK_mean_allSBJ(:,1:5)-IK_std_allSBJ(:,1:5))], [0.9 0.9 0.9],'FaceAlpha', 0.5, 'EdgeColor', 'none');
hold on; grid on
plot(IK_mean_allSBJ_knee(:,6:end),'LineWidth',2)
title('STOOP LIFTING')
legend('0kg', '5kg', '10kg', '15kg', 'exo-10kg')
xlabel('Movement Cycle')
ylabel('Knee Flex-Ext Angle [°]')

figure
% fill([x fliplr(x)], [IK_mean_allSBJ(:,1:5)+IK_std_allSBJ(:,1:5) fliplr(IK_mean_allSBJ(:,1:5)-IK_std_allSBJ(:,1:5))], [0.9 0.9 0.9],'FaceAlpha', 0.5, 'EdgeColor', 'none');
hold on; grid on
plot(IK_mean_allSBJ_hip(:,6:end),'LineWidth',2)
title('STOOP LIFTING')
legend('0kg', '5kg', '10kg', '15kg', 'exo-10kg')
xlabel('Movement Cycle')
ylabel('Hip Flex-Ext Angle [°]')


figure
% fill([x fliplr(x)], [IK_mean_allSBJ(:,1:5)+IK_std_allSBJ(:,1:5) fliplr(IK_mean_allSBJ(:,1:5)-IK_std_allSBJ(:,1:5))], [0.9 0.9 0.9],'FaceAlpha', 0.5, 'EdgeColor', 'none');
hold on; grid on
plot(IK_mean_allSBJ(:,6:end),'LineWidth',2)
title('STOOP LIFTING')
legend('0kg', '5kg', '10kg', '15kg', 'exo-10kg')
xlabel('Movement Cycle')
ylabel('L5S1 Flex-Ext Angle [°]')
 
%% statistics - check normality  -- all normality data
% hip
[H_squat_noexo, pValue_squat_noexo, W_squat_noexo] = swtest(squeeze(ROM_knee(:,:,3))); % normalità ok
[H_squat_exo, pValue_squat_exo, W_squat_exo] = swtest(squeeze(ROM_knee(:,:,5))); % normalità ok

[H_squat_noexo, pValue_squat_noexo, W_squat_noexo] = swtest(squeeze(valore_medio_knee(:,:,3))); % normalità ok
[H_squat_exo, pValue_squat_exo, W_squat_exo] = swtest(squeeze(valore_medio_knee(:,:,5))); % normalità ok

[H_squat_noexo, pValue_squat_noexo, W_squat_noexo] = swtest(squeeze(ROM_hip(:,:,3))); % normalità ok
[H_squat_exo, pValue_squat_exo, W_squat_exo] = swtest(squeeze(ROM_hip(:,:,5))); % normalità ok

[H_squat_noexo, pValue_squat_noexo, W_squat_noexo] = swtest(squeeze(valore_medio_hip(:,:,3))); % normalità ok
[H_squat_exo, pValue_squat_exo, W_squat_exo] = swtest(squeeze(valore_medio_hip(:,:,5))); % normalità ok
% 
% [H_stoop_noexo, pValue_stoop_noexo, W_stoop_noexo] = swtest(squeeze(ROM_knee(:,:,8))); % normalità ok
% [H_stoop_exo, pValue_stoop_exo, W_stoop_exo] = swtest(squeeze(ROM_knee(:,:,10))); % normalità ok
% 
% [H_squat_noexo_max, pValue_squat_noexo_max, W_squat_noexo_max] = swtest(squeeze(massimo_knee(:,:,3))); % normalità ok
% [H_squat_exo_max, pValue_squat_exo_max, W_squat_exo_max] = swtest(squeeze(massimo_knee(:,:,5))); % normalità ok
% 
% [H_stoop_noexo_max, pValue_stoop_noexo_max, W_stoop_noexo_max] = swtest(squeeze(massimo_knee(:,:,8))); % normalità ok
% [H_stoop_exo_max, pValue_stoop_exo_max, W_stoop_exo_max] = swtest(squeeze(massimo_knee(:,:,10))); % normalità ok
% 
% [H_squat_noexo_min, pValue_squat_noexo_min, W_squat_noexo_min] = swtest(squeeze(minimo_knee(:,:,3))); % normalità ok
% [H_squat_exo_min, pValue_squat_exo_min, W_squat_exo_min] = swtest(squeeze(minimo_knee(:,:,5))); % normalità ok
% 
% [H_stoop_noexo_min, pValue_stoop_noexo_min, W_stoop_noexo_min] = swtest(squeeze(minimo_knee(:,:,8))); % normalità ok
% [H_stoop_exo_min, pValue_stoop_exo_min, W_stoop_exo_min] =
% swtest(squeeze(minimo_knee(:,:,10))); % ok normalità 

% bilateral
[H_squat_noexo, pValue_squat_noexo, W_squat_noexo] = swtest(squeeze(ROM_knee(:,:,1))); % normalità ok
[H_squat_exo, pValue_squat_exo, W_squat_exo] = swtest(squeeze(ROM_knee(:,:,2))); % normalità ok

[H_squat_noexo, pValue_squat_noexo, W_squat_noexo] = swtest(squeeze(valore_medio_knee(:,:,1))); % normalità ok
[H_squat_exo, pValue_squat_exo, W_squat_exo] = swtest(squeeze(valore_medio_knee(:,:,2))); % normalità ok

[H_squat_noexo, pValue_squat_noexo, W_squat_noexo] = swtest(squeeze(ROM_hip(:,:,1))); % normalità ok
[H_squat_exo, pValue_squat_exo, W_squat_exo] = swtest(squeeze(ROM_hip(:,:,2))); % normalità ok

[H_squat_noexo, pValue_squat_noexo, W_squat_noexo] = swtest(squeeze(valore_medio_hip(:,:,1))); % normalità ok
[H_squat_exo, pValue_squat_exo, W_squat_exo] = swtest(squeeze(valore_medio_hip(:,:,2))); % normalità ok

%% t-test
% rom
[~, p_rom_squat, ci_rom_squat, stats_rom_squat] = ttest(squeeze(ROM_knee(:,:,3)), squeeze(ROM_knee(:,:,5))); % diff significativa 
[~, p_rom_stoopt, ci_rom_stoop, stats_rom_stoop] = ttest(squeeze(ROM_knee(:,:,8)), squeeze(ROM_knee(:,:,10)));
[~, p_rom_squat, ci_rom_squat, stats_rom_squat] = ttest(squeeze(ROM_hip(:,:,3)), squeeze(ROM_hip(:,:,5))); % diff significativa 
[~, p_rom_squat, ci_rom_squat, stats_rom_squat] = ttest(squeeze(ROM_hip(:,:,8)), squeeze(ROM_hip(:,:,10))); % diff significativa 



%vvalore medio
[~, p_rom_squat, ci_rom_squat, stats_rom_squat] = ttest(squeeze(valore_medio_knee(:,:,3)), squeeze(valore_medio_knee(:,:,5))); % diff no significativa 
[~, p_rom_squat, ci_rom_squat, stats_rom_squat] = ttest(squeeze(valore_medio_hip(:,:,3)), squeeze(valore_medio_hip(:,:,5))); % diff significativa 
[~, p_rom_squat, ci_rom_squat, stats_rom_squat] = ttest(squeeze(valore_medio_knee(:,:,8)), squeeze(valore_medio_knee(:,:,10))); % diff no significativa 
[~, p_rom_squat, ci_rom_squat, stats_rom_squat] = ttest(squeeze(valore_medio_hip(:,:,8)), squeeze(valore_medio_hip(:,:,10))); % diff significativa 

% massimo
[~, p_max_squat, ci_max_squat, stats_max_squat] = ttest(squeeze(massimo_knee(:,:,3)), squeeze(massimo_knee(:,:,5))); % diff significativa
[~, p_max_stoopt, ci_max_stoop, stats_max_stoop] = ttest(squeeze(massimo_knee(:,:,8)), squeeze(massimo_knee(:,:,10)));

%minimo
[~, p_min_squat, ci_min_squat, stats_min_squat] = ttest(squeeze(minimo_knee(:,:,3)), squeeze(minimo_knee(:,:,5)));
[~, p_min_stoopt, ci_min_stoop, stats_min_stoop] = ttest(squeeze(minimo_knee(:,:,8)), squeeze(minimo_knee(:,:,10)));

% bilateral
[~, p_rom_squat, ci_rom_squat, stats_rom_squat] = ttest(squeeze(ROM_knee(:,:,1)), squeeze(ROM_knee(:,:,2))); % diff significativa 
[~, p_rom_squat, ci_rom_squat, stats_rom_squat] = ttest(squeeze(ROM_hip(:,:,1)), squeeze(ROM_hip(:,:,2))); % diff significativa 


%vvalore medio
[~, p_rom_squat, ci_rom_squat, stats_rom_squat] = ttest(squeeze(valore_medio_knee(:,:,1)), squeeze(valore_medio_knee(:,:,2))); % diff no significativa 
[~, p_rom_squat, ci_rom_squat, stats_rom_squat] = ttest(squeeze(valore_medio_hip(:,:,1)), squeeze(valore_medio_hip(:,:,2))); % diff significativa 

%% STOOP 10 kg HIP
% Estrai il task 8: matrice 8 x 1001

task8 = IK_mean_hip(:, :, 8);
task10 = IK_mean_hip(:, :, 10);

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
plot(x, media_task8, 'color', '#298c8c', 'LineWidth', 3);


plot(x, media_task10, 'color', '#bc5090', 'LineWidth', 3);

xlabel('Movement Cycle', 'FontSize', 18, 'FontWeight', 'bold');
ylabel('L5S1 Flex Ext Angle [°]', 'FontSize', 18, 'FontWeight', 'bold');
title('Stoop Lifting');
% grid on;
set(gca, 'FontSize', 16, 'LineWidth', 1.5);
xlim([0 1000]);                       % Limita asse X da 0 a 1000
xticks(0:100:1000);                   % Imposta i tick ogni 100
xticklabels(0:10:100);                % Etichette da 0% a 100%
xlabel('Lifting cycle (%)');         % Etichetta asse X
legend('', '', 'NoExo', 'Exo');

hold off;

%% SQUAT 10 kg - HIP
% Estrai il task 8: matrice 8 x 1001

task8 = IK_mean_hip(:, :, 3);
task10 = IK_mean_hip(:, :, 5);

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
plot(x, media_task8, 'color', '#298c8c', 'LineWidth', 3);


plot(x, media_task10, 'color', '#bc5090', 'LineWidth', 3);

xlabel('Movement Cycle', 'FontSize', 18, 'FontWeight', 'bold');
ylabel('L5S1 Flex Ext Angle [°]', 'FontSize', 18, 'FontWeight', 'bold');
title('Squat Lifting');
% grid on;
set(gca, 'FontSize', 16, 'LineWidth', 1.5);
xlim([0 1000]);                       % Limita asse X da 0 a 1000
xticks(0:100:1000);                   % Imposta i tick ogni 100
xticklabels(0:10:100);                % Etichette da 0% a 100%
xlabel('Lifting cycle (%)');         % Etichetta asse X
legend('', '', 'NoExo', 'Exo');

hold off;

%% STOOP 10 kg KNEE
% Estrai il task 8: matrice 8 x 1001

task8 = IK_mean_Knee(:, :, 8);
task10 = IK_mean_Knee(:, :, 10);

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
plot(x, media_task8, 'color', '#298c8c', 'LineWidth', 3);


plot(x, media_task10, 'color', '#bc5090', 'LineWidth', 3);

xlabel('Movement Cycle', 'FontSize', 18, 'FontWeight', 'bold');
ylabel('L5S1 Flex Ext Angle [°]', 'FontSize', 18, 'FontWeight', 'bold');
title('Stoop Lifting');
% grid on;
set(gca, 'FontSize', 16, 'LineWidth', 1.5);
xlim([0 1000]);                       % Limita asse X da 0 a 1000
xticks(0:100:1000);                   % Imposta i tick ogni 100
xticklabels(0:10:100);                % Etichette da 0% a 100%
xlabel('Lifting cycle (%)');         % Etichetta asse X
legend('', '', 'NoExo', 'Exo');

hold off;

%% SQUAT 10 kg - KNEE
% Estrai il task 8: matrice 8 x 1001

task8 = IK_mean_Knee(:, :, 3);
task10 = IK_mean_Knee(:, :, 5);

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
plot(x, media_task8, 'color', '#298c8c', 'LineWidth', 3);


plot(x, media_task10, 'color', '#bc5090', 'LineWidth', 3);

xlabel('Movement Cycle', 'FontSize', 18, 'FontWeight', 'bold');
ylabel('L5S1 Flex Ext Angle [°]', 'FontSize', 18, 'FontWeight', 'bold');
title('Squat Lifting');
% grid on;
set(gca, 'FontSize', 16, 'LineWidth', 1.5);
xlim([0 1000]);                       % Limita asse X da 0 a 1000
xticks(0:100:1000);                   % Imposta i tick ogni 100
xticklabels(0:10:100);                % Etichette da 0% a 100%
xlabel('Lifting cycle (%)');         % Etichetta asse X
legend('', '', 'NoExo', 'Exo');

hold off;