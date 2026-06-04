%% moment arm

clear; close all; clc

%% import data
% load('C:\Twente\IUVO\SUB011\SUB011_noExo_SQ_0.mat')
% SQ_0 = Datastr;
% 
% load('C:\Twente\IUVO\SUB011\SUB011_noExo_SQ_5.mat')
% SQ_5 = Datastr;
% 
% load('C:\Twente\IUVO\SUB011\SUB011_noExo_ST_0.mat')
% SQ_10 = Datastr;
% 
% load('C:\Twente\IUVO\SUB011\SUB011_noExo_SQ_15.mat')
% SQ_15 = Datastr;
% 
% load('C:\Twente\IUVO\SUB011\SUB011_yesExo_SQ_10.mat')
% SQ_exo = Datastr;

task = {'noExo_SQ_0', 'noExo_SQ_5', 'noExo_SQ_10', 'noExo_SQ_15', 'yesExo_SQ_10', 'noExo_ST_0', 'noExo_ST_5', 'noExo_ST_10', 'noExo_ST_15', 'yesExo_ST_10'};
%%

for t = 1:length(task)

    load(['C:\Twente\IUVO\SUB011\SUB011_', task{t}, '.mat'])

    %% torque
    Datastr = getMovementPhaseMoments(Datastr, 'ID');


    ID(t,:) = Datastr.cutMovements.ID.L5_S1_Flex_Ext_moment.Mean;

% ID_5_SQ = SQ_5.cutMovements.ID.L5_S1_Flex_Ext_moment.Mean;
% 
% ID_10_SQ = SQ_10.cutMovements.ID.L5_S1_Flex_Ext_moment.Mean;
% 
% ID_15_SQ = SQ_15.cutMovements.ID.L5_S1_Flex_Ext_moment.Mean;
% 
% ID_exo_SQ = SQ_exo.cutMovements.ID.L5_S1_Flex_Ext_moment.Mean;

%% box
BX1 = squeeze(Datastr.Marker.MarkerData(find(strcmp(Datastr.Marker.DataLabel, 'BX1')), :, :));
BX2 = squeeze(Datastr.Marker.MarkerData(find(strcmp(Datastr.Marker.DataLabel, 'BX2')), :, :));
BX3 = squeeze(Datastr.Marker.MarkerData(find(strcmp(Datastr.Marker.DataLabel, 'BX3')), :, :));
BX4 = squeeze(Datastr.Marker.MarkerData(find(strcmp(Datastr.Marker.DataLabel, 'BX4')), :, :));

x_box = (BX1(1,:)+BX2(1,:)+BX3(1,:)+BX4(1,:))/4;
z_box = (BX1(3,:)+BX2(3,:)+BX3(3,:)+BX4(3,:))/4;

% figure; plot(x_box); hold on; plot(z_box);

%% pelvis

P1 = squeeze(Datastr.Marker.MarkerData(find(strcmp(Datastr.Marker.DataLabel, 'RASI')), :, :));
P2 = squeeze(Datastr.Marker.MarkerData(find(strcmp(Datastr.Marker.DataLabel, 'LASI')), :, :));
P3 = squeeze(Datastr.Marker.MarkerData(find(strcmp(Datastr.Marker.DataLabel, 'RPSI')), :, :));
P4 = squeeze(Datastr.Marker.MarkerData(find(strcmp(Datastr.Marker.DataLabel, 'LPSI')), :, :));

x_pelvi = (P1(1,:)+P2(1,:)+P3(1,:)+P4(1,:))/4;
z_pelvi = (P1(3,:)+P2(3,:)+P3(3,:)+P4(3,:))/4;

% plot(x_pelvi); plot(z_pelvi);
% legend('x-box', 'z-box', 'x-pelvi', 'z-pelvi')

%% distance

for i= 1:length(z_pelvi)
    dist(t, i)= sqrt((x_pelvi(:,i)-x_box(:,i))^2+(z_pelvi(:,i)-z_box(:,i))^2);
end
figure; plot(dist(t,:))
title(task(t))
end
%%
figure
tiledlayout(3,2)

nexttile
plot(dist(1,:)); hold on ; plot(dist(6,:))
title('0kg')

nexttile
plot(dist(2,:)); hold on ; plot(dist(7,:))
title('5kg')

nexttile
plot(dist(3,:)); hold on ; plot(dist(8,:))
title('10kg')

nexttile
plot(dist(4,:)); hold on ; plot(dist(9,:))
title('15kg')

nexttile
plot(dist(5,:)); hold on ; plot(dist(10,:))
title('exo 10kg')

%% figure
tiledlayout(3,2)

nexttile
plot(ID(1,:)); hold on ; plot(ID(6,:))
title('0kg')

nexttile
plot(ID(2,:)); hold on ; plot(ID(7,:))
title('5kg')

nexttile
plot(ID(3,:)); hold on ; plot(ID(8,:))
title('10kg')

nexttile
plot(ID(4,:)); hold on ; plot(ID(9,:))
title('15kg')

nexttile
plot(ID(5,:)); hold on ; plot(ID(10,:))
title('exo 10kg')