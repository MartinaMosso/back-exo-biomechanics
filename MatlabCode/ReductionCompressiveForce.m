%% reduction of compressive force

clear; close all; clc;

%% import: calibration all

folder = 'C:\Twente\IUVO\SUB010';

elencoTrial = dir('C:\Twente\IUVO\SUB010\CEINMS\execution\OP\EMG');
elencoTrial(1:2,:) = [];

repMat = {'rep1' 'rep2' 'rep3' 'rep4' 'rep5' 'rep6' 'rep7' 'rep8' 'rep9' 'rep10'};

%% STOOP
load([folder, '\', 'SUB010_noExo_ST_10']);

for r = 1:length(repMat)
    fcom_unfilt = Datastr.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.(repMat{r});
    fcom_filt_noexo(r,:) = movmean(Datastr.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.(repMat{r}), 20);

    delta_ST_no(r) = abs(max(fcom_filt_noexo(r,:))-min(fcom_filt_noexo(r,:)));

end

load([folder, '\', 'SUB010_yesExo_ST_10']);

for r = 1:length(repMat)
    fcom_unfilt = Datastr.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.(repMat{r});
    fcom_filt_yesexo(r,:) = movmean(Datastr.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.(repMat{r}), 20);

    delta_ST_yes(r) = abs(max(fcom_filt_yesexo(r,:))-min(fcom_filt_yesexo(r,:)));

end


%% SQUAT

load([folder, '\', 'SUB010_noExo_SQ_10']);

for r = 1:length(repMat)
    fcom_unfilt = Datastr.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.(repMat{r});
    fcom_filt_noexo(r,:) = movmean(Datastr.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.(repMat{r}), 20);

    delta_SQ_no(r) = abs(max(fcom_filt_noexo(r,:))-min(fcom_filt_noexo(r,:)));

end

load([folder, '\', 'SUB010_yesExo_SQ_10']);

for r = 1:length(repMat)
    fcom_unfilt = Datastr.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.(repMat{r});
    fcom_filt_yesexo(r,:) = movmean(Datastr.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.(repMat{r}), 20);

    delta_SQ_yes(r) = abs(max(fcom_filt_yesexo(r,:))-min(fcom_filt_yesexo(r,:)));

end

%% BILATERAL

load([folder, '\', 'SUB010_noExo_BL_10']);

for r = 1:length(repMat)
    fcom_unfilt = Datastr.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.(repMat{r});
    fcom_filt_noexo(r,:) = movmean(Datastr.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.(repMat{r}), 20);

    delta_BL_no(r) = abs(max(fcom_filt_noexo(r,:))-min(fcom_filt_noexo(r,:)));

end

load([folder, '\', 'SUB010_yesExo_BL_10']);

for r = 1:length(repMat)
    fcom_unfilt = Datastr.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.(repMat{r});
    fcom_filt_yesexo(r,:) = movmean(Datastr.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.(repMat{r}), 20);

    delta_BL_yes(r) = abs(max(fcom_filt_yesexo(r,:))-min(fcom_filt_yesexo(r,:)));

end

%% ------------------- NUOVO SET CALIBRAZIONE - NOEXO ------------------

%% STOOP

folder = 'C:\Twente\IUVO\SUB009_CEINMSnoExo';
load([folder, '\', 'SUB009_noExo_ST_10']);

for r = 1:length(repMat)
    fcom_unfilt = Datastr.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.(repMat{r});
    fcom_filt_noexo(r,:) = movmean(Datastr.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.(repMat{r}), 20);

    delta_ST_no(r) = abs(max(fcom_filt_noexo(r,:))-min(fcom_filt_noexo(r,:)));

end


folder  = 'C:\Twente\IUVO\SUB009_execYesExocalibNoExo';
load([folder, '\', 'SUB009_yesExo_ST_10']);

for r = 1:length(repMat)
    fcom_unfilt = Datastr.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.(repMat{r});
    fcom_filt_yesexo(r,:) = movmean(Datastr.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.(repMat{r}), 20);

    delta_ST_yes(r) = abs(max(fcom_filt_yesexo(r,:))-min(fcom_filt_yesexo(r,:)));

end


%% SQUAT
folder = 'C:\Twente\IUVO\SUB009_CEINMSnoExo';
load([folder, '\', 'SUB009_noExo_SQ_10']);

for r = 1:length(repMat)
    fcom_unfilt = Datastr.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.(repMat{r});
    fcom_filt_noexo(r,:) = movmean(Datastr.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.(repMat{r}), 20);

    delta_SQ_no(r) = abs(max(fcom_filt_noexo(r,:))-min(fcom_filt_noexo(r,:)));

end


folder  = 'C:\Twente\IUVO\SUB009_execYesExocalibNoExo';
load([folder, '\', 'SUB009_yesExo_SQ_10']);

for r = 1:length(repMat)
    fcom_unfilt = Datastr.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.(repMat{r});
    fcom_filt_yesexo(r,:) = movmean(Datastr.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.(repMat{r}), 20);

    delta_SQ_yes(r) = abs(max(fcom_filt_yesexo(r,:))-min(fcom_filt_yesexo(r,:)));

end

%% BILATERAL


folder = 'C:\Twente\IUVO\SUB009_CEINMSnoExo';
load([folder, '\', 'SUB009_noExo_BL_10']);

for r = 1:length(repMat)
    fcom_unfilt = Datastr.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.(repMat{r});
    fcom_filt_noexo(r,:) = movmean(Datastr.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.(repMat{r}), 20);

    delta_BL_no(r) = abs(max(fcom_filt_noexo(r,:))-min(fcom_filt_noexo(r,:)));

end

folder  = 'C:\Twente\IUVO\SUB009_execYesExocalibNoExo';
load([folder, '\', 'SUB009_yesExo_BL_10']);

for r = 1:length(repMat)
    fcom_unfilt = Datastr.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.(repMat{r});
    fcom_filt_yesexo(r,:) = movmean(Datastr.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.(repMat{r}), 20);

    delta_BL_yes(r) = abs(max(fcom_filt_yesexo(r,:))-min(fcom_filt_yesexo(r,:)));

end