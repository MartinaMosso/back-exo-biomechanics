clear; close all; clc

trials = {'1', '3', '4','5', '6', '8','9', '11', '12', '16' ,'17', '18', '20','21',  '22', '23', '24', '25', '27', '28',  '31'} % sub005, five no exo
% trials = {'2', '3', '4', '6', '7', '8', '11', '12', '13', '14', '15', '17', '19', '20', '22', '23', '24', '26', '27', '28', '29', '30', '31'} % sub005, one no exo

sbj = 'SUB005';

for i=1:length(trials)
    filename = ['C:\Twente\IUVO\PHASE2\', sbj, '\', sbj, '_noExo_five', trials{i}, '_10.mat'];
    load(filename)

    figure
    plot(Datastr.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.rep1)

end
