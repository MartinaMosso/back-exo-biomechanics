function [Datastr] = S11_OSIKtosto(Datastr,osInstallPath,osFolder,permvec)
% gBMPDynUI osInstallPath=1; osFolder=1; permvec=1;
% (removed: osModel=1; ikGenSet=1)
%
% Run inverse kinematics (IK) using OpenSim, and port the data to the
% structure
%
% INPUT)
% - Datastr: with no specific fields required
%
% - osInstallPath: string, full path of the OpenSim directory. Example:
% 'C:\Program Files\OpenSim\OpenSim 3.3';
%
% - osFolder, string, specifying the folder in which the OpenSim files will
% be stored, relative to the subject root folder. Example:
% 'OS'
%
% - permVec, vector, containing 3 elements to permute the data dimensions
% (xyz) from OpenSim to whatever order you're using in the structure.
% When left empty, no permutation occurs.
% Default OpenSim: x = walking direction, z = to the right, y = upward
% Example:
% [2 3 1];
%
% OUTPUT)
% - Datas1tr: structure, with added fields:
%
% NOTES)


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

%% Check
if ~isfield(Datastr,'Marker') % if no VZ data
    warning(['No .trc in trial ' Datastr.Info.Trial '. Skipping.']);
    return
end

%% Get info and paths

rootfolder = Datastr.Info.SubjRoot;
bckslsh = strfind(rootfolder,'\');
if isempty(bckslsh)
    bckslsh = 0;
end

trial = Datastr.Info.Trial;
savename = [rootfolder(bckslsh(end)+1:end) trial];
osMod = Datastr.Info.subjosmodfile; % This is assumed available
ikGenSet = Datastr.Info.subjosiksetfile; % This is assumed available

osModPath = [rootfolder '\' osFolder '\' osMod];
ikGenSetPath = [rootfolder '\' osFolder '\' ikGenSet];
ikTrcPath = [rootfolder '\' osFolder '\DataFiles\' savename '.trc'];

%% Do stuff
ikSetFileName = 'IKset'; %IKset for normal IK
ikSaveName = 'IK';  %IK for normal IK

% Do IK
getOSIKmotsto(osInstallPath,osModPath,ikGenSetPath,ikTrcPath,ikSetFileName,ikSaveName);

% Get path to created IK.mot file
ikMotPath = [rootfolder '\' osFolder '\DataFiles\' savename 'IK.mot'];

% Port data to structure
Datastr = getOSIKinM_nosync(Datastr,ikMotPath,permvec);


disp('End of S11_toOSIKtosto')
end