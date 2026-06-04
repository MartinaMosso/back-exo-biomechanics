function [Datastr] = S8_procEMG_addZeroChannel(Datastr,lpf_fCut,addZeroEMG)
% gBMPDynUI lpf_fCut=1; addZeroEMG = 1;  
% EMGs_Input={'TAL','GML','RFL'};
% Detrend, rectify, and low pass filter EMG
% add an additional zero EMG channel for driving some CEINMS muscles
%
% INPUT)
% Datastr: structure, with at least the fields
%     .EMG.channels
%     .EMG.EMGFrameRate
%
% lpf_fCut : cut off frequency used to generate EMG envelope
%
% addZeroEMG : include a zero EMG channel?
%
% mvcNormalization: whether use mvc to normalize EMG
% dynNormalization: whether use dynamic mvc to normalize EMG
%
% OUTPUT)
% Datastr: structure with no new added fields
%     .EMG.envelope
%

%% Check input

if isfield(Datastr,'EMG')
    fprintf(['Trial ' Datastr.Info.Trial ' processed (flagEMG=1).\n ']) % All trials were processsed during the first trial
else
    warning(['No EMG data in file ' Datastr.Info.Trial '. Skipping.'])
end


%% Do Stuff
%Input BioMechPro

% %% ------------------------------------------------------------------------
% %                      START/STOP COMPUTATION
% %--------------------------------------------------------------------------

if isfield(Datastr,'EMG') %only .mat files with EMG (and skip flagEMG file)
    
    emgData = Datastr.EMG.Channels;
    fs_emg = Datastr.EMG.FrameRate;
    % get EMG envelope
    EMG_envelope = getEMGEnvelop_wbandpass(emgData', fs_emg, lpf_fCut);    

    
    Datastr.EMG.EMGLinEnv = EMG_envelope;
    Datastr.EMG.mvcNorFlag = 0;
    Datastr.EMG.dynNorFlag = 0;
    
    % Prevent multiple 'zeroEMG' channels, and add if not present
    if strcmp(addZeroEMG, 'True') && ~sum(contains(Datastr.EMG.DataLabel, 'zeroEMG'))
        Datastr.EMG.Channels(:,end+1)  = zeros(length(Datastr.EMG.Channels),1);
        Datastr.EMG.EMGLinEnv(:,end+1) = zeros(length(Datastr.EMG.Channels),1);
        Datastr.EMG.DataLabel(:,end+1) = "zeroEMG";
        Datastr.EMG.addZeroEMGFlag = 1;
    end
    
else
    warning(['No EMG data in file ' Datastr.Info.Trial '. Skipping.']);
end



disp('End of S8_procEMG_addZeroChannel')
end