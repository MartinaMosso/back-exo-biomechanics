function [Datastr] = S1_importMatINAIL(Datastr, matfolder, taskName, fTrans)
% gBMPDynUI matfolder=1; taskName = 1; fTrans=1;

%% Test Dataset
% Datastr.Info.SubjRoot = 'C:\Users\MohamedRefaiMI1\surfdrive\INAILDataset'; %;
% Datastr.Info.Trial = {'s003_withStanding'}; %[];
% matfolder = 'MATFiles';
% fTrans = [];
% taskName = '3_TaskLI1S_1'; %'3_TaskLI1S_1' Standing
%
%%
% Import .mat file into the structure, where the .mat file was obtained
% from INAIL from their trials
%
% - matfolder: string, specifying the folder containing the measurement
% trials with the marker data, force and emg data,
% relative to the subject root folder.
% Example: 'MAT'
%
% - taskName: For INAIL dataset the following options
%    'Standing'     -> static trial
% or '3_TaskLI1S_1' -> [SubNumber]_Task[RiskLevel]S_[Repetition]
%
%
% - fTrans: vector, change the force data order into the same as marker,
% also the same as the OpenSim model setup:
% For the INAIL dataset, the fTrans is [1, 2, 3]
%
%        ----------- -----------
%        | FP L    |x|  FP R   |
%        |         |^|         |
%        |    |    |||         |
%        |    |    |||         |
%        |    |    |o|------> z|
%        |         |y|         |
%        |         | |         |
%        |         | |         |
%        |         | |         |
%        ----------- -----------
%
%
% 10-6-2022 : Irfan Refai : creation

%% Init inputs transform vector

if isempty(fTrans)
    fTrans = [1, 2, 3]; % INAIL dataset:
end


%% Find file
subjrootfolder = Datastr.Info.SubjRoot;
subjtrial = [Datastr.Info.Trial];

