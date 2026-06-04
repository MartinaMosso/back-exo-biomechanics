function [Datastr] = S10_toOS_IncludeCarriedObjectDynamics(Datastr, osInstallPath, osFolder, permVec, removeEndFrames, LowPassCutOff, CoPOffset, ObjectName, handMarkerLabels, splitBetweenHands)
% gBMPDynUI osInstallPath = 1; osFolder=1; permVec=1; removeEndFrames=1; LowPassCutOff = 1; CoPOffset = 1; ObjectName = 1; handMarkerLabels = 1; splitBetweenHands =1;
%
% Create .mot files and .trc files for use in OpenSim
% includes functionality for adding vertical forces to the hand
%
% Requires predefined filepaths 
% 
% INPUT)
% - Datastr, the data structure that contains predefined filepaths 
%       objectosmodfile   (e.g. Gear_body.osim)                                                                                                                                                                                                                                                                                 
%       objectosidxldfile (e.g. ID_loadDefinition_ObjectForces.xml) 
%       objectosiksetfile (e.g. InverseKinematics_CarriedObject.xml) 
%
% In addition the user input fields:
%
% - osInstallPath: string, full path of the OpenSim directory. Example:
% 'C:\Program Files\OpenSim\OpenSim 3.3';
% 
% - osFolder: string, specifying the folder in which the OpenSim files will
% be stored, relative to the subject root folder. Example: 'OS'
%
% - permVec: vector, containing 3 elements to permute the data dimensions
% (xyz) to OpenSim coordinates. When left empty, no permutation occurs.
% Default OpenSim: x = walking direction, z = to the right, y = upward
% Example:
% [2 3 1];
%
% - removeEndFrames: remove frames at the beginning and at the end, to
%
% - CoPOffset: [RightOffset; LeftOffset]; eg [0 0 0; 0.13 0 0] Offsets the
%   cop estimate with the given values => used to handle Dual force plate issues
%
% - handMarkerLabels: eg {'2K','5K'}; - list the markers used to identify where the
% point force exerted by the carried object is to be applied.
% and dynamics file and to write files for reading later
%
% - splitBetweenHands: [1 or 0] - are forces equally split between both
% hands?
%
% OUTPUT)
% - several files are written: ObjectIK.sto, ObjectID.sto, XLD.mot
%
% NOTES)

%% Get info

subjroot = Datastr.Info.SubjRoot;
trial = Datastr.Info.Trial;

if isempty(removeEndFrames)
removeEndFrames = 0;
end
Datastr.Info.OSFramesRemoved = removeEndFrames;

if isempty(permVec)
    permVec = 1:3;
end

if isempty(CoPOffset)
    CoPOffset = NaN;
end



%% Folder

% Check if folder exist, if not create new
if ~ exist([subjroot '\' osFolder],'dir')
    mkdir(subjroot,osFolder);
end

%% Export files

bckslsh = strfind(subjroot,'\');
if isempty(bckslsh)
    bckslsh = 0;
end
dataFilepath = [subjroot '\' osFolder '\DataFiles\' subjroot(bckslsh(end)+1:end) trial];

% Create .sto file (kinematic data)
if isfield(Datastr.Resample, 'Marker')
    getTrc(Datastr,dataFilepath, permVec, removeEndFrames)
else
    warning(['No field Marker in trial' trial '. Skipping writing to .trc file. Unable to do IK.']);
end

%% Carried Object Kinematics and Dynamics
Datastr = getCarrie2dObjectIKID(Datastr,osInstallPath,osFolder,LowPassCutOff,ObjectName);

if isfield(Datastr.Resample,'Force')  % Create .mot file (kinetic data)
    Datastr = getExternalLoadsAndCarriedObjectForcesMot(Datastr,dataFilepath, ...
        removeEndFrames, CoPOffset, ObjectName, handMarkerLabels, splitBetweenHands);
else
    warning(['No field Force in trial' trial '. Skipping writing to .mot file. Unable to do ID.']);
end
%%
disp('End of S10_toOS_IncludeCarriedObjectDynamics')

end