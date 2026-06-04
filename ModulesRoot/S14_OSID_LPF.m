function [Datastr] = S14_OSID_LPF(Datastr,osInstallPath,osFolder,permvec,LowPassCutOff)
% gBMPDynUI osInstallPath=1; osFolder=1; permVec=1; LowPassCutOff = 1;
% (removed: osModel=1; ikGenSet=1)
%
% Run inverse dynamics (ID) using OpenSim, and port the data to the
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
% - permVec, vector, containing 3 elements to permute the data dimensions
% (xyz) from OpenSim to whatever order you're using in the structure.
% When left empty, no permutation occurs.
% Default OpenSim: x = walking direction, z = to the right, y = upward
% Example: [2 3 1];
%
% LowPassCutOff : cut off frequency used to smoothen estimated ID
%
% OUTPUT)
% - Datastr: structure, with added fields:
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

if ~isfield(Datastr,'Force') % if no VZ data
    warning(['No XLD.mot (loads) in trial ' Datastr.Info.Trial '. Skipping.']);
    return
end

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

osMod = Datastr.Info.subjosmodfile;
idGenSet = Datastr.Info.subjosidsetfile;
xldGenSet = Datastr.Info.subjosidxldfile;

% if exo
% xldGenSet = 'UTmodel\ID_loadDefinition_exo.xml'

% Create paths
osModPath = [rootfolder '\' osFolder '\' osMod]; % Subject model
idGenSetPath = [rootfolder '\' osFolder '\' idGenSet]; % ID general settings
xldGenSetPath = [rootfolder '\' osFolder '\' xldGenSet]; % External load ID settings

ikFilePath = [rootfolder '\' osFolder '\DataFiles\' savename 'IK.mot']; % IK output
xldFilePath = [rootfolder '\' osFolder '\DataFiles\' savename 'XLD.mot']; % External load file

%% Do ID

% Do ID
getOSID_LPF(osInstallPath,osModPath,idGenSetPath,xldGenSetPath,ikFilePath,xldFilePath,LowPassCutOff);

% Get path to created ID.sto file
osidsto = [rootfolder '\' osFolder '\DataFiles\' savename 'ID.sto']; % Path to ID output (.sto file)

% Store in C3Ddata structure
Datastr = getOSIDinM_nosync(Datastr,osidsto,permvec);


disp('End of S14_OSID')
end