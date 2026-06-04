function [Datastr] = S21_exportEMG_includeDelay(Datastr, osFolder, EMGOutput, EMGFormat, norType, emDelay)
% gBMPDynUI osFolder=1; EMGs_Output=1; EMGFormat=1; norType=1; emDelay = 1; useReducedEMG = 1;
% Detrend, rectify, and low pass filter EMG
%
% INPUT)
% Datastr: structure, with at least the fields
%     .EMG.EMGData
%     .EMG.EMGFrameRate
%  EMGs_Output={'TAL','GML','RFL'}; or any EMG channel of interest
%  EMGFormat=['.mot']; %availableFileFormats=['.txt', ' .sto', ' .mot'];
%  norType ='MVC' or other options below
%  emDelay = introduces an electromechanical delay, default = 0

%
% OUTPUT)
% Adds normalized EMG to Datastr.Resample.NormEMG
% Creates an Osim noConstraint model 
% A .mot file is created in the destination provided by filename
%
% NOTES)
% Function based on MOtion data elaboration TOolbox for
% NeuroMusculoSkeletal applications (MOtoNMS).
% Copyright (C) 2012-2014 Alice Mantoan, Monica Reggiani
%
% This function ports EMG data to a .mot file.
% With option_fs=0,  the number of
% samples written corresponds with the number of marker samples for which
% EMG data is available. It is assumed that the EMG data has AT LEAST the sample frequency of
% that of the marker data. If the EMG data has a higher sample frequency,
% some samples will be discarded.
% With option_fs=1, the data is exported at the frame rate of 100Hz by
% default (modify function accordingly for other frame rates)


%% Check input

if ~isfield(Datastr.Resample,'EMG') %if no EMG data
    warning(['No field EMG file ' Datastr.Info.Trial '. Skipping.']);
    return;
end

if isempty(EMGOutput)
    EMGOutput = Datastr.EMG.DataLabel;
end

if isempty(emDelay)
    emDelay = 0;
end

%% Get info
% get subject folder
 subjroot = Datastr.Info.SubjRoot;
trial = Datastr.Info.Trial;

if isfield(Datastr.Info, 'subjID')
    subID    = Datastr.Info.subjID;
    MVCfilename    = [subID '_MVCvalue'];
    dynMVCfilename = [subID '_dynMVCvalue'];
else
    MVCfilename    = 'MVCvalue';
    dynMVCfilename = 'dynMVCvalue';
end


if isfield(Datastr.Info,'OSFramesRemoved')
    remEndFrames = Datastr.Info.OSFramesRemoved;
else
    remEndFrames = 0;
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

% Create Osim noConstraint model
[Datastr] = getOsimNoConstraintModel(Datastr);

