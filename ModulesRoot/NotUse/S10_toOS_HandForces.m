function [Datastr] = S10_toOS_HandForces(Datastr, osFolder, permVec, removeEndFrames, CoPOffset, HandLoad, ObjectMarkerPrefix, HandMarkerLabels)
% gBMPDynUI osFolder=1; permVec=1; removeEndFrames=1; CoPOffset = 1; HandLoad = 1; ObjectMarkerPrefix = 1; HandMarkerLabels = 1;
%
% Create .mot files and .trc files for use in OpenSim
% includes functionality for adding vertical forces to the hand
%
% Requires the input subjosidxldfile_handForces = 'ID_HandForces_loadDefinition.xml';
%
% INPUT)
% - Datastr, the data structure with at least the fields:
%
% - osFolder: string, specifying the folder in which the OpenSim files will
% be stored, relative to the subject root folder. Example:
% 'OS'
%
% - permVec: vector, containing 3 elements to permute the data dimensions
% (xyz) to OpenSim coordinates. When left empty, no permutation occurs.
% Default OpenSim: x = walking direction, z = to the right, y = upward
% Example:
% [2 3 1];
%
% - beginEndRemove: remove 90 frames at the beginning and at the end, to
% remove the artifacts of sychronization
%
% - CoPOffset: [RightOffset; LeftOffset]; eg [0 0 0; 0.13 0 0] Offsets the
%   cop estimate with the given values => used to handle Dual force plate issues
%
% - HandForces: [] kg: specify the weight being held by both hands. Half of
% the force will be added to each hand between the knuckle markers. Requires
% markers on the object being carried to estimate a centroid that will be
% used as a check on when to add the loading.
%
% - ObjectMarkerIndices: [] - Numbers corresponding to the indices that
% define the markers placed on the object.
%
% - ObjectMinimumHeight: [] m -> minimum height above which the object is
% assumed to be lifted and moved. loading on the hand is applied when the object is
% above this threshold.
%
% OUTPUT)
% - None
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

if isempty(HandLoad)
    HandLoad = 0;
end

%% remove fields if exist
if isfield(Datastr, 'Resample')
    if isfield(Datastr.Resample, 'IKAngData')
        Datastr.Resample = rmfield(Datastr.Resample, 'IKAngData');
    end
    
    if isfield(Datastr.Resample, 'ForcePlateGRFData')
        Datastr.Resample = rmfield(Datastr.Resample, 'ForcePlateGRFData');
    end
    
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

% Create .sto file (kinematic data)
if isfield(Datastr.Resample, 'Marker')
    getTrc(Datastr,[subjroot '\' osFolder '\' subjroot(bckslsh(end)+1:end) trial], permVec, removeEndFrames)
else
    warning(['No field Marker in trial' trial '. Skipping writing to .trc file. Unable to do IK.']);
end

if isfield(Datastr.Resample,'Force')  % Create .mot file (kinetic data)
    Datastr = getHandForcesMot(Datastr,[subjroot '\' osFolder '\' subjroot(bckslsh(end)+1:end) trial], ...
        removeEndFrames, CoPOffset, HandLoad, ObjectMarkerPrefix, HandMarkerLabels);
else
    warning(['No field Force in trial' trial '. Skipping writing to .mot file. Unable to do ID.']);
end

disp('End of S10_toOS')
% Set empty return value (to prevent saving by UI)
% Datastr = [];
end