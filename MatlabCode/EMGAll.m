%% INVERSE KINEMATICS

clear; close all; clc

%% import

task = {'noExo_ST_10', 'yesExo_ST_10'};
% task = {'noExo_SQ_0', 'noExo_SQ_5', 'noExo_SQ_10', 'noExo_SQ_15', 'yesExo_SQ_10', 'noExo_ST_0', 'noExo_ST_5', 'noExo_ST_10', 'noExo_ST_15', 'yesExo_ST_10'};

sbj = {'SUB005', 'SUB006', 'SUB007', 'SUB008', 'SUB009', 'SUB010', 'SUB011', 'SUB012'};
%per bilateral
% sbj = {'SUB005', 'SUB006','SUB008'}; %'SUB007', 'SUB008', 'SUB009', 'SUB010', 'SUB011', 'SUB012'};

rep = {'rep1', 'rep2', 'rep3', 'rep4', 'rep5','rep6', 'rep7', 'rep8', 'rep9', 'rep10'};

%% save mean and std for each subject across the 10 rep

for t = 1:length(task)
    for s=1:length(sbj)
        load(['C:\Twente\IUVO\', sbj{s}, '\', sbj{s}, '_', task{t}, '.mat'])

        Datastr = getMovementPhaseMoments(Datastr, 'EMG');

        EMG_longThor_mean_l(s,:,t) = Datastr.cutMovements.EMG.longthor_l.Mean;
        EMG_longLumb_mean_l(s,:,t) = Datastr.cutMovements.EMG.longlumb_l.Mean;
        EMG_ilio_mean_l(s,:,t) = Datastr.cutMovements.EMG .iliocost_l.Mean;

        massimo_EMG_longThor_mean_l(s,:,t) = max(EMG_longThor_mean_l(s,:,t));
        massimo_EMG_longLumb_mean_l(s,:,t) = max(EMG_longLumb_mean_l(s,:,t));
        massimo_EMG_ilio_mean_l(s,:,t) = max(EMG_ilio_mean_l(s,:,t));

        EMG_longThor_mean_r(s,:,t) = Datastr.cutMovements.EMG.longthor_r.Mean;
        EMG_longLumb_mean_r(s,:,t) = Datastr.cutMovements.EMG.longlumb_r.Mean;
        EMG_ilio_mean_r(s,:,t) = Datastr.cutMovements.EMG .iliocost_r.Mean;

        massimo_EMG_longThor_mean_r(s,:,t) = max(EMG_longThor_mean_r(s,:,t));
        massimo_EMG_longLumb_mean_r(s,:,t) = max(EMG_longLumb_mean_r(s,:,t));
        massimo_EMG_ilio_mean_r(s,:,t) = max(EMG_ilio_mean_r(s,:,t));

        % EMG_longThor_std(s,:,t) = Datastr.cutMovements.EMG.longthor_r.Std;
        % EMG_longLumb_std(s,:,t) = Datastr.cutMovements.EMG.longlumb_r.Std;
        % EMG_ilio_std(s,:,t) = Datastr.cutMovements.EMG.iliocost_r.Std;

        % massimo_longThor(s,:,t)= max( EMG_longThor_mean(s,:,t));
        % massimo_longLumb(s,:,t)= max( EMG_longLumb_mean(s,:,t));
        % massimo_ilio(s,:,t)= max( EMG_ilio_mean(s,:,t));

        EMG_longThor_mean(s,:,t) = mean([EMG_longThor_mean_l(s,:,t);EMG_longThor_mean_r(s,:,t)],1);
        EMG_longLumb_mean(s,:,t) = mean([EMG_longLumb_mean_l(s,:,t);EMG_longLumb_mean_r(s,:,t)],1);
        EMG_ilio_mean(s,:,t) = mean([EMG_ilio_mean_l(s,:,t);EMG_ilio_mean_r(s,:,t)],1);


        EMG_longThor_meanMAX(s,:,t) = mean([massimo_EMG_longThor_mean_l(s,:,t);massimo_EMG_longThor_mean_r(s,:,t)],1);
        EMG_longLumb_meanMAX(s,:,t) = mean([massimo_EMG_longLumb_mean_l(s,:,t);massimo_EMG_longLumb_mean_r(s,:,t)],1);
        EMG_ilio_meanMAX(s,:,t) = mean([massimo_EMG_ilio_mean_l(s,:,t);massimo_EMG_ilio_mean_r(s,:,t)],1);

    end
end

%% rms 

for t = 1:length(task)
    for s=1:length(sbj)
        load(['C:\Twente\IUVO\', sbj{s}, '\', sbj{s}, '_', task{t}, '.mat'])

        Datastr = getMovementPhaseMoments(Datastr, 'EMG');
        for r=1:10

            rms_longthor_l(r) =sqrt(mean(Datastr.cutMovements.EMG.longthor_l.(rep{r}).^2));
            rms_longlumb_l(r) =sqrt(mean(Datastr.cutMovements.EMG.longlumb_l.(rep{r}).^2));
            rms_ilio_l(r) =sqrt(mean(Datastr.cutMovements.EMG.iliocost_l.(rep{r}).^2));

            rms_longthor_r(r) =sqrt(mean(Datastr.cutMovements.EMG.longthor_r.(rep{r}).^2));
            rms_longlumb_r(r) =sqrt(mean(Datastr.cutMovements.EMG.longlumb_r.(rep{r}).^2));
            rms_ilio_r(r) =sqrt(mean(Datastr.cutMovements.EMG.iliocost_r.(rep{r}).^2));

        end
        RMS_longThor_l(s,:,t) = mean(rms_longthor_l);
        RMS_longlumb_l(s,:,t) = mean(rms_longlumb_l);
        RMS_ilio_l(s,:,t) = mean(rms_ilio_l);

        RMS_longThor_r(s,:,t) = mean(rms_longthor_r);
        RMS_longlumb_r(s,:,t) = mean(rms_longlumb_r);
        RMS_ilio_r(s,:,t) = mean(rms_ilio_r);


        EMG_longThor_meanRMS(s,:,t) = mean([RMS_longThor_l(s,:,t);RMS_longThor_r(s,:,t)],1);
        EMG_longLumb_meanRMS(s,:,t) = mean([RMS_longlumb_l(s,:,t);RMS_longlumb_r(s,:,t)],1);
        EMG_ilio_meanRMS(s,:,t) = mean([RMS_ilio_l(s,:,t);RMS_ilio_r(s,:,t)],1);



      
    end
end
%% iEMG

fs= 50;
T = 1001/fs; 

for t = 1:length(task)
    for s=1:length(sbj)
        load(['C:\Twente\IUVO\', sbj{s}, '\', sbj{s}, '_', task{t}, '.mat'])

        Datastr = getMovementPhaseMoments(Datastr, 'EMG');
        for r=1:10


            iemg_longthor_l(r) =(trapz(Datastr.cutMovements.EMG.longthor_l.(rep{r})/fs)/T);
            iemg_longlumb_l(r) =(trapz(Datastr.cutMovements.EMG.longlumb_l.(rep{r})/fs)/T);
            iemg_ilio_l(r) =(trapz(Datastr.cutMovements.EMG.iliocost_l.(rep{r})/fs)/T);

            iemg_longthor_r(r) =(trapz(Datastr.cutMovements.EMG.longthor_r.(rep{r})/fs)/T);
            iemg_longlumb_r(r) =(trapz(Datastr.cutMovements.EMG.longlumb_r.(rep{r})/fs)/T);
            iemg_ilio_r(r) =(trapz(Datastr.cutMovements.EMG.iliocost_r.(rep{r})/fs)/T);


        end
        IEMG_longThor_l(s,:,t) = mean(iemg_longthor_l);
        IEMG_longlumb_l(s,:,t) = mean(iemg_longlumb_l);
        IEMG_ilio_l(s,:,t) = mean(iemg_ilio_l);

        IEMG_longThor_r(s,:,t) = mean(iemg_longthor_r);
        IEMG_longlumb_r(s,:,t) = mean(iemg_longlumb_r);
        IEMG_ilio_r(s,:,t) = mean(iemg_ilio_r);


        EMG_longThor_meanIEMG(s,:,t) = mean([IEMG_longThor_l(s,:,t);IEMG_longThor_r(s,:,t)],1);
        EMG_longLumb_meanIEMG(s,:,t) = mean([IEMG_longlumb_l(s,:,t);IEMG_longlumb_r(s,:,t)],1);
        EMG_ilio_meanIEMG(s,:,t) = mean([IEMG_ilio_l(s,:,t);IEMG_ilio_r(s,:,t)],1);
    end
end


%% check normality
% bilatera
% longTHor
% [H_squat_noexo_max, pValue_squat_noexo_max, W_squat_noexo_max] = swtest(squeeze(massimo_longThor(:,:,1))); % normalità ok
% [H_squat_exo_max, pValue_squat_exo_max, W_squat_exo_max] = swtest(squeeze(massimo_longThor(:,:,2))); % normalità ok

% longLumb

% [H_squat_noexo_max, pValue_squat_noexo_max, W_squat_noexo_max] = swtest(squeeze(massimo_longLumb(:,:,1))); % normalità ok
% [H_squat_exo_max, pValue_squat_exo_max, W_squat_exo_max] = swtest(squeeze(massimo_longLumb(:,:,2))); % normalità ok

% ilio
% [H_squat_noexo_max, pValue_squat_noexo_max, W_squat_noexo_max] = swtest(squeeze(massimo_ilio(:,:,1))); % normalità ok
% [H_squat_exo_max, pValue_squat_exo_max, W_squat_exo_max] = swtest(squeeze(massimo_ilio(:,:,2))); % normalità ok

% squat stoop

% longTHor
[H_squat_noexo_max, pValue_squat_noexo_max, W_squat_noexo_max] = swtest(squeeze(EMG_longThor_meanMAX(:,:,3))); % normalità ok
[H_squat_exo_max, pValue_squat_exo_max, W_squat_exo_max] = swtest(squeeze(EMG_longThor_meanMAX(:,:,5))); % normalità ok

[H_stoop_noexo_max, pValue_stoop_noexo_max, W_stoop_noexo_max] = swtest(squeeze(EMG_longThor_meanMAX(:,:,8))); % normalità ok
[H_stoop_exo_max, pValue_stoop_exo_max, W_stoop_exo_max] = swtest(squeeze(EMG_longThor_meanMAX(:,:,10))); % normalità ok

% longLumb

[H_squat_noexo_max, pValue_squat_noexo_max, W_squat_noexo_max] = swtest(squeeze(EMG_longLumb_meanMAX(:,:,3))); % normalità ok
[H_squat_exo_max, pValue_squat_exo_max, W_squat_exo_max] = swtest(squeeze(EMG_longLumb_meanMAX(:,:,5))); % normalità ok

[H_stoop_noexo_max, pValue_stoop_noexo_max, W_stoop_noexo_max] = swtest(squeeze(EMG_longLumb_meanMAX(:,:,8))); % normalità ok
[H_stoop_exo_max, pValue_stoop_exo_max, W_stoop_exo_max] = swtest(squeeze(EMG_longLumb_meanMAX(:,:,10))); % normalità ok

% ilio
[H_squat_noexo_max, pValue_squat_noexo_max, W_squat_noexo_max] = swtest(squeeze(EMG_ilio_meanMAX(:,:,3))); % normalità ok
[H_squat_exo_max, pValue_squat_exo_max, W_squat_exo_max] = swtest(squeeze(EMG_ilio_meanMAX(:,:,5))); % normalità ok

[H_stoop_noexo_max, pValue_stoop_noexo_max, W_stoop_noexo_max] = swtest(squeeze(EMG_ilio_meanMAX(:,:,8))); % normalità ok
[H_stoop_exo_max, pValue_stoop_exo_max, W_stoop_exo_max] = swtest(squeeze(EMG_ilio_meanMAX(:,:,10))); % normalità ok


% bilatera
[H_squat_noexo_max, pValue_squat_noexo_max, W_squat_noexo_max] = swtest(squeeze(EMG_longThor_meanMAX(:,:,1))); % normalità ok
[H_squat_exo_max, pValue_squat_exo_max, W_squat_exo_max] = swtest(squeeze(EMG_longThor_meanMAX(:,:,2))); % normalità ok

[H_squat_noexo_max, pValue_squat_noexo_max, W_squat_noexo_max] = swtest(squeeze(EMG_longLumb_meanMAX(:,:,1))); % normalità ok
[H_squat_exo_max, pValue_squat_exo_max, W_squat_exo_max] = swtest(squeeze(EMG_longLumb_meanMAX(:,:,2))); % normalità ok

[H_squat_noexo_max, pValue_squat_noexo_max, W_squat_noexo_max] = swtest(squeeze(EMG_ilio_meanMAX(:,:,1))); % normalità ok
[H_squat_exo_max, pValue_squat_exo_max, W_squat_exo_max] = swtest(squeeze(EMG_ilio_meanMAX(:,:,2))); % normalità ok

%% rms normality
% longTHor
[H_squat_noexo_max, pValue_squat_noexo_max, W_squat_noexo_max] = swtest(squeeze(EMG_longThor_meanRMS(:,:,3))); % normalità ok
[H_squat_exo_max, pValue_squat_exo_max, W_squat_exo_max] = swtest(squeeze(EMG_longThor_meanRMS(:,:,5))); % normalità ok

[H_stoop_noexo_max, pValue_stoop_noexo_max, W_stoop_noexo_max] = swtest(squeeze(EMG_longThor_meanRMS(:,:,8))); % normalità ok
[H_stoop_exo_max, pValue_stoop_exo_max, W_stoop_exo_max] = swtest(squeeze(EMG_longThor_meanRMS(:,:,10))); % normalità ok

% longLumb

[H_squat_noexo_max, pValue_squat_noexo_max, W_squat_noexo_max] = swtest(squeeze(EMG_longLumb_meanRMS(:,:,3))); % normalità ok
[H_squat_exo_max, pValue_squat_exo_max, W_squat_exo_max] = swtest(squeeze(EMG_longLumb_meanRMS(:,:,5))); % normalità ok

[H_stoop_noexo_max, pValue_stoop_noexo_max, W_stoop_noexo_max] = swtest(squeeze(EMG_longLumb_meanRMS(:,:,8))); % normalità ok
[H_stoop_exo_max, pValue_stoop_exo_max, W_stoop_exo_max] = swtest(squeeze(EMG_longLumb_meanRMS(:,:,10))); % normalità ok

% ilio
[H_squat_noexo_max, pValue_squat_noexo_max, W_squat_noexo_max] = swtest(squeeze(EMG_ilio_meanRMS(:,:,3))); % normalità ok
[H_squat_exo_max, pValue_squat_exo_max, W_squat_exo_max] = swtest(squeeze(EMG_ilio_meanRMS(:,:,5))); % normalità ok

[H_stoop_noexo_max, pValue_stoop_noexo_max, W_stoop_noexo_max] = swtest(squeeze(EMG_ilio_meanRMS(:,:,8))); % normalità ok
[H_stoop_exo_max, pValue_stoop_exo_max, W_stoop_exo_max] = swtest(squeeze(EMG_ilio_meanRMS(:,:,10))); % normalità ok

% bilatera
[H_squat_noexo_max, pValue_squat_noexo_max, W_squat_noexo_max] = swtest(squeeze(EMG_longThor_meanRMS(:,:,1))); % normalità ok
[H_squat_exo_max, pValue_squat_exo_max, W_squat_exo_max] = swtest(squeeze(EMG_longThor_meanRMS(:,:,2))); % normalità ok

[H_squat_noexo_max, pValue_squat_noexo_max, W_squat_noexo_max] = swtest(squeeze(EMG_longLumb_meanRMS(:,:,1))); % normalità ok
[H_squat_exo_max, pValue_squat_exo_max, W_squat_exo_max] = swtest(squeeze(EMG_longLumb_meanRMS(:,:,2))); % normalità ok

[H_squat_noexo_max, pValue_squat_noexo_max, W_squat_noexo_max] = swtest(squeeze(EMG_ilio_meanRMS(:,:,1))); % normalità ok
[H_squat_exo_max, pValue_squat_exo_max, W_squat_exo_max] = swtest(squeeze(EMG_ilio_meanRMS(:,:,2))); % normalità ok
%% IEMG normality
% longTHor
[H_squat_noexo_max, pValue_squat_noexo_max, W_squat_noexo_max] = swtest(squeeze(EMG_longThor_meanIEMG(:,:,3))); % normalità ok
[H_squat_exo_max, pValue_squat_exo_max, W_squat_exo_max] = swtest(squeeze(EMG_longThor_meanIEMG(:,:,5))); % normalità ok

[H_stoop_noexo_max, pValue_stoop_noexo_max, W_stoop_noexo_max] = swtest(squeeze(EMG_longThor_meanIEMG(:,:,8))); % normalità ok
[H_stoop_exo_max, pValue_stoop_exo_max, W_stoop_exo_max] = swtest(squeeze(EMG_longThor_meanIEMG(:,:,10))); % normalità ok

% longLumb

[H_squat_noexo_max, pValue_squat_noexo_max, W_squat_noexo_max] = swtest(squeeze(EMG_longLumb_meanIEMG(:,:,3))); % normalità ok
[H_squat_exo_max, pValue_squat_exo_max, W_squat_exo_max] = swtest(squeeze(EMG_longLumb_meanIEMG(:,:,5))); % normalità ok

[H_stoop_noexo_max, pValue_stoop_noexo_max, W_stoop_noexo_max] = swtest(squeeze(EMG_longLumb_meanIEMG(:,:,8))); % normalità ok
[H_stoop_exo_max, pValue_stoop_exo_max, W_stoop_exo_max] = swtest(squeeze(EMG_longLumb_meanIEMG(:,:,10))); % normalità ok

% ilio
[H_squat_noexo_max, pValue_squat_noexo_max, W_squat_noexo_max] = swtest(squeeze(EMG_ilio_meanIEMG(:,:,3))); % normalità ok
[H_squat_exo_max, pValue_squat_exo_max, W_squat_exo_max] = swtest(squeeze(EMG_ilio_meanIEMG(:,:,5))); % normalità ok

[H_stoop_noexo_max, pValue_stoop_noexo_max, W_stoop_noexo_max] = swtest(squeeze(EMG_ilio_meanIEMG(:,:,8))); % normalità ok
[H_stoop_exo_max, pValue_stoop_exo_max, W_stoop_exo_max] = swtest(squeeze(EMG_ilio_meanIEMG(:,:,10))); % normalità ok

% bilatera
[H_squat_noexo_max, pValue_squat_noexo_max, W_squat_noexo_max] = swtest(squeeze(EMG_longThor_meanIEMG(:,:,1))); % normalità ok
[H_squat_exo_max, pValue_squat_exo_max, W_squat_exo_max] = swtest(squeeze(EMG_longThor_meanIEMG(:,:,2))); % normalità ok

[H_squat_noexo_max, pValue_squat_noexo_max, W_squat_noexo_max] = swtest(squeeze(EMG_longLumb_meanIEMG(:,:,1))); % normalità ok
[H_squat_exo_max, pValue_squat_exo_max, W_squat_exo_max] = swtest(squeeze(EMG_longLumb_meanIEMG(:,:,2))); % normalità ok

[H_squat_noexo_max, pValue_squat_noexo_max, W_squat_noexo_max] = swtest(squeeze(EMG_ilio_meanIEMG(:,:,1))); % normalità ok
[H_squat_exo_max, pValue_squat_exo_max, W_squat_exo_max] = swtest(squeeze(EMG_ilio_meanIEMG(:,:,2))); % normalità ok
%% t-test 
% longThor
[~, p_longThor_squat, ci_rom_squat, stats_rom_squat] = ttest(squeeze(EMG_longThor_meanMAX(:,:,3)), squeeze(EMG_longThor_meanMAX(:,:,5)));
[~, p_longThor_stoopt, ci_rom_stoop, stats_rom_stoop] = ttest(squeeze(EMG_longThor_meanMAX(:,:,8)), squeeze(EMG_longThor_meanMAX(:,:,10)));

% longLumb
[~, p_longLumb_squat, ci_rom_squat, stats_rom_squat] = ttest(squeeze(EMG_longLumb_meanMAX(:,:,3)), squeeze(EMG_longLumb_meanMAX(:,:,5)));
[~, p_longLumb_stoopt, ci_rom_stoop, stats_rom_stoop] = ttest(squeeze(EMG_longLumb_meanMAX(:,:,8)), squeeze(EMG_longLumb_meanMAX(:,:,10)));

% ilio
[~, p_ilio_squat, ci_rom_squat, stats_rom_squat] = ttest(squeeze(EMG_ilio_meanMAX(:,:,3)), squeeze(EMG_ilio_meanMAX(:,:,5)));
[~, p_ilio_stoopt, ci_rom_stoop, stats_rom_stoop] = ttest(squeeze(EMG_ilio_meanMAX(:,:,8)), squeeze(EMG_ilio_meanMAX(:,:,10)));

% bilareraò
[~, p_longThor_bl, ci_rom_squat, stats_rom_squat] = ttest(squeeze(EMG_longThor_meanMAX(:,:,1)), squeeze(EMG_longThor_meanMAX(:,:,2)));
[~, p_longLumb_bl, ci_rom_squat, stats_rom_squat] = ttest(squeeze(EMG_longLumb_meanMAX(:,:,1)), squeeze(EMG_longLumb_meanMAX(:,:,2)));

[~, p_ilio_bl, ci_rom_squat, stats_rom_squat] = ttest(squeeze(EMG_ilio_meanMAX(:,:,1)), squeeze(EMG_ilio_meanMAX(:,:,2)));

%% ttest rms
[~, p_longThor_squat, ci_rom_squat, stats_rom_squat] = ttest(squeeze(EMG_longThor_meanRMS(:,:,3)), squeeze(EMG_longThor_meanRMS(:,:,5)));
[~, p_longThor_stoopt, ci_rom_stoop, stats_rom_stoop] = ttest(squeeze(EMG_longThor_meanRMS(:,:,8)), squeeze(EMG_longThor_meanRMS(:,:,10)));

% longLumb
[~, p_longLumb_squat, ci_rom_squat, stats_rom_squat] = ttest(squeeze(EMG_longLumb_meanRMS(:,:,3)), squeeze(EMG_longLumb_meanRMS(:,:,5)));
[~, p_longLumb_stoopt, ci_rom_stoop, stats_rom_stoop] = ttest(squeeze(EMG_longLumb_meanRMS(:,:,8)), squeeze(EMG_longLumb_meanRMS(:,:,10)));

% ilio
[~, p_ilio_squat, ci_rom_squat, stats_rom_squat] = ttest(squeeze(EMG_ilio_meanRMS(:,:,3)), squeeze(EMG_ilio_meanRMS(:,:,5)));
[~, p_ilio_stoopt, ci_rom_stoop, stats_rom_stoop] = ttest(squeeze(EMG_ilio_meanRMS(:,:,8)), squeeze(EMG_ilio_meanRMS(:,:,10)));

% bilareraò
[~, p_longThor_bl, ci_rom_squat, stats_rom_squat] = ttest(squeeze(EMG_longThor_meanRMS(:,:,1)), squeeze(EMG_longThor_meanRMS(:,:,2)));
[~, p_longLumb_bl, ci_rom_squat, stats_rom_squat] = ttest(squeeze(EMG_longLumb_meanRMS(:,:,1)), squeeze(EMG_longLumb_meanRMS(:,:,2)));

[~, p_ilio_bl, ci_rom_squat, stats_rom_squat] = ttest(squeeze(EMG_ilio_meanRMS(:,:,1)), squeeze(EMG_ilio_meanRMS(:,:,2)));

%% ttest IEMG
[~, p_longThor_squat, ci_rom_squat, stats_rom_squat] = ttest(squeeze(EMG_longThor_meanIEMG(:,:,3)), squeeze(EMG_longThor_meanIEMG(:,:,5)));
[~, p_longThor_stoopt, ci_rom_stoop, stats_rom_stoop] = ttest(squeeze(EMG_longThor_meanIEMG(:,:,8)), squeeze(EMG_longThor_meanIEMG(:,:,10)));

% longLumb
[~, p_longLumb_squat, ci_rom_squat, stats_rom_squat] = ttest(squeeze(EMG_longLumb_meanIEMG(:,:,3)), squeeze(EMG_longLumb_meanIEMG(:,:,5)));
[~, p_longLumb_stoopt, ci_rom_stoop, stats_rom_stoop] = ttest(squeeze(EMG_longLumb_meanIEMG(:,:,8)), squeeze(EMG_longLumb_meanIEMG(:,:,10)));

% ilio
[~, p_ilio_squat, ci_rom_squat, stats_rom_squat] = ttest(squeeze(EMG_ilio_meanIEMG(:,:,3)), squeeze(EMG_ilio_meanIEMG(:,:,5)));
[~, p_ilio_stoopt, ci_rom_stoop, stats_rom_stoop] = ttest(squeeze(EMG_ilio_meanIEMG(:,:,8)), squeeze(EMG_ilio_meanIEMG(:,:,10)));

% bilareraò
[~, p_longThor_bl, ci_rom_squat, stats_rom_squat] = ttest(squeeze(EMG_longThor_meanIEMG(:,:,1)), squeeze(EMG_longThor_meanIEMG(:,:,2)));
[~, p_longLumb_bl, ci_rom_squat, stats_rom_squat] = ttest(squeeze(EMG_longLumb_meanIEMG(:,:,1)), squeeze(EMG_longLumb_meanIEMG(:,:,2)));
[~, p_ilio_bl, ci_rom_squat, stats_rom_squat] = ttest(squeeze(EMG_ilio_meanIEMG(:,:,1)), squeeze(EMG_ilio_meanIEMG(:,:,2)));

%% correlation

% [R, P] = corr(squeeze(ROM(:,:,3)), squeeze(ROM(:,:,5)));
% R_squared = R^2;
% 
% figure;
% scatter(squeeze(ROM(:,:,3)), squeeze(ROM(:,:,5)));
% lsline; % linea di regressione
% xlabel('No eso'); ylabel('Eso');
% title(['R = ' num2str(R) ', R^2 = ' num2str(R_squared)]);


%% stoop lifting
all_muscles = cat(4, EMG_ilio_mean, EMG_longThor_mean, EMG_longLumb_mean);
media_muscoli = mean(all_muscles, 4); % risultato: 8x1001x10
media_soggetti = squeeze(mean(media_muscoli, 1)); % risultato: 1001x10

% EMG_ilio_mean2 = [EMG_ilio_mean(1,:,:);  EMG_ilio_mean(6:7, :, :)]; % si può tenere anche sbj 3 e 8
% EMG_longThor_mean2 = [EMG_longThor_mean(1:3,:,:);  EMG_longThor_mean(6, :, :)]; % si può tenere anche sbj 3 e 8
% EMG_longLumb_mean2 = [EMG_longLumb_mean(1:2,:,:);  EMG_longLumb_mean(5:6, :, :)]; % si può tenere anche sbj 3 e 8
% 
% ilio_mean = squeeze(mean(EMG_ilio_mean2, 1));  % Risultato: 1001 x 10
% longThor_mean = squeeze(mean(EMG_longThor_mean2, 1));  % Risultato: 1001 x 10
% longLumb_mean = squeeze(mean(EMG_longLumb_mean2, 1));  % Risultato: 1001 x 10
% 
% [~, p_longLumb_stoopt, ci_rom_stoop, stats_rom_stoop] = ttest(max(EMG_longLumb_mean2(:,:,8),[],2), max(EMG_longLumb_mean2(:,:,10), [], 2));
% p_sttopno = ranksum(max(EMG_longLumb_mean2(:,:,8),[],2), max(EMG_longLumb_mean2(:,:,10), [], 2));

% Calcola la media tra soggetti (lunghezza 1001)
media_task8 = movmean(media_soggetti(:,8), 40);  % risultato 1 x 1001
media_task10 = movmean(media_soggetti(:,10), 40); % risultato 1 x 1001
p_sttopmedia = ranksum(media_soggetti(:,8), media_soggetti(:,10));
% [~, p_longLumb_stoopt, ci_rom_stoop, stats_rom_stoop] = ttest(EMG_longLumb_mean2(:,:,8), EMG_longLumb_mean2(:,:,10));

% Calcola la deviazione standard tra soggetti
std_task8 = movmean(std(media_muscoli(:,:,8), 0, 1)', 40);  % risultato 1 x 1001
std_task10 = movmean(std(media_muscoli(:,:,10), 0, 1)', 40);  % risultato 1 x 1001

% media_task8 = movmean(squeeze(media_task8).', 25);
% std_task8 = movmean(squeeze(std_task8).', 25);
% media_task10 = squeeze(media_task10).';
% std_task10 = squeeze(std_task10).';
x = 1:1001;

% Plot
figure;
hold on;
% Fascia colorata (±1 std)
fill([x fliplr(x)], ...
    [media_task8 + std_task8; flipud(media_task8 - std_task8)]', ...
    [159/256 200/256 200/256], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
fill([x fliplr(x)], ...
    [media_task10 + std_task10; flipud(media_task10 - std_task10)]',  ...
    [188/256 80/256 144/256], 'EdgeColor', 'none', 'FaceAlpha', 0.2);


% Linea della media
plot(x, media_task8, 'color', '#298c8c', 'LineWidth', 2);


plot(x, media_task10, 'color', '#bc5090', 'LineWidth', 2);



xlabel('Movement Cycle', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Muscle Activity', 'FontSize', 12, 'FontWeight', 'bold');
title('Stoop Lifting');
% grid on;
set(gca, 'FontSize', 12, 'LineWidth', 1.5);

legend('', '', 'NoExo', 'Exo');
xlim([0 1000]);                       % Limita asse X da 0 a 1000
xticks(0:100:1000);                   % Imposta i tick ogni 100
xticklabels(0:10:100);                % Etichette da 0% a 100%
xlabel('Lifting cycle (%)');         % Etichetta asse X

hold off;
print(gcf, 'StoopEMG.png', '-dpng', '-r600')

%% SQUAT lifting

% EMG_ilio_mean2 = [EMG_ilio_mean(1:5,:,:);  EMG_ilio_mean(6:8, :, :)]; % si può tenere anche sbj 3 e 8
% EMG_longThor_mean2 = [EMG_longThor_mean(1:5,:,:);  EMG_longThor_mean(6:8, :, :)]; % si può tenere anche sbj 3 e 8
% EMG_longLumb_mean2 = [EMG_longLumb_mean(1:2,:,:);  EMG_longLumb_mean(3:8, :, :)]; % si può tenere anche sbj 3 e 8
% 
% 
% ilio_mean = squeeze(mean(EMG_ilio_mean2, 1));  % Risultato: 1001 x 10
% longThor_mean = squeeze(mean(EMG_longThor_mean2, 1));  % Risultato: 1001 x 10
% longLumb_mean = squeeze(mean(EMG_longLumb_mean2, 1));  % Risultato: 1001 x 10
% 
% [~, p_longLumb_stoopt, ci_rom_stoop, stats_rom_stoop] = ttest(max(EMG_longLumb_mean2(:,:,3),[],2), max(EMG_longLumb_mean2(:,:,5), [], 2));
% p_sttopno = ranksum(max(EMG_longLumb_mean2(:,:,3),[],2), max(EMG_longLumb_mean2(:,:,5), [], 2));

% Calcola la media tra soggetti (lunghezza 1001)
media_task8 = movmean(media_soggetti(:,3), 40);  % risultato 1 x 1001
media_task10 = movmean(media_soggetti(:,5), 40); % risultato 1 x 1001
p_sttopmedia = ranksum(media_soggetti(:,3), media_soggetti(:,5));
% [~, p_longLumb_stoopt, ci_rom_stoop, stats_rom_stoop] = ttest(EMG_longLumb_mean2(:,:,8), EMG_longLumb_mean2(:,:,10));

% Calcola la deviazione standard tra soggetti
std_task8 = movmean(std(media_muscoli(:,:,3), 0, 1)', 40);  % risultato 1 x 1001
std_task10 = movmean(std(media_muscoli(:,:,5), 0, 1)', 40);  % risultato 1 x 1001

% media_task8 = movmean(squeeze(media_task8).', 25);
% std_task8 = movmean(squeeze(std_task8).', 25);
% media_task10 = squeeze(media_task10).';
% std_task10 = squeeze(std_task10).';
x = 1:1001;

% Plot
figure;
hold on;
% Fascia colorata (±1 std)
fill([x fliplr(x)], ...
    [media_task8 + std_task8; flipud(media_task8 - std_task8)]', ...
    [159/256 200/256 200/256], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
fill([x fliplr(x)], ...
    [media_task10 + std_task10; flipud(media_task10 - std_task10)]',  ...
    [188/256 80/256 144/256], 'EdgeColor', 'none', 'FaceAlpha', 0.2);


% Linea della media
plot(x, media_task8, 'color', '#298c8c', 'LineWidth', 2);


plot(x, media_task10, 'color', '#bc5090', 'LineWidth', 2);



xlabel('Movement Cycle', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Muscle Activity', 'FontSize', 12, 'FontWeight', 'bold');
title('Squat Lifting');
% grid on;
set(gca, 'FontSize', 12, 'LineWidth', 1.5);

legend('', '', 'NoExo', 'Exo');
xlim([0 1000]);                       % Limita asse X da 0 a 1000
xticks(0:100:1000);                   % Imposta i tick ogni 100
xticklabels(0:10:100);                % Etichette da 0% a 100%
xlabel('Lifting cycle (%)');         % Etichetta asse X

hold off;
print(gcf, 'SquatEMG.png', '-dpng', '-r600')

%% BIlateral
all_muscles = cat(4, EMG_ilio_mean, EMG_longThor_mean, EMG_longLumb_mean);
media_muscoli = mean(all_muscles, 4); % risultato: 8x1001x10
media_soggetti = squeeze(mean(media_muscoli, 1)); % risultato: 1001x10

media_task8 = movmean(media_soggetti(:,1), 40);  % risultato 1 x 1001
media_task10 = movmean(media_soggetti(:,2), 40); % risultato 1 x 1001
p_sttopmedia = ranksum(media_soggetti(:,1), media_soggetti(:,2));
% [~, p_longLumb_stoopt, ci_rom_stoop, stats_rom_stoop] = ttest(EMG_longLumb_mean2(:,:,8), EMG_longLumb_mean2(:,:,10));

% Calcola la deviazione standard tra soggetti
std_task8 = movmean(std(media_muscoli(:,:,1), 0, 1)', 40);  % risultato 1 x 1001
std_task10 = movmean(std(media_muscoli(:,:,2), 0, 1)', 40);  % risultato 1 x 1001

% media_task8 = movmean(squeeze(media_task8).', 25);
% std_task8 = movmean(squeeze(std_task8).', 25);
% media_task10 = squeeze(media_task10).';
% std_task10 = squeeze(std_task10).';
x = 1:1001;

% Plot
figure;
hold on;
% Fascia colorata (±1 std)
fill([x fliplr(x)], ...
    [media_task8 + std_task8; flipud(media_task8 - std_task8)]', ...
    [159/256 200/256 200/256], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
fill([x fliplr(x)], ...
    [media_task10 + std_task10; flipud(media_task10 - std_task10)]',  ...
    [188/256 80/256 144/256], 'EdgeColor', 'none', 'FaceAlpha', 0.2);


% Linea della media
plot(x, media_task8, 'color', '#298c8c', 'LineWidth', 4);


plot(x, media_task10, 'color', '#bc5090', 'LineWidth', 4);



xlabel('Movement Cycle', 'FontSize', 16, 'FontWeight', 'bold');
ylabel('Muscle Activity', 'FontSize', 16, 'FontWeight', 'bold');
title('Bilateral Lifting');
% grid on;
set(gca, 'FontSize', 16, 'LineWidth', 3);

legend('', '', 'NoExo', 'Exo');
xlim([0 1000]);                       % Limita asse X da 0 a 1000
xticks(0:100:1000);                   % Imposta i tick ogni 100
xticklabels(0:10:100);                % Etichette da 0% a 100%
xlabel('Lifting cycle (%)');         % Etichetta asse X
set(gcf, 'color', 'none');   
set(gca, 'color', 'none');
copygraphics(gcf, 'BackgroundColor', 'none', 'ContentType', 'vector');
hold off;
print(gcf, 'BilEMG.png', '-dpng', '-r600')