trialOutputPath             = [subjroot '\' osFolder '\' subjroot(bckslsh(end)+1:end) trial 'EMG'];
%trialOutputPathreducedEMG   = [subjroot '\' osFolder '\' subjroot(bckslsh(end)+1:end) trial 'reducedEMG'];

% Prepare the EMG for output
% EMG is exported at the resampling frame rate
markerFrameRate = Datastr.Resample.FrameRate;

nRows = size(Datastr.Resample.EMG, 1) - remEndFrames;

% UnNormEMG = Datastr.Resample.Sych.EMG(:, strcmp(EMGOutput, Datastr.EMG.DataLabel));
% Irfan overwriting
% identify indices
[~,~,comStringInd] = intersect(EMGOutput, strip(Datastr.EMG.DataLabel),'stable');
UnNormEMG_nodelay = Datastr.Resample.EMG(1:nRows, comStringInd);

for iCt = 1:size(UnNormEMG_nodelay,2)
    curEMGcol = UnNormEMG_nodelay(:,iCt);
    curEMGcol(curEMGcol<0) = 0;
    UnNormEMG_nodelay(:,iCt) = curEMGcol;
end



if emDelay == 0
    UnNormEMG = UnNormEMG_nodelay;
else
    emDelayinSamples = round(emDelay*markerFrameRate);
    UnNormEMG = zeros(size(UnNormEMG_nodelay));
    UnNormEMG(emDelayinSamples+1:end,:) = UnNormEMG_nodelay(1:end-emDelayinSamples,:);
    Datastr.Resample.EMDelaytoEMG = emDelay;
end

if strcmp(norType, 'dynMVC')
    dynMVC = importdata([subjroot '\' dynMVCfilename '.mat']);
    %     NormEMG = UnNormEMG./dynMVC(strcmp(EMGOutput, Datastr.EMG.DataLabel));
    NormEMG = UnNormEMG./dynMVC(comStringInd);
    Datastr.Resample.EMGExpdynNorFlag = 1;
    Datastr.Resample.EMGExpNorFlag = 0;
    Datastr.Resample.NormEMG = NormEMG;
    Datastr.Resample.NormEMGsensors =  Datastr.EMG.DataLabel(comStringInd);

elseif strcmp(norType, 'MVC')
    MVC = importdata([subjroot '\' MVCfilename '.mat']);
    NormEMG = UnNormEMG./MVC(comStringInd);
    Datastr.Resample.EMGExpdynNorFlag = 0;
    Datastr.Resample.EMGExpNorFlag = 1;
    Datastr.Resample.NormEMG = NormEMG;
    Datastr.Resample.NormEMGsensors =  Datastr.EMG.DataLabel(comStringInd);
else
    NormEMG = UnNormEMG;
    Datastr.Resample.EMGExpdynNorFlag = 0;
    Datastr.Resample.EMGExpNorFlag = 0;
    Datastr.Resample.NormEMG = NormEMG;
    Datastr.Resample.NormEMGsensors =  Datastr.EMG.DataLabel(comStringInd);
end

EMGtime = (0:size(NormEMG ,1)-1)'./markerFrameRate;

%% Resample to get movement phase [0 100]% 
Method = 'EMG';
[Datastr] = getMovementPhaseMoments(Datastr, Method);

% ------------------------------------------------------------------------
%                            PRINT emg.txt
%--------------------------------------------------------------------------
%availableFileFormats=['.txt', ' .sto', ' .mot'];

switch EMGFormat
    case '.txt'
        printEMGtxt(trialOutputPath, EMGtime, NormEMG, EMGOutput);
    case {'.sto','.mot'}
        % fprintf('Saving filt EMG in selected format: %4.2f %\n',k/length(trialsList)*100);
        printEMGmot(trialOutputPath, EMGtime, NormEMG, EMGOutput, EMGFormat);

%         %% Reduced sensor set-up EMG files
%         % Find non empty EMG labels
%         emptyEMGlabels = Datastr.EMG.DataLabel == '';
%         [~,locs]=find(~emptyEMGlabels);
%         EMGlabels = Datastr.EMG.DataLabel(locs);
%         
%         % Perform this code for both NMF and SVD to create reducedSensorEMGNMF and
%         % reducedSensorEMGSVD
% 
%         for i = 1:2
%             if i == 1
%                 decompMethod = 'NMF';
%             elseif i == 2
%                 decompMethod = 'SVD';
%             end
% 
%         % Find normal EMG matrix size
%         normEMGmatSize = size(Datastr.Resample.NormEMG);
%         reducedSensorEMGdata = Datastr.EMGDecomposition.(decompMethod).ReducedSensorSetUp.EMGest';
%         reducedEMGmatSize = size(reducedSensorEMGdata);
%         zeroMat = zeros(reducedEMGmatSize(1),normEMGmatSize(2)-reducedEMGmatSize(2));
% 
%         % Add zeros for frontal muscles
%         fullReducedSensorEMGdata = [reducedSensorEMGdata zeroMat];
% 
%         printEMGmot([trialOutputPathreducedEMG decompMethod], EMGtime, fullReducedSensorEMGdata, EMGlabels, EMGFormat);
% 
%         end

        %case ...
        %you can add here other file formats
    otherwise
        error('ErrorTests:convertTest', ...
            ['----------------------------------------------------------------\nWARNING: EMG Output File Format not Available!\nChoose among: [' availableFileFormats '].'])
end

cd(Datastr.Info.SubjRoot) %Make sure it is in subject folder

disp('End of S21_exportEMG_includeDelay')

% Datastr=[];



end