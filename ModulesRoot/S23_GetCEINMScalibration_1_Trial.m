function [Datastr] = S23_GetCEINMScalibrationAllTrials(Datastr, calibCases, reducedSensor)
% gBMPDynUI calibCases = 1; reducedSensor = 1;

% This creates files used for CEINMS calibration based on
% the user's request, and performs calibration (If calibration model is already available, the calibration skipped)
% Inputs: 
%   1. Datastr to get momentArmData, MuscleTLength, normEMG, IDTrqData
%   2. calibCases: Which calibration model do you want to use? 
%   Options: 'All', 'AsymBased', 'SymBased'
%   3. reducedSensor: Do you want to use a reduced sensor set-up? 
%   Options: '' (use original EMG), 'NMF', 'SVD'
%   
%
% Outputs:
% calibrated_L5S1.xml model in:
% \calibration\calibrated\CalibratedModel\[calibCases reducedSensor]
% Flag (1 or 0) in CalibFlagCEINMS.mat to note if calibration with [type] has been
% performed
% Options for [type] are all combinations of calibCases and reducedSensor, so CalibFlagCEINMS.flag.All, CalibFlagCEINMS.flag.AllSVD, ..., CalibFlagCEINMS.flag.SymBasedNMF
%
%
% Jan Willem Rook (18-12-2023)

%% Inputs
subjroot = Datastr.Info.SubjRoot;
ceinmsFolder    = 'CEINMS';
ceinmsCalFolder = 'CEINMScalibFiles';

bckslsh = strfind(subjroot,'\');
if isempty(bckslsh)
    bckslsh = 0;
end

% Identify SubID
subID = subjroot(bckslsh(end)+1:end);

%% Get Flag and timestamp of latest calibration

% Create id
calibCasesRedSensor = [calibCases reducedSensor];

% Check if file exists
if isfile([subjroot '\CalibFlagCEINMS.mat']) % File exists, 

    % Check value CalibFlagCEINMS.flag, if = 1 return, else proceed
    load([subjroot '\CalibFlagCEINMS.mat'], "CalibFlagCEINMS");

    if CalibFlagCEINMS.flag.(calibCasesRedSensor) == 1
        return
    end

else % file doesn't exist, so create it

    % Set calibration flag to 0, for all calibCases and RedSensor
    % combinations
    CalibFlagCEINMS.flag.All            = 0;
    CalibFlagCEINMS.flag.AllSVD         = 0;
    CalibFlagCEINMS.flag.AllNMF         = 0;
    CalibFlagCEINMS.flag.AsymBased      = 0;
    CalibFlagCEINMS.flag.AsymBasedSVD   = 0;
    CalibFlagCEINMS.flag.AsymBasedNMF   = 0;
    CalibFlagCEINMS.flag.SymBased       = 0;
    CalibFlagCEINMS.flag.SymBasedSVD    = 0;
    CalibFlagCEINMS.flag.SymBasedNMF    = 0;
    % CalibFlagCEINMS.flag.Prova          = 0;

    % Timestamp
    CalibFlagCEINMS.fileCreationDate = datetime;
    filename=([subjroot '\CalibFlagCEINMS.mat']);
    save(filename,'CalibFlagCEINMS'); 
end

%% Now select calibration files {random pick}

load([subjroot '\CalibFlagCEINMS.mat'], "CalibFlagCEINMS");

% Calibration Cases
% 1. All trials included (pick 1 random sample)
% 2. Movement sorted (pick 1 random sample)

% input('Which trials should be used for calibration? Choose: All, AsymBased, SymBased');

switch calibCases
    case 'All'
        % trialList = {'yesExo_ST_10'; 'yesExo_SQ_10'; 'yesExo_BL_10'}; %'noExo_ST_10'; 'noExo_SQ_10'; 'noExo_BL_10'}%; };

        % movList = {'yesExoST10';'yesExoSQ10'; 'yesExoBL10'};%'noExoST10';'noExoSQ10'; 'noExoBL10'}%; };

        trialList = {'noExo_ST_10'; 'noExo_SQ_10'; 'noExo_BL_10'};% 'yesExo_ST_10'; 'yesExo_SQ_10'; 'yesExo_BL_10'};

        movList = {'noExoST10';'noExoSQ10'; 'noExoBL10'};%'yesExoST10';'yesExoSQ10'; 'yesExoBL10' };

        % % In case of a horizontal movement, we have 3 reps
        % trialList = {   'noExo_UT_0'; 
        %         'noExo_UT_75';
        %         'noExo_UT_150';
        %         'noExo_BT_0';
        %         'noExo_BT_75';
        %         'noExo_BT_150';
        %         'noExo_SQ_0'; 
        %         'noExo_SQ_75';
        %         'noExo_SQ_150';
        %         'noExo_ST_0';
        %         'noExo_ST_75';
        %         'noExo_ST_150'};
        % 
        % movList = {'UT0'; 'UT75'; 'UT150'; 'BT0'; 'BT75'; 'BT150';
        %     'SQ0'; 'SQ75'; 'SQ150'; 'ST0'; 'ST75'; 'ST150' };

        
    
    case 'AsymBased'
        trialList = {'noExo_UT_0'; 
                'noExo_UT_75';
                'noExo_UT_150'
                'noExo_BT_0'
                'noExo_BT_75'
                'noExo_BT_150'};

        movList = {'UT0'; 'UT75'; 'UT150'; 'BT0'; 'BT75'; 'BT150'};

        
    
    case 'SymBased'
        trialList = {'noExo_SQ_0'; 
                'noExo_SQ_75';
                'noExo_SQ_150'
                'noExo_ST_0'
                'noExo_ST_75'
                'noExo_ST_150'};

        movList = {'SQ0'; 'SQ75'; 'SQ150'; 'ST0'; 'ST75'; 'ST150'};

    % case 'Prova'
    %     trialList = {'yesExo_SQ_10'};
    % 
    %     movList = {'SQ10'};


        
    
   otherwise
        disp('Input not valid')
        return
