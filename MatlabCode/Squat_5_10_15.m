%% COMPARING STOOP WITH DIFFERENT WEIGHT

clear; close all; clc


%% import ST_5, ST_10, ST_15

load('C:\Twente\IUVO\SUB010\SUB010_noExo_SQ_0.mat')
SQ_5 = Datastr;

load('C:\Twente\IUVO\SUB010\SUB010_noExo_ST_0.mat')
SQ_10 = Datastr;

% load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\ST_noExo_Fnorm.mat')
% ST_noExo_mean = mean([ST_noExo(1:10,:)]);%ST_noExo(51:end,:)]);
% ST_noExo_std = std([ST_noExo(1:30,:);ST_noExo(51:end,:)]);


load('C:\Twente\IUVO\SUB012\SUB012_noExo_SQ_15.mat')
SQ_15 = Datastr;

%% import task with exo

load('C:\Twente\IUVO\SUB006\SUB006_yesExo_SQ_10.mat')
SQ_exo = Datastr;
clear Datastr;

%% cut movements IK

[SQ_5] = getMovementPhaseMoments(SQ_5, 'IK');

[SQ_10] = getMovementPhaseMoments(SQ_10, 'IK');

[SQ_15] = getMovementPhaseMoments(SQ_15, 'IK');

% [SQ_exo] = getMovementPhaseMoments(SQ_exo, 'IK');


%% IK

IK_5 = SQ_5.cutMovements.IK.L5_S1_Flex_Ext_moment.Mean;

IK_10 = SQ_10.cutMovements.IK.L5_S1_Flex_Ext_moment.Mean;

IK_15 = SQ_15.cutMovements.IK.L5_S1_Flex_Ext_moment.Mean;

% IK_exo = SQ_exo.cutMovements.IK.L5_S1_Flex_Ext_moment.Mean;


figure
plot(IK_5);
hold on
plot(IK_10)
plot(IK_15)
% plot(IK_exo, LineWidth=2)
title('SQUAT: L5S1 Flex-Ext Angle')
legend('5kg', '10kg', '15kg')

%% ID
% [ST_5] = getMovementPhaseMoments(ST_5, 'ID');
% 
[SQ_10] = getMovementPhaseMoments(SQ_10, 'ID');

% [SQ_exo] = getMovementPhaseMoments(SQ_exo, 'ID');

% 
% [ST_15] = getMovementPhaseMoments(ST_15, 'ID');
%% 
ID_5 = SQ_5.cutMovements.ID.L5_S1_Flex_Ext_moment.Mean;

ID_10 = SQ_10.cutMovements.ID.L5_S1_Flex_Ext_moment.Mean;

ID_15 = SQ_15.cutMovements.ID.L5_S1_Flex_Ext_moment.Mean;

% ID_exo = SQ_exo.cutMovements.ID.L5_S1_Flex_Ext_moment.Mean;

figure
plot(ID_5);
hold on
plot(ID_10)
plot(ID_15)
plot(ID_exo, LineWidth=2)

title('STOOP: L5S1 Flex-Ext Moment')
legend('5kg', '10kg', '15kg')

%% JRF

FC_5 = SQ_5.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.Mean/(9.81*SQ_5.Info.subjMass);

[SQ_10] = getMovementPhaseMoments(SQ_10, 'JRA_EMG');
[SQ_exo] = getMovementPhaseMoments(SQ_exo, 'JRA_EMG');


FC_10 = SQ_10.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.Mean/(9.81*SQ_10.Info.subjMass);

FC_15 = SQ_15.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.Mean/(9.81*SQ_15.Info.subjMass);
FC_exo = SQ_exo.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.Mean/(9.81*SQ_exo.Info.subjMass);

figure
plot(FC_5);
hold on
plot(FC_10)
plot(FC_15)
plot(FC_exo, LineWidth=2)
title('STOOP: L5S1 Compressive Force')
legend('5kg', '10kg', '15kg')


