%% SUBJECT 11

% CALIBRATION STTOP -SQUAT 0-5-10

clear; close all; clc

%% import data
sbj = 'C:\Twente\IUVO\SUB012\SUB012';
% squat

load([sbj, '_noExo_SQ_0.mat'])
SQ_0 = Datastr;

load([sbj, '_noExo_SQ_5.mat'])
SQ_5 = Datastr;

load([sbj, '_noExo_SQ_10.mat'])
SQ_10 = Datastr;

load([sbj, '_noExo_SQ_15.mat'])
SQ_15 = Datastr;

load([sbj, '_yesExo_SQ_10.mat'])
SQ_exo = Datastr;

% stoop

load([sbj, '_noExo_ST_0.mat'])
ST_0 = Datastr;

load([sbj, '_noExo_ST_5.mat'])
ST_5 = Datastr;

load([sbj, '_noExo_ST_10.mat'])
ST_10 = Datastr;

load([sbj, '_noExo_ST_15.mat'])
ST_15 = Datastr;

load([sbj, '_yesExo_ST_10.mat'])
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


IK_0_SQ_std = SQ_0.cutMovements.IK.L5_S1_Flex_Ext_moment.Std;

IK_5_SQ_std  = SQ_5.cutMovements.IK.L5_S1_Flex_Ext_moment.Std;

IK_10_SQ_std  = SQ_10.cutMovements.IK.L5_S1_Flex_Ext_moment.Std;

IK_15_SQ_std  = SQ_15.cutMovements.IK.L5_S1_Flex_Ext_moment.Std;

IK_exo_SQ_std  = SQ_exo.cutMovements.IK.L5_S1_Flex_Ext_moment.Std;


IK_0_ST_std  = ST_0.cutMovements.IK.L5_S1_Flex_Ext_moment.Std;

IK_5_ST_std  = ST_5.cutMovements.IK.L5_S1_Flex_Ext_moment.Std;

IK_10_ST_std  = ST_10.cutMovements.IK.L5_S1_Flex_Ext_moment.Std;

IK_15_ST_std  = ST_15.cutMovements.IK.L5_S1_Flex_Ext_moment.Std;

IK_exo_ST_std  = ST_exo.cutMovements.IK.L5_S1_Flex_Ext_moment.Std;



x = 1:length(IK_0_SQ); % adatta x ai tuoi dati

figure
fill([x fliplr(x)], [IK_0_SQ+IK_0_SQ_std fliplr(IK_0_SQ-IK_0_SQ_std)], [0.9 0.9 0.9],'FaceAlpha', 0.5, 'EdgeColor', 'none');
hold on; grid on
plot(IK_0_SQ, LineWidth=2)

fill([x fliplr(x)], [IK_5_SQ+IK_5_SQ_std fliplr(IK_5_SQ-IK_5_SQ_std)], [0.9 0.9 0.9],'FaceAlpha', 0.5, 'EdgeColor', 'none');
plot(IK_5_SQ, LineWidth=2)

fill([x fliplr(x)], [IK_10_SQ+IK_10_SQ_std fliplr(IK_10_SQ-IK_10_SQ_std)], [0.9 0.9 0.9],'FaceAlpha', 0.5, 'EdgeColor', 'none');
plot(IK_10_SQ, LineWidth=2)

fill([x fliplr(x)], [IK_15_SQ+IK_15_SQ_std fliplr(IK_15_SQ-IK_15_SQ_std)], [0.9 0.9 0.9],'FaceAlpha', 0.5, 'EdgeColor', 'none');
plot(IK_15_SQ, LineWidth=2)

fill([x fliplr(x)], [IK_exo_SQ+IK_exo_SQ_std fliplr(IK_exo_SQ-IK_exo_SQ_std)], [0.9 0.9 0.9],'FaceAlpha', 0.5, 'EdgeColor', 'none');
plot(IK_exo_SQ, '--k', LineWidth=2)

