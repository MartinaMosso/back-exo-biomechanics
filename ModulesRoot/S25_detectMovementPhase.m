function [Datastr] = S25_detectMovementPhase(Datastr)

% Remove existing fields [prevents overwriting]
if isfield(Datastr, 'cutMovements')
Datastr = rmfield(Datastr,'cutMovements');
end

% Determine start and stop samples based on torque differential
L5S1Trq = Datastr.Resample.IDTrqData(:,18);

% Cube signal and apply threshold to cut start and end of signal
L5S1TrqCubed    = ceil(L5S1Trq.^3);
threshold       = ceil(0.2*max(L5S1TrqCubed));
intersect       = find(L5S1TrqCubed>threshold);
genStart        = intersect(1)-ceil(0.2*intersect(1));
if genStart ==0
    genStart =1;
end
genStop         = intersect(end)+ceil(0.2*intersect(1));

% Cut torque signal based on identified start / stop sample
if genStop > length(L5S1Trq)
    genStop = length(L5S1Trq);
    L5S1Trq = L5S1Trq(genStart:end);   
else  
    L5S1Trq = L5S1Trq(genStart:genStop);
end

%% Pick the last repetition (lastRep)
% [r,~] = xcorr(L5S1Trq, L5S1Trq);
% [~,ind] = max(r);

