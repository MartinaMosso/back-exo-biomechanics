function [Datastr] = S27b_CreateSubjectCalibrationSet(Datastr)

% This script creates a CalibrationSet.mat that will be used to calculate the synergy matrix W
% the user's request.
% Inputs: 
% Datastr                   -> Subject data

% Ouput:
% CalibrationSet.mat with:
% V -> EMG envelopes of all included Training sets. This will be used for
% decomposition (NMF or SVD) according to V = WH (W is synergy matrix, this matrix will be obtained through calibration. H is trial dependent)
% musclenames -> Contains all names of included muscles (per index of V)
% TrialInfo -> Which trial has been included in trainingset and absolute
% location in V.
%

%% First delete existing models based on previous calibration

% Indicate Decomposition Models
DecompositionModelNMF.fileName       = [Datastr.Info.SubjRoot '\DecompositionModelNMF.mat'];
DecompositionModelSVD.fileName       = [Datastr.Info.SubjRoot '\DecompositionModelSVD.mat'];

% Delete NMF model, if present
if isfile(DecompositionModelNMF.fileName)
     % File exists, delete model.
     delete(DecompositionModelNMF.fileName);
else
     % File does not exist, proceed.
end

% Same for SVD
if isfile(DecompositionModelSVD.fileName)
     % File exists, delete model.
     delete(DecompositionModelSVD.fileName);
else
     % File does not exist, proceed.
end

%% Now create CalibrationSet.mat

CalibrationSet.fileName = [Datastr.Info.SubjRoot '\CalibrationSet.mat'];  
Trial = Datastr.Info.Trial;

if isfile(CalibrationSet.fileName)
     % File exists.
     load(CalibrationSet.fileName)
     IndexShift = length(CalibrationSet.V);
     CalibrationSet.V = horzcat(CalibrationSet.V, Datastr.EMGDataset.TrainingData.V);
     CalibrationSet.(Trial).testInd = Datastr.EMGDataset.TrainingData.testInd;
     CalibrationSet.(Trial).Samples.Start = Datastr.EMGDataset.TrainingData.Samples.Start + IndexShift;  
     CalibrationSet.(Trial).Samples.Stop  = Datastr.EMGDataset.TrainingData.Samples.Stop + IndexShift;
else
     % File does not exist.
     CalibrationSet.V = Datastr.EMGDataset.TrainingData.V;
     CalibrationSet.muscleNames = Datastr.EMGDataset.muscleNames;
     CalibrationSet.(Trial).testInd = Datastr.EMGDataset.TrainingData.testInd;
     CalibrationSet.(Trial).Samples = Datastr.EMGDataset.TrainingData.Samples;  
end

save(CalibrationSet.fileName,"CalibrationSet")

end
