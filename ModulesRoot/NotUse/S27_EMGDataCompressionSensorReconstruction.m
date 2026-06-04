function [Datastr] = S27_EMGDataCompressionSensorReconstruction(Datastr, osFolder, EMGFormat, onlyBackMuscles, nrSensors, NMFsparseConstraint, trainRatio, sensorInput)
% gBMPDynUI osFolder=1; EMGFormat=1; onlyBackMuscles=1;  nrSensors = 1; NMFsparseConstraint=1; trainRatio=1; sensorInput=1; 

% This script performs data compression (using NMF or SVD) of measured EMG data based on
% the user's request.
% Inputs: 
%   1. onlyBackMuscles (1 if yes, use 6 muscles (dorsal muscles only), 0 if no, use 12 muscles (all measured muscles))
%   2. nrSensor: How many sensors are used in the reduced model (for example: 2)
%   3. NMFsparseConstraint: Do you want to use a sparse NMF optimizer (1 if yes, 0 if you want default)
%   4. applyFiltering: Do you want to filter the Training/Test data? (1 if yes, else 0)
%
% Outputs:
% Datastr.EMGDecomposition.NMF and Datastr.EMGDecomposition.SVD 
% Datastr.cutMovements.EMG_NMFreducedSensor and Datastr.cutMovements.EMG_SVDreducedSensor

% Select which muscles are used
if onlyBackMuscles == 1
    muscleNumbers = 6;
    
elseif onlyBackMuscles == 0
    muscleNumbers = 12;
else
    disp('Please enter if you want to use only posterior muscles (1) or all muscles (0)')
    return
end

% Get muscleNames
muscleNames = Datastr.EMG.DataLabel(1:muscleNumbers);

% Sparsity constraints NMF
params.maxiter      = 100; 
params.sparsevar    = 0.2;
params.sparse       = NMFsparseConstraint;            % Sparsity constraint on (1) or off (0)

%% PART 1: Number of Synergies

% For this part, check for number of synergies
Data.V = Datastr.Resample.NormEMG(:,1:muscleNumbers)';

