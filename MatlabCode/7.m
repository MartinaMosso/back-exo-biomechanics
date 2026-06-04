%% COMPARE ID WITH DIFFERENT FORCE

clear; close all; clc

%% import file

IDall = importdata('C:\Twente\IUVO\SUB009\OS\DataFiles\ResultOS\ID_yesExo_SQ_10_all.sto');

IDchest = importdata('C:\Twente\IUVO\SUB009\OS\DataFiles\ResultOS\ID_yesExo_SQ_10_chest.sto');

IDleg = importdata('C:\Twente\IUVO\SUB009\OS\DataFiles\ResultOS\ID_yesExo_SQ_10_leg.sto');

IDPelvis = importdata('C:\Twente\IUVO\SUB009\OS\DataFiles\ResultOS\ID_yesExo_SQ_10_pelvis.sto');

IDchestLeg = importdata('C:\Twente\IUVO\SUB009\OS\DataFiles\ResultOS\ID_yesExo_SQ_10_chestLeg.sto');

IDzero = importdata('C:\Twente\IUVO\SUB009\OS\DataFiles\ResultOS\ID_yesExo_SQ_10.sto');

%% 

torqueAll = IDall.data(:,18);
torquechest = IDchest.data(:,18);
torqueleg = IDleg.data(:,18);
torquePelvis = IDPelvis.data(:,18);
torquechestLeg = IDchestLeg.data(:,18);
torquezero = IDzero.data(:,18);

%% 
figure
plot(torquezero)
hold on
plot(torqueAll)
plot(torquechest)
legend('zero', 'all', 'chest')

figure; hold on
plot(torquezero)
hold on
plot(torqueAll)
plot(torqueleg)
legend('zero', 'all', 'leg')


figure; hold on
plot(torquezero)
hold on
plot(torqueAll)
plot(torquePelvis)
legend('zero', 'all', 'pelvis')


figure; hold on
plot(torquezero)
hold on
plot(torqueAll)
plot(torquechestLeg)
legend('zero', 'all', 'chest+leg')