% Get all .mat filenames in marker folder
matfiles = dir([subjrootfolder '\' matfolder '\*.mat']);
matfilenames = cell(1,length(matfiles));
matfilenamescmp = cell(1,length(matfiles));
for ifile = 1:length(matfiles)
    matfilenames{ifile} = matfiles(ifile).name;
    
    % Reverse string and remove '.mat', for comparison with strncmpi
    matfilenamescmp{ifile} = matfiles(ifile).name(1:end-4);
end
clear matfiles;
% Check if storage filenames specified by Trials field exist.
% If not, skip the thing
match = strcmpi(subjtrial,matfilenamescmp);
if sum(match) == 1
    subjmarkfile = matfilenames{match};
else
    try
        warning(['Skipping Mat file ' subjtrial ': not found or multiple found.']);
        return;
    catch
        error('A1_importMat:nofile',['Skipping Mat file ' subjtrial ': not found.']);
    end
end

%% Get .mat data

% Get root folder and filename
rootfolder = Datastr.Info.SubjRoot;
fullFileName = [rootfolder '\' matfolder '\' subjmarkfile];
% Load data file
MATDataFile = importdata(fullFileName);


taskName = subjtrial(6:end); % task name is coded in the mat file
Datastr.Info.TrialName = taskName;
 mkrdataPtr = 'data_3D';
 
% Put data into correct structure (Datastr that is used for further processing)
if strcmpi(taskName,'Standing')
    MATDataMarker = MATDataFile.Standing;
%     mkrdataPtr = 'data_3D_raw';
    
else
    
%     mkrdataPtr = 'data_3D';
    %     task = [taskName '.TDF'];
    
    %     taskList = length(MATDataFile.Kinematic_Raw_data);
    %     taskNo = 0;
    %
    %     for tCt = 1:taskList
    %         checkCount = strcmpi(taskName,MATDataFile.Kinematic_Raw_data(tCt).task(1:end-4));
    %
    %         if checkCount == 1
    %             if taskNo ~= 0
    %                 error('Not handled')
    %             end
    %             taskNo = tCt;
    %         end
    %
    %
    %     end
    
    %     MATDataMarker = MATDataFile.Kinematic_Raw_data(taskNo);
    MATDataMarker = MATDataFile.Kinematic_Raw_data;
    
    
    % Force data:
    MATDataForces = MATDataFile.Kinetic_Raw_data;
    
    DatastrRaw.Force.DataLabel = string(fieldnames(MATDataForces.platform_data));
    DatastrRaw.Force.RightPlateLocation = [];
    DatastrRaw.Force.LeftPlateLocation = [];
    DatastrRaw.Force.FrameRate = MATDataForces.fc_forces;
    DatastrRaw.Force.units = {'N','m'};
    
    % save data based on the order of force label and transform vector
    % ["Fx", "Fy", "Fz", "Mx", "My", "Mz",  "CoPx", "CoPy", "CoPz"]
    DatastrRaw.Force.RightForceData = ([sign(fTrans)'.*MATDataForces.platform_data.F_r(:,abs(fTrans))'; ...
        sign(fTrans)'.*MATDataForces.platform_data.M_r(:,abs(fTrans))';...
        sign(fTrans)'.*MATDataForces.platform_data.CoP_r(:,abs(fTrans))'])';
    
    DatastrRaw.Force.LeftForceData = ([sign(fTrans)'.*MATDataForces.platform_data.F_l(:,abs(fTrans))';...
        sign(fTrans)'.*MATDataForces.platform_data.M_l(:,abs(fTrans))';...
        sign(fTrans)'.*MATDataForces.platform_data.CoP_l(:,abs(fTrans))'])';
    
    
    
    % extract EMG data
    MATDataEMG = MATDataFile.sEMG_Raw_data;
    DatastrRaw.EMG.FrameRate= MATDataEMG.fc_EMG;
    
    % translate EMGs to existing workflow name
    matlabEMGLabels = string((fieldnames(MATDataEMG.sEMG))');
    opensimEMGLabels = [];
    
    muscleNamesFile = [subjrootfolder '\OS\UTmodel\muscleTranslator.txt'];
    muscleNamesTranslator = tdfread(muscleNamesFile,',');
    muscleNamesINAIL = string(muscleNamesTranslator.INAIL);
    muscleNamesOpensim = string(muscleNamesTranslator.Opensim);
    
    for labelCt = 1:length(matlabEMGLabels)
        curName = matlabEMGLabels{labelCt};
        inailInd = find(strcmpi(curName,strip(muscleNamesINAIL)));
        opensimEMGLabels{labelCt} = muscleNamesOpensim{inailInd};
    end
    
    DatastrRaw.EMG.INAILLabel = matlabEMGLabels;
    DatastrRaw.EMG.DataLabel = string(opensimEMGLabels);
    DatastrRaw.EMG.Channels =  MATDataEMG.sEMG;
    
    
    % Save EMG data in common Datastr format
    numSamples = length(MATDataEMG.sEMG.(matlabEMGLabels{1}));
    
    tempVar = zeros(numSamples,length(DatastrRaw.EMG.DataLabel));
    for nameCt = 1:length(DatastrRaw.EMG.DataLabel)
        curName = matlabEMGLabels{nameCt};
        curData = MATDataEMG.sEMG.(curName);
        tempVar(:,nameCt) = curData';
    end
    DatastrRaw.EMG.Channels = tempVar;
    
    
    
    Datastr.Force.ForceDataTransform = fTrans;
    Datastr.Force = DatastrRaw.Force;
    Datastr.EMG = DatastrRaw.EMG;
    
end

% Marker data:
DatastrRaw.Marker.FrameRate = MATDataMarker.fc_3D;
DatastrRaw.Marker.DataLabel = string(fieldnames(MATDataMarker.(mkrdataPtr))');
DatastrRaw.Marker.units = 'm';

% Save Marker data in common Datastr format
numSamples = length(MATDataMarker.(mkrdataPtr).(DatastrRaw.Marker.DataLabel{1}));
if ~any(ismember(size(MATDataMarker.(mkrdataPtr).(DatastrRaw.Marker.DataLabel{1})),3))
    error('Are the marker data in 3D ?')
end

tempVar = zeros(length(DatastrRaw.Marker.DataLabel),3,numSamples);
for nameCt = 1:length(DatastrRaw.Marker.DataLabel)
    curName = DatastrRaw.Marker.DataLabel{nameCt};
    curData = MATDataMarker.(mkrdataPtr).(curName);
    tempVar(nameCt,:,:) = curData';
end
DatastrRaw.Marker.MarkerData = tempVar;
Datastr.Marker = DatastrRaw.Marker;

% All marker, force, EMG data are saved to Datastr
end