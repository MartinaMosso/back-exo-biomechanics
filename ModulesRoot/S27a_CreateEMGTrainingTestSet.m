function [Datastr] = S27a_CreateEMGTrainingTestSet(Datastr, onlyBackMuscles, trainRatio)
% gBMPDynUI onlyBackMuscles=1; trainRatio=1;

% This script divides data into training and test datasets.
% Inputs: 
% Datastr                   -> Subject data
% onlyBackMuscles [0 or 1]  -> Include only backmuscles (1) or all muscles (0)
% trainRatio                -> Ratio of data used for training [between 1/numTrials and 1]
% trainRatio for Exo trials should be set to 0! (we use NMF/SVD model of noExo trails)

% Ouput:
% Datastr.EMGDataset with fields TrainingData and TestData that contain:
% V [muscleNumber, total samplelength]  -> EMG linear envelopes from Datastr.Resample.NormEMG
% testInd                               -> Trials that have been included in Dataset
% Samples                               -> Start and Stop indices of included trials

%% Select which muscles are used
if onlyBackMuscles == 1
    muscleNumbers = 6;
    
elseif onlyBackMuscles == 0
    muscleNumbers = 16;
else
    disp('Please enter if you want to use only posterior muscles (1) or all muscles (0)')
    return
end

%% Get muscleNames
muscleNames = Datastr.EMG.DataLabel(1:muscleNumbers);
Datastr.EMGDataset.muscleNames = muscleNames;

%% For this part, obtain Training and Test datasets
if Datastr.Info.horMovFlag == 1
    % numTrials = 10;
        numTrials = 1;% pahse 2

elseif Datastr.Info.vertMovFlag == 1
    % numTrials = 10;
    numTrials = 1; % phase 2
end

valRatio            = 0;                                    % No validation set is used
testRatio           = round(1-trainRatio,3);                % Use others for test

% If no training trials are included, return and give error message
if trainRatio < round(1/numTrials,2) && trainRatio > 0
    leastRatio = round(1/numTrials,2);
    disp(['No training data included, trainRatio should at least be: ' num2str(leastRatio)])
    return
end

% If no training trials are included, return and give error message
if trainRatio == 0
    disp('No training data included (only for Exo trials)')
    if Datastr.Info.exoFlag == 0
        return      % No exo trial, so 0 trainRatio is invalid
    end
end

% if Datastr.Info.exoFlag == 0
% Divide trials randomly into training and test dataset 
[TrainingData.trainInd, ~, TestData.testInd] = dividerand(numTrials, trainRatio, valRatio, testRatio);
% elseif Datastr.Info.exoFlag == 1
% TrainingData.trainInd = [];
% TestData.testInd = 1:numTrials;
% end


% If all trials are used for training, use all trials for analysis as well
% (to evaluate impact of splitting data into training and test datasets)
if testRatio == 0
    TestData.testInd = TrainingData.trainInd;
end

% Load NormEMG
Data.V = Datastr.Resample.NormEMG(:,1:muscleNumbers)';

% Remove stationary parts from EMG data (override Data.V)
Data.V = Data.V(1:muscleNumbers, Datastr.cutMovements.stationaryStart: Datastr.cutMovements.stationaryEnd);

% Create TrainingSet
% if Datastr.Info.exoFlag == 0
for n = 1:length(TrainingData.trainInd)
TrainingData.collectData(:,:,n) = Data.V(:,Datastr.cutMovements.sharpenedSamples.Start(TrainingData.trainInd(n)): Datastr.cutMovements.sharpenedSamples.Stop(TrainingData.trainInd(n)));
% end

% Reshape into 2D
newLength = size(TrainingData.collectData,2) * size(TrainingData.collectData,3);
Datastr.EMGDataset.TrainingData.V = reshape(TrainingData.collectData, muscleNumbers, newLength);
Datastr.EMGDataset.TrainingData.testInd = TrainingData.trainInd;
end

% Create TestSet
for n = 1:length(TestData.testInd)
TestData.collectData(:,:,n) = Data.V(:,Datastr.cutMovements.sharpenedSamples.Start(TestData.testInd(n)): Datastr.cutMovements.sharpenedSamples.Stop(TestData.testInd(n)));
end                                                                                                                                            

% Reshape into 2D
newLength = size(TestData.collectData,2) * size(TestData.collectData,3);
Datastr.EMGDataset.TestData.V = reshape(TestData.collectData, muscleNumbers, newLength);
Datastr.EMGDataset.TestData.testInd = TestData.testInd;

%% Calculate Sample indices & save these

% if Datastr.Info.exoFlag == 0
    caseIndex = [1 2];
% elseif Datastr.Info.exoFlag == 1
%     caseIndex = 1;
%     if isfield(Datastr.EMGDataset, "TrainingData")
%     Datastr.EMGDataset = rmfield(Datastr.EMGDataset, "TrainingData");       % Remove existing trainingData (no training used for Exo trials)
%     end
% end

for n = caseIndex
switch n
    case 1
    dataType = 'TestData';
    case 2
    dataType = 'TrainingData';
end

nReps = length(Datastr.EMGDataset.(dataType).testInd);          
sampleLength = Datastr.cutMovements.sharpenedSamples.Stop(1)-Datastr.cutMovements.sharpenedSamples.Start(1)+1;
newStartSamples = 1 + (0:nReps-1) * sampleLength;
newStopSamples  = newStartSamples + sampleLength - 1;
Datastr.EMGDataset.(dataType).Samples.Start = newStartSamples;
Datastr.EMGDataset.(dataType).Samples.Stop = newStopSamples;

end

end
