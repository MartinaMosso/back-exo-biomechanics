%% compare L5S1 COMPRESSIVE FORCE evaluated by CEINMS

clear all; clc; close all

%% decide file to import, subject and trials

sbj = 005;

outputPath = 'C:\Twente\IUVO\SUB005\CEINMS\execution\OP\reducedEMGSVD';

fileList = dir(outputPath);

fileList(1:2, :) = [];


sq0 ='C:\Twente\IUVO\SUB005\OS\DataFiles\SUB005noExo_SQ_0reducedEMGSVD_JointReaction_ReactionLoads.sto';
% 
% sq5 ='C:\Twente\IUVO\SUB005\CEINMS\execution\OP\reducedEMGSVD\SUB005noExo_SQ_5\Torques.sto';
% 
sq10 ='C:\Twente\IUVO\SUB005\OS\DataFiles\SUB005noExo_SQ_10reducedEMGSVD_JointReaction_ReactionLoads.sto';
% 
% sq15 ='C:\Twente\IUVO\SUB005\CEINMS\execution\OP\reducedEMGSVD\SUB005noExo_SQ_15\Torques.sto';
% 
st0 ='C:\Twente\IUVO\SUB005\OS\DataFiles\SUB005noExo_ST_0reducedEMGSVD_JointReaction_ReactionLoads.sto';

% st5 ='C:\Twente\IUVO\SUB005\CEINMS\execution\OP\reducedEMGSVD\SUB005noExo_ST_5\Torques.sto';
% 
% st10 ='C:\Twente\IUVO\SUB005\CEINMS\execution\OP\reducedEMGSVD\SUB005noExo_ST_10\Torques.sto';
% 
% bl10 ='C:\Twente\IUVO\SUB005\CEINMS\execution\OP\reducedEMGSVD\SUB005noExo_BL_10\Torques.sto';


% st15 ='C:\Twente\IUVO\SUB005\CEINMS\execution\OP\reducedEMGSVD\SUB005noExo_ST_15';



dataTorques = importdata(sq0);
torque_sq0 = dataTorques.data(:,2:4);

% dataTorques = importdata(sq5);
% torque_sq5 = dataTorques.data(:,2);
% 
dataTorques = importdata(sq10);
torque_sq10 = dataTorques.data(:,2:4);
% 
% dataTorques = importdata(sq15);
% torque_sq15 = dataTorques.data(:,2);

dataTorques = importdata(st0);
torque_st0 = dataTorques.data(:,2:4);

% dataTorques = importdata(st5);
% torque_st5 = dataTorques.data(:,2);
% 
% dataTorques = importdata(st10);
% torque_st10 = dataTorques.data(:,2);
% 
% dataTorques = importdata(bl10);
% torque_bl10 = dataTorques.data(:,2);

% figure
% plot(torque_sq0)
% hold on
% plot(torque_sq5)
% plot(torque_sq10)
% plot(torque_sq15)
% plot(torque_st0)
% plot(torque_st5)
% plot(torque_st10)


% torque_st0(400:length(torque_st0)+400,:) = torque_st0;
% torque_st0(1:399,:) = torque_st0(400,:)

figure
tiledlayout(3,1)
nexttile
plot(torque_sq0(:,1))
hold on
plot(torque_st0(:,1))
title('Load 0kg - FX')
legend('Squat', 'Stoop')

nexttile
plot(torque_sq0(:,2))
hold on
plot(torque_st0(:,2))
title('Load 0kg - FY')
legend('Squat', 'Stoop')

nexttile
plot(torque_sq0(:,3))
hold on
plot(torque_st0(:,3))
title('Load 0kg - FZ')
legend('Squat', 'Stoop')

%
figure
tiledlayout(3,1)
nexttile
plot(torque_sq0(:,1))
hold on
plot(torque_sq10(:,1))
title('Squat - FX')
legend('0', '10')

nexttile
plot(torque_sq0(:,2))
hold on
plot(torque_sq10(:,2))
title('Squat - FX')
legend('0', '10')

nexttile
plot(torque_sq0(:,3))
hold on
plot(torque_sq10(:,3))
title('Squat - FX')
legend('0', '10')
% 
