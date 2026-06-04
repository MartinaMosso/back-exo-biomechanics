%% COMPARE TORQUE L5S1 OF OS AND CEINMS

clear; close all; clc

%% select the conditions

movement = {'SQ', 'ST', 'BL'};

sbj = {'SUB005', 'SUB006', 'SUB007', 'SUB008', 'SUB009', 'SUB010', 'SUB011', 'SUB012'};

condition = {'noExo', 'yesExo'};

%% import data from os and from CEINSM


for t= 1:2% length(movement)

    for j = 7:7 %1:length(sbj)

        for k = 1:1%length(condition)

            % file OS
            task_OS = strcat(sbj{j},  condition{k}, '_', movement{t}, '_10ID.sto');
            
            file2import = strcat('C:\Twente\IUVO\', sbj{j}, '\OS\DataFiles\ResultOS\', task_OS);

            ID_OS = importdata(file2import);

            % file CEINSM
            task_CEINSM = strcat(sbj{j},  condition{k}, '_', movement{t}, '_10\torques.sto');

            file2import_CEINMS =  strcat('C:\Twente\IUVO\', sbj{j}, '\CEINMS\execution\OP\EMG\', task_CEINSM);

            ID_CEINMS = importdata(file2import_CEINMS);
            fs = 50;  % Frequenza di campionamento (Hz)
            fc = 6;     % Frequenza di taglio (Hz)
            order = 4;  % Ordine del filtro

            % Creazione del filtro Butterworth
            [b, a] = butter(order, fc/(fs/2), 'low');

            % Applicazione del filtro al segnale
            L5S1Trq = filtfilt(b, a, ID_CEINMS.data(:,2));
            figure
            plot(ID_OS.data(:,18))
            hold on
            plot(L5S1Trq)
            title(movement{t})
        end
    end
end
