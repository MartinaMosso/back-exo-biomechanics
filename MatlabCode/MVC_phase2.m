%% MVC p2

clear; close all; clc

% function [env_norm_res, env_res, env, emg_bp] = emg_envelope_normalize(emg, fs, mvc)
trials = {'MVC_DorAbdPre', 'MVC_DorAbdMedio', 'MVC_DorAbdPost'};

% sbj = 'C:\Users\Dottorato\OneDrive - unibs.it\MARTINA\DOTTORATO\2ANNO\Twente\ACQUISIZIONI\Phase2\Phase2.2\SBJ003\sessionData';
sbj = 'C:\Users\Dottorato\OneDrive - unibs.it\MARTINA\DOTTORATO\2ANNO\Twente\ACQUISIZIONI\Phase2\Phase2.2\SBJ002\ElaboratedData\sessionData';

for i=1:3

file = char(strcat(sbj, '\', trials(i), '\AnalogData.mat'));
load(file)

emg = AnalogData.RawData;

% EMG_ENVELOPE_NORMALIZE
% Full EMG preprocessing pipeline:
%   - DC removal
%   - Band-pass filter (20–450 Hz)
%   - Notch filter (50 Hz)
%   - Full-wave rectification
%   - Low-pass filter to extract envelope (6 Hz)
%   - Normalization (to MVC if provided, otherwise to max)
%   - Resampling to 100 Hz
%
% Inputs:
%   emg : raw EMG signal (vector)
%   fs  : original sampling frequency (Hz)
%   mvc : (optional) raw EMG from MVC trial for normalization
%
% Outputs:
%   env_norm_res : normalized envelope, resampled to 100 Hz
%   env_res      : unnormalized envelope, resampled to 100 Hz
%   env          : envelope before resampling
%   emg_bp       : band-passed + notched EMG signal

% -----------------------------
% Parameters
% -----------------------------
bp_cutoff = [20 450];   % Hz
fc_env    = 6;          % low-pass for envelope (Hz)
notch_f   = 50;         % Hz (EU mains)
resamp_fs = 100;        % Hz (target sampling rate)
fs = 2000;
% -----------------------------
% 1. Preprocessing
% -----------------------------
% emg = emg(:);
emg = emg - mean(emg, 'omitnan');

% --- Band-pass filter ---
Wn = min(bp_cutoff, fs/2 * [0.99 0.99]) / (fs/2);
[bbp, abp] = butter(4, Wn, 'bandpass');
emg_bp = filtfilt(bbp, abp, emg);

% --- Notch filter ---
wo = notch_f / (fs/2);
Q  = 35;
bw = wo / Q;
[bn, an] = iirnotch(wo, bw);
emg_bp = filtfilt(bn, an, emg_bp);

% -----------------------------
% 2. Envelope extraction
% -----------------------------
emg_rect = abs(emg_bp);
[blp, alp] = butter(4, fc_env / (fs/2), 'low');
env = filtfilt(blp, alp, emg_rect);

massimoMVC(i,:) = max(env);
end
% -----------------------------
% 3. Normalization
% -----------------------------
% if nargin >= 3 && ~isempty(mvc)
%     mvc = mvc(:) - mean(mvc, 'omitnan');
%     mvc_bp = filtfilt(bbp, abp, mvc);
%     mvc_bp = filtfilt(bn, an, mvc_bp);
%     mvc_env = filtfilt(blp, alp, abs(mvc_bp));
%     denom = max(mvc_env, [], 'omitnan');
% else
%     denom = max(env, [], 'omitnan');
% end
% env_norm = env / max(denom, eps);
figure;plot(massimoMVC','DisplayName','massimoMVC')

% -----------------------------
% 4. Resample to 100 Hz
% -----------------------------
% t_original = (0:length(env)-1)' / fs;
% t_resamp   = (0:1/resamp_fs:t_original(end))';
% env_res      = interp1(t_original, env, t_resamp, 'linear', 'extrap');
% env_norm_res = interp1(t_original, env_norm, t_resamp, 'linear', 'extrap');

% end
