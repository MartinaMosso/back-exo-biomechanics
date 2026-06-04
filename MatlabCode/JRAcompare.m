%% COMPARE JRF FROM OPENSIM AND BIOMECHPRO
% option used in OS for actuator --> replace

clear; close all; clc;

%% importdata

SQ_noExo_BMP = importdata('C:\Twente\IUVO\SUB010\OS\DataFiles\SUB010noExo_SQ_10EMG_JointReaction_ReactionLoads.sto');

SQ_noExo_OS = importdata('C:\Twente\IUVO\SUB010\OS\JRF\SUB010noExo_SQ_10_noAct_JointReaction_ReactionLoads.sto');


figure
plot(SQ_noExo_BMP.data(:,3))
hold on
plot(SQ_noExo_OS.data(:,3))