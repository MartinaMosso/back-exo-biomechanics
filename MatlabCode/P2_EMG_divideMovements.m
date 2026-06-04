%% EMG: collect repetition

clear; clc; close all;

%% set values
rep_1 = {'1', '4', '7', '10', '13', '16', '19', '22', '25', '28'};
rep_2 = {'2', '5', '8', '11', '14', '17', '20', '23', '26', '29'};
rep_3 = {'3', '6', '9', '12', '15', '18', '21', '24', '27', '30'};
rep_4 = {'4', '7', '10', '13', '16', '19', '22', '25', '28', '31'};

sbj = '003';

trial = {'one', 'five'};

sbj = '003';
rep_1_004_one_noExo =  {'1', '4', '7', '10', '22','25', '28' };
rep_2_004_one_noExo =  {'5', '8', '11', '14', '17', '20', '23', '26'};
rep_3_004_one_noExo = {'3', '6', '9', '12', '15', '18', '21', '24',  '30'};
rep_4_004_one_noExo = {'4', '7', '10',  '22', '25', '28'};

trial = {'one','five'};
rep_1_004_five_noExo =  {'1', '4', '7', '16', '19', '22','25' };
rep_2_004_five_noExo = {'2','5', '8', '11', '14', '20', '23', '26', '29'}; % '17',
rep_3_004_five_noExo = {'3', '6', '9',  '15', '18', '21', '24', '27', '30'};
rep_4_004_five_noExo =  { '4', '7', '16', '19', '22','25', '31' };


rep_1_004_one_yesExo =  { '4',  '16',  '19', '22','25',   '10' };
rep_2_004_one_yesExo =  {'5', '8', '11', '14', '17', '20', '23', '26'};
rep_3_004_one_yesExo = {'3', '9', '12', '15', '18', '21', '24',  '30'};
rep_4_004_one_yesExo = {'4', '16',  '19', '22','25',   '10' };

% trial = {'one','five'};
rep_1_004_five_yesExo =  {    '25' };
rep_2_004_five_yesExo = {'02',  '11', '14',  '23', '26', '29'}; % '17',
rep_3_004_five_yesExo = {'03', '06', '09',  '15',  '21', '24', '27', '30'};
rep_4_004_five_yesExo =  {  '31' };


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

%% rep 1
for t = 1:1%length(trial)
    if t ==1
        % rep_1= { '4', '7', '13', '19', '22', '28'}; % valori per sub005, noexo
                % rep_1= { '7', '19',  '28'}; % valori per sub005, yesexo one
rep_1 = rep_1_003_one_noExo;
    else
        % rep_1= {'1', '4', '16', '22', '25', '28'}; % valori per sub005, noexo7
        % rep_1 = {'4', '7'}; 
        rep_1 = rep_1_003_five_noExo;

    end
    for r = 1: length(rep_1)
        nameFile = ['C:\Twente\IUVO\PHASE2\SUB', sbj, '\SUB', sbj, '_noExo_', trial{t}, rep_1{r}, '_10.mat']
        load(nameFile)
        if ~strcmp(rep_1{r},'1')
            nFrames = length(Datastr.Resample.IKAngData);
            Datastr.Resample.EMG =  Datastr.Resample.EMG(1:nFrames/2,:);
        end
        Datastr = oneRepCutMovements(Datastr, 'EMG');

        mean_back1 = mean([Datastr.cutMovements.EMG.longthor_r.rep1; Datastr.cutMovements.EMG.longthor_l.rep1]);
        mean_back2 = mean([Datastr.cutMovements.EMG.longlumb_r.rep1; Datastr.cutMovements.EMG.longlumb_l.rep1]);
        mean_back3 = mean([Datastr.cutMovements.EMG.iliocost_r.rep1; Datastr.cutMovements.EMG.iliocost_l.rep1]);

        mean_abd1 = mean([Datastr.cutMovements.EMG.intobl_r.rep1; Datastr.cutMovements.EMG.intobl_l.rep1]);
        mean_abd2 = mean([Datastr.cutMovements.EMG.extobl_r.rep1; Datastr.cutMovements.EMG.extobl_l.rep1]);
        mean_abd3 = mean([Datastr.cutMovements.EMG.rectabd_r.rep1; Datastr.cutMovements.EMG.rectabd_l.rep1]);

        mean_leg1 = mean([Datastr.cutMovements.EMG.recfem_r.rep1; Datastr.cutMovements.EMG.recfem_l.rep1]);
        mean_leg2 = mean([Datastr.cutMovements.EMG.bicfem_r.rep1; Datastr.cutMovements.EMG.bicfem_l.rep1]);

        back = [mean_back1, mean_back2, mean_back3];
        abd = [mean_abd1, mean_abd2, mean_abd3];
        leg = [mean_leg1, mean_leg2];
        if t ==1
            rep1.back(r,:)  = back;
            rep1.abd(r,:)  = abd;
            rep1.leg(r,:)  = leg;
        else
            rep1.back(r+10,:)  = back;
            rep1.abd(r+10,:)  = abd;
            rep1.leg(r+10,:)  = leg;
        end

    end