% We expect to find 5 peaks (first peak is located at 0 and won't be identified by findpeaks)
% npeaks = 5;
% [~,locsMAX,~,~] = findpeaks(r(ind:end),'MinPeakDistance',length(r(1:ind))/8, 'SortStr', 'descend', 'NPeaks', npeaks);

% Find last repetition
%lastRep = L5S1Trq(length(L5S1Trq)-locsMAX(1):end);

% Load an example movement (more stable than lastRep)
idx = strfind(Datastr.Info.SubjRoot, '\');

if Datastr.Info.horMovFlag == 1
    movPatternLoc = [Datastr.Info.SubjRoot(1:idx(end)) 'MovLib\movPattern_BL.mat']; 
elseif Datastr.Info.vertMovFlag == 1
    movPatternLoc = [Datastr.Info.SubjRoot(1:idx(end)) 'MovLib\movPattern.mat'];
end

load(movPatternLoc, 'lastRep');

% Include zeros to make vectors same length
movPatternRepfull = [zeros(length(L5S1Trq)-length(lastRep),1); lastRep];

%% Use lastRepfull to find all other repetitions
[r,~] = xcorr(L5S1Trq, movPatternRepfull);

% We expect to find 9 peaks (first peak is located at 0 and won't be identified by findpeaks)

% DA CAMBIARE QUANDO PHASE2, E METTERE NPEAKS = 1;
% npeaks = 9;  
npeaks = 1;  

% r = r(50:length(L5S1Trq)-50); % Don't include peaks at the start or at the end (only due to full overlap or false/unintended movements)
% [~,locsMAX,~,~] = findpeaks(r, "MinPeakWidth", 30,'MinPeakDistance',225, 'SortStr', 'descend', 'NPeaks', npeaks);

%% Identify startSamples, and sort these in ascending order
% startSamples = locsMAX;
startSamples = 1;


startSamples = sort(startSamples);
signalLength = length(L5S1Trq);

%% First indication of approximated cutting points
% Samples = [1; startSamples; signalLength];
Samples = [startSamples; signalLength];

%% Make distinction between horizontal movements (3 reps) and vertical
% movements (10 reps)
% if Datastr.Info.horMovFlag == 1
%     nReps = 10;
%     % Samples = Samples(1:2:end);
%     repMat = {'rep1' 'rep2' 'rep3' 'rep4' 'rep5' 'rep6' 'rep7' 'rep8' 'rep9' 'rep10'};
% elseif Datastr.Info.vertMovFlag == 1
%     nReps = 10;   
%     repMat = {'rep1' 'rep2' 'rep3' 'rep4' 'rep5' 'rep6' 'rep7' 'rep8' 'rep9' 'rep10'};
% end
nReps =1;
% Save these samples as 'broadSamples'
broadSamples.Start = Samples(1:end-1);
broadSamples.Stop  = Samples(2:end);

%% Cut samples
% tau = zeros(1,nReps);
% 
% % Iterate through each struct
% for i = 1:length(Samples)-1
%     Repetitions.(repMat{i}) = L5S1Trq(Samples(i):Samples(i+1));
% end
% 
% % Calculate delay between repetitions
% for n = 1:nReps   
%     [r,lags] = xcorr(Repetitions.(repMat{1}), Repetitions.(repMat{n}));
%     [~,ind] = max(r);
%     tau(n) = lags(max(ind));
% end
% 
% % Align repetitions
% noDelayMat = zeros(nReps, length(Repetitions.(repMat{1}))+max(tau)+abs(min(tau)));
% tau = tau + abs(min(tau)) + 1;      % Make sure all delays are positive, and lowest tau value = 1
% 
% for n = 1:nReps
% noDelayMat(n,tau(n):length(Repetitions.(repMat{n}))+tau(n)-1) = Repetitions.(repMat{n});
% end
% 
% % Find start and stop sample
% noDelayMatSum = sum(noDelayMat);
% threshold = 0.2*max(noDelayMatSum);             % Set to 20% of maximum value
% intersection=find(noDelayMatSum>threshold);
% 
% % Set first sample / last sample n samples before / after threshold
% % respectively
% firstSample     = intersection(1)-ceil((length(noDelayMatSum)-intersection(1)-(length(noDelayMatSum)-intersection(end)))/15);
% 
% % First sample should be positive
% if firstSample <= 0
%     firstSample = intersection(1);
% end
% 
% lastSample      = intersection(end)+ceil((length(noDelayMatSum)-intersection(1)-(length(noDelayMatSum)-intersection(end)))/15);
% if lastSample > length(noDelayMat)
%     lastSample = length(noDelayMat);
% end
% 
% % firstSample and lastSample are relative to noDelayMatrix. So to identify
% % the absolute start and stop samples, we can perform cross correlation to
% % find the start sample, and based on length (lastSample-firstSample) we
% % can identify stop samples
% for n = 1:nReps 
%     % For Start Samples
%     RepetitionsIntermediate.(repMat{n}) = noDelayMat(n,firstSample:lastSample);
%     [r,lags] = xcorr(Repetitions.(repMat{n}), RepetitionsIntermediate.(repMat{n}));
%     [~,ind] = max(r);
%     tau(n) = lags(max(ind));
% 
% end
% 
% % Find absolute start and stop samples in torque data
% % These can later be used for EMG cutting as well

absSamples.Start = Samples(1:end-1);
absSamples.Stop = Samples(end);

% absSamples.Start = Samples(1:end-1) + tau';
% absSamples.Stop = absSamples.Start + (lastSample-firstSample);

% if absSamples.Start(1) <= 0
%     absSamples.Start(1) = 1;
%     absSamples.Stop(1) = absSamples.Stop(2)-absSamples.Start(2)+1;
% end
% 
% if absSamples.Stop(end) > length(L5S1Trq)
%     absSamples.Stop(end) = length(L5S1Trq);
%     absSamples.Start(end) = absSamples.Stop(end)-(absSamples.Stop(2)-absSamples.Start(2));
% end

% Save absSamples in Datastr
Datastr.cutMovements.broadSamples = broadSamples;
Datastr.cutMovements.sharpenedSamples = absSamples;
Datastr.cutMovements.stationaryStart = genStart;
Datastr.cutMovements.stationaryEnd = genStop;

%% Resample to get movement phase [0 100]% 

% Method = {'ID'; 'IK'};
Method = 'ID'; %% controllare come era all'inizio
[Datastr] = getMovementPhaseMoments(Datastr, Method);


end

