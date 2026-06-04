%% ADD IK AND ID

clear; close all; clc

%%

movement = {'SQ', 'ST', 'BL'};

sbj = {'SUB005', 'SUB006', 'SUB007', 'SUB008', 'SUB009', 'SUB010', 'SUB011', 'SUB012'};

condition = {'noExo', 'yesExo'};
% condition = {'yesExo'};


for j = 1:length(sbj)
    
    for t= 1:length(movement)

        for k = 1:length(condition)

            % load ID results from OS

            task_ID = strcat('ID_', condition{k}, '_', movement{t}, '_10.sto');

            file2import_ID = strcat('C:\Twente\IUVO\', sbj{j}, '\OS\DataFiles\ResultOS\', task_ID);

            ID = importdata(file2import_ID);

            % load IK results from OS

            task_IK = strcat(condition{k}, '_', movement{t}, '_10.mot');

            file2import_IK = strcat('C:\Twente\IUVO\', sbj{j}, '\OS\DataFiles\ResultOS\', task_IK);

            IK = readmatrix(file2import_IK, 'FileType', 'text', 'NumHeaderLines', 6);

            % load DataSTR
            file2import_datastr = ['C:\Twente\IUVO\', sbj{j}, '\DatastrMARTA\', sbj{j}, '_', condition{k}, '_', movement{t}, '_10.mat'];
            load(file2import_datastr);

            Datastr.Resample.IKAngData = IK(5:end,:);
            Datastr.Resample.IDTrqData = ID.data;

            file2save = ['C:\Twente\IUVO\', sbj{j}, '\Datastr\', sbj{j}, '_', condition{k}, '_', movement{t}, '_10.mat'];
            save(file2save, "Datastr")

        end
    end
end
