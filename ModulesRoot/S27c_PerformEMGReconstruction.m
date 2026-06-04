function [Datastr] = S27c_PerformEMGReconstruction(Datastr, osFolder, NMFsparseConstraint, nrSensors, sensorInput, EMGFormat)
% gBMPDynUI osFolder=1; NMFsparseConstraint=1; nrSensors=1; sensorInput=1; EMGFormat=1;

% This script creates a NMF and SVD based model, and tests the performance of this model based on the test dataset
% 
% Inputs: 
% Datastr                   -> Subject data
% NMFsparseConstraint       -> sparse NMF decomposition (1=yes, 0=no)
% nrSensors                 -> Nr. of desired sensors (1,2,3,4,5 or 6)
% sensorInput               -> if [] best sensors are chosen, otherwise
%                              specify which sensors should be used (example [1 2])
% osFolder                  -> Specify location of EMG.sto files ('OS\DataFiles';)
% EMGFormat                 -> Specify file format EMG (.sto)
% 
% Outputs:
% DecompositionModelNMF 
% DecompositionModelSVD
% Datastr.EMGModelEval.NMF      -> NMF Model outputs based on Testdata
% Datastr.EMGModelEval.SVD      -> SVD Model outputs based on Testdata
% Datastr.cutMovements.(Method) -> NMF, SVD, and TestData for 0-100% movementphase
%                                   
% Jan Willem Rook 05-01-2024

% Indicate calibration Set
CalibrationSet.fileName         = [Datastr.Info.SubjRoot '\CalibrationSet.mat'];  

% Indicate Decomposition Sets
DecompositionModelNMF.fileName       = [Datastr.Info.SubjRoot '\DecompositionModelNMF.mat'];
DecompositionModelSVD.fileName       = [Datastr.Info.SubjRoot '\DecompositionModelSVD.mat'];

%% Check if DecompositionModelNMF exists

if isfile(DecompositionModelNMF.fileName)
     % File exists, proceed.
     load(DecompositionModelNMF.fileName)
else
     % File does not exist.
     if Datastr.Info.exoFlag == 1 
        disp('Create a model based on noExo data')
        return
     elseif Datastr.Info.exoFlag == 0
     load(CalibrationSet.fileName)
     TrainingData.V = CalibrationSet.V;

     % Sparsity constraints NMF
     params.maxiter      = 100; 
     params.sparsevar    = 0.2;
     params.sparse       = NMFsparseConstraint;            % Sparsity constraint on (1) or off (0)

     % We want to analyze all synergies (1: #nrOfMuscles - correlates to the smallest matrix size)
     nrSyn = 1:min(size(TrainingData.V));
     DecompositionModelNMF.Model = NMFdecomp(TrainingData, params, nrSyn);

     % Save the model
     save(DecompositionModelNMF.fileName, "DecompositionModelNMF")
     end
end

%% Same for SVD

if isfile(DecompositionModelSVD.fileName)
     % File exists load it and proceed.
     load(DecompositionModelSVD.fileName)
else
     % File does not exist.
     if Datastr.Info.exoFlag == 1 
        disp('Create a model based on noExo data')
        return
     elseif Datastr.Info.exoFlag == 0
     load(CalibrationSet.fileName)
     TrainingData.V = CalibrationSet.V;
     
     % We want to analyze all synergies (1: #nrOfMuscles - correlates to the smallest matrix size)
     nrSyn = 1:min(size(TrainingData.V));
     DecompositionModelSVD.Model = SVDdecomp(TrainingData, nrSyn);

     % Save the model
     save(DecompositionModelSVD.fileName, "DecompositionModelSVD")
     end
end

%% ReducedSensorModel evaluation on TestData

% Perform sensor reconstruction for NMF and SVD
muscleNames = Datastr.EMGDataset.muscleNames;  
[Datastr.EMGModelEval.NMF] = sensorReconstruction(nrSensors, DecompositionModelNMF.Model, Datastr.EMGDataset.TestData.V, muscleNames, sensorInput);
[Datastr.EMGModelEval.SVD] = sensorReconstruction(nrSensors, DecompositionModelSVD.Model, Datastr.EMGDataset.TestData.V, muscleNames, sensorInput);

%% Cut data in single movements for NMF reconstructed-, SVD reconstructed- and Test data

Method = 'EMG_NMFreducedSensor';
[Datastr] = getMovementPhaseMoments(Datastr, Method);

Method = 'EMG_SVDreducedSensor';
[Datastr] = getMovementPhaseMoments(Datastr, Method);

Method = 'EMG_TestData';
[Datastr] = getMovementPhaseMoments(Datastr, Method);

 %% Reduced sensor set-up EMG files (.sto)
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
        reducedSensorEMGdata = Datastr.EMGModelEval.(decompMethod).EMGestimated';
        reducedEMGmatSize = size(reducedSensorEMGdata);
        zeroMat = zeros(reducedEMGmatSize(1),normEMGmatSize(2)-reducedEMGmatSize(2));

        % Add zeros for frontal muscles
        fullReducedSensorEMGdata = [reducedSensorEMGdata zeroMat];
        
        % Get EMGtime
        markerFrameRate = Datastr.Resample.FrameRate;
        NormEMG = Datastr.Resample.NormEMG;
        EMGtime = (0:size(NormEMG ,1)-1)'./markerFrameRate;
        % da cambiare la riga commentata, il codice corretto è
        % reducedEMGmatSize
        % EMGtime = EMGtime(1:normEMGmatSize,:);
        EMGtime = EMGtime(1:reducedEMGmatSize,:);

        printEMGmot([trialOutputPathreducedEMG decompMethod], EMGtime, fullReducedSensorEMGdata, EMGlabels, EMGFormat);

        end

end