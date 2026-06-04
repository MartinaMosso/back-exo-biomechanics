%% Fcomp -- collect repetition

clear; clc; close all;

%% set values
rep_1 = {'1', '4', '7', '10', '13', '16', '19', '22', '25', '28'}; 
rep_2 = {'2', '5', '8', '11', '14', '17', '20', '23', '26', '29'};
rep_3 = {'3', '6', '9', '12', '15', '18', '21', '24', '27', '30'};
rep_4 = {'4', '7', '10', '13', '16', '19', '22', '25', '28', '31'};

sbj = '002';

trial = {'one', 'five'};
rep_1_004_one_noExo =  {'1',  '10', '22', '28' };
rep_2_004_one_noExo =  {'5', '8', '11', '14', '17', '20', '23', '26'};
rep_3_004_one_noExo = {'3', '6', '9', '12', '15', '18', '21', '24',  '30'};
rep_4_004_one_noExo = { '10',  '22', '28'};

trial = {'one','five'};
rep_1_004_five_noExo =  {  '19', '25' };
rep_2_004_five_noExo = {'2','5', '8', '11', '14', '20', '23', '26', '29'}; % '17',
rep_3_004_five_noExo = {'3', '9',  '15', '21', '24', '27', '30'};
rep_4_004_five_noExo =  { '19', '25', '31' };


rep_1_004_one_yesExo =  {  '16'       };
rep_2_004_one_yesExo =  {'5', '8', '11', '14', '17', '20',  '26'};
rep_3_004_one_yesExo = {  '12', '15', '18', '21'};
rep_4_004_one_yesExo = {'16'    };

% trial = {'one','five'};
rep_1_004_five_yesExo =  {    '25' };
rep_2_004_five_yesExo = {'02',  '11', '14',  '23', '26', '29'}; % '17',
rep_3_004_five_yesExo = {'03', '06', '09',  '15',  '21', '24', '27', '30'};
rep_4_004_five_yesExo =  {  '31' };

% sub 005
rep_1_005_one_yesExo =  {  '7'       };
rep_2_005_one_yesExo =  {'2', '8', '11', '14',  '26', '29'};
rep_3_005_one_yesExo = {  '3','6', '9', '12', '15', '18', '21', '30'};
rep_4_005_one_yesExo = {'7'    };

% trial = {'one','five'};
rep_1_005_five_yesExo =  { '7' };
rep_2_005_five_yesExo = {'5','8',  '11', '14','17','20',  '23', '26', '29'}; % '17',
rep_3_005_five_yesExo = {'3', '6', '9',  '12', '15',  '18', '21', '24', '27', '30'};
rep_4_005_five_yesExo =  { '7', '31' };


% sub 0002
rep_1_002_one_noExo =  {'4', '7', '10', '13', '16', '19', '22' };
rep_2_002_one_noExo =  {'2', '5', '8',  '14', '17', '20', '23', '26', '29'};
rep_3_002_one_noExo = {'3', '6', '9', '15', '18',  '24',  '27','30'};
rep_4_002_one_noExo ={'4', '7', '10', '13', '16', '19', '22' , '31'};

rep_1_002_five_noExo =  { '7', '13', '16', '22','25' , '28'};
rep_2_002_five_noExo = {'2','5', '8', '11', '14', '17',  '26', '29'}; % '17',
rep_3_002_five_noExo = {'3',  '9','12',  '15', '18', '21', '24', '27', '30'};
rep_4_002_five_noExo =  { '7', '13', '16', '22','25' , '28', '31' };

% sub 0003
trial = {'one', 'six'};
rep_1_003_one_noExo =  {'4', '7',  '22', '25', '28' };
rep_2_003_one_noExo =  {'2', '5', '8',  '11', '14', '17', '20', '23', '26', '29'};
rep_3_003_one_noExo = {'3', '6', '9', '12', '15', '21',  '24',  '27'};
rep_4_003_one_noExo ={'4', '7',  '22', '25', '28' };

rep_1_003_five_noExo =  { '7', '13', '16', '22','25' , '28'};
rep_2_003_five_noExo = {'2','5', '8', '11', '14', '17','20', '23',  '26', '29'}; % '17',
rep_3_003_five_noExo = {'3', '6',  '9','12',  '15', '18', '21', '24', '27', '30'};
rep_4_003_five_noExo =  { '7', '13', '16', '22','25' , '28', '31' };