end

disp(['Trial list contains: ' calibCases])

for n = 1:length(trialList)
    if n < 6
        s = 3;
    elseif n >= 6
        s= 6;
    end
    
    % Save picked files in struct
    pickedTrial = randi([1 s],1);
    trialset = [calibCases reducedSensor];
    CalibFlagCEINMS.(subID).(trialset).(movList{n}) = [subID trialList{n} 'rep' num2str(pickedTrial)];
    CalibFlagCEINMS.CalibrationCase = calibCases;
end

%% Create a folder to place the calibrated model

if ~exist([subjroot '\' ceinmsFolder '\calibration\calibrated\CalibratedModel' calibCases reducedSensor], 'dir')
       mkdir([subjroot '\' ceinmsFolder '\calibration\calibrated\CalibratedModel' calibCases reducedSensor])
end

%% Get some directories
dirCalSetup = [subjroot '\' ceinmsFolder '\calibration\Setup\'];
dirCalFiles = [subjroot '\' ceinmsCalFolder '\'];

% Go to the correct location -> CEINMSOffline\ceinms\calibration\Setup
% Do: Change set-up files
% Input variables: [SUB#], [Trial#]

% CEINMS calibration calls {calibrationSetup_L5S1_stiff.xml}
% 1. don't change <subjectFile>
% 2. don't change <excitationGeneratorFile>
% 3. change name <calibrationFile> to 'calibrationCfg_L5S1_stiff_[SUB#].xml'

%% Change calibrationSetup_L5S1_stiff [1 file per subject]
xmlFilePath = [dirCalSetup 'calibrationSetup_L5S1_stiff.xml'];
xmlSet = xmlread(xmlFilePath);
persCalibrationFileCfg = ['calibrationCfg_L5S1_stiff' subID '.xml'];

% Change the calibrationFile dir
xmlSet.getElementsByTagName('calibrationFile').item(0).setTextContent([persCalibrationFileCfg]);

% Save the calibrated model in specified folder
xmlSet.getElementsByTagName('outputSubjectFile').item(0).setTextContent([subjroot '\' ceinmsFolder '\calibration\calibrated\CalibratedModel' calibCases reducedSensor '\calibrated_L5S1.xml']);

xmlFileChanged = ['calibrationSetup_L5S1_stiff' subID '.xml'];
xmlwrite([dirCalSetup xmlFileChanged], xmlSet);

%% Change calibrationCfg_L5S1_stiff [1 file per subject, add all trials to trialSet]
xmlFilePath = [dirCalSetup 'calibrationCfg_L5S1_stiff.xml'];
xmlSet = xmlread(xmlFilePath);

persTrialSet = [];

for n = 1: length(trialList)
persTrialSet = [persTrialSet CalibFlagCEINMS.(subID).(trialset).(movList{n}) '.xml '];
end                                   

xmlSet.getElementsByTagName('trialSet').item(0).setTextContent([persTrialSet]);
xmlFileChanged = ['calibrationCfg_L5S1_stiff' subID '.xml'];
xmlwrite([dirCalSetup xmlFileChanged], xmlSet);

%% In 'calibrationTrials.xml' change variable names to correct
xmlFilePath = [dirCalSetup 'calibrationTrials.xml'];
xmlSet = xmlread(xmlFilePath);

% Rewrite elements 
% For muscleTendonLength
for n = 1:length(trialList)

persMuscleTendonLengthFile = [dirCalFiles CalibFlagCEINMS.(subID).(trialset).(movList{n}) '_MusA_MTULen' '.sto'];
xmlSet.getElementsByTagName('muscleTendonLengthFile').item(0).setTextContent([persMuscleTendonLengthFile]);

% For excitationsFile

if strcmp(reducedSensor, 'SVD')
persExcitationsFile = [dirCalFiles CalibFlagCEINMS.(subID).(trialset).(movList{n}) 'reducedSensorEMGSVD' '.sto'];
elseif strcmp(reducedSensor, 'NMF')
persExcitationsFile = [dirCalFiles CalibFlagCEINMS.(subID).(trialset).(movList{n}) 'reducedSensorEMGNMF' '.sto'];
elseif strcmp(reducedSensor, '')
persExcitationsFile = [dirCalFiles CalibFlagCEINMS.(subID).(trialset).(movList{n}) 'EMG' '.sto'];
end

xmlSet.getElementsByTagName('excitationsFile').item(0).setTextContent([persExcitationsFile]);

% For momentArmsFiles
persMomentArmsFile = [dirCalFiles CalibFlagCEINMS.(subID).(trialset).(movList{n}) '_MusA_MA_L5_S1_Flex_Ext' '.sto'];
xmlSet.getElementsByTagName('momentArmsFile').item(0).getFirstChild.setTextContent([persMomentArmsFile]);

% For externalTorquesFile
persExternalTorques = [dirCalFiles CalibFlagCEINMS.(subID).(trialset).(movList{n}) 'ID' '.sto'];
xmlSet.getElementsByTagName('externalTorquesFile').item(0).setTextContent([persExternalTorques]);

% Save file
xmlFileChanged = [CalibFlagCEINMS.(subID).(trialset).(movList{n}) '.xml'];
xmlwrite([dirCalSetup xmlFileChanged], xmlSet);

end

%% Perform calibration [CEINMSCalibrate]
% calCommand = ['CEINMSCalibrate -S "' dirCalSetup 'calibrationSetup_L5S1_stiff' subID '.xml"'];
% system(calCommand);
% 
% %% Save end of calibration time
% 
% CalibFlagCEINMS.flag.(calibCasesRedSensor) = 1;
% CalibFlagCEINMS.calibFinished = datetime;
% filename=([subjroot '\CalibFlagCEINMS.mat']);
% save(filename,'CalibFlagCEINMS'); 

end
