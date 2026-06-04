%% PHASE 2 - box segmentation 

clear; close all; clc;

%% import file

load('C:\Users\Dottorato\OneDrive - unibs.it\MARTINA\DOTTORATO\2ANNO\Twente\ACQUISIZIONI\SUB007\Qualisys\Phase2\mat\noExo_1_1.mat');
% Datastr = noExo_1_1_1;
%% coordinate box

label_box = {'BX1', 'BX2', 'BX3', 'BX4'};
Datastr = qtm_;
for i=1:length(label_box)
     idx = find(strcmp(label_box(i), Datastr.Trajectories.Labeled.Labels));
     coord_box(i,1:3,:) = Datastr.Trajectories.Labeled.Data(idx,1:3,:);
end

BX1 = squeeze(coord_box(1,:,:))';
BX2 = squeeze(coord_box(2,:,:))';
BX3 = squeeze(coord_box(3,:,:))';
BX4 = squeeze(coord_box(4,:,:))';

%% figure
figure
tiledlayout(2,2)
nexttile
plot(BX1(:,2))   
title('BOX1')
nexttile
plot(BX2(:,2))
title('BOX2')
nexttile
plot(BX3(:,2))
title('BOX3')
nexttile
plot(BX4(:,2))
title('BOX4')

figure
plot(BX4(:,2))

figure
plot(diff(BX4(:,2)))
hold on; plot(diff(BX1(:,2)))

%% calculate force on hand
C3Ddata=Datastr;

handMarkerLabels =["2K", "5K"];

% Generate Hand Forces and add them
% check if the required markers are available --> pt applicazione forza

if length(handMarkerLabels) == 1
    hM_r = ['R' handMarkerLabels{1}];
    hM_l = ['L' handMarkerLabels{1}];
    
    if ~(any(strcmp(C3Ddata.Marker.DataLabel,hM_r)) && any(strcmp(C3Ddata.Marker.DataLabel,hM_l)))
        error('Required markers missing!')
    end
    
    rInd = find(strcmp(C3Ddata.Marker.DataLabel,hM_r));
    lInd = find(strcmp(C3Ddata.Marker.DataLabel,hM_l));
    
    rM = squeeze(C3Ddata.Resample.Marker(:,:,rInd));
    lM = squeeze(C3Ddata.Resample.Marker(:,:,lInd));
    
    hand_r = rM;
    hand_l = lM;
    
elseif length(handMarkerLabels) == 2
    hM_r1 = ['R' handMarkerLabels{1}];
    hM_l1 = ['L' handMarkerLabels{1}];
    hM_r2 = ['R' handMarkerLabels{2}];
    hM_l2 = ['L' handMarkerLabels{2}];
    
    if ~(any(strcmp(C3Ddata.Trajectories.Labeled.Labels,hM_r1)) && any(strcmp(C3Ddata.Trajectories.Labeled.Labels,hM_l1)) && ...
            any(strcmp(C3Ddata.Trajectories.Labeled.Labels,hM_r2)) && any(strcmp(C3Ddata.Trajectories.Labeled.Labels,hM_l2)) )
        error('Required markers missing!')
    end
    
    r1Ind = find(strcmp(C3Ddata.Trajectories.Labeled.Labels,hM_r1));
    l1Ind = find(strcmp(C3Ddata.Trajectories.Labeled.Labels,hM_l1));
    r2Ind = find(strcmp(C3Ddata.Trajectories.Labeled.Labels,hM_r2));
    l2Ind = find(strcmp(C3Ddata.Trajectories.Labeled.Labels,hM_l2));
    
    r1 = squeeze(C3Ddata.Trajectories.Labeled.Data(r1Ind, 1:3, :,:));
    l1 = squeeze(C3Ddata.Trajectories.Labeled.Data(l1Ind, 1:3, :,:));
    
    r2 = squeeze(C3Ddata.Trajectories.Labeled.Data(r2Ind, 1:3, :,:));
    l2 = squeeze(C3Ddata.Trajectories.Labeled.Data(l2Ind, 1:3, :,:));
    
    hand_r = (r1 + r2)/2;
    hand_l = (l1 + l2)/2;
    
    
else
    error('How many hand markers are used?')
end

% objectYPosition = (BX1(:,2)+BX2(:,2)+BX3(:,2)+BX4(:,2))/4;
objectYPosition = BX4(:,2)/1000;

ac_box = diff(diff(objectYPosition));

% objectYPosInd   = find(contains(strip(objectIK.colheaders),'_ty'));
% objectYPosition = objectIK.data(1:nRows,objectYPosInd);
% IKtimestep = objectIK.data(3,1)  - objectIK.data(2,1);
IKsampFreq = 1/C3Ddata.FrameRate;

objectYVelocity = [0 ; diff(objectYPosition)];

data_clean = objectYVelocity;  % Copia il tuo segnale
idx_nan = isnan(data_clean);  % Trova i NaN

