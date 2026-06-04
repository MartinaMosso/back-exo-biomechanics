%% COMPARING STOOP WITH DIFFERENT WEIGHT

clear; close all; clc

%% import ST_5, ST_10, ST_15

load('C:\Twente\IUVO\SUB005\SUB005_noExo_ST_5.mat')
ST_5 = Datastr;

load('C:\Twente\IUVO\SUB005\SUB005_noExo_ST_10.mat')
ST_10 = Datastr;

% load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\ST_noExo_Fnorm.mat')
% ST_noExo_mean = mean([ST_noExo(1:10,:)]);%ST_noExo(51:end,:)]);
% ST_noExo_std = std([ST_noExo(1:30,:);ST_noExo(51:end,:)]);


load('C:\Twente\IUVO\SUB005\SUB005_noExo_ST_15.mat')
ST_15 = Datastr;

%% import task with exo

load('C:\Twente\IUVO\SUB005\SUB005_yesExo_ST_10.mat')
ST_exo = Datastr;
clear Datastr;

%% cut movements IK

[ST_5] = getMovementPhaseMoments(ST_5, 'IK');

[ST_10] = getMovementPhaseMoments(ST_10, 'IK');

[ST_15] = getMovementPhaseMoments(ST_15, 'IK');

[ST_exo] = getMovementPhaseMoments(ST_exo, 'IK');


%% IK

IK_5 = ST_5.cutMovements.IK.L5_S1_Flex_Ext_moment.Mean;

IK_10 = ST_10.cutMovements.IK.L5_S1_Flex_Ext_moment.Mean;

IK_15 = ST_15.cutMovements.IK.L5_S1_Flex_Ext_moment.Mean;

IK_exo = ST_exo.cutMovements.IK.L5_S1_Flex_Ext_moment.Mean;


figure
plot(IK_5);
hold on
plot(IK_10)
plot(IK_15)
plot(IK_exo, LineWidth=2)
title('STOOP: L5S1 Flex-Ext Angle')
legend('5kg', '10kg', '15kg')

%% ID
% [ST_5] = getMovementPhaseMoments(ST_5, 'ID');
% 
[ST_10] = getMovementPhaseMoments(ST_10, 'ID');

[ST_exo] = getMovementPhaseMoments(ST_exo, 'ID');

% 
% [ST_15] = getMovementPhaseMoments(ST_15, 'ID');
%% 
ID_5 = ST_5.cutMovements.ID.L5_S1_Flex_Ext_moment.Mean;

ID_10 = ST_10.cutMovements.ID.L5_S1_Flex_Ext_moment.Mean;

ID_15 = ST_15.cutMovements.ID.L5_S1_Flex_Ext_moment.Mean;

ID_exo = ST_exo.cutMovements.ID.L5_S1_Flex_Ext_moment.Mean;

figure
plot(ID_5);
hold on
plot(ID_10)
plot(ID_15)
plot(ID_exo, LineWidth=2)

title('STOOP: L5S1 Flex-Ext Moment')
legend('5kg', '10kg', '15kg')

%% JRF

FC_5 = ST_5.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.Mean/(9.81*ST_5.Info.subjMass);

[ST_10] = getMovementPhaseMoments(ST_10, 'JRA_EMG');
[ST_exo] = getMovementPhaseMoments(ST_exo, 'JRA_EMG');


FC_10 = ST_10.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.Mean/(9.81*ST_10.Info.subjMass);

FC_15 = ST_15.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.Mean/(9.81*ST_15.Info.subjMass);
FC_exo = ST_exo.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.Mean/(9.81*ST_exo.Info.subjMass);

figure
plot(FC_5);
hold on
plot(FC_10)
plot(FC_15)
plot(FC_exo, LineWidth=2)
title('STOOP: L5S1 Compressive Force')
legend('5kg', '10kg', '15kg')


