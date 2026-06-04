function [Datastr] = S20_extractMVC_INAIL(Datastr, dynNormalization, timeMovingWindow, outlierArraysinSec)
% gBMPDynUI dynNormalization = 1; timeMovingWindow = 1; outlierArraysinSec = 1;
% EMGs_Input={'TAL','GML','RFL'};
% Detrend, rectify, and low pass filter EMG of the MVC trail;
% Then, plot them and let user choice the largest value of each EMG channel
% The selected MVC activations will be stored at Datastr.Info
%
% INPUT)
% Datastr: structure, with at least the fields
%     .Info
% MVCtrial: trial name of the MVC recording
% dynNormalization: whether apply normization using the MVC or the higest
% emg peaks among all trials
%
% NOTES)
% Function based on MOtion data elaboration TOolbox for
% NeuroMusculoSkeletal applications (MOtoNMS).
% Copyright (C) 2012-2014 Alice Mantoan, Monica Reggiani

% TODO
%This module could be more efficient, loading the trial to be normalized in
%each trial processing from BioMechPro. Nevbertheless, to keep MOtoNMS
%functions the same, all the processing is done when we loading the first
%trial in BioMechpro. All trials are processed in the first loading. The next loadings are skipped
%(as they were already proccessed during the first trial. Read the code!)


%% Check input
MVCtrial = Datastr.Info.MVCtrial;
subID    = Datastr.Info.subjID;

MVCfilename    = [subID '_MVCvalue'];
dynMVCfilename = [subID '_dynMVCvalue'];
%%

if strcmp(dynNormalization, 'True')
    
    fprintf('extract dynamic MVC from all data trials...\n')
    
    subj_folder = Datastr.Info.SubjRoot;
    
    if isfield(Datastr,'Resample')
        EMGdata = Datastr.Resample.EMG;
    else
        
        EMGdata = Datastr.EMG.EMGLinEnv;
    end
    
    %     frameMovingWindow = timeMovingWindow*Datastr.EMG.FrameRate;
    % apply moving average of 50 ms windows
    %     EMG_envelope_movingaverage = getMovingAverage(EMGdata, frameMovingWindow);
    
    emgPeakList = max(EMGdata);
    
    
    
    
    if ~isempty(MVCtrial)
        if isfile([subj_folder, '\' MVCfilename '.mat'])
            MVCvalue = importdata([subj_folder, '\' MVCfilename '.mat']);
        else
            extractMVCtrial_INAIL(Datastr,[Datastr.Info.SubjRoot, '\' MVCtrial], timeMovingWindow, Datastr.EMG.addZeroEMGFlag)
            MVCvalue = importdata([subj_folder, '\' MVCfilename '.mat']);
        end
    end
    
    if isfile([subj_folder, '\' dynMVCfilename '.mat'])
        dynMVCvalue = importdata(strcat(subj_folder, '\', dynMVCfilename, '.mat'));
        MVCvalueMid = max(MVCvalue, dynMVCvalue);
        MVCvalueMax = max(MVCvalueMid, emgPeakList);
        
        save(strcat(subj_folder, '\',dynMVCfilename, '.mat'),  'MVCvalueMax')
    else
        MVCvalueMax = max(emgPeakList, MVCvalue);
        save(strcat(subj_folder, '\', dynMVCfilename, '.mat'),  'MVCvalueMax')
    end
    
elseif strcmp(dynNormalization, 'False')
    
    if isempty(MVCtrial)
        fprintf('No MVC trial provided, cannot extract...\n')
        
    else
        extractMVCtrial_INAIL(Datastr,[Datastr.Info.SubjRoot '\' MVCtrial{1}], timeMovingWindow, Datastr.EMG.addZeroEMGFlag);
    end
end

end