%% CHECK EXO FORCES - SQUAT and STOOP


clear; close all; clc

%% import

% task = {'noExo_BL_10', 'yesExo_BL_10'};
task = {'noExo_SQ_0', 'noExo_SQ_5', 'noExo_SQ_10', 'noExo_SQ_15', 'yesExo_SQ_10', 'noExo_ST_0', 'noExo_ST_5', 'noExo_ST_10', 'noExo_ST_15', 'yesExo_ST_10'};

sbj = {'SUB005', 'SUB006', 'SUB007', 'SUB008', 'SUB009', 'SUB010', 'SUB011', 'SUB012'};

%% exo torque stoop - squat
for s=1:length(sbj)
    load(['C:\Twente\IUVO\', sbj{s}, '\',  'SingleTorqueExo_SQ.mat'])
    squatTorque = coppia_interpolata_2D;
    load(['C:\Twente\IUVO\', sbj{s}, '\',  'SingleTorqueExo_ST.mat'])
    stoopTorque = coppia_interpolata_2D;
    max_ST_Torque(s)= max(stoopTorque);
    max_SQ_Torque(s)= max(squatTorque);
    if  max_ST_Torque(s) >30
        max_ST_Torque(s) = 30;

    end
    if  max_SQ_Torque(s) >30 
        max_SQ_Torque(s)=30;
    end
    figure
    plot(squatTorque)
    hold on
    plot(stoopTorque)
end


%% exo angle stoop - squat
for s=1:length(sbj)
    load(['C:\Twente\IUVO\', sbj{s}, '\',  'ExoAngle_SQ.mat'])
    squatAngle = theta_offset_2D;
    load(['C:\Twente\IUVO\', sbj{s}, '\',  'ExoAngle_ST.mat'])
    stoopAngle = theta_offset_2D;
      max_ST_angle(s)= max(stoopAngle);
    max_SQ_angle(s)= max(squatAngle);
    figure
    plot(squatAngle)
    hold on
    plot(stoopAngle)
end

%%
data = [max_SQ_Torque; max_ST_Torque ]'; % transpose to get 8 rows x 2 columns

% Plot
figure;
bar(data);
legend('Squat', 'Stoop');
xlabel('Subject');
ylabel('Max Value Torque');
title('Comparison of Max Values: Squat vs Stoop');

%%
angle = [max_SQ_angle; max_ST_angle ]'; % transpose to get 8 rows x 2 columns

% Plot
figure;
bar(angle);
legend('Squat', 'Stoop');
xlabel('Subject');
ylabel('Max Value Angle');
title('Comparison of Max Values: Squat vs Stoop');

%% F chest

for s=1:length(sbj)
    load(['C:\Twente\IUVO\', sbj{s}, '\', 'ExoForces', '\',  'Fchest_SQ_10.mat'])
    squatChest = F_trunk_3d;
    load(['C:\Twente\IUVO\', sbj{s}, '\',  'ExoForces', '\',  'Fchest_ST_10.mat'])
    stoopChest = F_trunk_3d;
      max_ST_chest(s)= max(stoopChest(:,3));
    max_SQ_chest(s)= max(squatChest(:,3));
    figure
    plot(squatChest)
    hold on
    plot(stoopChest)
end
chest = [max_SQ_chest; max_ST_chest ]'; % transpose to get 8 rows x 2 columns

% Plot
figure;
bar(chest);
legend('Squat', 'Stoop');
xlabel('Subject');
ylabel('Max Value Chest Force');
title('Comparison of Max Values: Squat vs Stoop');


%% F leg

for s=1:length(sbj)
    load(['C:\Twente\IUVO\', sbj{s}, '\', 'ExoForces', '\',  'FlegR_SQ_10.mat'])
    squatLeg = F_thigh_3dR;
    load(['C:\Twente\IUVO\', sbj{s}, '\',  'ExoForces', '\',  'FlegR_ST_10.mat'])
    stoopLeg = F_thigh_3dR;
    max_ST_leg(s)= max(stoopLeg(:,3));
    max_SQ_leg(s)= max(squatLeg(:,3));
    figure
    plot(squatLeg)
    hold on
    plot(stoopLeg)
end
leg = [max_SQ_leg; max_ST_leg ]'; % transpose to get 8 rows x 2 columns

% Plot
figure;
bar(leg);
legend('Squat', 'Stoop');
xlabel('Subject');
ylabel('Max Value Angle');
title('Comparison of Max Values: Squat vs Stoop');