title('SQUAT: L5S1 Flex-Ext Angle')
legend('','0kg', '', '5kg', '', '10kg','',  '15kg', '', 'exo')
xlabel('Movement Cycle')
ylabel('FLex-Ext Anlge [°]')

figure
fill([x fliplr(x)], [IK_0_ST+IK_0_ST_std fliplr(IK_0_ST-IK_0_ST_std)], [0.9 0.9 0.9],'FaceAlpha', 0.5, 'EdgeColor', 'none');
hold on; grid on
plot(IK_0_ST,LineWidth=2);

fill([x fliplr(x)], [IK_5_ST+IK_5_ST_std fliplr(IK_5_ST-IK_5_ST_std)], [0.9 0.9 0.9],'FaceAlpha', 0.5, 'EdgeColor', 'none');
plot(IK_5_ST, LineWidth=2)

fill([x fliplr(x)], [IK_10_ST+IK_10_ST_std fliplr(IK_10_ST-IK_10_ST_std)], [0.9 0.9 0.9],'FaceAlpha', 0.5, 'EdgeColor', 'none');
plot(IK_10_ST, LineWidth=2)

fill([x fliplr(x)], [IK_15_ST+IK_15_ST_std fliplr(IK_15_ST-IK_15_ST_std)], [0.9 0.9 0.9],'FaceAlpha', 0.5, 'EdgeColor', 'none');
plot(IK_15_ST, LineWidth=2)

fill([x fliplr(x)], [IK_exo_ST+IK_exo_ST_std fliplr(IK_exo_ST-IK_exo_ST_std)], [0.9 0.9 0.9],'FaceAlpha', 0.5, 'EdgeColor', 'none');
plot(IK_exo_ST,'--k', LineWidth=2)

title('STOOP: L5S1 Flex-Ext Angle')
legend('','0kg', '', '5kg', '', '10kg','',  '15kg', '', 'exo')
xlabel('Movement Cycle')
ylabel('FLex-Ext Anlge [°]')

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


ID_0_SQ_std = SQ_0.cutMovements.ID.L5_S1_Flex_Ext_moment.Std;

ID_5_SQ_std  = SQ_5.cutMovements.ID.L5_S1_Flex_Ext_moment.Std;

ID_10_SQ_std  = SQ_10.cutMovements.ID.L5_S1_Flex_Ext_moment.Std;

ID_15_SQ_std  = SQ_15.cutMovements.ID.L5_S1_Flex_Ext_moment.Std;

ID_exo_SQ_std  = SQ_exo.cutMovements.ID.L5_S1_Flex_Ext_moment.Std;


ID_0_ST_std  = ST_0.cutMovements.ID.L5_S1_Flex_Ext_moment.Std;

ID_5_ST_std  = ST_5.cutMovements.ID.L5_S1_Flex_Ext_moment.Std;

ID_10_ST_std  = ST_10.cutMovements.ID.L5_S1_Flex_Ext_moment.Std;

ID_15_ST_std  = ST_15.cutMovements.ID.L5_S1_Flex_Ext_moment.Std;

ID_exo_ST_std  = ST_exo.cutMovements.ID.L5_S1_Flex_Ext_moment.Std;



x = 1:length(ID_0_SQ); % adatta x ai tuoi dati

figure
hold on; grid on
fill([x fliplr(x)], [ID_0_SQ+ID_0_SQ_std fliplr(ID_0_SQ-ID_0_SQ_std)], [0.9 0.9 0.9],'FaceAlpha', 0.5, 'EdgeColor', 'none');
plot(ID_0_SQ, LineWidth=2)

fill([x fliplr(x)], [ID_5_SQ+ID_5_SQ_std fliplr(ID_5_SQ-ID_5_SQ_std)], [0.9 0.9 0.9],'FaceAlpha', 0.5, 'EdgeColor', 'none');
plot(ID_5_SQ, LineWidth=2)

fill([x fliplr(x)], [ID_10_SQ+ID_10_SQ_std fliplr(ID_10_SQ-ID_10_SQ_std)], [0.9 0.9 0.9],'FaceAlpha', 0.5, 'EdgeColor', 'none');
plot(ID_10_SQ, LineWidth=2)

