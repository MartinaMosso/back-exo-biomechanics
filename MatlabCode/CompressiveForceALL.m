
clear; clc; close all

%% Import Compressive Force

movement = {'SQ', 'ST', 'BL'};

sbj = {'SUB005', 'SUB007', 'SUB008', 'SUB009', 'SUB010', 'SUB011', 'SUB012', 'SUB006'};

condition = {'noExo', 'yesExo'};
rep = {'Mean'};
% rep = {'rep1','rep2', 'rep3', 'rep4', 'rep5', 'rep6', 'rep7', 'rep8', 'rep9', 'rep10', 'Mean'};
for j = 1:length(sbj)

    for t= 1:length(movement)

        for k = 1:length(condition)

            task = strcat(sbj{j}, '_',  condition{k}, '_', movement{t}, '_10.mat');

            file2import = strcat('C:\Twente\IUVO\', sbj{j},'\', task)

            load(file2import);

            for r = 1:length(rep)

                % filtraggio rep
                rep_unfilt = Datastr.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.(rep{r});

                fs = 50;  % Frequenza di campionamento (Hz)
                fc = 6;     % Frequenza di taglio (Hz)
                order = 4;  % Ordine del filtro

                % Creazione del filtro Butterworth
                [b, a] = butter(order, fc/(fs/2), 'low');

                % Applicazione del filtro al segnale
                repFilt = filtfilt(b, a, rep_unfilt);
            
                %% cut movements

                CompressiveForce.(movement{t}).(condition{k}).subjMean(:,j) = rep_unfilt;

            end
        end

    end
end


%% mean of mean and plot

load('L5S1_ID_BL.mat')
BL = L5S1_torque.BL;

load('L5S1_ID_SQ_ST.mat')
L5S1_torque.BL = BL;


movement = {'SQ', 'ST', 'BL'};


sbj = {'SUB005', 'SUB006', 'SUB007', 'SUB008', 'SUB009', 'SUB010', 'SUB011', 'SUB012'};

condition = {'noExo', 'yesExo'};

rep = {'rep1', 'rep2', 'rep3', 'rep4', 'rep5', 'rep6', 'rep7', 'rep8', 'rep9', 'rep10'};
for t = 1:length(movement)
    for k = 1:length(condition)
        for i = 1:length(sbj)
            for j = 1:10
                mass(j) = max(L5S1_torque.(movement{t}).(condition{k}).(sbj{i}).L5S1_flexext.(rep{j}));
            end
            L5S1_torque.(movement{t}).(condition{k}).(sbj{i}).massimo = mass;
            L5S1_torque.(movement{t}).(condition{k}).(sbj{i}).maxmean = mean(L5S1_torque.(movement{t}).(condition{k}).(sbj{i}).massimo);
            L5S1_torque.(movement{t}).(condition{k}).maxmean_sbj(i)= L5S1_torque.(movement{t}).(condition{k}).(sbj{i}).maxmean;

        end
        L5S1_torque.(movement{t}).(condition{k}).maxmean = mean(L5S1_torque.(movement{t}).(condition{k}).maxmean_sbj);
        L5S1_torque.(movement{t}).(condition{k}).stdmean = std(L5S1_torque.(movement{t}).(condition{k}).maxmean_sbj);
    end
end

for j = 1:length(sbj)

    allmean_SQ_noExo(j,:)= L5S1_torque.SQ.noExo.(sbj{j}).L5S1_flexext.Mean;
    allmean_SQ_yesExo(j,:) =  L5S1_torque.SQ.yesExo.(sbj{j}).L5S1_flexext.Mean;

    allmean_ST_noExo(j,:) =  L5S1_torque.ST.noExo.(sbj{j}).L5S1_flexext.Mean;
    allmean_ST_yesExo(j,:) = L5S1_torque.ST.yesExo.(sbj{j}).L5S1_flexext.Mean;

    allmean_BL_noExo(j,:) =  L5S1_torque.BL.noExo.(sbj{j}).L5S1_flexext.Mean;
    allmean_BL_yesExo(j,:) = L5S1_torque.BL.yesExo.(sbj{j}).L5S1_flexext.Mean;

end

meanSQ_noExo = mean(allmean_SQ_noExo);
meanSQ_yesExo = mean(allmean_SQ_yesExo);
stdSQ_noExo = std(allmean_SQ_noExo);
stdSQ_yesExo = std(allmean_SQ_yesExo);

meanST_noExo = mean(allmean_ST_noExo);
meanST_yesExo = mean(allmean_ST_yesExo);
stdST_noExo = std(allmean_ST_noExo);
stdST_yesExo = std(allmean_ST_yesExo);

meanBL_noExo = mean(allmean_BL_noExo);
meanBL_yesExo = mean(allmean_BL_yesExo);
stdBL_noExo = std(allmean_BL_noExo);
stdBL_yesExo = std(allmean_BL_yesExo);

%%

% Dati
means = [L5S1_torque.SQ.noExo.maxmean L5S1_torque.SQ.yesExo.maxmean; L5S1_torque.ST.noExo.maxmean L5S1_torque.ST.yesExo.maxmean; L5S1_torque.BL.noExo.maxmean L5S1_torque.BL.yesExo.maxmean]; % Valori medi (3 movimenti × 2 condizioni)
stds = [L5S1_torque.SQ.noExo.stdmean L5S1_torque.SQ.yesExo.stdmean; L5S1_torque.ST.noExo.stdmean L5S1_torque.ST.yesExo.stdmean; L5S1_torque.BL.noExo.stdmean L5S1_torque.BL.yesExo.stdmean]; % Deviazioni standard

% Creazione del bar plot
figure;
b = bar(means, 'grouped');
hold on;

% Aggiunta delle barre di errore
ngroups = size(means, 1);
nbars = size(means, 2);
groupwidth = min(0.8, nbars/(nbars + 1.5)); % Determina la distanza tra le barre

for i = 1:nbars
    % Calcola la posizione delle barre di errore
    x = b(i).XEndPoints;
    errorbar(x, means(:,i), stds(:,i), 'k', 'linestyle', 'none', 'LineWidth', 1.5);
end

% Formattazione
xticklabels({'SQ', 'ST', 'BL'}); % Etichette asse x
ylabel('Torque');
legend({'NoExo', 'YesExo'}, 'Location', 'northwest');
grid on;
hold off;

%% Calcolo della media e della deviazione standard

n_campioni = length(meanBL_yesExo);
x = linspace(0, 100, n_campioni); % Percentuale del ciclo
% Plot del grafico con la deviazione standard in grigio
figure; hold on;
% Linee della media
plot(x, meanSQ_noExo, 'b', 'LineWidth', 2); % Blu per No Exo
plot(x, meanSQ_yesExo, 'r', 'LineWidth', 2); % Rosso per Exo
% Fascia di deviazione standard - No Exo (Blu chiaro)
fill([x, fliplr(x)], [meanSQ_noExo + stdSQ_noExo, fliplr(meanSQ_noExo - stdSQ_noExo)], ...
    'b', 'FaceAlpha', 0.1, 'EdgeColor', 'none');
% Fascia di deviazione standard - Exo (Rosso chiaro)
fill([x, fliplr(x)], [meanSQ_yesExo + stdSQ_yesExo, fliplr(meanSQ_yesExo - stdSQ_yesExo)], ...
    'r', 'FaceAlpha', 0.1, 'EdgeColor', 'none');
% Etichette e legenda
xlabel('Movement cycle (%)');
ylabel('Torque [Nm]');
title('Exo Torque - SQ');
legend('noExo', 'YesExo', 'Location', 'Best');
grid on; hold off;

figure; hold on;
% Linee della media
plot(x, meanST_noExo, 'b', 'LineWidth', 2); % Blu per No Exo
plot(x, meanST_yesExo, 'r', 'LineWidth', 2); % Rosso per Exo
% Fascia di deviazione standard - No Exo (Blu chiaro)
fill([x, fliplr(x)], [meanST_noExo + stdST_noExo, fliplr(meanST_noExo - stdST_noExo)], ...
    'b', 'FaceAlpha', 0.1, 'EdgeColor', 'none');
% Fascia di deviazione standard - Exo (Rosso chiaro)
fill([x, fliplr(x)], [meanST_yesExo + stdST_yesExo, fliplr(meanST_yesExo - stdST_yesExo)], ...
    'r', 'FaceAlpha', 0.1, 'EdgeColor', 'none');
% Etichette e legenda
xlabel('Movement cycle (%)');
ylabel('Torque [Nm]');
title('Exo Torque - ST');
legend('noExo', 'YesExo', 'Location', 'Best');
grid on; hold off;

figure; hold on;
% Linee della media
plot(x, meanBL_noExo, 'b', 'LineWidth', 2); % Blu per No Exo
plot(x, meanBL_yesExo, 'r', 'LineWidth', 2); % Rosso per Exo
% Fascia di deviazione standard - No Exo (Blu chiaro)
fill([x, fliplr(x)], [meanBL_noExo + stdBL_noExo, fliplr(meanBL_noExo - stdBL_noExo)], ...
    'b', 'FaceAlpha', 0.1, 'EdgeColor', 'none');
% Fascia di deviazione standard - Exo (Rosso chiaro)
fill([x, fliplr(x)], [meanBL_yesExo + stdBL_yesExo, fliplr(meanBL_yesExo - stdBL_yesExo)], ...
    'r', 'FaceAlpha', 0.1, 'EdgeColor', 'none');
% Etichette e legenda
xlabel('Movement cycle (%)');
ylabel('Torque [Nm]');
title('Exo Torque - BL');
legend('noExo', 'YesExo', 'Location', 'Best');
grid on; hold off;