%% RMS VALUE AND CORRELETION BETWEEN OS TORQUE AND CEINMS TORQUE

clear; close all; clc

%% define subject and movement

trial = {'noExo_SQ_10', 'noExo_ST_10', 'noExo_BL_10', 'yesExo_SQ_10', 'yesExo_ST_10', 'yesExo_BL_10'};

sbj = {'SUB005',  'SUB006', 'SUB007', 'SUB009', 'SUB010', 'SUB011', 'SUB012'}; % ---> aggiungere SBJ 006

%% import OS and CEINMS

for s = 1:length(sbj)

    for t = 1:length(trial)

        file_OS =  ['C:\Twente\IUVO\', sbj{s}, '\OS\DataFiles\ResultOS\',sbj{s}, trial{t}, 'ID.sto'];
        ID_OSs = importdata(file_OS);
        ID_OS = ID_OSs.data(:,18);

        file_CEINMS_oneCalib = ['C:\Twente\IUVO\', sbj{s}, '\CEINMS\execution\OP\EMG_calibOne_newParam\', sbj{s}, trial{t}, '\', 'Torques.sto'];
        ID_ceinms_oneCalib = importdata(file_CEINMS_oneCalib);
        ID_ceinms_oneC = ID_ceinms_oneCalib.data(:,2);

        file_CEINMS_allCalib = ['C:\Twente\IUVO\', sbj{s}, '\CEINMS\execution\OP\EMG_calibMix_newParam\', sbj{s}, trial{t}, '\', 'Torques.sto'];
        ID_ceinms_allCalib = importdata(file_CEINMS_allCalib);
        ID_ceinms_allC = ID_ceinms_allCalib.data(:,2);

        rmsvalue.all.(sbj{s}).(trial{t}) = rms(ID_OS-ID_ceinms_allC);
        rmsvalue.one.(sbj{s}).(trial{t}) = rms(ID_OS-ID_ceinms_oneC);

        R_all = corrcoef(ID_OS, ID_ceinms_allC);
        corr.all.(sbj{s}).(trial{t}) = R_all(1,2);

        R_one = corrcoef(ID_OS, ID_ceinms_oneC);
        corr.one.(sbj{s}).(trial{t}) = R_one(1,2);

        figure
        plot(ID_OS)
        hold on; plot(ID_ceinms_allC); plot(ID_ceinms_oneC)
        legend('OS', 'CEINMS ALL', 'CEINMS ONE')
        title([sbj{s}, '-', trial{t}])

    end

    close all
end

%% cambio struct

for s = 1:length(sbj)

    rms_all_SQ(s) =  rmsvalue.all.(sbj{s}).noExo_SQ_10;
    rms_one_SQ(s) =  rmsvalue.one.(sbj{s}).noExo_SQ_10;

    rms_all_ST(s) =  rmsvalue.all.(sbj{s}).noExo_ST_10;
    rms_one_ST(s) =  rmsvalue.one.(sbj{s}).noExo_ST_10;

    rms_all_BL(s) =  rmsvalue.all.(sbj{s}).noExo_BL_10;
    rms_one_BL(s) =  rmsvalue.one.(sbj{s}).noExo_BL_10;

    corr_all_SQ(s) =  corr.all.(sbj{s}).noExo_SQ_10;
    corr_one_SQ(s) =  corr.one.(sbj{s}).noExo_SQ_10;

    corr_all_ST(s) =  corr.all.(sbj{s}).noExo_ST_10;
    corr_one_ST(s) =  corr.one.(sbj{s}).noExo_ST_10;

    corr_all_BL(s) =  corr.all.(sbj{s}).noExo_BL_10;
    corr_one_BL(s) =  corr.one.(sbj{s}).noExo_BL_10;


end

figure
plot(rms_all_SQ); hold on; plot(rms_one_SQ)
title('RMS - SQ')
legend('calib all', 'calib one')

figure
plot(rms_all_ST); hold on; plot(rms_one_ST)
title('RMS - ST')
legend('calib all', 'calib one')

figure
plot(rms_all_BL); hold on; plot(rms_one_BL)
title('RMS - BL')
legend('calib all', 'calib one')

figure
plot(corr_all_SQ); hold on; plot(corr_one_SQ)
title('CORR - SQ')
legend('calib all', 'calib one')

figure
plot(corr_all_ST); hold on; plot(corr_one_ST)
title('CORR - ST')
legend('calib all', 'calib one')

figure
plot(corr_all_BL); hold on; plot(corr_one_BL)
title('CORR - BL')
legend('calib all', 'calib one')

%% import RMS e CORR of different calib

% standard param
load('RMS_all_one.mat');
load('corr_all_one.mat')

for s = 1:length(sbj)

    rms_all_SQ_oldParam(s) =  rmsvalue.all.(sbj{s}).noExo_SQ_10;
    rms_one_SQ_oldParam(s) =  rmsvalue.one.(sbj{s}).noExo_SQ_10;

    rms_all_ST_oldParam(s) =  rmsvalue.all.(sbj{s}).noExo_ST_10;
    rms_one_ST_oldParam(s) =  rmsvalue.one.(sbj{s}).noExo_ST_10;

    rms_all_BL_oldParam(s) =  rmsvalue.all.(sbj{s}).noExo_BL_10;
    rms_one_BL_oldParam(s) =  rmsvalue.one.(sbj{s}).noExo_BL_10;

    corr_all_SQ_oldParam(s) =  corr.all.(sbj{s}).noExo_SQ_10;
    corr_one_SQ_oldParam(s) =  corr.one.(sbj{s}).noExo_SQ_10;

    corr_all_ST_oldParam(s) =  corr.all.(sbj{s}).noExo_ST_10;
    corr_one_ST_oldParam(s) =  corr.one.(sbj{s}).noExo_ST_10;

    corr_all_BL_oldParam(s) =  corr.all.(sbj{s}).noExo_BL_10;
    corr_one_BL_oldParam(s) =  corr.one.(sbj{s}).noExo_BL_10;

end

% New param
load('RMS_all_one_NewParam.mat');
load('corr_all_one_NewParam.mat')

for s = 1:length(sbj)

    rms_all_SQ_newParam(s) =  rmsvalue.all.(sbj{s}).noExo_SQ_10;
    rms_one_SQ_newParam(s) =  rmsvalue.one.(sbj{s}).noExo_SQ_10;

    rms_all_ST_newParam(s) =  rmsvalue.all.(sbj{s}).noExo_ST_10;
    rms_one_ST_newParam(s) =  rmsvalue.one.(sbj{s}).noExo_ST_10;

    rms_all_BL_newParam(s) =  rmsvalue.all.(sbj{s}).noExo_BL_10;
    rms_one_BL_newParam(s) =  rmsvalue.one.(sbj{s}).noExo_BL_10;

    corr_all_SQ_newParam(s) =  corr.all.(sbj{s}).noExo_SQ_10;
    corr_one_SQ_newParam(s) =  corr.one.(sbj{s}).noExo_SQ_10;

    corr_all_ST_newParam(s) =  corr.all.(sbj{s}).noExo_ST_10;
    corr_one_ST_newParam(s) =  corr.one.(sbj{s}).noExo_ST_10;

    corr_all_BL_newParam(s) =  corr.all.(sbj{s}).noExo_BL_10;
    corr_one_BL_newParam(s) =  corr.one.(sbj{s}).noExo_BL_10;

end

figure
plot(rms_all_SQ_oldParam); hold on; plot(rms_one_SQ_oldParam); plot(rms_all_SQ_newParam); plot(rms_one_SQ_newParam)
title('RMS - SQ')
legend('calib all', 'calib one', 'calib new all', 'calib new one')

figure
plot(rms_all_ST_oldParam); hold on; plot(rms_one_ST_oldParam); plot(rms_all_ST_newParam); plot(rms_one_ST_newParam)
title('RMS - ST')
legend('calib all', 'calib one', 'calib new all', 'calib new one')

figure
plot(rms_all_BL_oldParam); hold on; plot(rms_one_BL_oldParam); plot(rms_all_BL_newParam); plot(rms_one_BL_newParam)
title('RMS - BL')
legend('calib all', 'calib one', 'calib new all', 'calib new one')


figure
plot(corr_all_SQ_oldParam); hold on; plot(corr_one_SQ_oldParam); plot(corr_all_SQ_newParam); plot(corr_one_SQ_newParam)
title('CORR - SQ')
legend('calib all', 'calib one', 'calib new all', 'calib new one')

figure
plot(corr_all_ST_oldParam); hold on; plot(corr_one_ST_oldParam); plot(corr_all_ST_newParam); plot(corr_one_ST_newParam)
title('CORR - ST')
legend('calib all', 'calib one', 'calib new all', 'calib new one')

figure
plot(corr_all_BL_oldParam); hold on; plot(corr_one_BL_oldParam); plot(corr_all_BL_newParam); plot(corr_one_BL_newParam)
title('CORR - BL')
legend('calib all', 'calib one', 'calib new all', 'calib new one')

% istogramma
figure
bar([mean(rms_all_SQ_oldParam), mean(rms_one_SQ_oldParam), mean(rms_all_SQ_newParam), mean(rms_one_SQ_newParam)] )
title('RMS - SQ')

figure
bar([mean(rms_all_ST_oldParam), mean(rms_one_ST_oldParam), mean(rms_all_ST_newParam), mean(rms_one_ST_newParam)] )
title('RMS - ST')

figure
bar([mean(rms_all_BL_oldParam), mean(rms_one_BL_oldParam), mean(rms_all_BL_newParam), mean(rms_one_BL_newParam)] )
title('RMS - BL')

figure
bar([mean(corr_all_SQ_oldParam), mean(corr_one_SQ_oldParam), mean(corr_all_SQ_newParam), mean(corr_one_SQ_newParam)] )
title('Corr - SQ')

figure
bar([mean(corr_all_ST_oldParam), mean(corr_one_ST_oldParam), mean(corr_all_ST_newParam), mean(corr_one_ST_newParam)] )
title('Corr - ST')

figure
bar([mean(corr_all_BL_oldParam), mean(corr_one_BL_oldParam), mean(corr_all_BL_newParam), mean(corr_one_BL_newParam)] )
title('Corr - BL')

%% compare compressive force 

importdata('C:\Twente\IUVO\SUB010_all\OS\DataFiles\SUB010noExo_SQ_10EMG_JointReaction_ReactionLoads.sto')
calibOld = ans.data(:,3);

importdata('C:\Twente\IUVO\SUB010\OS\DataFiles\SUB010noExo_SQ_10EMG_calibOne_standardParam_JointReaction_ReactionLoads.sto')
calibOk = ans.data(:,3);

figure
plot(calibOld), hold on, plot(calibOk);