% We want to analyze all synergies (1: #nrOfMuscles - correlates to the smallest matrix size)
nrSyn = 1:min(size(Data.V));

% Data decomposition NMF
[Datastr.EMGDecomposition.nrSynergies.NMF] = NMFdecomp(Data, params, nrSyn);

% Data decomposition SVD
[Datastr.EMGDecomposition.nrSynergies.SVD] = SVDdecomp(Data, nrSyn);

%% PART 2: Sensor Reduction

% For this part, obtain Training and Test datasets
if Datastr.Info.horMovFlag == 1
    numTrials = 3;
elseif Datastr.Info.vertMovFlag == 1
    numTrials = 6;
end

valRatio            = 0;                                    % No validation set is used
testRatio           = round(1-trainRatio,3);                % Use others for test

% Divide trials randomly into training and test dataset 
[TrainingData.trainInd, ~, TestData.testInd] = dividerand(numTrials, trainRatio, valRatio, testRatio);

% If all trials are used for training, use all trials for analysis as well
% (to evaluate impact of splitting data into training and test datasets)
if testRatio == 0
    TestData.testInd = TrainingData.trainInd;
end

% Remove stationary parts from EMG data (override Data.V)
Data.V = Data.V(1:muscleNumbers, Datastr.cutMovements.stationaryStart: Datastr.cutMovements.stationaryEnd);

% Create TrainingSet
for n = 1:length(TrainingData.trainInd)
TrainingData.collectData(:,:,n) = Data.V(:,Datastr.cutMovements.sharpenedSamples.Start(TrainingData.trainInd(n)): Datastr.cutMovements.sharpenedSamples.Stop(TrainingData.trainInd(n)));
end

% Reshape into 2D
newLength = size(TrainingData.collectData,2) * size(TrainingData.collectData,3);
TrainingData.V = reshape(TrainingData.collectData, muscleNumbers, newLength);

% Create TestSet
for n = 1:length(TestData.testInd)
TestData.collectData(:,:,n) = Data.V(:,Datastr.cutMovements.sharpenedSamples.Start(TestData.testInd(n)): Datastr.cutMovements.sharpenedSamples.Stop(TestData.testInd(n)));
end                                                                                                                                            

% Reshape into 2D
newLength = size(TestData.collectData,2) * size(TestData.collectData,3);
TestData.V = reshape(TestData.collectData, muscleNumbers, newLength);

% Sensor reconstruction
% We want to analyze the case where nrSyn = nrSensors (=2)
nrSyn = nrSensors;

% Save muscleNames in struct
Datastr.EMGDecomposition.musleNames = muscleNames;

% Data decomposition NMF - Calibration using only TrainingData
[Datastr.EMGDecomposition.NMF] = NMFdecomp(TrainingData, params, nrSyn);
nrSynNamesNMF = fieldnames(Datastr.EMGDecomposition.NMF);
Datastr.EMGDecomposition.NMF.(nrSynNamesNMF{1}).trainTrials = TrainingData.trainInd;

% Data decomposition SVD - Calibration using only TrainingData
[Datastr.EMGDecomposition.SVD] = SVDdecomp(TrainingData, nrSyn);
nrSynNamesSVD = fieldnames(Datastr.EMGDecomposition.SVD);
Datastr.EMGDecomposition.SVD.(nrSynNamesSVD{1}).trainTrials = TrainingData.trainInd;

% Calculate sensor reconstruction using NMF basis - Validation using only
% TestData
[Datastr.EMGDecomposition.NMF] = sensorReconstruction(nrSensors, Datastr.EMGDecomposition.NMF, TestData.V, muscleNames, sensorInput);
nrSynNamesNMF = fieldnames(Datastr.EMGDecomposition.NMF);
Datastr.EMGDecomposition.NMF.(nrSynNamesNMF{2}).testTrials = TestData.testInd;

% Calculate sensor reconstruction using SVD basis - Validation using only
% TestData
[Datastr.EMGDecomposition.SVD] = sensorReconstruction(nrSensors, Datastr.EMGDecomposition.SVD, TestData.V, muscleNames, sensorInput);
nrSynNamesSVD = fieldnames(Datastr.EMGDecomposition.SVD);
Datastr.EMGDecomposition.SVD.(nrSynNamesSVD{2}).testTrials = TestData.testInd;

%% Calculate new sample indices & save these

nReps = length(TestData.testInd);          % only use TestData
sampleLength = Datastr.cutMovements.sharpenedSamples.Stop(1)-Datastr.cutMovements.sharpenedSamples.Start(1)+1;
newStartSamples = 1 + (0:nReps-1) * sampleLength;
newStopSamples  = newStartSamples + sampleLength - 1;
Datastr.cutMovements.sharpenedSamplesTestData.Start = newStartSamples;
Datastr.cutMovements.sharpenedSamplesTestData.Stop = newStopSamples;

%% Cut Movements for NMF, SVD and TestTrials in

Method = 'EMG_NMFreducedSensor';
[Datastr] = getMovementPhaseMoments(Datastr, Method);

Method = 'EMG_SVDreducedSensor';
[Datastr] = getMovementPhaseMoments(Datastr, Method);

Method = 'EMG_TestTrials';
[Datastr] = getMovementPhaseMoments(Datastr, Method);

 %% Reduced sensor set-up EMG files
 % get subject folder
 subjroot = Datastr.Info.SubjRoot;
 bckslsh = strfind(subjroot,'\');
 
 if isempty(bckslsh)
    bckslsh = 0;
 end
    
 trial = Datastr.Info.Trial;
 trialOutputPathreducedEMG   = [subjroot '\' osFolder '\' subjroot(bckslsh(end)+1:end) trial 'reducedEMG'];

        % Find non empty EMG labels
        emptyEMGlabels = Datastr.EMG.DataLabel == '';
        [~,locs]=find(~emptyEMGlabels);
        EMGlabels = Datastr.EMG.DataLabel(locs);
        
        % Perform this code for both NMF and SVD to create reducedSensorEMGNMF and
        % reducedSensorEMGSVD

        for i = 1:2
            if i == 1
                decompMethod = 'NMF';
            elseif i == 2
                decompMethod = 'SVD';
            end

        % Find normal EMG matrix size
        normEMGmatSize = size(Datastr.Resample.NormEMG);
        reducedSensorEMGdata = Datastr.EMGDecomposition.(decompMethod).ReducedSensorSetUp.EMGest';
        reducedEMGmatSize = size(reducedSensorEMGdata);
        zeroMat = zeros(reducedEMGmatSize(1),normEMGmatSize(2)-reducedEMGmatSize(2));

        % Add zeros for frontal muscles
        fullReducedSensorEMGdata = [reducedSensorEMGdata zeroMat];
        
        % Get EMGtime
        markerFrameRate = Datastr.Resample.FrameRate;
        NormEMG = Datastr.Resample.NormEMG;
        EMGtime = (0:size(NormEMG ,1)-1)'./markerFrameRate;
        EMGtime = EMGtime(1:reducedEMGmatSize,:);

        printEMGmot([trialOutputPathreducedEMG decompMethod], EMGtime, fullReducedSensorEMGdata, EMGlabels, EMGFormat);

        end