fill([x fliplr(x)], [ID_15_SQ+ID_15_SQ_std fliplr(ID_15_SQ-ID_15_SQ_std)], [0.9 0.9 0.9],'FaceAlpha', 0.5, 'EdgeColor', 'none');
plot(ID_15_SQ, LineWidth=2)

fill([x fliplr(x)], [ID_exo_SQ+ID_exo_SQ_std fliplr(ID_exo_SQ-ID_exo_SQ_std)], [0.9 0.9 0.9],'FaceAlpha', 0.5, 'EdgeColor', 'none');
plot(ID_exo_SQ, '--k', LineWidth=2)

title('SQUAT: L5S1 Flex-Ext Moment')
legend('','0kg', '', '5kg', '', '10kg','',  '15kg', '', 'exo')
xlabel('Movement Cycle')
ylabel('FLex-Ext Moment [Nm]')

figure
hold on; grid on
fill([x fliplr(x)], [ID_0_ST+ID_0_ST_std fliplr(ID_0_ST-ID_0_ST_std)], [0.9 0.9 0.9],'FaceAlpha', 0.5, 'EdgeColor', 'none');
plot(ID_0_ST,LineWidth=2);

fill([x fliplr(x)], [ID_5_ST+ID_5_ST_std fliplr(ID_5_ST-ID_5_ST_std)], [0.9 0.9 0.9],'FaceAlpha', 0.5, 'EdgeColor', 'none');
plot(ID_5_ST, LineWidth=2)

fill([x fliplr(x)], [ID_10_ST+ID_10_ST_std fliplr(ID_10_ST-ID_10_ST_std)], [0.9 0.9 0.9],'FaceAlpha', 0.5, 'EdgeColor', 'none');
plot(ID_10_ST, LineWidth=2)

fill([x fliplr(x)], [ID_15_ST+ID_15_ST_std fliplr(ID_15_ST-ID_15_ST_std)], [0.9 0.9 0.9],'FaceAlpha', 0.5, 'EdgeColor', 'none');
plot(ID_15_ST, LineWidth=2)

fill([x fliplr(x)], [ID_exo_ST+ID_exo_ST_std fliplr(ID_exo_ST-ID_exo_ST_std)], [0.9 0.9 0.9],'FaceAlpha', 0.5, 'EdgeColor', 'none');
plot(ID_exo_ST,'--k', LineWidth=2)

title('STOOP: L5S1 Flex-Ext Moment')
legend('', '0kg', '', '5kg', '', '10kg','',  '15kg', '', 'exo')
xlabel('Movement Cycle')
ylabel('FLex-Ext Moment [Nm]')



%% FC
[SQ_0] = getMovementPhaseMoments(SQ_0, 'JRA_EMG');
[SQ_5] = getMovementPhaseMoments(SQ_5, 'JRA_EMG');
[SQ_10] = getMovementPhaseMoments(SQ_10, 'JRA_EMG');
[SQ_15] = getMovementPhaseMoments(SQ_15, 'JRA_EMG');
[SQ_exo] = getMovementPhaseMoments(SQ_exo, 'JRA_EMG');

[ST_0] = getMovementPhaseMoments(ST_0, 'JRA_EMG');
[ST_5] = getMovementPhaseMoments(ST_5, 'JRA_EMG');
[ST_10] = getMovementPhaseMoments(ST_10, 'JRA_EMG');
[ST_15] = getMovementPhaseMoments(ST_15, 'JRA_EMG');
[ST_exo] = getMovementPhaseMoments(ST_exo, 'JRA_EMG');

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
plot(movmean(FC_0_SQ, 25), LineWidth=2);
hold on; grid on
plot(movmean(FC_5_SQ, 25), LineWidth=2)
plot(movmean(FC_10_SQ,25), LineWidth=2)
plot(movmean(FC_15_SQ, 25), LineWidth=2)
plot(FC_exo_SQ, '--k', LineWidth=2)
title('SQUAT: L5S1 Compressive Force')
legend('0kg', '5kg', '10kg', '15kg', 'exo')
xlabel('Movement Cycle')
ylabel('L5S1 Compressive Force')

