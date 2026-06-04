%% SUBJECT 11

% CALIBRATION STTOP -SQUAT 0-5-10

clear; clc

%% import data

% squat

load('C:\Twente\IUVO\SUB011\SUB011_noExo_SQ_0.mat')
SQ_0 = Datastr;

load('C:\Twente\IUVO\SUB011\SUB011_noExo_SQ_5.mat')
SQ_5 = Datastr;

load('C:\Twente\IUVO\SUB011\SUB011_noExo_SQ_10.mat')
SQ_10 = Datastr;

load('C:\Twente\IUVO\SUB011\SUB011_noExo_SQ_15.mat')
SQ_15 = Datastr;

load('C:\Twente\IUVO\SUB011\SUB011_yesExo_SQ_10.mat')
SQ_exo = Datastr;

% stoop

load('C:\Twente\IUVO\SUB011\SUB011_noExo_ST_0.mat')
ST_0 = Datastr;

load('C:\Twente\IUVO\SUB011\SUB011_noExo_ST_5.mat')
ST_5 = Datastr;

load('C:\Twente\IUVO\SUB011\SUB011_noExo_ST_10.mat')
ST_10 = Datastr;

load('C:\Twente\IUVO\SUB011\SUB011_noExo_ST_15.mat')
ST_15 = Datastr;

load('C:\Twente\IUVO\SUB011\SUB011_yesExo_ST_10.mat')
ST_exo = Datastr;

%% cut movements IK

[SQ_0] = getMovementPhaseMoments(SQ_0, 'IK');

[SQ_5] = getMovementPhaseMoments(SQ_5, 'IK');

[SQ_10] = getMovementPhaseMoments(SQ_10, 'IK');

[SQ_15] = getMovementPhaseMoments(SQ_15, 'IK');

[SQ_exo] = getMovementPhaseMoments(SQ_exo, 'IK');

[ST_0] = getMovementPhaseMoments(ST_0, 'IK');

[ST_5] = getMovementPhaseMoments(ST_5, 'IK');

[ST_10] = getMovementPhaseMoments(ST_10, 'IK');

[ST_15] = getMovementPhaseMoments(ST_15, 'IK');

[ST_exo] = getMovementPhaseMoments(ST_exo, 'IK');



IK_0_SQ = SQ_0.cutMovements.IK.L5_S1_Flex_Ext_moment.Mean;

IK_5_SQ  = SQ_5.cutMovements.IK.L5_S1_Flex_Ext_moment.Mean;

IK_10_SQ  = SQ_10.cutMovements.IK.L5_S1_Flex_Ext_moment.Mean;

IK_15_SQ  = SQ_15.cutMovements.IK.L5_S1_Flex_Ext_moment.Mean;

IK_exo_SQ  = SQ_exo.cutMovements.IK.L5_S1_Flex_Ext_moment.Mean;


IK_0_ST  = ST_0.cutMovements.IK.L5_S1_Flex_Ext_moment.Mean;

IK_5_ST  = ST_5.cutMovements.IK.L5_S1_Flex_Ext_moment.Mean;

IK_10_ST  = ST_10.cutMovements.IK.L5_S1_Flex_Ext_moment.Mean;

IK_15_ST  = ST_15.cutMovements.IK.L5_S1_Flex_Ext_moment.Mean;

IK_exo_ST  = ST_exo.cutMovements.IK.L5_S1_Flex_Ext_moment.Mean;


figure
plot(IK_0_SQ)
hold on
plot(IK_5_SQ)
plot(IK_10_SQ)
plot(IK_15_SQ)
plot(IK_exo_SQ)
title('SQUAT: L5S1 Flex-Ext Angle')
legend('0kg', '5kg', '10kg', '15kg', 'exo')

figure
plot(IK_0_ST);
hold on
plot(IK_5_ST)
plot(IK_10_ST)
plot(IK_15_ST)
plot(IK_exo_ST)
title('STOOP: L5S1 Flex-Ext Angle')
legend('0kg', '5kg', '10kg', '15kg', 'exo')

%% ID

[SQ_0] = getMovementPhaseMoments(SQ_0, 'ID');

[SQ_5] = getMovementPhaseMoments(SQ_5, 'ID');

