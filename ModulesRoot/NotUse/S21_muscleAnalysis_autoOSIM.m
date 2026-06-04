function Datastr = S21_muscleAnalysis_autoOSIM(Datastr,osFolder, DoFrequired, MuscleAnalysisFolder, muscleNames)
% gBMPDynUI  osFolder=1; DoFrequired = 1; MuscleAnalysisFolder = 1; muscleNames =1;
%
% INPUT)
% - Datastr: structure, containing at least the fields:
% .Info.SubjRoot
% .Info.Trial
%
% - osFolder: string, specifying the folder in which the OpenSim files will
% be stored, relative to the subject root folder. Example: 'OS'
%
% - osimModelNoConstraints: Opensim model that has all constraints set to
% false. This is needed to avoid dependence of muscle lengths on
% coordinate constraints. Eg. LFB_model_scaled_noconstraints.osim
%
% - DoFrequired: DoF list around which the muscle analysis is performed.
% Eg. {'L5_S1_Flex_Ext'}
%
% - MuscleAnalysisFolder: string, specifying the folder in which the muscle
% analysis files from Opensim will be stored, relative to the subject root
% folder. Example: 'OS\muscleAnalysis'
%
% - muscleNames: txt file, specifying list of all available muscles in
% Osim model for which the analysis will be performed.
%
% Requires the following existing files:
%   IK.mot file that contains inverse kinematics information of
% the subject
%
%
% OUTPUT)
% prints two files that are stored in MuscleAnalysis Folder
% - _MusA_MA_(DoF).sto: Muscle Analysis Moment arms for the DoF of interest
% - _MusA_MTULen.sto: Muscle Analysis muscle tendon length
%
% NOTES)
% requires muscleNames list -> list of all available muscles in Osim model
%
% Versions
% Irfan Refai 30-5-2022

%%
rootfolder = Datastr.Info.SubjRoot;
trial = Datastr.Info.Trial;
bckslsh = strfind(rootfolder,'\');
savename = [rootfolder(bckslsh(end)+1:end) trial];
osimFile = Datastr.Info.subjosmodfile;
osimModelNoConstraints = [osimFile(1:end-5) '_noconstraints.osim'];

%% check input signals
muscleNamesFile = [rootfolder '\' muscleNames]; % get from user
ikMotFile = [rootfolder '\' osFolder '\DataFiles\' savename 'IK.mot']; % get from name


osimModelFileNoConstraints = [rootfolder '\' osFolder '\' osimModelNoConstraints]; % get from user
coordinateNames = DoFrequired; % coordinateNames = {'L5_S1_Flex_Ext'}; % get from user
%%
muscleNamesAll = importdata(muscleNamesFile);
muscleNames = strip(strsplit(char(muscleNamesAll),',')); %split by comma and remove whitespaces
ikData = importdata(ikMotFile);
%%
tic
[MuscleTLength, MomentArmData, muscleListExtracted] =...
    getOsimMuscleLengthMA(osimModelFileNoConstraints, ikData, muscleNames, coordinateNames);
toc
%% write files
MuscleTLengthFile = [rootfolder '\' MuscleAnalysisFolder '\' savename '_MusA_MTULen.sto'];
    timeInfo = ikData.data(:,1);
    printMuscleTLengthsto(MuscleTLengthFile, MuscleTLength, muscleListExtracted, timeInfo)
    
    
if length(coordinateNames)>1
    
    for coordCt = 1:length(coordinateNames)
    
    momentArmFile = [rootfolder '\' MuscleAnalysisFolder '\' savename '_MusA_MA_' coordinateNames{coordCt} '.sto'];
    timeInfo = ikData.data(:,1);
    printMomentArmsto(momentArmFile, coordinateNames{1}, squeeze(MomentArmData(:,:,coordCt)), muscleListExtracted, timeInfo)
    
    end
    
    
elseif length(coordinateNames) == 1
    momentArmFile = [rootfolder '\' MuscleAnalysisFolder '\' savename '_MusA_MA_' coordinateNames{1} '.sto'];
    timeInfo = ikData.data(:,1);
    printMomentArmsto(momentArmFile, coordinateNames{1}, MomentArmData, muscleListExtracted, timeInfo)
    
    
    
else
    error('Not handled')
end



disp('End of S21_muscleAnalysis')
end