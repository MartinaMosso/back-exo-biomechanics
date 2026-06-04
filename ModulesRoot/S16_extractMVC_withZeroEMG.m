function [Datastr] = S16_extractMVC_withZeroEMG(Datastr, MVCtrial, dynNormalization, timeMovingWindow, outlierArraysinSec, lpffCut)
% gBMPDynUI MVCtrial=1;  dynNormalization = 1; timeMovingWindow = 1; outlierArraysinSec = 1; lpf_fCut=1;
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

% Addition: Because there could be some outliers, the mean of the 3 highest
% peak values are chosen. This is sensible because eacht trial to find the
% max peaks for specific muscles consisted of 3 reps.

% TODO
%This module could be more efficient, loading the trial to be normalized in
%each trial processing from BioMechPro. Nevbertheless, to keep MOtoNMS
%functions the same, all the processing is done when we loading the first
%trial in BioMechpro. All trials are processed in the first loading. The next loadings are skipped
%(as they were already proccessed during the first trial. Read the code!)


%% Check input
outlierArraysinSec = Datastr.Info.EMGMVCOutliers; % subject specific information

%%

if strcmp(dynNormalization, 'True')
    
    fprintf('extract dynamic MVC from all data trials...\n')
    
    subj_folder = Datastr.Info.SubjRoot;
    
    EMGdata = Datastr.EMG.EMGLinEnv;
    
    if isempty(timeMovingWindow)
        timeMovingWindow = 0.05;
        emgPeakList = max(EMGdata);
    else
        frameMovingWindow = timeMovingWindow*Datastr.EMG.FrameRate;
        
        
        % apply moving average of 50 ms windows
        EMG_envelope_movingaverage = getMovingAverage(EMGdata, frameMovingWindow);
        emgPeakList = max(EMG_envelope_movingaverage);
        
    end
    
    
    
    if ~isempty(MVCtrial)
        if isfile([subj_folder, '\MVCvalue.mat'])
            MVCvalue = importdata([subj_folder, '\MVCvalue.mat']);
        else
            extractMVCtrial([Datastr.Info.SubjRoot, '\Qualisys\' MVCtrial], timeMovingWindow, Datastr.EMG.addZeroEMGFlag, outlierArraysinSec)
            MVCvalue = importdata([subj_folder, '\MVCvalue.mat']);
        end
    end
    
    if isfile([subj_folder, '\dynMVCvalue.mat'])
        dynMVCvalue = importdata(strcat(subj_folder, '\dynMVCvalue.mat'));
        MVCvalueMid = max(MVCvalue, dynMVCvalue);
        MVCvalueMax = max(MVCvalueMid, emgPeakList);
        
        save(strcat(subj_folder, '\dynMVCvalue.mat'),  'MVCvalueMax')
    else
        MVCvalueMax = max(emgPeakList, MVCvalue);
        save(strcat(subj_folder, '\dynMVCvalue.mat'),  'MVCvalueMax')
    end
    
elseif strcmp(dynNormalization, 'False')
    
    if isempty(MVCtrial)
        fprintf('No MVC trial provided, cannot extract...\n')
        
    else
        extractMVCtrial([Datastr.Info.SubjRoot, '\Qualisys\' MVCtrial], timeMovingWindow, Datastr.EMG.addZeroEMGFlag, outlierArraysinSec);
    end
end

    function MVCvalue = extractMVCtrial(mvcFileName, timeMovingWindow, addZeroEMGFlag, outlierArraysinSec)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % extract MVCvalue from MVC trial
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % load the MVC data
        MVCdata = importdata(mvcFileName);
        
        % Get sample frequency
        fs_emg = 2000;%MVCdata.Analog.Frequency;
        
        % Added to find ChannelNumbers
        Datastr.EMG.ChannelNumbers = 1:length(Datastr.Info.EMGLabel);
        
        emgData = MVCdata.Analog.Data(Datastr.EMG.ChannelNumbers, :);
        
        % Get EMG
        if ~isempty(outlierArraysinSec)
            outlierArray = outlierArraysinSec*fs_emg;
            for iLen = 1:size(outlierArray,1)
                emgData(:,outlierArray(iLen,1):outlierArray(iLen,2)) = [];
            end
        end
        
        % EMG envelope
        % only for SUB002 due to lower sampling rate during MVC [48 instead of 2048]
        
        % Get subject
        %Subject = regexp(Datastr.Info.SubjRoot, '\', 'split');
        %Subject = Subject(4); 
        
        %if strcmp(Subject, 'SUB002')
        %EMG_envelope = getEMGEnvelop(emgData, fs_emg, lpffCut);
        %else
        EMG_envelope = getEMGEnvelop_wbandpass(emgData, fs_emg, lpffCut);
        %end

        % calculate the frame number of the moving window
        frameMovingWindow = fs_emg*timeMovingWindow;
        
        % apply moving average of 50 ms windows
        EMG_envelope_movingaverage = getMovingAverage(EMG_envelope, frameMovingWindow);
        
        % Save MVC envelope (only in datastruct of first trial that passes the module)
        Datastr.EMG.MVCenvelope = EMG_envelope_movingaverage;

        %% Instead of 1 max, average over 3 max peaks (not used)
%         % Number of peaks to find (3 MVC per side, 3 reps per MVC)
%         numPeaks = 9;
% 
%         % Preallocate arrays to store peak indices and values
%         peakIndices = zeros(numPeaks, size(EMG_envelope, 2));
%         peakValues = zeros(numPeaks, size(EMG_envelope, 2));
% 
%         % Loop through each column
%         for col = 1:size(EMG_envelope, 2)
%         % Find peaks in the current column
%         [peaks, indices] = findpeaks(EMG_envelope(:, col), 'MinPeakDistance',length(EMG_envelope)/25, 'SortStr', 'descend', 'NPeaks', numPeaks);
% 
%         % Store the results
%         peakValues(:, col) = peaks;
%         peakIndices(:, col) = indices;
%         end
          %MVCvalue = mean(maxk(peakValues,3));
%%    

        MVCvalue = max(EMG_envelope_movingaverage);

        if addZeroEMGFlag
            MVCvalue = [MVCvalue 1];
        end
        
        slashIndexes = strfind(mvcFileName, '\');
        
        % Save values
        save([mvcFileName(1:slashIndexes(end-1)) 'MVCvalue.mat'], 'MVCvalue')
       
        MVCdata.Analog.EMGLinEnv = EMG_envelope;

        % Save struct with lin envelope in Qualisys folder
        save([Datastr.Info.SubjRoot, '\Qualisys\' MVCtrial], 'MVCdata')
    end

end