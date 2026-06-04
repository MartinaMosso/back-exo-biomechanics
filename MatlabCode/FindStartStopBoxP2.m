%% segmenting trials phase 2

clear; close all; clc

%% import 

load('C:\Twente\IUVO\PHASE2\SUB005\SUB005_yesExo_1_BOX.mat')

bx2 = squeeze(Datastr.Marker.MarkerData  (77, :, :)); %indice Box 3 o box 2

y_bx = bx2(2,:)';

tol =1e-3;
minLength=100;
% --- 1. Riempimento dei NaN (interpolazione lineare) ---
if any(isnan(y_bx))
    y_bx = fillmissing(y_bx, 'linear');
    % Se i NaN iniziano o finiscono ai bordi, riempi con il valore più vicino
    y_bx = fillmissing(y_bx, 'nearest');
end

% --- 2. Calcola la derivata assoluta ---
ds = abs(diff(y_bx));

% --- 3. Trova regioni piatte entro la tolleranza ---
flat = ds < tol;

% --- 4. Identifica inizio e fine dei plateau ---
dflat = diff([0; flat; 0]);
startIdx = find(dflat == 1);
endIdx   = find(dflat == -1) - 1;

% --- 5. Filtra per lunghezza minima ---
valid = (endIdx - startIdx + 1) >= minLength;
plateaus.Start = startIdx(valid);

plateaus.Stop  = endIdx(valid);

% plateaus.Start(21) = [];
% plateaus.Start(13) = [];
% plateaus.Start(10) = [];
% plateaus.Start(9) = [];
% 
% % 
% plateaus.Stop(21) = [];
% plateaus.Stop(12) = [];
% plateaus.Stop(9) = [];
% plateaus.Stop(8) = [];

% Plot del segnale
figure('Color','w');
plot( y_bx, 'b', 'LineWidth', 1.5); hold on;
xlabel('Time [s]');
ylabel('Amplitude');
title('Segnale con inizio e fine plateau');
grid on;

% Aggiungi linee verticali per inizio e fine plateau
for i = 1:length(plateaus.Start)
    xline(plateaus.Start(i), '--g', 'LineWidth', 1.5, 'Label', 'Start', 'LabelOrientation', 'horizontal');
    xline(plateaus.Stop(i), '--r', 'LineWidth', 1.5, 'Label', 'End', 'LabelOrientation', 'horizontal');
end

legend('Segnale', 'Inizio plateau', 'Fine plateau');



