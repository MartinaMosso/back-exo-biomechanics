%% compare Output of CEINMS with different calib method

clear; close all; clc;

elencoTrial = dir('C:\Twente\IUVO\SUB009\CEINMS\execution\OP\EMG');
elencoTrial(1:2,:) = [];

%% condition noExo

for i=1:length(elencoTrial)-3

% Calibration done with boht condition noExo and yesExo
nameFile = ['C:\Twente\IUVO\SUB009\CEINMS\execution\OP\EMG', '\', elencoTrial(i,:).name, '\', 'Torques.sto'];
torque_calibALL = importdata(nameFile);

torque_calibALL = torque_calibALL.data(:,2);

% % Calibration only No
% nameFile = ['C:\Twente\IUVO\SUB009\CEINMS\execution\OP\EMG', '\', elencoTrial(i,:).name, '\', 'Torques.sto'];
% torque_calibNO = importdata(nameFile);
% 
% torque_calibNO = torque_calibNO.data(:,2);

% import torque calculated with OS

fileOS = ['C:\Twente\IUVO\SUB009\OS\DataFiles\ResultOS\', elencoTrial(i,:).name, 'ID.sto'];
torque_OS = importdata(fileOS);
torque_OS = torque_OS.data(:,18);


figure
plot(torque_calibALL)
hold on; grid on

plot(torque_OS, 'LineWidth',2)
legend('calib ALL', 'calib noExo', 'OS')
title(elencoTrial(i,:).name)
end


%% condition yesExo

for i=4:length(elencoTrial)

% Calibration done with boht condition noExo and yesExo
nameFile = ['C:\Twente\IUVO\SUB009_calibInsiemeYeseNo\CEINMS\execution\OP\EMG', '\', elencoTrial(i,:).name, '\', 'Torques.sto']
torque_calibALL = importdata(nameFile);

torque_calibALL = torque_calibALL.data(:,2);

% Calibration only yes
nameFile = ['C:\Twente\IUVO\SUB009_CEINMSyesExo\CEINMS\execution\OP\EMG', '\', elencoTrial(i,:).name, '\', 'Torques.sto'];
torque_calibYES = importdata(nameFile);

torque_calibYES = torque_calibYES.data(:,2);

% Calibration no, execute yes 
nameFile = ['C:\Twente\IUVO\SUB009_execYesExocalibNoExo\CEINMS\execution\OP\EMG', '\', elencoTrial(i,:).name, '\', 'Torques.sto'];
torque_calibNo = importdata(nameFile);

torque_calibNo = torque_calibNo.data(:,2);


% import torque calculated with OS

fileOS = ['C:\Twente\IUVO\SUB009_calibInsiemeYeseNo\OS\DataFiles\ResultOS\', elencoTrial(i,:).name, 'ID.sto'];
torque_OS = importdata(fileOS);
torque_OS = torque_OS.data(:,18);


figure
plot(torque_calibALL)
hold on; grid on
plot(torque_calibYES)
plot(torque_calibNo)
plot(torque_OS, 'LineWidth',2)
legend('calib ALL', 'calib yesExo', 'calib noExo', 'OS')
title(elencoTrial(i,:).name)
end

%% ------------------------------- compressive force --------------------------

%% condition noExo

for i=1:length(elencoTrial)-3

% Calibration done with boht condition noExo and yesExo
nameFile = ['C:\Twente\IUVO\SUB009_calibInsiemeYeseNo\OS\DataFiles', '\', elencoTrial(i,:).name, 'EMG_JointReaction_ReactionLoads.sto'];

compForce_calibALLno = importdata(nameFile);

compForce_calibALLno = compForce_calibALLno.data(:,3);

% Calibration only No exo
nameFile = ['C:\Twente\IUVO\SUB009_CEINMSnoExo\OS\DataFiles', '\', elencoTrial(i,:).name, 'EMG_JointReaction_ReactionLoads.sto']; % --> modificato e ricalcolate le forze di compressione SUB009_CEINMSnoExo
compForce_calibNO = importdata(nameFile);

compForce_calibNO = compForce_calibNO.data(:,3);

figure
plot(compForce_calibALLno)
hold on; grid on
plot(compForce_calibNO)
legend('calib ALL', 'calib noExo')
title(elencoTrial(i,:).name)
end

%% condition yesExo

for i=4:length(elencoTrial)

% Calibration done with boht condition noExo and yesExo
nameFile = ['C:\Twente\IUVO\SUB009_calibInsiemeYeseNo\OS\DataFiles', '\', elencoTrial(i,:).name, 'EMG_JointReaction_ReactionLoads.sto']
compForce_calibALLyes = importdata(nameFile);

compForce_calibALLyes = compForce_calibALLyes.data(:,2);

% Calibration only yes
nameFile = ['C:\Twente\IUVO\SUB009_CEINMSyesExo\OS\DataFiles', '\', elencoTrial(i,:).name, 'EMG_JointReaction_ReactionLoads.sto'];
compForce_calibYES = importdata(nameFile);

compForce_calibYES = compForce_calibYES.data(:,2);

% Calibration no, execute yes 
nameFile = ['C:\Twente\IUVO\SUB009_execYesExocalibNoExo\OS\DataFiles', '\', elencoTrial(i,:).name,  'EMG_JointReaction_ReactionLoads.sto'];
compForce_calibNoExYes = importdata(nameFile);

compForce_calibNoExYes = compForce_calibNoExYes.data(:,2);

figure
plot(compForce_calibALLyes)
hold on; grid on
plot(compForce_calibYES)
plot(compForce_calibNoExYes)
legend('calib ALL', 'calib yesExo', 'calib noExo')
title(elencoTrial(i,:).name)
end


%% ------------------------------- compressive force --------------------------

BL_noExo = importdata('C:\Twente\IUVO\SUB010\OS\DataFiles\SUB010noExo_BL_10EMG_JointReaction_ReactionLoads.sto');
BL_yesExo = importdata('C:\Twente\IUVO\SUB010\OS\DataFiles\SUB010yesExo_BL_10EMG_JointReaction_ReactionLoads.sto');
figure
plot(BL_noExo.data(:,3))
hold on
plot(BL_yesExo.data(:,3))

SQ_noExo = importdata('C:\Twente\IUVO\SUB010\OS\DataFiles\SUB010noExo_SQ_10EMG_JointReaction_ReactionLoads.sto');
SQ_yesExo = importdata('C:\Twente\IUVO\SUB010\OS\DataFiles\SUB010yesExo_SQ_10EMG_JointReaction_ReactionLoads.sto');
figure
plot(SQ_noExo.data(:,3))
hold on
plot(SQ_yesExo.data(:,3))

ST_noExo = importdata('C:\Twente\IUVO\SUB010\OS\DataFiles\SUB010noExo_ST_10EMG_JointReaction_ReactionLoads.sto');
ST_yesExo = importdata('C:\Twente\IUVO\SUB010\OS\DataFiles\SUB010yesExo_ST_10EMG_JointReaction_ReactionLoads.sto');
figure
plot(ST_noExo.data(:,3))
hold on
plot(ST_yesExo.data(:,3))
