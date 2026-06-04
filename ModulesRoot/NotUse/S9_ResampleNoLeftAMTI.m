function Datastr = S9_ResampleNoLeftAMTI(Datastr, resampleRate, removeFrames)
% gBMPDynUI resampleRate=1; removeFrames = 1;
%
% Irfan Refai 13 01 22
% difference with S9_uniResample is this current file assumes all data
% points are synchronized
% INPUT)
% - Datastr: structure, containing at least the fields:
% .Marker.FrameRate
% .Marker.MarkerData
%
% .Force.FrameRate
% .Force.RightForceData
% .Force.LeftForceData
%
% .EMG.FrameRate
% .EMG.EMGLinEnv
%
% - resampleRate: the resampling rate for all signals
% - beginEndRemove: whether to remove 1 second at the beginning and end for
% inverse kinematics and inverse dynamics. This is to avoid the unexpected
% peaks.
%
% OUTPUT)
%
% NOTES)
%

% remove the original resampling data in case the data lengths are different
if isfield(Datastr, 'Resample')
    if isfield(Datastr.Resample,'Marker')
    Datastr.Resample = rmfield(Datastr.Resample, 'Marker');
    end
    
    if isfield(Datastr.Resample,'Force')
        Datastr.Resample = rmfield(Datastr.Resample, 'Force');
    end
    if isfield(Datastr.Resample,'EMG')
        Datastr.Resample = rmfield(Datastr.Resample, 'EMG');
    end
end

%% check input signals

if isempty(resampleRate)
    resampleRate = min([Datastr.Marker.FrameRate, Datastr.Force.FrameRate,...
        Datastr.EMG.FrameRate]);
end

Datastr.Resample.FrameRate = resampleRate;

if removeFrames
    remove_samples = removeFrames;
else
    remove_samples = 0;
end


%% start resampling
if isempty(Datastr.Marker)
    disp('No marker data')
else
    
    for mk = 1:length(Datastr.Marker.MarkerData(:, 1, 1))
        
        MrData = squeeze(Datastr.Marker.MarkerData(mk, :, :));
        time_frame = linspace(0,...
            (length(MrData(1, :))-1)/Datastr.Marker.FrameRate,...
            length(MrData(1, :)));
        
        if any(isnan(MrData) )
        for mrDim = 1:3
        MrData(mrDim,isnan(MrData(mrDim,:))) = 0;
        end
        end
        
        Datastr.Resample.Marker(:, :, mk) = ...
            resample(MrData', time_frame, resampleRate, 'spline');
        
        % ressign the NaNs to the resampled marker trajectories
        if ~isempty(find(isnan(MrData(1, :))==1))
            id_nan_ori = find(isnan(MrData(1,:))==1);
            id_nan_new = ceil(1 + resampleRate*(id_nan_ori-1)/Datastr.Marker.FrameRate);
            id_nan_new(id_nan_new > size(Datastr.Resample.Marker, 1)) = [];
            Datastr.Resample.Marker(id_nan_new, :, mk) = NaN;
        end
    end
    
    % remove 10 frames of data from the beginning and end
    Datastr.Resample.Marker(1:remove_samples, :, :) = [];
    Datastr.Resample.Marker(end-remove_samples:end, :, :) = [];
    
end

if ~isfield(Datastr,'Force')
    disp('No Force data')
elseif ~isempty(Datastr.Force)
    
    Datastr.Resample.Force.Right = ...
        resample(Datastr.Force.RightForceData, linspace(0,...
        (length(Datastr.Force.RightForceData(:, 1))-1)/Datastr.Force.FrameRate,...
        length(Datastr.Force.RightForceData(:, 1))), resampleRate, 'spline');
    
    
    % remove 10 frames of data from the beginning and end
    Datastr.Resample.Force.Right(1:remove_samples, :) = [];
    Datastr.Resample.Force.Right(end-remove_samples:end, :) = [];
    
    % Datastr.Resample.Force.Left = ...
    %     resample(Datastr.Force.LeftForceData, linspace(0,...
    %     (length(Datastr.Force.LeftForceData(:, 1))-1)/Datastr.Force.FrameRate,...
    %     length(Datastr.Force.LeftForceData(:, 1))), resampleRate, 'spline');
    
    % remove 10 frames of data from the beginning and end
    % Datastr.Resample.Force.Left(1:remove_samples, :) = [];
    % Datastr.Resample.Force.Left(end-remove_samples:end, :) = [];
    
end

if ~isfield(Datastr,'EMG')
    disp('No EMG data')
elseif ~isempty(Datastr.EMG)
    
    
    if isfield(Datastr.EMG, 'EMGLinEnv')
        Datastr.Resample.EMG = ...
            resample(Datastr.EMG.EMGLinEnv, linspace(0,...
            (length(Datastr.EMG.EMGLinEnv(:, 1))-1)/Datastr.EMG.FrameRate,...
            length(Datastr.EMG.EMGLinEnv(:, 1))), resampleRate, 'spline');
    elseif isfield(Datastr.EMG, 'EMGLinEnvNor')
        Datastr.Resample.EMG = ...
            resample(Datastr.EMG.EMGLinEnvNor, linspace(0,...
            (length(Datastr.EMG.EMGLinEnvNor(:, 1))-1)/Datastr.EMG.FrameRate,...
            length(Datastr.EMG.EMGLinEnvNor(:, 1))), resampleRate, 'spline');
    else
        Datastr.Resample.EMG = ...
            resample(Datastr.EMG.Channels, linspace(0,...
            (length(Datastr.EMG.Channels(:, 1))-1)/Datastr.EMG.FrameRate,...
            length(Datastr.EMG.Channels(:, 1))), resampleRate, 'spline');
    end
    
    % check Size
    if ~isempty(Datastr.Marker) && size(Datastr.Resample.EMG,1) > size(Datastr.Resample.Marker,1)
        diffSamples = size(Datastr.Resample.EMG,1) - size(Datastr.Resample.Marker,1)  ;
        Datastr.Resample.EMG(end-diffSamples+1:end, :) = [];
        
    else
        % remove 10 frames of data from the beginning and end
        Datastr.Resample.EMG(1:remove_samples, :) = [];
        Datastr.Resample.EMG(end-remove_samples:end, :) = [];
    end
    
end

end