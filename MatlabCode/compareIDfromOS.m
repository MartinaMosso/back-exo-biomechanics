
clear; clc; close all

%% Import ID from OS --> L5S1

method = 'ExoAngle';

% movement = {'SQ', 'ST', 'BL'};
movement = {'ST'};

% sbj = {'SUB005', 'SUB006', 'SUB007', 'SUB008', 'SUB009', 'SUB010', 'SUB011', 'SUB012'};

sbj = { 'SUB012'};

condition = {'noExo'};
% condition = {'yesExo'};

for t= 1:length(movement)

    for j = 1:length(sbj)

        for k = 1:length(condition)

            task = strcat(sbj{j},  condition{k}, '_', movement{t}, '_10ID.sto');

            file2import = strcat('C:\Twente\IUVO\', sbj{j}, '\OS\DataFiles\ResultOS\', task)

            ID = importdata(file2import);

            %% cut movements
            % Determine start and stop samples based on torque differential
            L5S1Trq_unfilt = ID.data(10:end-10,18);

            fs = 50;  % Frequenza di campionamento (Hz)
            fc = 6;     % Frequenza di taglio (Hz)
            order = 4;  % Ordine del filtro

            % Creazione del filtro Butterworth
            [b, a] = butter(order, fc/(fs/2), 'low');

            % Applicazione del filtro al segnale
            L5S1Trq = filtfilt(b, a, L5S1Trq_unfilt);

            % Cube signal and apply threshold to cut start and end of signal
            L5S1TrqCubed    = ceil(L5S1Trq(1:end-20).^3);
            threshold       = ceil(0.2*max(L5S1TrqCubed));
            intersect       = find(L5S1TrqCubed>threshold);
            genStart        = intersect(1)-ceil(0.2*intersect(1));
            genStop         = intersect(end)+ceil(0.2*intersect(1));

            % Cut torque signal based on identified start / stop sample
            if genStop > length(L5S1Trq)
                genStop = length(L5S1Trq);
                L5S1Trq = L5S1Trq(genStart:end);
            else
                L5S1Trq = L5S1Trq(genStart:genStop);
            end

            %load LastRep
            if strcmp(movement{t}, 'BL')
                movPatternLoc = 'C:\Users\Dottorato\OneDrive - University of Twente\Data\MovLib\movPattern_BL.mat';
            else
                movPatternLoc = 'C:\Users\Dottorato\OneDrive - University of Twente\Data\MovLib\movPattern.mat';
            end

            load(movPatternLoc, 'lastRep');

            % Include zeros to make vectors same length
            movPatternRepfull = [zeros(length(L5S1Trq)-length(lastRep),1); lastRep];

            %% Use lastRepfull to find all other repetitions
            [r,~] = xcorr(L5S1Trq, movPatternRepfull);

            % We expect to find 9 peaks (first peak is located at 0 and won't be identified by findpeaks)
            npeaks = 9;
            r = r(1:length(L5S1Trq)); % Don't include peaks at the start or at the end (only due to full overlap or false/unintended movements)
            [~,locsMAX,~,~] = findpeaks(r, "MinPeakWidth", 30,'MinPeakDistance',225, 'SortStr', 'descend', 'NPeaks', npeaks);

            %% Identify startSamples, and sort these in ascending order
            startSamples = locsMAX;
            startSamples = sort(startSamples);
            signalLength = length(L5S1Trq);

            %% First indication of approximated cutting points
            Samples = [1; startSamples; signalLength];

            %% Make distinction between horizontal movements (3 reps) and vertical
            % movements (10 reps)
            nReps = 10;

            repMat = {'rep1' 'rep2' 'rep3' 'rep4' 'rep5' 'rep6' 'rep7' 'rep8' 'rep9' 'rep10'};

            % Save these samples as 'broadSamples'
            broadSamples.Start = Samples(1:end-1);
            broadSamples.Stop  = Samples(2:end);

            %% Cut samples
            tau = zeros(1,nReps);

            % Iterate through each struct
            for i = 1:length(Samples)-1
                Repetitions.(repMat{i}) = L5S1Trq(Samples(i):Samples(i+1));
            end

            % Calculate delay between repetitions
            for n = 1:nReps
                [r,lags] = xcorr(Repetitions.(repMat{1}), Repetitions.(repMat{n}));
                [~,ind] = max(r);
                tau(n) = lags(max(ind));
            end

            % Align repetitions
            noDelayMat = zeros(nReps, length(Repetitions.(repMat{1}))+max(tau)+abs(min(tau)));
            tau = tau + abs(min(tau)) + 1;      % Make sure all delays are positive, and lowest tau value = 1

            for n = 1:nReps
                noDelayMat(n,tau(n):length(Repetitions.(repMat{n}))+tau(n)-1) = Repetitions.(repMat{n});
            end

            % Find start and stop sample
            noDelayMatSum = sum(noDelayMat);
            threshold = 0.2*max(noDelayMatSum);             % Set to 20% of maximum value
            intersection=find(noDelayMatSum>threshold);

            % Set first sample / last sample n samples before / after threshold
            % respectively
            firstSample     = intersection(1)-ceil((length(noDelayMatSum)-intersection(1)-(length(noDelayMatSum)-intersection(end)))/15);

            % First sample should be positive
            if firstSample <= 0
                firstSample = intersection(1);
            end

            lastSample      = intersection(end)+ceil((length(noDelayMatSum)-intersection(1)-(length(noDelayMatSum)-intersection(end)))/15);
            if lastSample > length(noDelayMat)
                lastSample = length(noDelayMat);
            end

            % firstSample and lastSample are relative to noDelayMatrix. So to identify
            % the absolute start and stop samples, we can perform cross correlation to
            % find the start sample, and based on length (lastSample-firstSample) we
            % can identify stop samples
            for n = 1:nReps
                % For Start Samples
                RepetitionsIntermediate.(repMat{n}) = noDelayMat(n,firstSample:lastSample);
                [r,lags] = xcorr(Repetitions.(repMat{n}), RepetitionsIntermediate.(repMat{n}));
                [~,ind] = max(r);
                tau(n) = lags(max(ind));

            end

            % Find absolute start and stop samples in torque data
            % These can later be used for EMG cutting as well

            absSamples.Start = Samples(1:end-1) + tau';
            absSamples.Stop = absSamples.Start + (lastSample-firstSample);

            if absSamples.Start(1) <= 0
                absSamples.Start(1) = 1;
                absSamples.Stop(1) = absSamples.Stop(2)-absSamples.Start(2)+1;
            end

            if absSamples.Stop(end) > length(L5S1Trq)
                absSamples.Stop(end) = length(L5S1Trq);
                absSamples.Start(end) = absSamples.Stop(end)-(absSamples.Stop(2)-absSamples.Start(2));
            end

            % Save absSamples in Datastr
            Datastr.cutMovements.broadSamples = broadSamples;
            Datastr.cutMovements.sharpenedSamples = absSamples;
            Datastr.cutMovements.stationaryStart = genStart;
            Datastr.cutMovements.stationaryEnd = genStop;

            %% Cut data and interpolate to find reps as function of movement cycle

            % switch method
            %     case 'ID'
            %         Data = ID.data(Datastr.cutMovements.stationaryStart:Datastr.cutMovements.stationaryEnd, 18);
            % case 'ExoTorque'
            %     nameTorqueFile = strcat('C:\Twente\IUVO\', sbj{j}, '\ExoForces\SingleTorque_', movement{t}, '_10.mat');
            %     load(nameTorqueFile);
            %     Dataunfilt = coppia_interpolata_2D';
            %     Data = movmean(Dataunfilt, 25);
            % case 'ExoAngle'
            %      nameTorqueFile = strcat('C:\Twente\IUVO\', sbj{j}, '\ExoForces\ExoAngle_', movement{t}, '_10.mat');
            %      load(nameTorqueFile);
            %      Data = theta_offset_2D';
            % case 'ForceLeg'
            %     nameTorqueFile = strcat('C:\Twente\IUVO\', sbj{j}, '\ExoForces\FlegR_', movement{t}, '_10.mat');
            %     load(nameTorqueFile);
            %      Data = F_thigh_3dR;
            % case 'ForceChest'
            %     nameTorqueFile = strcat('C:\Twente\IUVO\', sbj{j}, '\ExoForces\Fchest_', movement{t}, '_10.mat');
            %     load(nameTorqueFile);
            %     Data = F_trunk_3d;
            % end

            % Define movement phase
            movPhase = 0:1:1000;
            Data = ID.data(Datastr.cutMovements.stationaryStart:Datastr.cutMovements.stationaryEnd, 18);
            absSamples = Datastr.cutMovements.sharpenedSamples;

            % For EMG we have 12 muscles + 1 zeroEMG, else 1 torque signal (for ID or CEINMS)
            sz = size(Data);

            for m = 1:sz(2)

                varName = 'L5S1_flexext';
                % Interpolation to find movement cycle values from 0:1:100
                for n = 1:nReps
                    Repetitions.(varName).(repMat{n}) = Data(absSamples.Start(n):absSamples.Stop(n), m);
                    x = linspace(0,length(movPhase),length(Repetitions.(varName).(repMat{n})));
                    Repetitions.(varName).(repMat{n}) = spline(x,Repetitions.(varName).(repMat{n}),movPhase);
                end

                %% Calculate mean, std
                % Get mean and std
                Repetitions.(varName).Matrix = zeros(nReps,length(movPhase));

                for n = 1:nReps
                    Repetitions.(varName).Matrix(n,:) =  Repetitions.(varName).(repMat{n});
                end

                Repetitions.(varName).Mean = mean(Repetitions.(varName).Matrix,1);
                Repetitions.(varName).Std  = std(Repetitions.(varName).Matrix,0,1);
                Repetitions.(varName).MovementPhase = movPhase./10;

                %% Save important variables in Datastr
                Datastr.cutMovements.ID = Repetitions;
                L5S1_torque.(movement{t}).(condition{k}).(sbj{j}) = Repetitions;
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