function [Datastr] = S15_CombineMVC(Datastr, MVCabd, MVCback, MVCcomb)
% gBMPDynUI MVCabd=1; MVCback = 1; MVCcomb=1;

% This function can be used to combine multiple MVC files into one file
% which is used as MVC file in module S16_extractMVC_withZeroEMG.m

% INPUT)
% Datastr: structure, with at least the fields
%     .Info
% MVCabd: trial name of the MVC recording of abdominal muscles
% MVCback: trial name of the MVC recording of back muscles
% MVCcomb: trial name of newly created structure to save both frequency and
% combined data of both MVC trials

% OUTPUT)
% MVCcomb datastruct, saved in the Qualisys data folder with
%   .Frequency
%   .Data

% Jan Willem Rook, 07-11-2023 (j.w.a.rook@student.utwente.nl)
%%

MVC_comb_path = [Datastr.Info.SubjRoot, '\Qualisys\' MVCcomb];

% Check if MVCcomb already exists
if isfile(MVC_comb_path)
     % File exists.
     return
else
     % File does not exist. Do stuff:

% Find struct MVCs in Qualisys folder
MVCabdFileName = [Datastr.Info.SubjRoot, '\Qualisys\' MVCabd];
MVCbackFileName = [Datastr.Info.SubjRoot, '\Qualisys\' MVCback];

% Extract data
MVCabdData = importdata(MVCabdFileName);
MVCbackData = importdata(MVCbackFileName);

% Check if frequency is the same
MVCabdFreq = MVCabdData.Analog.Frequency;
MVCbackFreq = MVCbackData.Analog.Frequency;

if MVCabdFreq == MVCbackFreq

% Create combined data struct with frequency and data
MVCcombinedData.Analog.Frequency = MVCabdFreq;

% Combine data
MVCcombinedData.Analog.Data = [MVCabdData.Analog.Data MVCbackData.Analog.Data];

% Save struct in Qualisys folder
save([Datastr.Info.SubjRoot, '\Qualisys\' MVCcomb], 'MVCcombinedData')

else
disp('Frequencies of MVC trials are not equal')

end

end
end