% Interpola solo se ci sono valori validi
if any(~idx_nan)
    data_clean(idx_nan) = interp1(find(~idx_nan), data_clean(~idx_nan), find(idx_nan), 'linear', 'extrap');
end

objectYVelocity = data_clean;

[b,a] = butter(2,10/(100/2),'low');
objectYVelocityfilt = filtfilt(b,a,objectYVelocity);

objectYAcc = [0 ; diff(objectYVelocityfilt)];
objectYAccfilt = filtfilt(b,a,objectYAcc);

accThresh = 0.05; 

% Changed part, see if extra condition (height < 0.2m) for objectMov also works 
% objRest = [objectYAccfilt < accThresh & objectYAccfilt > -accThresh] % acc within m/s2
% New:

% heightThresh = 0.23; % [m]
heightThresh = 0.70;
% Only apply height constraint to vertical movements (indicated by vertMovFlag = 1)
objRest = [objectYAccfilt < accThresh & objectYAccfilt > -accThresh & objectYPosition < heightThresh]; % acc within m/s2

%
% objRest([1:IKsampFreq*0.50 end-IKsampFreq*0.50:end],:) = 1;

objRestChanges = [1; diff(objRest)];

objRestFill = objRest;

objStartedMoving = find(objRestChanges==-1);
objStoppedMoving = find(objRestChanges==1);

for iInd = 1:length(objStoppedMoving) -1
    endMove   = objStoppedMoving(iInd);
    startMove = objStartedMoving(iInd);
    
    if endMove > startMove
        error('Not handled')
    end
    
    restWindow = startMove - endMove + 1;
    
    if restWindow < IKsampFreq*0.50 % if moving window < 50% samp freq
        objRestFill(endMove:startMove,:) = 0;
        
    end
    
end
%%Generate Hand Forces
handInfo = zeros(length(hand_r),12);
handInfo(:, [4:6 10:12]) =  [hand_l' hand_r']; % fill in point of force action

%% id box
% osInstallPath ='C:\OpenSim 4.5';
% 
% getOSIDwoExternalLoads(osInstallPath,osModPath,idGenSetPath,xldGenSetPath,ikFilePath,LowPassCutOff);
% 
% str = 'BoxModel\BOX_11.2kg.osim';
% num_str = regexp(str, '(\d+\.?\d*)kg', 'tokens'); 
% weight_bx = str2double(num_str{1}{1}); % Converte la stringa in numero
% 
% objectForceInd   = find(contains(strip(objectID.colheaders),'_force'));
% objectInteractionForce = objectID.data(1:nRows,objectForceInd);
weight_bx = 11.2;
objectInteractionForce(:,2) = (weight_bx*(objectYAccfilt+9.81));

objectInteractionForce(objRestFill,:) = 0;

IDtimestep = objectID.data(3,1)  - objectID.data(2,1);
IDsampFreq = 1/IDtimestep;
[b,a] = butter(4,0.06,'low');

% [b,a] = butter(2,2.*6/IDsampFreq,'low');
objectInteractionForceFilt = filtfilt(b,a,objectInteractionForce);

if splitBetweenHands
    handInfo(:,1:3) = -objectInteractionForceFilt/2;
    handInfo(:,7:9) = -objectInteractionForceFilt/2;
else
    handInfo(:,1:3) = -objectInteractionForceFilt;
    handInfo(:,7:9) = -objectInteractionForceFilt;
end


%% %% divide the phases using x position od BOX4

y = BX4(:,1);

pos1 = mean(x_bx4(1:200));
pos2 = mean(x_bx4(1200:1600));

indici_min = islocalmin(y); 

% Per ottenere gli indici invece che un array logico:
indici_min = find(islocalmin(y));

figure
plot(y); hold on;
plot(indici_min, y(indici_min), 'ro', 'MarkerFaceColor', 'r'); % Evidenzia i minimi
legend('Segnale', 'Minimi locali');
hold off;


%% divide the phases using diff of BOX1
y = BX1(:,2);
dy = diff(BX1(:,2));
threshold = 0.1 * max(abs(dy)); % Soglia per evitare piccoli rumori

% Identificare i punti di minimo e massimo locali
indici_min = find(dy(1:end-1) < -threshold) %& dy(2:end) > threshold); % Minimi significativi
indici_max = find(dy(1:end-1) > threshold)% & dy(2:end) < -threshold); % Massimi significativi

% Unire e ordinare gli indici rilevanti
indici_ripetizioni = sort([indici_min; indici_max]);

% Dividere il segnale in 10 ripetizioni
num_ripetizioni = 10;
segmenti = cell(1, num_ripetizioni);
for i = 1:num_ripetizioni
    if i < num_ripetizioni
        segmenti{i} = y(indici_ripetizioni(i):indici_ripetizioni(i+1));
    else
        segmenti{i} = y(indici_ripetizioni(i):end); % Ultima parte del segnale
    end
end