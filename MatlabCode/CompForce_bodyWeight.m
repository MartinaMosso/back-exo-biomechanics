%% COMPRESSIVE FORCE PER BODY WEIGHT

clear; close all; clc

%%


elencoTrial = {'noExo_SQ_10', 'noExo_ST_10', 'noExo_BL_10', 'yesExo_SQ_10', 'yesExo_ST_10', 'yesExo_BL_10'};

sbj = {'SUB005', 'SUB006', 'SUB007', 'SUB009', 'SUB010', 'SUB011', 'SUB012'}; % --> aggiungere sbj 008


repMap = {'rep1', 'rep2', 'rep3', 'rep4','rep5','rep6','rep7','rep8','rep9','rep10'};

for s = 1:length(sbj)
    
    for t = 4:4%length(elencoTrial)

        file2import = ['C:\Twente\IUVO\', sbj{s}, '\', sbj{s}, '_', elencoTrial{t}, '.mat'];

        load(file2import)

        weight = Datastr.Info.subjMass;
        Datastr.cutMovements.JRA_EMG_calibOne_standardParam.L5_S1_IVDjnt_on_sacrum_in_sacrumNORM = {};

        for r = 1:length(repMap)
            rep = Datastr.cutMovements.JRA_EMG_calibOne_standardParam.L5_S1_IVDjnt_on_sacrum_in_sacrum.(repMap{r});

            repNorm = rep./(weight*9.81);
            namerep = repMap{r};

            Datastr.cutMovements.JRA_EMG_calibOne_standardParam.L5_S1_IVDjnt_on_sacrum_in_sacrumNORM.namerep = repNorm;

            repSBJ(r,:) = repNorm;

            hold on
            plot(repNorm)

        end
        close
        repMean = mean(repSBJ);

        repSTD =  std(repSBJ, 0, 1); % std su ogni colonna
        Datastr.cutMovements.JRA_EMG_calibOne_standardParam.L5_S1_IVDjnt_on_sacrum_in_sacrumNORM.Mean = repMean;
        Datastr.cutMovements.JRA_EMG_calibOne_standardParam.L5_S1_IVDjnt_on_sacrum_in_sacrumNORM.Std = repSTD;
       
       
         SQ_yesExo((s-1)*10+1:(s)*10, :) = repSBJ;
        % save(file2import, 'Datastr');
        % 
        % hold on
        % plot(repMean)
        
         
    end


end


%% SQ no Exo

load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\SQ_noExo_Fnorm.mat')

% for i=1:70
%     hold on
%    plot(SQ_noExo(i,:))
% end
figure
SQ_noExo_mean = mean([SQ_noExo(1:20,:);SQ_noExo(31:end,:)]);
SQ_noExo_std = std([SQ_noExo(1:20,:);SQ_noExo(31:end,:)]);
 hold on

x = 1:length(SQ_noExo_mean); % adatta x ai tuoi dati
fill([x fliplr(x)], [SQ_noExo_mean+SQ_noExo_std fliplr(SQ_noExo_mean-SQ_noExo_std)], [0.9 0.9 0.9],'FaceAlpha', 0.3, 'EdgeColor', 'none');
plot(SQ_noExo_mean, 'r',linewidth=2)
%% SQ yes Exo

load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\SQ_yesExo_Fnorm.mat')

% for i=1:70
%     hold on
%     plot(SQ_yesExo(i,:))
% end
figure
SQ_yesExo_mean = mean([SQ_yesExo(1:19,:);SQ_yesExo(31:end,:)]);
SQ_yesExo_std = std([SQ_yesExo(1:19,:);SQ_noExo(31:end,:)]);
 hold on

x = 1:length(SQ_yesExo_mean); % adatta x ai tuoi dati
fill([x fliplr(x)], [SQ_yesExo_mean+SQ_yesExo_std fliplr(SQ_yesExo_mean-SQ_yesExo_std)], [0.9 0.9 0.9],'FaceAlpha', 0.3, 'EdgeColor', 'none');
plot(SQ_yesExo_mean, 'r',linewidth=2)

%% ST no Exo

load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\ST_noExo_Fnorm.mat')
figure
% for i=1:70
%     hold on
%    plot(ST_noExo(i,:))
% end

ST_noExo_mean = mean([ST_noExo(1:30,:);ST_noExo(51:end,:)]);
ST_noExo_std = std([ST_noExo(1:30,:);ST_noExo(51:end,:)]);
 hold on

x = 1:length(ST_noExo_mean); % adatta x ai tuoi dati
fill([x fliplr(x)], [ST_noExo_mean+ST_noExo_std fliplr(ST_noExo_mean-ST_noExo_std)], [0.9 0.9 0.9],'FaceAlpha', 0.3, 'EdgeColor', 'none');
plot(ST_noExo_mean, 'r',linewidth=2)

%% ST yes Exo

load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\ST_yesExo_Fnorm.mat')
figure
% for i=1:70
%     hold on
%     plot(ST_yesExo(i,:))
% end

ST_yesExo_mean = mean([ST_yesExo(1:15,:);ST_yesExo(17:30,:); ST_yesExo(61:end,:)]);
ST_yesExo_std = std([ST_yesExo(1:15,:);ST_yesExo(17:30,:); ST_yesExo(61:end,:)]);
 hold on

x = 1:length(ST_yesExo_mean); % adatta x ai tuoi dati
fill([x fliplr(x)], [ST_yesExo_mean+ST_yesExo_std fliplr(ST_yesExo_mean-ST_yesExo_std)], [0.9 0.9 0.9],'FaceAlpha', 0.3, 'EdgeColor', 'none');
plot(ST_yesExo_mean, 'r',linewidth=2)

%% BL no Exo

load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\BL_noExo_Fnorm.mat')
figure
% for i=1:70
%     hold on
%    plot(BL_noExo(i,:))
% end

BL_noExo_mean = mean(BL_noExo(1:20,:));
BL_noExo_std = std(BL_noExo(1:20,:));
 hold on

x = 1:length(BL_noExo_mean); % adatta x ai tuoi dati
fill([x fliplr(x)], [BL_noExo_mean+BL_noExo_std fliplr(BL_noExo_mean-BL_noExo_std)], [0.9 0.9 0.9],'FaceAlpha', 0.3, 'EdgeColor', 'none');
plot(BL_noExo_mean, 'r',linewidth=2)
%% BL yes Exo

load('C:\Users\Dottorato\OneDrive - University of Twente\Data\MATLAB\BL_yesExo_Fnorm.mat')
figure
% for i=1:70
%     hold on
%     plot(BL_yesExo(i,:))
% end

BL_yesExo_mean = mean(BL_yesExo(1:20,:));
BL_yesExo_std = std(BL_yesExo(1:20,:));
 hold on

x = 1:length(BL_yesExo_mean); % adatta x ai tuoi dati [0.6 0.6 1]
fill([x fliplr(x)], [BL_yesExo_mean+BL_yesExo_std fliplr(BL_yesExo_mean-BL_yesExo_std)], [0.9 0.9 0.9],'FaceAlpha', 0.3, 'EdgeColor', 'none');
plot(BL_yesExo_mean, 'r',linewidth=2)

%% compare yes-no

figure
plot(SQ_noExo_mean), hold on, plot(SQ_yesExo_mean)
fill([x fliplr(x)], [SQ_noExo_mean+SQ_noExo_std fliplr(SQ_noExo_mean-SQ_noExo_std)],  [1 0.6 0.6],'FaceAlpha', 0.3, 'EdgeColor', 'none');
fill([x fliplr(x)], [SQ_yesExo_mean+SQ_yesExo_std fliplr(SQ_yesExo_mean-SQ_yesExo_std)],  [0.6 0.6 1],'FaceAlpha', 0.3, 'EdgeColor', 'none');
title('SQ')
legend('noExo', 'yesExo')

figure
plot(ST_noExo_mean), hold on, plot(ST_yesExo_mean)
fill([x fliplr(x)], [ST_noExo_mean+ST_noExo_std fliplr(ST_noExo_mean-ST_noExo_std)],  [1 0.6 0.6],'FaceAlpha', 0.3, 'EdgeColor', 'none');
fill([x fliplr(x)], [ST_yesExo_mean+ST_yesExo_std fliplr(ST_yesExo_mean-ST_yesExo_std)],  [0.6 0.6 1],'FaceAlpha', 0.3, 'EdgeColor', 'none');
title('ST')
legend('noExo', 'yesExo')

figure
plot(BL_noExo_mean), hold on, plot(BL_yesExo_mean)
fill([x fliplr(x)], [BL_noExo_mean+BL_noExo_std fliplr(BL_noExo_mean-BL_noExo_std)],  [1 0.6 0.6],'FaceAlpha', 0.3, 'EdgeColor', 'none');
fill([x fliplr(x)], [BL_yesExo_mean+BL_yesExo_std fliplr(BL_yesExo_mean-BL_yesExo_std)],  [0.6 0.6 1],'FaceAlpha', 0.3, 'EdgeColor', 'none');
title('BL')
legend('noExo', 'yesExo')
