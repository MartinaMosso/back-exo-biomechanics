% D.squat.t = linspace(0,100,101);       % opzionale; altrimenti lo deduce da N
clear; close all; clc

%% id

load("IDmean_10.mat");
load("IDstd_10.mat")

D.squat.noexo.mean = movmean(mean(ID_mean(:,:,1), 1)',15)'; % [1xN]
D.squat.noexo.std  = movmean(std(ID_mean(:,:,1), 0, 1)', 50);  % [1xN]
D.squat.exo.mean   = movmean(mean(ID_mean(:,:,2), 1)',15);   % [1xN]
D.squat.exo.std    = movmean(std(ID_mean(:,:,2), 0, 1)', 50);    % [1xN]

% === STOOP ===
% D.stoop.t = linspace(0,100,101);
D.stoop.noexo.mean = movmean(mean(ID_mean(:,:,3), 1)',15);
D.stoop.noexo.std  = movmean(std(ID_mean(:,:,3), 0, 1)', 50);
D.stoop.exo.mean   = movmean(mean(ID_mean(:,:,4), 1)',15);
D.stoop.exo.std    = movmean(std(ID_mean(:,:,4), 0, 1)', 50);

% === BILATERAL ===
% D.bilateral.t = linspace(0,100,101);
D.bilateral.noexo.mean = movmean(mean([ID_mean(1:2,:,5); ID_mean(4,:,5)], 1)',15); 
D.bilateral.noexo.std  = movmean(std([ID_mean(1:2,:,5); ID_mean(4,:,5)], 0, 1)', 50);
D.bilateral.exo.mean   = movmean(mean([ID_mean(1:2,:,6); ID_mean(4,:,6)], 1)',15);
D.bilateral.exo.std    = movmean(std([ID_mean(1:2,:,6); ID_mean(4,:,6)], 0, 1)', 50);

%%
load('FCmean_10.mat')
load('FCstd_10.mat')

load("IDmean_10.mat");
load("IDstd_10.mat")

C.squat.noexo.mean = movmean(mean(FC_mean(:,:,1), 1)',15)'; % [1xN]
C.squat.noexo.std  = movmean(std(FC_mean(:,:,1), 0, 1)', 50);  % [1xN]
C.squat.exo.mean   = movmean(mean(FC_mean(:,:,2), 1)',15);   % [1xN]
C.squat.exo.std    = movmean(std(FC_mean(:,:,2), 0, 1)', 50);    % [1xN]

% === STOOP ===
% D.stoop.t = linspace(0,100,101);
C.stoop.noexo.mean = movmean(mean(FC_mean(:,:,3), 1)',15);
C.stoop.noexo.std  = movmean(std(FC_mean(:,:,3), 0, 1)', 50);
C.stoop.exo.mean   = movmean(mean(FC_mean(:,:,4), 1)',15);
C.stoop.exo.std    = movmean(std(FC_mean(:,:,4), 0, 1)', 50);

% === BILATERAL ===
% D.bilateral.t = linspace(0,100,101);
C.bilateral.noexo.mean = movmean(mean([FC_mean(1:2,:,5); FC_mean(4,:,5)], 1)',15); 
C.bilateral.noexo.std  = movmean(std([FC_mean(1:2,:,5); FC_mean(4,:,5)], 0, 1)', 50);
C.bilateral.exo.mean   = movmean(mean([FC_mean(1:2,:,6); FC_mean(4,:,6)], 1)',15);
C.bilateral.exo.std    = movmean(std([FC_mean(1:2,:,6); FC_mean(4,:,6)], 0, 1)', 50);

% === CREA FIGURA ===
SUBPLOT_L5S1_MOMENTS(D,C, './fig/Fig_L5S1_Moments_COMP');