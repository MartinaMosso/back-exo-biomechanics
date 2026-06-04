%% IK -- collect repetition

clear; clc; close all;

%% set values
rep_1 = {'1', '4', '7', '16',  '19', '22','25',   '10','13','28' };
rep_2 = {'2','5', '8', '11', '14', '20', '23', '26', '29', '17'};
rep_3 = {'3', '6', '9',  '15', '18', '21', '24', '27', '30', '12'};
rep_4 = {'4', '7', '16'  '19', '22', '25', '31', '13', '16', '19'};%,, '31'

sbj = '003';
rep_1_004_one_noExo =  {'1', '4', '7', '10', '22','25', '28' };
rep_2_004_one_noExo =  {'5', '8', '11', '14', '17', '20', '23', '26'};
rep_3_004_one_noExo = {'3', '6', '9', '12', '15', '18', '21', '24',  '30'};
rep_4_004_one_noExo = {'4', '7', '10',  '22', '25', '28'};

% trial = {'one','six'};
rep_1_004_five_noExo =  {'1', '4', '7', '16', '19', '22','25' };
rep_2_004_five_noExo = {'2','5', '8', '11', '14', '20', '23', '26', '29'}; % '17',
rep_3_004_five_noExo = {'3', '6', '9',  '15', '18', '21', '24', '27', '30'};
rep_4_004_five_noExo =  { '4', '7', '16', '19', '22','25', '31' };


rep_1_004_one_yesExo =  {  };
rep_2_004_one_yesExo =  {'5', '8', '11',  '26', '29'};
rep_3_004_one_yesExo = {'3','6', '9', '12', '15',  '21', '24','27',  '30'};
rep_4_004_one_yesExo = {    };

trial = {'one','five'};
rep_1_004_five_yesExo =  { '1', '10',  '25' };
rep_2_004_five_yesExo = {'2', '5', '8', '11',  '29'}; % '17',
rep_3_004_five_yesExo = {'3', '6', '9',  '12', '15',  '21', '24', '27', '30'};
rep_4_004_five_yesExo =  { '10', '31' };

%% mov 1
for t = 2:length(trial)
    if t ==1
                % rep_1= { '4', '7', '10', '13', '16', '19', '22'}; % valori per sub002, noexo one
                %rep_1= { '4', '7',   '16',  '22', '25', '28'}; % valori per sub003, noexo one
rep_1 = rep_1_004_one_yesExo; % valori per sub003, yesexo one
        % rep_1= { '4', '7', '13', '19', '22', '28'}; % valori per sub005, noexo
    %             % rep_1= { '7', '19',  '28'}; % valori per sub005, yesexo one
    %             % rep_1 = rep_1_004_one_noExo;
    %             rep_1 = rep_1_004_one_yesExo;
    % 
    else
        % rep_1= {'1', '4', '16', '22', '25', '28'}; % valori per sub005, noexo7
    %     % rep_1 = {'4', '7'}; 
    %     % rep_1 = rep_1_004_five_noExo;
        % rep_1 =rep_1_004_five_yesExo;
        % rep_1= {'7','13', '16', '22', '25', '28'}; % valori per sub002, noExo five
        % rep_1= {'7','13', '16', '22', '25', '28'}; % valori per sub002, noExo five
rep_1 = rep_1_004_five_yesExo; % valori per sub003, yesexo five

    end
    for r = 1: length(rep_1)

        nameFile = ['C:\Twente\IUVO\PHASE2\SUB', sbj, '\SUB', sbj, '_yesExo_', trial{t}, rep_1{r}, '_10.mat']
        load(nameFile)
        if ~strcmp(rep_1{r},'1')
            nFrames = length(Datastr.Resample.IKAngData);
            Datastr.Resample.IDTrqData =  Datastr.Resample.IDTrqData(1:nFrames/2,:);
            Datastr.Resample.IKAngData =  Datastr.Resample.IKAngData(1:nFrames/2,:);
        end
        Datastr = oneRepCutMovements(Datastr, 'IK');
        Datastr = oneRepCutMovements(Datastr, 'ID');

        if t ==1
            rep1.IK(r,:)  = Datastr.cutMovements.IK.L5_S1_Flex_Ext_moment.rep1;
            rep1.ID(r,:)  = Datastr.cutMovements.ID.L5_S1_Flex_Ext_moment.rep1;
        else
            rep1.IK(r+10,:)  = Datastr.cutMovements.IK.L5_S1_Flex_Ext_moment.rep1;
            rep1.ID(r+10,:)  = Datastr.cutMovements.ID.L5_S1_Flex_Ext_moment.rep1;
        end

    end
end

%% mov 2
for t = 2:length(trial)
    if t ==1
        % rep_2 =rep_2_004_one_yesExo;
    %     % rep_2 = rep_2_004_one_noExo;
    %     rep_2 = {'2', '8', '11', '14',  '26', '29'};
                    % rep_2 = {'2', '5', '8',  '14', '17', '20', '23', '26', '29'}; % sub 002 no exo, one
                    % rep_2 = {'2', '5', '8', '11',  '14', '17', '20', '23', '26', '29'}; % sub 003 no exo, one
