function [Datastr] = S23_GetCEINMScalibration(Datastr)

% create calibration files in folder
getCalibFilesCEINMS(Datastr)

% Select calibration files {random pick}

% Get info
subjroot = Datastr.Info.SubjRoot;
trial = Datastr.Info.Trial;
ceinmsFolder = 'CEINMS';

bckslsh = strfind(subjroot,'\');
if isempty(bckslsh)
    bckslsh = 0;
end

subID = subjroot(bckslsh(end)+1:end);

% Get some directories
dirCalSetup = [subjroot '\' ceinmsFolder '\calibration\Setup\'];

% Go to the correct location -> CEINMSOffline\ceinms\calibration\Setup
% Do: Change set-up files
% Input variables: [SUB#], [Trial#]

% CEINMS calibration calls {calibrationSetup_L5S1_stiff.xml}
% 1. don't change <subjectFile>
% 2. don't change <excitationGeneratorFile>
% 3. change name <calibrationFile> to 'calibrationCfg_L5S1_stiff_[SUB#].xml'

% Change calibrationSetup_L5S1_stiff
xmlFilePath = [dirCalSetup 'calibrationSetup_L5S1_stiff.xml'];
xmlSet = xmlread(xmlFilePath);
persCalibrationFileCfg = ['calibrationCfg_L5S1_stiff' subID trial '.xml'];
xmlSet.getElementsByTagName('calibrationFile').item(0).setTextContent([persCalibrationFileCfg]);
xmlFileChanged = ['calibrationSetup_L5S1_stiff' subID trial '.xml'];
xmlwrite([dirCalSetup xmlFileChanged], xmlSet);

% Change calibrationCfg_L5S1_stiff
xmlFilePath = [dirCalSetup 'calibrationCfg_L5S1_stiff.xml'];
xmlSet = xmlread(xmlFilePath);
persTrialSet = ['calibrationTrials' subID trial '.xml'];
xmlSet.getElementsByTagName('trialSet').item(0).setTextContent([persTrialSet]);
xmlFileChanged = ['calibrationCfg_L5S1_stiff' subID trial '.xml'];
xmlwrite([dirCalSetup xmlFileChanged], xmlSet);

% reWrite 
% In 'calibrationTrials.xml' change variable names to correct
xmlFilePath = [dirCalSetup 'calibrationTrials.xml'];
foo = strfind(xmlFilePath,'\');
xmlFileName = xmlFilePath(foo(end)+1:end);
[~, xmlFileName, ~] = fileparts(xmlFileName);
xmlSet = xmlread(xmlFilePath);

% Rewrite elements 
% For muscleTendonLength
persMuscleTendonLengthFile = ['..\..\..\OS\muscleAnalysis\' subID trial '_MusA_MTULen' '.sto'];
xmlSet.getElementsByTagName('muscleTendonLengthFile').item(0).setTextContent([persMuscleTendonLengthFile]);

% For excitationsFile
persExcitationsFile = ['..\..\..\OS\DataFiles\' subID trial 'EMG' '.sto'];
xmlSet.getElementsByTagName('excitationsFile').item(0).setTextContent([persExcitationsFile]);

% For momentArmsFiles
persMomentArmsFile = ['..\..\..\OS\muscleAnalysis\' subID trial '_MusA_MA_L5_S1_Flex_Ext' '.sto'];
xmlSet.getElementsByTagName('momentArmsFile').item(0).getFirstChild.setTextContent([persMomentArmsFile]);

% For externalTorquesFile
persExternalTorques = ['..\..\..\OS\DataFiles\' subID trial 'ID' '.sto'];
xmlSet.getElementsByTagName('externalTorquesFile').item(0).setTextContent([persExternalTorques]);

% Save file
xmlFileChanged = [xmlFileName subID trial '.xml'];
xmlwrite([dirCalSetup xmlFileChanged], xmlSet);

%2 Perform calibration [CEINMSCalibrate]
calCommand = ['CEINMSCalibrate -S "' dirCalSetup 'calibrationSetup_L5S1_stiff' subID trial '.xml"'];
system(calCommand);

end