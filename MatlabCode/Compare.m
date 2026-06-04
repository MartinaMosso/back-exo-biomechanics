%% compare DATA irfan - SUB002 Knowledge Transfer

clear; close all; clc

%% import

file_OS = 'C:\Users\Dottorato\Downloads\SUB002\SUB002noExo_ST_75_MusA_MTULen.sto';
length_OS = importdata(file_OS);
l_OS = length_OS.data(:,2);


file_CEINMS_fiber= ('C:\Users\Dottorato\Downloads\SUB002\FiberLenghts.sto');
length_CEINMS_fiber = importdata(file_CEINMS_fiber);
l_CEINMS_fiber = length_CEINMS_fiber.data(:,2);

file_CEINMS_fiberNorm= ('C:\Users\Dottorato\Downloads\SUB002\NormFiberLengths.sto');
length_CEINMS_fiberNorm = importdata(file_CEINMS_fiberNorm);
l_CEINMS_fibe0Normr = length_CEINMS_fiberNorm.data(:,2);

figure
plot(l_OS); hold on; plot(l_CEINMS_fiber); plot(l_CEINMS_fibe0Normr)

%% torque

file_OS = 'C:\Users\Dottorato\Downloads\SUB002\SUB002noExo_ST_75ID.sto';
id_OSs = importdata(file_OS);
id_OS = id_OSs.data(:,18);


file_CIENMS = 'C:\Users\Dottorato\Downloads\SUB002\Torques.sto';
id_CIENMS = importdata(file_CIENMS);
id_CIENMS = id_CIENMS.data(:,2);

figure
plot(id_OS); hold on; plot(id_CIENMS);

%% compare torque between differnt calib

% ----------- SQUAT -------------------
file_OS_old = 'C:\Twente\IUVO\SUB009_OK\OS\DataFiles\ResultOS\SUB009noExo_SQ_10ID.sto';
id_OS_olds = importdata(file_OS_old);
id_OS = id_OS_olds .data(:,18);


file_CIENMS_old  = 'C:\Twente\IUVO\SUB009_OK\CEINMS\execution\OP\EMG\SUB009noExo_SQ_10\Torques.sto';
id_CIENMS_olds = importdata(file_CIENMS_old);
id_CIENMS_old = id_CIENMS_olds.data(:,2);

file_CIENMS = 'C:\Twente\IUVO\SUB009\CEINMS\execution\OP\EMG\SUB009noExo_SQ_10\Torques.sto';
id_CIENMS = importdata(file_CIENMS);
id_CIENMS = id_CIENMS.data(:,2);

figure
plot(id_OS); hold on; plot(id_CIENMS); plot(id_CIENMS_old)
legend('OS', 'CEINSM new', 'CEINMS old')


% ----------- STOOP -------------------
file_OS_old = 'C:\Twente\IUVO\SUB012\OS\DataFiles\ResultOS\SUB012noExo_ST_10ID.sto';
id_OS_olds = importdata(file_OS_old);
id_OS = id_OS_olds .data(:,18);


file_CIENMS_old  = 'C:\Twente\IUVO\SUB012_FC\CEINMS\execution\OP\EMG\SUB012noExo_ST_10\Torques.sto';
id_CIENMS_olds = importdata(file_CIENMS_old);
id_CIENMS_old = id_CIENMS_olds.data(:,2);

file_CIENMS = 'C:\Twente\IUVO\SUB012\CEINMS\execution\OP\EMG\SUB012noExo_ST_10\Torques.sto';
id_CIENMS = importdata(file_CIENMS);
id_CIENMS = id_CIENMS.data(:,2);

figure
plot(id_OS); hold on; plot(id_CIENMS); plot(id_CIENMS_old)
legend('OS', 'CEINSM new', 'CEINMS old')

% ----------- BILATERAL -------------------
file_OS_old = 'C:\Twente\IUVO\SUB006_ok\OS\DataFiles\ResultOS\SUB006yesExo_BL_10ID.sto';
id_OS_olds = importdata(file_OS_old);
id_OS = id_OS_olds .data(:,18);


file_CIENMS_old  = 'C:\Twente\IUVO\SUB006_ok\CEINMS\execution\OP\EMG\SUB006yesExo_BL_10\Torques.sto';
id_CIENMS_olds = importdata(file_CIENMS_old);
id_CIENMS_old = id_CIENMS_olds.data(:,2);

file_CIENMS = 'C:\Twente\IUVO\SUB006\CEINMS\execution\OP\EMG\SUB006yesExo_BL_10\Torques.sto';
id_CIENMS = importdata(file_CIENMS);
id_CIENMS = id_CIENMS.data(:,2);

figure
plot(id_OS); hold on; plot(id_CIENMS); plot(id_CIENMS_old)
legend('OS', 'CEINSM new', 'CEINMS old')

%% compressive forces

FC_yes_file = 'C:\Twente\IUVO\SUB009\OS\DataFiles\SUB009yesExo_SQ_10EMG_JointReaction_ReactionLoads.sto'
FC_yess = importdata(FC_yes_file);
FC_yes = FC_yess.data(:,2);

FC_no_file = 'C:\Twente\IUVO\SUB009\OS\DataFiles\SUB009noExo_SQ_10EMG_JointReaction_ReactionLoads.sto'
FC_noo = importdata(FC_no_file);
FC_no = FC_noo.data(:,2);


figure
plot(FC_no)
hold on; plot(FC_yes)
legend('noExo', 'yesExo')


figure
plot(FC_no(2820:2820+600,:)/70.5)
hold on; plot(FC_yes(4300:4900,:)/70.5)
legend('noExo', 'yesExo')
