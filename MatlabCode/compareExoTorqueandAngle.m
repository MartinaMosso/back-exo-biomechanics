clear; clc; close all

%% Import

method = 'ExoAngle';

movement = {'SQ', 'ST', 'BL'};

sbj = {'SUB005', 'SUB006', 'SUB007', 'SUB008', 'SUB009', 'SUB010', 'SUB011', 'SUB012'};

% condition = {'noExo', 'yesExo'};
condition = {'yesExo'};

nReps = 10;
repMat = {'rep1' 'rep2' 'rep3' 'rep4' 'rep5' 'rep6' 'rep7' 'rep8' 'rep9' 'rep10'};

%%

for t = 1:length(movement)
    for j = 1:length(sbj)

        % import datastr
        namefile = ['C:\Twente\IUVO\', sbj{j}, '\DatastrMARTA\', sbj{j}, '_yesExo_', movement{t}, '_10.mat'];
        load(namefile);
        startInd = Datastr.cutMovements.broadSamples.Start;

        % import data of exo
        nameTorqueFile = strcat('C:\Twente\IUVO\', sbj{j}, '\ExoForces\ExoAngle_', movement{t}, '_10.mat');
        load(nameTorqueFile);
        % data = coppia_interpolata_2D';
        data = theta_offset_2D';
        
        %% Cut samples
        tau = zeros(1,nReps);

        Samples = [startInd;  Datastr.cutMovements.broadSamples.Stop(end)];

        % Iterate through each struct
        for i = 1:length(Samples)-1
            Repetitions.(repMat{i}) = data(Samples(i):Samples(i+1));
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

        if absSamples.Stop(end) > length(data)
            absSamples.Stop(end) = length(data);
            absSamples.Start(end) = absSamples.Stop(end)-(absSamples.Stop(2)-absSamples.Start(2));
        end

        % Save absSamples in Datastr
        % Datastr.cutMovements.broadSamples = broadSamples;
        % Datastr.cutMovements.sharpenedSamples = absSamples;
        % Datastr.cutMovements.stationaryStart = genStart;
        % Datastr.cutMovements.stationaryEnd = genStop;

        %% Cut data and interpolate to find reps as function of movement cycle



        % Define movement phase
        movPhase = 0:1:1000;
        Data = data(Datastr.cutMovements.stationaryStart:Datastr.cutMovements.stationaryEnd);
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
            ExoAngle.(movement{t}).(sbj{j}) = Repetitions;
        end

    end

end

%% mean of mean and plot
load('ExoAngle.mat')
load("ExoTorque.mat")

for j = 1:length(sbj)

    allmean_SQ_torque(j,:)= ExoAngle.SQ.(sbj{j}).L5S1_flexext.Mean;
    allmean_SQ_angle(j,:) =  ExoTorque.SQ.(sbj{j}).L5S1_flexext.Mean;

    allmean_ST_torque(j,:) =  ExoAngle.ST.(sbj{j}).L5S1_flexext.Mean;
    allmean_ST_angle(j,:) = ExoTorque.ST.(sbj{j}).L5S1_flexext.Mean;

    allmean_BL_torque(j,:) =  ExoAngle.BL.(sbj{j}).L5S1_flexext.Mean;
    allmean_BL_angle(j,:) = ExoTorque.BL.(sbj{j}).L5S1_flexext.Mean;

end

meanSQ_torque = mean(allmean_SQ_torque);
meanSQ_angle = mean(allmean_SQ_angle);
stdSQ_torque = std(allmean_SQ_torque);
stdSQ_angle = std(allmean_SQ_angle);

meanST_torque = mean(allmean_ST_torque);
meanST_angle = mean(allmean_ST_angle);
stdST_torque = std(allmean_ST_torque);
stdST_angle = std(allmean_ST_angle);

meanBL_torque = mean(allmean_BL_torque);
meanBL_angle = mean(allmean_BL_angle);
stdBL_torque = std(allmean_BL_torque);
stdBL_angle = std(allmean_BL_angle);


%% Calcolo della media e della deviazione standard

n_campioni = length(meanBL_torque);
x = linspace(0, 100, n_campioni); % Percentuale del ciclo
% Plot del grafico con la deviazione standard in grigio
subplot(2,3,1)
% Linee della media
plot(x, meanSQ_angle, 'b', 'LineWidth', 2); % Blu per No Exo
hold on
fill([x, fliplr(x)], [meanSQ_angle + stdSQ_angle, fliplr(meanSQ_angle - stdSQ_angle)], ...
    'b', 'FaceAlpha', 0.1, 'EdgeColor', 'none');
grid on
title('Exo Angle - SQ')
subplot(2,3,2)
plot(x, meanST_angle, 'b', 'LineWidth', 2); % Rosso per Exo
% Fascia di deviazione standard - No Exo (Blu chiaro)
hold on
fill([x, fliplr(x)], [meanST_angle + stdST_angle, fliplr(meanST_angle - stdST_angle)], ...
    'b', 'FaceAlpha', 0.1, 'EdgeColor', 'none');
grid on
title('Exo Angle - ST')
subplot(2,3,3)
plot(x, meanBL_angle, 'b', 'LineWidth', 2); % Rosso per Exo
hold on
fill([x, fliplr(x)], [meanBL_angle + stdBL_angle, fliplr(meanBL_angle - stdBL_angle)], ...
    'b', 'FaceAlpha', 0.1, 'EdgeColor', 'none');
grid on;
title('Exo Angle - BL')

subplot(2,3,4)
% Linee della media
plot(x, meanSQ_torque, 'b', 'LineWidth', 2); % Blu per No Exo
hold on
fill([x, fliplr(x)], [meanSQ_torque + stdSQ_torque, fliplr(meanSQ_torque - stdSQ_torque)], ...
    'b', 'FaceAlpha', 0.1, 'EdgeColor', 'none');
grid on
title('Exo Torque - SQ')
subplot(2,3,5)
plot(x, meanST_torque, 'b', 'LineWidth', 2); % Rosso per Exo
% Fascia di deviazione standard - No Exo (Blu chiaro)
hold on
fill([x, fliplr(x)], [meanST_torque + stdST_torque, fliplr(meanST_torque - stdST_torque)], ...
    'b', 'FaceAlpha', 0.1, 'EdgeColor', 'none');
grid on
title('Exo Torque - ST')
subplot(2,3,6)
plot(x, meanBL_torque, 'b', 'LineWidth', 2); % Rosso per Exo
hold on
fill([x, fliplr(x)], [meanBL_torque + stdBL_torque, fliplr(meanBL_torque - stdBL_torque)], ...
    'b', 'FaceAlpha', 0.1, 'EdgeColor', 'none');
grid on;
title('Exo Torque - BL')
