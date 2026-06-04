function [Datastr] = S24_executeCEINMS(Datastr, calibCases, reducedSensor, processedEMGdata)
% gBMPDynUI calibCases = 1; reducedSensor = 1; processedEMGdata = 1;

% This script executes CEINMS based on
% the user's request.
% Inputs: 
%   1. Datastr to get momentArmData, MuscleTLength, normEMG, IDTrqData
%   2. calibCases: Which calibration model do you want to use? 
%   Options: 'All', 'AsymBased', 'SymBased'
%   3. reducedSensor: Do you want to use a reduced sensor set-up? 
%   Options: '' (use original EMG), 'NMF', 'SVD'
%   4. processedEMGdata: Which EMG data (.sto) file do you want to use to run
%   the model? 
%   Options: 'EMG' (original data), 'reducedEMGNMF', 'reducedEMGSVD'
%
% Outputs:
% Data saved in struct: Datastr.Resample.CEINMS_[usedCalModel]_[processedEMGdata] (uncut)
% Data saved in struct: Datastr.cutMovements.CEINMS_[usedCalModel]_[processedEMGdata] (cut)
% Data (.sto) in folder CEINSM\execution\ [processedEMGdata]
%
% Jan Willem Rook (18-12-2023)

%% Inputs
subjroot = Datastr.Info.SubjRoot;
trial = Datastr.Info.Trial
ceinmsFolder = 'ceinms';

bckslsh = strfind(subjroot,'\');
if isempty(bckslsh)
    bckslsh = 0;
end

subID = subjroot(bckslsh(end)+1:end);

% Get some directories
dirExSetup = [subjroot '\' ceinmsFolder '\execution\'];

%% Rewrite ExecutionSetup files
xmlFilePath = [dirExSetup 'ceinmsExecutionSetup.xml'];
foo = strfind(xmlFilePath,'\');
xmlFileName = xmlFilePath(foo(end)+1:end);
[~, xmlFileName, ~] = fileparts(xmlFileName);
xmlSet = xmlread(xmlFilePath);

% Rewrite elements 
% For subjectFile
% Change this to the correct calibration model ['Which calibration model do you want to use?']
persSubjectFile = ['..\calibration\calibrated\CalibratedModel' calibCases reducedSensor '\calibrated_L5S1.xml'];
xmlSet.getElementsByTagName('subjectFile').item(0).setTextContent([persSubjectFile]);

% For inputDataFile, go to folder
persInputDataFile = ['..\execution\Setup\execTrials' subID trial '.xml'];
xmlSet.getElementsByTagName('inputDataFile').item(0).setTextContent([persInputDataFile]);

% For excitationGeneratorFile
persExcitationGeneratorFile = ['..\calibration\Setup\excitationGenerator_L5S1.xml'];
xmlSet.getElementsByTagName('excitationGeneratorFile').item(0).setTextContent([persExcitationGeneratorFile]);

% For outputDirectory

% Create folder if it doesn't exist
if ~exist([subjroot '\' ceinmsFolder '\execution\OP\' processedEMGdata], 'dir')
       mkdir([subjroot '\' ceinmsFolder '\execution\OP\' processedEMGdata])
end

persOutputDirectory = ['OP\' processedEMGdata '\' subID trial]; % Folder
xmlSet.getElementsByTagName('outputDirectory').item(0).setTextContent([persOutputDirectory]);

% Save file
xmlFileChanged = [xmlFileName subID trial '.xml'];
xmlwrite([dirExSetup xmlFileChanged], xmlSet);

%% Write inputDataFile
% Create execTrials[#SUB][#trial].xml 
% In 'execTrials.xml' change variable names to correct
xmlFilePath = [dirExSetup 'Setup\execTrials.xml'];
foo = strfind(xmlFilePath,'\');
xmlFileName = xmlFilePath(foo(end)+1:end);
[~, xmlFileName, ~] = fileparts(xmlFileName);
xmlSet = xmlread(xmlFilePath);

% Set muscleTendonLengthFile
% For muscleTendonLength
persMuscleTendonLengthFile = ['..\..\..\OS\muscleAnalysis\' subID trial '_MusA_MTULen' '.sto'];
xmlSet.getElementsByTagName('muscleTendonLengthFile').item(0).setTextContent([persMuscleTendonLengthFile]);

% Set excitationsFile

% 3 options: fullEMG, reducedEMGSVD, reducedEMGNMF
% Change this to the correct processed EMG data ['Which EMG data do you want to use?']
% processedEMGdata = 'EMG' (original EMG) OR 'reducedEMGNMF' OR
% 'reducedEMGSVD' (reduced sensor reconstruction)
persExcitationsFile = ['..\..\..\OS\DataFiles\' subID trial processedEMGdata '.sto'];
xmlSet.getElementsByTagName('excitationsFile').item(0).setTextContent([persExcitationsFile]);

% Set momentArmsFile
persMomentArmsFile = ['..\..\..\OS\muscleAnalysis\' subID trial '_MusA_MA_L5_S1_Flex_Ext' '.sto'];
xmlSet.getElementsByTagName('momentArmsFile').item(0).getFirstChild.setTextContent([persMomentArmsFile]);

% Set externalTorquesFile
persExternalTorques = ['..\..\..\OS\DataFiles\' subID trial 'ID' '.sto'];
xmlSet.getElementsByTagName('externalTorquesFile').item(0).setTextContent([persExternalTorques]);

xmlFileChanged = [xmlFileName subID trial '.xml'];
xmlwrite([dirExSetup '\Setup\' xmlFileChanged], xmlSet);

%% Execute CEINMS for selected trial
exCommand = ['CEINMS -S "' dirExSetup 'ceinmsExecutionSetup' subID trial '.xml"'];
system(exCommand);

%% Save results in Struct
CEINMSoutput = {'Activations.sto', 'FiberLenghts.sto','FiberVelocities.sto','MuscleForces.sto','NormFiberLengths.sto','NormFiberVelocities.sto','PennationAngles.sto','Torques.sto'};

for n = 1:length(CEINMSoutput)
dot = strfind(CEINMSoutput{n},'.');
if isempty(dot)
    dot = 0;
end

Method = ['CEINMS_' calibCases '_' processedEMGdata];

CEINMSvar = CEINMSoutput{n}(1:dot-1);
Data = importdata([dirExSetup persOutputDirectory '\' CEINMSoutput{n}]);
Datastr.Resample.(Method).(CEINMSvar).Data = Data.data;
Datastr.Resample.(Method).(CEINMSvar).Labels = Data.colheaders;
end

%% Resample to get movement phase [0 100]%
[Datastr] = getMovementPhaseMoments(Datastr, Method);

end