%% mov 1
for t = 1:length(trial)
    if t ==1
        % rep_1= { '4', '7', '13', '19', '22', '28'}; % valori per sub005
        rep_1 = rep_1_002_one_noExo;
    else
        % rep_1= {'1', '4', '16', '22', '25', '28'}; % valori per sub005
                rep_1 = rep_1_005_five_noExo;

    end
    for r = 1: length(rep_1)
        nameFile = ['C:\Twente\IUVO\PHASE2\SUB', sbj, '\SUB', sbj, '_yesExo_', trial{t}, rep_1{r}, '_10.mat']
        load(nameFile)
        if ~strcmp(rep_1{r},'1')
            nFrames = length(Datastr.Resample.JRA_EMG.ComprForceVecNorm);
            Datastr.Resample.JRA_EMG.ComprForceVecNorm = Datastr.Resample.JRA_EMG.ComprForceVecNorm(1:nFrames/2,:);
            Datastr.Resample.IDTrqData =  Datastr.Resample.IDTrqData(1:nFrames/2,:);

        end
        Datastr = oneRepCutMovements(Datastr, 'JRA');

        if t ==1
            rep1.FC(r,:)  = Datastr.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.rep1;
            
        else
            rep1.FC(r+10,:)  = Datastr.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.rep1;
        end

    end
end

%% mov 2
for t = 1:length(trial)
        if t ==1
        % rep_1= { '4', '7', '13', '19', '22', '28'}; % valori per sub005
        rep_2 = rep_2_005_one_yesExo;
    else
        % rep_1= {'1', '4', '16', '22', '25', '28'}; % valori per sub005
                rep_2 = rep_2_005_five_yesExo;

    end
    for r = 1: length(rep_2)
       filename= ['C:\Twente\IUVO\PHASE2\SUB', sbj, '\SUB', sbj, '_yesExo_', trial{t}, rep_2{r}, '_10.mat']
        load(['C:\Twente\IUVO\PHASE2\SUB', sbj, '\SUB', sbj, '_yesExo_', trial{t}, rep_2{r}, '_10.mat']);
        Datastr = oneRepCutMovements(Datastr, 'JRA');
        if t ==1
            rep2.FC(r,:)  = Datastr.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.rep1;

        else
            rep2.FC(r+10,:)  = Datastr.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.rep1;
        end

    end
end

%% mov3
for t = 1:length(trial)
        if t ==1
        % rep_1= { '4', '7', '13', '19', '22', '28'}; % valori per sub005
        rep_3 = rep_3_005_one_yesExo;
    else
        % rep_1= {'1', '4', '16', '22', '25', '28'}; % valori per sub005
                rep_3 = rep_3_005_five_yesExo;

    end
    for r = 1: length(rep_3)
        filename =['C:\Twente\IUVO\PHASE2\SUB', sbj, '\SUB', sbj, '_yesExo_', trial{t}, rep_3{r}, '_10.mat']
        load(['C:\Twente\IUVO\PHASE2\SUB', sbj, '\SUB', sbj, '_yesExo_', trial{t}, rep_3{r}, '_10.mat']);
        Datastr = oneRepCutMovements(Datastr, 'JRA');
        if t ==1
            rep3.FC(r,:)  = Datastr.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.rep1;
        else
            rep3.FC(r+10,:)  =Datastr.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.rep1
        end

    end
end

%% mov 4
for t = 1:length(trial)
    if t ==1
        % rep_4= {'4', '7', '13', '19', '22', '28', '31'}; % valori per sub005
                rep_4 = rep_4_005_one_yesExo;

    else
        % rep_4= { '4', '16', '22', '25', '28', '31'}; % valori per sub005
            rep_4 = rep_4_005_five_yesExo;

    end
    for r = 1: length(rep_4)
        nameFile = ['C:\Twente\IUVO\PHASE2\SUB', sbj, '\SUB', sbj, '_yesExo_', trial{t}, rep_4{r}, '_10.mat']
        load(nameFile)
        if ~strcmp(rep_4{r}, '31')
            nFrames = length(Datastr.Resample.JRA_EMG.ComprForceVecNorm);
            Datastr.Resample.JRA_EMG.ComprForceVecNorm = Datastr.Resample.JRA_EMG.ComprForceVecNorm(nFrames/2:end,:);
            Datastr.Resample.IDTrqData =  Datastr.Resample.IDTrqData(nFrames/2:end,:);

        end
        Datastr = oneRepCutMovements(Datastr, 'JRA');

        if t ==1
            rep4.FC(r,:)  = Datastr.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.rep1;
        else
            rep4.FC(r+10,:)  = Datastr.cutMovements.JRA_EMG.L5_S1_IVDjnt_on_sacrum_in_sacrum.rep1;
        end

    end
end
