%% compare Output of CEINMS with different calib method

clear; close all; clc;

elencoTrial = {'noExo_SQ_10', 'noExo_ST_10', 'noExo_BL_10', 'yesExo_SQ_10', 'yesExo_ST_10', 'yesExo_BL_10'};

sbj = {'SUB005', 'SUB006', 'SUB007', 'SUB008', 'SUB009', 'SUB010', 'SUB011', 'SUB012'};



%% ID: L5-S1 FLex-Ext Torque

for s = 2:2%length(sbj)
    for t = 2:2%length(elencoTrial)
        file_CEINMS = ['C:\Twente\IUVO\', sbj{s}, '\CEINMS\execution\OP\EMG\', sbj{s}, elencoTrial{t}, '\', 'Torques.sto'];
        ID_ceinms_Call = importdata(file_CEINMS);
        ID_ceinms_Call = ID_ceinms_Call.data(:,2);

            file_CEINMS_y = ['C:\Twente\IUVO\', sbj{s}, '\CEINMS\execution\OP\EMG\', sbj{s}, elencoTrial{t+3}, '\', 'Torques.sto'];
        ID_ceinms_Call_y  = importdata(file_CEINMS_y );
        ID_ceinms_Call_y  = ID_ceinms_Call_y .data(:,2);

        %    file_CEINMS = ['C:\Twente\IUVO\SUB009_OK\CEINMS\execution\OP\EMG\SUB009noExo_ST_10\', 'Torques.sto'];
        % ID_ceinms = importdata(file_CEINMS);
        % ID_ceinms = ID_ceinms.data(:,2);

     file_OS =  ['C:\Twente\IUVO\', sbj{s}, '\OS\DataFiles\ResultOS\',sbj{s}, elencoTrial{t}, 'ID.sto'];
        ID_OS = importdata(file_OS);
        ID_OS = ID_OS.data(:,18);


        file_OS_y =  ['C:\Twente\IUVO\', sbj{s}, '\OS\DataFiles\ResultOS\',sbj{s}, elencoTrial{t+3}, 'ID.sto'];
        ID_OS_y = importdata(file_OS_y);
        ID_OS_y = ID_OS_y.data(:,18);

        figure
        plot(ID_OS)
        hold on; plot(ID_ceinms_Call+11)
        % plot(ID_ceinms)
        legend('OS', 'CEINMS OLD', 'CEINMS NEW')
        title([sbj{s}, '-', elencoTrial{t}])

           figure
        plot(ID_OS_y)
        hold on; plot(ID_ceinms_Call_y+16)
        % plot(ID_ceinms)
        legend('OS', 'CEINMS')
        title([sbj{s}, '-', elencoTrial{t+3}])
    end

    close all
end

%% Compressive Forces

for s = 1:length(sbj)
    for t = 1:length(elencoTrial)
        file_CEINMS = ['C:\Twente\IUVO\', sbj{s}, '\CEINMS\execution\OP\EMG\', sbj{s}, elencoTrial{t}, '\', 'Torques.sto'];
        ID_ceinms = importdata(file_CEINMS);
        ID_ceinms = ID_ceinms.data(:,2);

        file_OS =  ['C:\Twente\IUVO\', sbj{s}, '\OS\DataFiles\',sbj{s}, elencoTrial{t}, 'EMG_JointReaction_ReactionLoads.sto'];
        ID_OS = importdata(file_OS);
        ID_OS = ID_OS.data(:,3);

        figure
        plot(ID_OS)
        hold on; plot(ID_ceinms)
        legend('OS', 'CEINMS')
        title([sbj{s}, '-', elencoTrial{t}])
    end

    close all
end

%%  fiber length

for s = 5:5%length(sbj)
    for t = 2:2%length(elencoTrial)
        file_CEINMS = ['C:\Twente\IUVO\', sbj{s}, '\CEINMS\execution\OP\EMG\', sbj{s}, elencoTrial{t}, '\', 'FiberLenghts.sto'];
        file_CEINMS_plus =  ['C:\Twente\IUVO\', sbj{s}, '\CEINMS\execution\OP\EMG\', sbj{s}, elencoTrial{t}, '\', 'NormFiberLengths.sto'];
        length_ceinms = importdata(file_CEINMS);
        l_ceinms = length_ceinms.data(:,2);
        length_norm = importdata(file_CEINMS_plus);
        l_norm = length_norm.data(:,2);

        % 
        % file_CEINMS = ['C:\Twente\IUVO\SUB009_OK\CEINMS\execution\OP\EMG\SUB009noExo_SQ_10\', 'FiberLenghts.sto'];
        % ID_ceinms = importdata(file_CEINMS);
        % ID_ceinms = ID_ceinms.data(:,2);
        
        if s >5
             file_OS =  ['C:\Twente\IUVO\', sbj{s}, '\OS\muscleAnalysis\ResultsOS\',sbj{s}, elencoTrial{t}, '_MuscleAnalysis_Length.sto'];
        else
             file_OS =  ['C:\Twente\IUVO\', sbj{s}, '\OS\muscleAnalysis\ResultsOS\',sbj{s}, elencoTrial{t}, '_Length.sto'];
              % file_OS =  ['C:\Twente\IUVO\', sbj{s}, '\OS\muscleAnalysis\ResultsOS\',sbj{s}, elencoTrial{t}, '_NormalizedFiberLength.sto'];
        end
        file_OS = 'C:\Twente\IUVO\SUB009\OS\muscleAnalysis\SUB009noExo_ST_10_MusA_MTULen.sto';
        length_OS = importdata(file_OS);
        l_OS = length_OS.data(:,2);
        file_OS_minus = ('C:\Twente\IUVO\SUB009\OS\muscleAnalysis\ResultsOS\SUB009noExo_ST_10_Length.sto');
        length_OS_minus = importdata(file_OS_minus);
        l_OS_minus = length_OS_minus.data(:,2);
        file_OS_tendon = ('C:\Twente\IUVO\SUB009\OS\muscleAnalysis\ResultsOS\SUB009noExo_ST_10_TendonLength.sto');
        length_OS_tendons = importdata(file_OS_tendon);
        l_OS_tendons = length_OS_tendons.data(:,2);
        file_OS_fiber = ('C:\Twente\IUVO\SUB009\OS\muscleAnalysis\ResultsOS\SUB009noExo_ST_10_FiberLength.sto');
        length_OS_fiber = importdata(file_OS_fiber);
        l_OS_fiber = length_OS_fiber.data(:,2);


        figure
        plot(l_OS)
        hold on; plot(l_ceinms); plot(l_norm)
        plot(l_OS_minus); plot(l_OS_tendons+l_OS_fiber); plot(l_OS_fiber)
        legend('OS', 'CEINMS', 'lemght', 'tendon', 'fiber')
        title([sbj{s}, '-', elencoTrial{t}])
    end

    close all
end

%% pennation angle --- OS non stampa nessun valore (cioè il valore non cambia nel tempo)


for s = 1:length(sbj)

    for t = 1:length(elencoTrial)
        file_CEINMS = ['C:\Twente\IUVO\', sbj{s}, '\CEINMS\execution\OP\EMG\', sbj{s}, elencoTrial{t}, '\', 'PennationAngles.sto'];
        length_ceinms = importdata(file_CEINMS);
        length_ceinms = length_ceinms.data(:,4);

        

        if s >5
             file_OS =  ['C:\Twente\IUVO\', sbj{s}, '\OS\muscleAnalysis\ResultsOS\',sbj{s}, elencoTrial{t}, '_MuscleAnalysis_PennationAngle.sto'];
        else
             file_OS =  ['C:\Twente\IUVO\', sbj{s}, '\OS\muscleAnalysis\ResultsOS\',sbj{s}, elencoTrial{t}, '_PennationAngle.sto'];
        end

        length_OS = importdata(file_OS);
        length_OS = length_OS.data(:,4);

        figure
        plot(length_OS)
        hold on; plot(length_ceinms)
        legend('OS', 'CEINMS')
        title([sbj{s}, '-', elencoTrial{t}])
    end

    close all
end