rep_2 = rep_2_004_one_yesExo; % valori per sub003, yesexo one

    else
        % rep_2 = {'5', '8', '11', '14', '17', '20', '23', '26', '29'};
                % rep_2 = {'2', '5', '8', '11', '14', '17',   '26', '29'}; % sub 002 no exo, five
                % rep_2 = {'2', '5', '8', '11', '14', '17',  '20', '23',  '26', '29'}; % sub 003 no exo, six
                rep_2 = rep_2_004_five_yesExo; % valori per sub003, yesexo one


    % % rep_2 = rep_2_004_five_noExo;
    % rep_2 = rep_2_004_five_yesExo;
    end
    for r = 1: length(rep_2)
        nameFile =['C:\Twente\IUVO\PHASE2\SUB', sbj, '\SUB', sbj, '_yesExo_', trial{t}, rep_2{r}, '_10.mat']
        load(['C:\Twente\IUVO\PHASE2\SUB', sbj, '\SUB', sbj, '_yesExo_', trial{t}, rep_2{r}, '_10.mat']);
        Datastr = oneRepCutMovements(Datastr, 'IK');
        if t ==1
            rep2.IK(r,:)  = Datastr.cutMovements.IK.L5_S1_Flex_Ext_moment.rep1;
            rep2.ID(r,:)  = Datastr.cutMovements.ID.L5_S1_Flex_Ext_moment.rep1;

        else
            rep2.IK(r+10,:)  = Datastr.cutMovements.IK.L5_S1_Flex_Ext_moment.rep1;
            rep2.ID(r+10,:)  = Datastr.cutMovements.ID.L5_S1_Flex_Ext_moment.rep1;
        end

    end
end

%% mov3
for t = 2:length(trial)
   % if t ==1
   % %     rep_3 = rep_3_004_one_noExo;
   % rep_3 = rep_3_004_one_yesExo;
   % else rep_3 = rep_3_004_five_yesExo;
   %     % rep_3 = rep_3_004_five_noExo;
   % end
   if t ==1
   % rep_3 = {'3', '6', '9',  '15', '18', '24', '27', '30'}; %sub002, no exo,one
      % rep_3 = {'3', '6', '9', '12', '15', '21', '24', '27'}; %sub003, no exo,one
      rep_3 = rep_3_004_one_yesExo; % valori per sub003, yesexo one


   else 
          % rep_3 = {'3',  '9', '12', '15', '18', '21', '24', '27', '30'}; %sub002, no exo,five
            % rep_3 = {'3','6' , '9', '12', '15', '18', '21', '24', '27', '30'}; %sub003, no exo six
rep_3 = rep_3_004_five_yesExo; % valori per sub003, yesexo five

   end
    for r = 1: length(rep_3)
        namefile = ['C:\Twente\IUVO\PHASE2\SUB', sbj, '\SUB', sbj, '_yesExo_', trial{t}, rep_3{r}, '_10.mat']
        load(['C:\Twente\IUVO\PHASE2\SUB', sbj, '\SUB', sbj, '_yesExo_', trial{t}, rep_3{r}, '_10.mat']);
        Datastr = oneRepCutMovements(Datastr, 'IK');
        if t ==1
            rep3.IK(r,:)  = Datastr.cutMovements.IK.L5_S1_Flex_Ext_moment.rep1;
            rep3.ID(r,:)  = Datastr.cutMovements.ID.L5_S1_Flex_Ext_moment.rep1;
        else
            rep3.IK(r+10,:)  = Datastr.cutMovements.IK.L5_S1_Flex_Ext_moment.rep1;
            rep3.ID(r+10,:)  = Datastr.cutMovements.ID.L5_S1_Flex_Ext_moment.rep1;
        end

    end
end

%% mov 4
for t = 2:length(trial)
    % if t ==1
    % %     % rep_4= {'4', '7', '13', '19', '22', '28', '31'}; % valori per sub005 noexo
    % %     rep_4 = { '7',  '19','28'};
    % % rep_4 = rep_4_004_one_noExo;
    %     rep_4 = rep_4_004_one_yesExo;
    % 
    % else rep_4 = rep_4_004_five_yesExo;
    % 
    % end
    % else
    %     % rep_4= { '4', '16', '22', '25', '28', '31'}; % valori per sub005 noexo
    %     rep_4 = {'4', '7', '31'};
    % end
    if t==1
    % rep_4= { '4','7', '10', '13','19', '16', '22',  '28', '31'}; % valori per sub002 noexo, one
        % rep_4= { '4','7',  '16', '22',  '28'}; % valori per sub003 noexo, one
rep_4 = rep_4_004_one_yesExo; % valori per sub003, yesexo one

    else 
            % rep_4= { '7', '13', '16', '22',  '28', '31'}; % valori per sub002 noexo, five
            rep_4 = rep_4_004_five_yesExo; % valori per sub003, yesexo one

    end
    for r = 1: length(rep_4)
        nameFile = ['C:\Twente\IUVO\PHASE2\SUB', sbj, '\SUB', sbj, '_yesExo_', trial{t}, rep_4{r}, '_10.mat']
        load(nameFile)
        if ~strcmp(rep_4{r}, '31')
            nFrames = length(Datastr.Resample.IKAngData);
            Datastr.Resample.IDTrqData =  Datastr.Resample.IDTrqData(nFrames/2+1:end,:);
            Datastr.Resample.IKAngData =  Datastr.Resample.IKAngData(nFrames/2+1:end,:);
        end
        Datastr = oneRepCutMovements(Datastr, 'IK');
        Datastr = oneRepCutMovements(Datastr, 'ID');
        if t ==1
            rep4.IK(r,:)  = Datastr.cutMovements.IK.L5_S1_Flex_Ext_moment.rep1;
             rep4.ID(r,:)  = Datastr.cutMovements.ID.L5_S1_Flex_Ext_moment.rep1;
        else
            rep4.IK(r+10,:)  = Datastr.cutMovements.IK.L5_S1_Flex_Ext_moment.rep1;
            rep4.ID(r+10,:)  = Datastr.cutMovements.ID.L5_S1_Flex_Ext_moment.rep1;
        end

    end
end
