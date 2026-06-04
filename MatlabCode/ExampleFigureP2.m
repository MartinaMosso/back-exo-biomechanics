%% figure P2 example

clear; close all; clc

%% laod
load('C:\Twente\IUVO\PHASE2\SUB005\noExo_one_segment.mat');

figure
plot(segment(10).lift)
hold on
plot([269 269], [-11 -2], '--r')
plot([458 458], [-11 -2], '--r')
plot([666 666], [-11 -2], '--r')


load('C:\Twente\IUVO\PHASE2\SUB005\SUB005_noExo_one28_10.mat');
figure;plot(Datastr.Resample.IDTrqData(:,18))

load('C:\Twente\IUVO\PHASE2\SUB005\SUB005_noExo_one29_10.mat');
figure;plot(Datastr.Resample.IDTrqData(:,18))

load('C:\Twente\IUVO\PHASE2\SUB005\SUB005_noExo_one30_10.mat');
figure;plot(Datastr.Resample.IDTrqData(:,18))

load('C:\Twente\IUVO\PHASE2\SUB005\SUB005_noExo_one31_10.mat');
figure;plot(Datastr.Resample.IDTrqData(:,18))
figure
plot(segment(10).torque)
plot([269 269], [-11 -2], '--r')
plot([458 458], [-11 -2], '--r')
plot([666 666], [-11 -2], '--r')


%% emg

load('C:\Twente\IUVO\PHASE2\SUB005\SUB005_noExo_one28_10.mat');
figure;plot(Datastr.Resample.NormEMG(:,3))

%% compressive forces

load('C:\Twente\IUVO\PHASE2\SUB005\SUB005_noExo_one28_10.mat')
figure; plot(Datastr.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.rep1)