function [Datastr] = S26_createCalibrationFiles(Datastr, osFolder, EMGFormat, sampleType, nrSensors)
% gBMPDynUI osFolder=1; EMGFormat = 1; sampleType=1; nrSensors=1;

% This script generates the required files for CEINMS calibration based on
% the user's request.
% Inputs: 
%   1. Datastr to get momentArmData, MuscleTLength, normEMG, IDTrqData
%   2. EMGFormat from user input (use '.sto')
%   3. sampleType ('broadSamples', or 'sharpenedSamples')
%
% Outputs:
% Files in folder CEINMScalibFiles that will be used for CEINMS calibration 

%% Inputs
rootfolder = Datastr.Info.SubjRoot;
trial = Datastr.Info.Trial;
bckslsh = strfind(rootfolder,'\');
savename = [rootfolder(bckslsh(end)+1:end) trial];
coordinateNames = {'L5_S1_Flex_Ext'};

%% Check if folder CEINMScalibFiles exists, else create this folder

if ~exist([rootfolder '\CEINMScalibFiles'], 'dir')
       mkdir([rootfolder '\CEINMScalibFiles'])
end

%% Find non empty EMG labels
emptyEMGlabels = Datastr.EMG.DataLabel == '';
[~,locs]=find(~emptyEMGlabels);
EMGlabels = Datastr.EMG.DataLabel(locs);

%% Prepare all files for CEINMS calibration inside calibrationTrials.xml
% 
% Of all movements, one trial will be included in the calibration file
% 1. muscleTendonLengthFile > OS\muscleAnalysis\MusA_MTULen.sto
% 2. excitationsFile > OS\DataFiles\EMG.sto
% 3. momentArmsFiles > OS\muscleAnalysis\MusA_MA_L5_S1_Flex_Ext.sto
% 4. externalTorquesFile > OS\DataFiles\ID.sto

nReps = length(Datastr.cutMovements.(sampleType).Start);
if nReps ==10
    repMat = {'rep1' 'rep2' 'rep3' 'rep4' 'rep5' 'rep6' 'rep7' 'rep8' 'rep9' 'rep10'};

else
    % repMat = {'rep1' 'rep2' 'rep3' 'rep4' 'rep5' 'rep6' 'rep7' 'rep8' 'rep9' 'rep10' 'rep11'};
        repMat = {'rep1'};

end

% Crate all files needed for calibration

start = Datastr.cutMovements.(sampleType).Start;
stop = Datastr.cutMovements.(sampleType).Stop;

for n = 1:nReps

%% Moment arm files
momentArmFile = [rootfolder '\CEINMScalibFiles\' savename repMat{n} '_MusA_MA_' coordinateNames{1} '.sto'];
printMomentArmsto(momentArmFile, coordinateNames{1}, Datastr.Resample.MomentArmData(start(n): stop(n),:), Datastr.Resample.muscleListExtracted, Datastr.Resample.IKAngData(start(n): stop(n),1));
% printMomentArmsto(momentArmFile, coordinateNames{1}, Datastr.Resample.MomentArmData(Datastr.cutMovements.(sampleType).Start(n): Datastr.cutMovements.(sampleType).Stop(n),:), Datastr.Resample.muscleListExtracted, Datastr.Resample.IKAngData(Datastr.cutMovements.(sampleType).Start(n): Datastr.cutMovements.(sampleType).Stop(n),1));

%% Muscle tendon length files
MuscleTLengthFile = [rootfolder '\CEINMScalibFiles\' savename repMat{n} '_MusA_MTULen.sto'];
printMuscleTLengthsto(MuscleTLengthFile, Datastr.Resample.MuscleTLength(start(n): stop(n),:), Datastr.Resample.muscleListExtracted, Datastr.Resample.IKAngData(start(n): stop(n),1));
% printMuscleTLengthsto(MuscleTLengthFile, Datastr.Resample.MuscleTLength(Datastr.cutMovements.(sampleType).Start(n): Datastr.cutMovements.(sampleType).Stop(n),:), Datastr.Resample.muscleListExtracted, Datastr.Resample.IKAngData(Datastr.cutMovements.(sampleType).Start(n): Datastr.cutMovements.(sampleType).Stop(n),1));

%% EMG files
EMGFile = [rootfolder '\CEINMScalibFiles\' savename repMat{n} 'EMG'];
printEMGmot(EMGFile, Datastr.Resample.IKAngData(start(n): stop(n),1), Datastr.Resample.NormEMG(start(n): stop(n),:), EMGlabels, EMGFormat);
% printEMGmot(EMGFile, Datastr.Resample.IKAngData(Datastr.cutMovements.(sampleType).Start(n): Datastr.cutMovements.(sampleType).Stop(n),1), Datastr.Resample.NormEMG(Datastr.cutMovements.(sampleType).Start(n): Datastr.cutMovements.(sampleType).Stop(n),:), EMGlabels, EMGFormat);

%% Reduced sensor set-up EMG files
% Perform this code for both NMF and SVD to create reducedSensorEMGNMF and
% reducedSensorEMGSVD

% sensModel = ['nrSyn' num2str(nrSensors)];
% 
% for i = 1:2
%     if i == 1
%         decompMethod = 'NMF';
%         load([rootfolder '\DecompositionModelNMF'], 'DecompositionModelNMF')
%         % Load synergy matrix W
%         SynergyMatEMG.W = DecompositionModelNMF.Model.(sensModel).SynergyMat.W;
%     elseif i == 2
%         decompMethod = 'SVD';
%         load([rootfolder '\DecompositionModelSVD'], 'DecompositionModelSVD')
%         % Load synergy matrix W
%         SynergyMatEMG.W = DecompositionModelSVD.Model.(sensModel).SynergyMat.W;
%     end
% 
% reducedSensorEMGFile = [rootfolder '\CEINMScalibFiles\' savename repMat{n} 'reducedSensorEMG' decompMethod];

%% Get EMG specifics
allEMG = Datastr.Resample.NormEMG';
markerFrameRate = Datastr.Resample.FrameRate;
EMGtime = (0:size(allEMG ,2)-1)'./markerFrameRate;

%% Perform EMG estimation based on 2 measured sensors
% sensors = Datastr.EMGModelEval.(decompMethod).sensors;
% EMG(1:nrSensors,:) = allEMG(sensors,:);
% 
% % Obtain reconstructed H
% reconH = SynergyMatEMG.W(sensors,:)\EMG; 
% 
% % Obtain reconstructed EMG
% EMGest = (SynergyMatEMG.W*reconH);
% 
% % Check that values are between [0 1]
% EMGest(EMGest < 0 ) = 0;
% EMGest(EMGest > 1 ) = 1;
% 
% % We need reducedSensorEMGdata both full length and cut samples (for CEINMS calibration)
% % cut samples
% normEMGmatSize = size(Datastr.Resample.NormEMG);
% reducedSensorEMGdata = EMGest(:,Datastr.cutMovements.(sampleType).Start(n): Datastr.cutMovements.(sampleType).Stop(n))';
% reducedEMGmatSize = size(reducedSensorEMGdata);
% zeroMat = zeros(reducedEMGmatSize(1),normEMGmatSize(2)-reducedEMGmatSize(2));
% 
% % Add zeros for frontal muscles
% fullReducedSensorEMGdata = [reducedSensorEMGdata zeroMat];
% 
% printEMGmot(reducedSensorEMGFile, EMGtime(Datastr.cutMovements.(sampleType).Start(n): Datastr.cutMovements.(sampleType).Stop(n),1), fullReducedSensorEMGdata, EMGlabels, EMGFormat);
% 
% % full length
% reducedSensorEMGdata = EMGest';
% reducedEMGmatSize = size(reducedSensorEMGdata);
% zeroMat = zeros(reducedEMGmatSize(1),normEMGmatSize(2)-reducedEMGmatSize(2));
% 
% % Add zeros for frontal muscles
% fullReducedSensorEMGdata = [reducedSensorEMGdata zeroMat];
% 
% trialOutputPathreducedEMG   = [rootfolder '\' osFolder '\' rootfolder(bckslsh(end)+1:end) trial 'reducedEMG'];
% printEMGmot([trialOutputPathreducedEMG decompMethod], EMGtime, fullReducedSensorEMGdata, EMGlabels, EMGFormat);
% 
% end

%% Inverse dynamics files
IDFile = [rootfolder '\CEINMScalibFiles\' savename repMat{n} 'ID.sto'];
[~, ncol] = size(Datastr.Resample.IDTrqData);
printIDsto(IDFile, Datastr.Resample.IDTrqData(Datastr.cutMovements.(sampleType).Start(n): Datastr.cutMovements.(sampleType).Stop(n),:), Datastr.Resample.IDTrqDataLabel(1,1:ncol) ,Datastr.Resample.IKAngData(Datastr.cutMovements.(sampleType).Start(n): Datastr.cutMovements.(sampleType).Stop(n),1));

end
end