end

%% rep 2

for t = 1:length(trial)
    if t ==1
        %     rep_2 = {'2', '8', '11', '14',  '26', '29'};
        rep_2 = rep_2_003_one_noExo;

    else
        % rep_2 = {'5', '8', '11', '14', '17', '20', '23', '26', '29'};
        rep_2 = rep_2_003_five_noExo;
    end

    for r = 1: length(rep_2)
        load(['C:\Twente\IUVO\PHASE2\SUB', sbj, '\SUB', sbj, '_noExo_', trial{t}, rep_2{r}, '_10.mat']);
        Datastr = oneRepCutMovements(Datastr, 'IK');


        mean_back1 = mean([Datastr.cutMovements.EMG.longthor_r.rep1; Datastr.cutMovements.EMG.longthor_l.rep1]);
        mean_back2 = mean([Datastr.cutMovements.EMG.longlumb_r.rep1; Datastr.cutMovements.EMG.longlumb_l.rep1]);
        mean_back3 = mean([Datastr.cutMovements.EMG.iliocost_r.rep1; Datastr.cutMovements.EMG.iliocost_l.rep1]);

        mean_abd1 = mean([Datastr.cutMovements.EMG.intobl_r.rep1; Datastr.cutMovements.EMG.intobl_l.rep1]);
        mean_abd2 = mean([Datastr.cutMovements.EMG.extobl_r.rep1; Datastr.cutMovements.EMG.extobl_l.rep1]);
        mean_abd3 = mean([Datastr.cutMovements.EMG.rectabd_r.rep1; Datastr.cutMovements.EMG.rectabd_l.rep1]);

        mean_leg1 = mean([Datastr.cutMovements.EMG.recfem_r.rep1; Datastr.cutMovements.EMG.recfem_l.rep1]);
        mean_leg2 = mean([Datastr.cutMovements.EMG.bicfem_r.rep1; Datastr.cutMovements.EMG.bicfem_l.rep1]);

        back = [mean_back1, mean_back2, mean_back3];
        abd = [mean_abd1, mean_abd2, mean_abd3];
        leg = [mean_leg1, mean_leg2];
        if t ==1
            rep2.back(r,:)  = back;
            rep2.abd(r,:)  = abd;
            rep2.leg(r,:)  = leg;
        else
            rep2.back(r+10,:)  = back;
            rep2.abd(r+10,:)  = abd;
            rep2.leg(r+10,:)  = leg;
        end

    end
end

%% rep 3