[SQ_10] = getMovementPhaseMoments(SQ_10, 'ID');

[SQ_15] = getMovementPhaseMoments(SQ_15, 'ID');

[SQ_exo] = getMovementPhaseMoments(SQ_exo, 'ID');


[ST_0] = getMovementPhaseMoments(ST_0, 'ID');

[ST_5] = getMovementPhaseMoments(ST_5, 'ID');

[ST_10] = getMovementPhaseMoments(ST_10, 'ID');

[ST_15] = getMovementPhaseMoments(ST_15, 'ID');

[ST_exo] = getMovementPhaseMoments(ST_exo, 'ID');

%

ID_0_SQ = SQ_0.cutMovements.ID.L5_S1_Flex_Ext_moment.Mean;

ID_5_SQ = SQ_5.cutMovements.ID.L5_S1_Flex_Ext_moment.Mean;

ID_10_SQ = SQ_10.cutMovements.ID.L5_S1_Flex_Ext_moment.Mean;

ID_15_SQ = SQ_15.cutMovements.ID.L5_S1_Flex_Ext_moment.Mean;

ID_exo_SQ = SQ_exo.cutMovements.ID.L5_S1_Flex_Ext_moment.Mean;


ID_0_ST = ST_0.cutMovements.ID.L5_S1_Flex_Ext_moment.Mean;

ID_5_ST = ST_5.cutMovements.ID.L5_S1_Flex_Ext_moment.Mean;

ID_10_ST = ST_10.cutMovements.ID.L5_S1_Flex_Ext_moment.Mean;

ID_15_ST = ST_15.cutMovements.ID.L5_S1_Flex_Ext_moment.Mean;

ID_exo_ST = ST_exo.cutMovements.ID.L5_S1_Flex_Ext_moment.Mean;




figure
plot(ID_0_SQ);
hold on
plot(ID_5_SQ)
plot(ID_10_SQ)
plot(ID_15_SQ)
plot(ID_exo_SQ)
title('SQUAT: L5S1 Flex-Ext Moment')
legend('0kg', '5kg', '10kg', '15kg', 'exo')

figure
plot(ID_0_ST);
hold on
plot(ID_5_ST)
plot(ID_10_ST)
plot(ID_15_ST)
plot(ID_exo_ST)
title('STOOP: L5S1 Flex-Ext Moment')
legend('0kg', '5kg', '10kg', '15kg', 'exo')

%% FC
[SQ_exo] = getMovementPhaseMoments(SQ_exo, 'JRA_EMG');

FC_0_SQ = SQ_0.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.Mean/(9.81*SQ_5.Info.subjMass);
FC_5_SQ = SQ_5.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.Mean/(9.81*SQ_5.Info.subjMass);
FC_10_SQ = SQ_10.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.Mean/(9.81*SQ_5.Info.subjMass);
FC_15_SQ = SQ_15.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.Mean/(9.81*SQ_5.Info.subjMass);
FC_exo_SQ = SQ_exo.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.Mean/(9.81*SQ_5.Info.subjMass);

FC_0_ST = ST_0.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.Mean/(9.81*ST_5.Info.subjMass);
FC_5_ST = ST_5.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.Mean/(9.81*ST_5.Info.subjMass);
FC_10_ST = ST_10.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.Mean/(9.81*ST_5.Info.subjMass);
FC_15_ST = ST_15.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.Mean/(9.81*ST_5.Info.subjMass);
FC_exo_ST = ST_exo.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.Mean/(9.81*SQ_5.Info.subjMass);

figure
plot(movmean(FC_0_SQ, 30));
hold on
plot(movmean(FC_5_SQ, 30))
plot(movmean(FC_10_SQ,30))
plot(movmean(FC_15_SQ, 30))
plot(FC_exo_SQ)
title('SQUAT: L5S1 Compressive Force')
legend('0kg', '5kg', '10kg', '15kg', 'exo')

figure
plot(movmean(FC_0_ST,30));
hold on
plot(FC_5_ST)
plot(FC_10_ST)
plot(movmean(FC_15_ST, 30))
plot(FC_exo_ST)
title('STOOP: L5S1 Compressive Force')
legend('0kg', '5kg', '10kg', '15kg', 'exo')