figure
plot(movmean(FC_0_ST,25), LineWidth=2);
hold on; grid on
plot(movmean(FC_5_ST, 25), LineWidth=2)
plot(movmean(FC_10_ST,25), LineWidth=2)
plot(movmean(FC_15_ST, 25), LineWidth=2)
plot(FC_exo_ST, '--k', LineWidth=2)
title('STOOP: L5S1 Compressive Force')
legend('0kg', '5kg', '10kg', '15kg', 'exo')
xlabel('Movement Cycle')
ylabel('L5S1 Compressive Force')

%%
figure
tiledlayout(1,3)
nexttile
plot(IK_0_SQ, LineWidth=2)
hold on; grid on
plot(IK_5_SQ, LineWidth=2)
plot(IK_10_SQ, LineWidth=2)
plot(IK_15_SQ, LineWidth=2)
plot(IK_exo_SQ, '--k', LineWidth=2)
title('SQUAT: L5S1 Flex-Ext Angle')
legend('0kg', '5kg', '10kg', '15kg', 'exo')
xlabel('Movement Cycle')
ylabel('FLex-Ext Anlge [°]')

nexttile
plot(ID_0_SQ, LineWidth=2)
hold on; grid on
plot(ID_5_SQ, LineWidth=2)
plot(ID_10_SQ, LineWidth=2)
plot(ID_15_SQ, LineWidth=2)
plot(ID_exo_SQ, '--k', LineWidth=2)
title('SQUAT: L5S1 Flex-Ext Moment')
legend('0kg', '5kg', '10kg', '15kg', 'exo')
xlabel('Movement Cycle')
ylabel('Flex-Ext Moment [Nm]')

nexttile
plot(movmean(FC_0_SQ, 30), LineWidth=2);
hold on; grid on
plot(movmean(FC_5_SQ, 30), LineWidth=2)
plot(movmean(FC_10_SQ,30), LineWidth=2)
plot(movmean(FC_15_SQ, 30), LineWidth=2)
plot(FC_exo_SQ, '--k', LineWidth=2)
title('SQUAT: L5S1 Compressive Force')
legend('0kg', '5kg', '10kg', '15kg', 'exo')
xlabel('Movement Cycle')
ylabel('L5S1 Compressive Force')

%% 
figure
tiledlayout(1,3)
nexttile
plot(IK_0_ST,LineWidth=2);
hold on; grid on
plot(IK_5_ST, LineWidth=2)
plot(IK_10_ST, LineWidth=2)
plot(IK_15_ST, LineWidth=2)
plot(IK_exo_ST,'--k', LineWidth=2)
title('STOOP: L5S1 Flex-Ext Angle')
legend('0kg', '5kg', '10kg', '15kg', 'exo')
xlabel('Movement Cycle')
ylabel('FLex-Ext Anlge [°]')

nexttile
plot(ID_0_ST,LineWidth=2);
hold on; grid on
plot(ID_5_ST, LineWidth=2)
plot(ID_10_ST, LineWidth=2)
plot(ID_15_ST, LineWidth=2)
plot(ID_exo_ST,'--k', LineWidth=2)
title('STOOP: L5S1 Flex-Ext Angle')
legend('0kg', '5kg', '10kg', '15kg', 'exo')
xlabel('Movement Cycle')
ylabel('Flex-Ext Moment [Nm]')

nexttile
plot(movmean(FC_0_ST,30), LineWidth=2);
hold on; grid on
plot(movmean(FC_5_ST, 25), LineWidth=2)
plot(FC_10_ST, LineWidth=2)
plot(movmean(FC_15_ST, 30), LineWidth=2)
plot(FC_exo_ST, '--k', LineWidth=2)
title('STOOP: L5S1 Compressive Force')
legend('0kg', '5kg', '10kg', '15kg', 'exo')
xlabel('Movement Cycle')
ylabel('L5S1 Compressive Force')