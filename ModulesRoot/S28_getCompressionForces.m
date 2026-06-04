function [Datastr] = S28_getCompressionForces(Datastr,osInstallPath,osFolder,LowPassCutOff, EMGfiletype)
% gBMPDynUI osInstallPath=1; osFolder=1; LowPassCutOff = 1; EMGfiletype = 1;
%
% Run JRA to get compressive loads using OpenSim, and port the data to the
% structure
%
% INPUT)
% - Datastr:
%
% - osInstallPath: string, full path of the OpenSim directory. Example:
% 'C:\Program Files\OpenSim\OpenSim 3.3';
%
% - osFolder, string, specifying the folder in which the OpenSim files will
% be stored, relative to the subject root folder. Example: 'OS'
%
%
% LowPassCutOff : cut off frequency used to smoothen estimated ID
%
% EMGfiletype : Forces calculated based on EMGfiletype ('EMG' or 'reducedEMGNMF')
%
% OUTPUT)
% - Datastr: structure, with added fields:
%
% NOTES)

% other files required:
% - osMod: string, name of the (scaled) subject model, located in the
% osFolder, including extension. Example:
% 'gait2354_simbody_MarkerPP1.osim'
%
% - ikGenSet: string, name of the general settings file for IK, located in
% the osFolder, including extension. Example:
% '141031IKGenSet.xml'%
%
% Version History
% 10-06-2022 Irfan Refai : add saving file to mot and sto
% 06-03-2024 Jan Willem Rook: adjusting file set-up for lifting experiment
%% 
% clear,clc,clf,close all
% osInstallPath = 'C:\OpenSim 4.3';
% osFolder = 'OS';
% LowPassCutOff = 6;
% rootfolder = 'C:\Users\janwi\OneDriveUT\LiftingExperiment\LiftingExperiment\SUB008';
% load([rootfolder '\SUB008_noExo_SQ_150.mat'])
% EMGfiletype = 'reducedEMGNMF'; % or 'reducedEMGNMF'

  
%% Check ------- da scommentare
if isempty(LowPassCutOff)
    LowPassCutOff = -1;
end

%% Get info

% Get data from .Info field (assumed there)
rootfolder = Datastr.Info.SubjRoot;

bckslsh = strfind(rootfolder,'\');
if isempty(bckslsh)
    bckslsh = 0;
end

trial = Datastr.Info.Trial;
savename = [rootfolder(bckslsh(end)+1:end) trial];

%% create Paths

% path to osim no constraints model
osimFile = Datastr.Info.subjosmodfile;
osimModelNoConstraints = [osimFile(1:end-5) '_noconstraints.osim'];
osimModelFileNoConstraints = [rootfolder '\' osFolder '\' osimModelNoConstraints]; % get from user

% JRA general settings
%jraGenSet = Datastr.Info.subjosjrasetfile;
jraGenSetPath = [rootfolder '\' osFolder '\UTmodel\jraGenSet.xml']; 

% Subject+Trial specific external forces xml
xldSubSetPath = [rootfolder '\' osFolder '\UTmodel\' savename 'XLDset.xml']; % External load file

% Subject+Trial specific IK
ikFilePath = [rootfolder '\' osFolder '\DataFiles\' savename 'IK.mot']; % IK output

% CEINMS output folder that contains MuscleForces.sto
ceinmsOPFolder = [rootfolder '\CEINMS\execution\OP\'];
trialIndex = [EMGfiletype '\' savename]; 
ceinmscurFolder = [ceinmsOPFolder trialIndex];

%% Do JRA
getJRA_INAIL(osInstallPath,osimModelFileNoConstraints,jraGenSetPath,xldSubSetPath,ikFilePath,ceinmscurFolder, EMGfiletype, LowPassCutOff);

% Get path to created JointReaction.sto file
osjrasto = [rootfolder '\' osFolder '\DataFiles\' savename EMGfiletype '_JointReaction_ReactionLoads.sto']; % Path to ID output (.sto file)

% Store in C3Ddata structure
Datastr = getJRACompLoad_nosync(Datastr,osjrasto, EMGfiletype);

% Cut data and save in Datastr.cutMovements
Method = ['JRA_' EMGfiletype];
[Datastr] = getMovementPhaseMoments(Datastr, Method);

disp('End of S28_getCompressionForces')
end