for t = 1:length(trial)
    if t ==1
        %     rep_2 = {'2', '8', '11', '14',  '26', '29'};
        rep_3 = rep_3_003_one_noExo;

    else
        % rep_2 = {'5', '8', '11', '14', '17', '20', '23', '26', '29'};
        rep_3 = rep_3_003_five_noExo;
    end

    for r = 1: length(rep_3)
        load(['C:\Twente\IUVO\PHASE2\SUB', sbj, '\SUB', sbj, '_noExo_', trial{t}, rep_3{r}, '_10.mat']);
        Datastr = oneRepCutMovements(Datastr, 'IK');


        mean_back1 = mean([Datastr.cutMovements.EMG.longthor_r.rep1; Datastr.cutMovements.EMG.longthor_l.rep1]);
        mean_back2 = mean([Datastr.cutMovements.EMG.longlumb_r.rep1; Datastr.cutMovements.EMG.longlumb_l.rep1]);
        mean_back3 = mean([Datastr.cutMovements.EMG.iliocost_r.rep1; Datastr.cutMovements.EMG.iliocost_l.rep1]);

        mean_abd1 = mean([Datastr.cutMovements.EMG.intobl_r.rep1; Datastr.cutMovements.EMG.intobl_l.rep1]);
        mean_abd2 = mean([Datastr.cutMovements.EMG.extobl_r.rep1; Datastr.cutMovements.EMG.extobl_l.rep1]);
        mean_abd3 = mean([Datastr.cutMovements.EMG.rectabd_r.rep1; Datastr.cutMovements.EMG.rectabd_l.rep1]);

        mean_leg1 = mean([Datastr.cutMovements.EMG.recfem_r.rep1; Datastr.cutMovements.EMG.recfem_l.rep1]);
        mean_leg2 = mean([Datastr.cutMovements.EMG.bicfem_r.rep1; Datastr.cutMovements.EMG.bicfem_l.rep1]);

        back = [mean_back1, mean_back2, mean_back3];
        abd = [mean_abd1, mean_abd2, mean_abd3];
        leg = [mean_leg1, mean_leg2];
        if t ==1
            rep3.back(r,:)  = back;
            rep3.abd(r,:)  = abd;
            rep3.leg(r,:)  = leg;
        else
            rep3.back(r+10,:)  = back;
            rep3.abd(r+10,:)  = abd;
            rep3.leg(r+10,:)  = leg;
        end

    end
end


%% mov 4

for t = 1:1%length(trial)
    if t ==1
        %            rep_4 = { '7',  '19','28'};          if t ==1
        %     rep_2 = {'2', '8', '11', '14',  '26', '29'};
        rep_4= rep_4_003_one_noExo;

    else % rep_2 = {'5', '8', '11', '14', '17', '20', '23', '26', '29'};
        rep_4 = rep_4_003_five_noExo;
    end

    % 
    %     % rep_4= {'4', '7', '13', '19', '22', '28', '31'}; % valori per sub005
    % else
    %             rep_4 = {'4', '7', '31'};
    % 
    %     % rep_4= { '4', '16', '22', '25', '28', '31'}; % valori per sub005
    % end
    for r = 1: length(rep_4)
        nameFile = ['C:\Twente\IUVO\PHASE2\SUB', sbj, '\SUB', sbj, '_noExo_', trial{t}, rep_4{r}, '_10.mat']
        load(nameFile)
        if ~strcmp(rep_4{r}, '31')
            nFrames = length(Datastr.Resample.IKAngData);
            Datastr.Resample.EMG =  Datastr.Resample.EMG(nFrames/2+1:end,:);
        end
         Datastr = oneRepCutMovements(Datastr, 'EMG');

        mean_back1 = mean([Datastr.cutMovements.EMG.longthor_r.rep1; Datastr.cutMovements.EMG.longthor_l.rep1]);
        mean_back2 = mean([Datastr.cutMovements.EMG.longlumb_r.rep1; Datastr.cutMovements.EMG.longlumb_l.rep1]);
        mean_back3 = mean([Datastr.cutMovements.EMG.iliocost_r.rep1; Datastr.cutMovements.EMG.iliocost_l.rep1]);

        mean_abd1 = mean([Datastr.cutMovements.EMG.intobl_r.rep1; Datastr.cutMovements.EMG.intobl_l.rep1]);
        mean_abd2 = mean([Datastr.cutMovements.EMG.extobl_r.rep1; Datastr.cutMovements.EMG.extobl_l.rep1]);
        mean_abd3 = mean([Datastr.cutMovements.EMG.rectabd_r.rep1; Datastr.cutMovements.EMG.rectabd_l.rep1]);

        mean_leg1 = mean([Datastr.cutMovements.EMG.recfem_r.rep1; Datastr.cutMovements.EMG.recfem_l.rep1]);
        mean_leg2 = mean([Datastr.cutMovements.EMG.bicfem_r.rep1; Datastr.cutMovements.EMG.bicfem_l.rep1]);

        back = [mean_back1, mean_back2, mean_back3];
        abd = [mean_abd1, mean_abd2, mean_abd3];
        leg = [mean_leg1, mean_leg2];
        if t ==1
            rep4.back(r,:)  = back;
            rep4.abd(r,:)  = abd;
            rep4.leg(r,:)  = leg;
        else
            rep4.back(r+10,:)  = back;
            rep4.abd(r+10,:)  = abd;
            rep4.leg(r+10,:)  = leg;
        end

    end
end