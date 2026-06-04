

clear; clc; close all;

%% 

boxID_0ST = importdata('C:\Twente\IUVO\SUB007\OS\DataFiles\SUB007noExo_ST_0XLD.mot');
% boxID_irfan = importdata('C:\Users\Dottorato\Downloads\OS\OS\DataFiles\SUB002noExo_ST_75BXID.sto')
boxID_5ST = importdata('C:\Twente\IUVO\SUB007\OS\DataFiles\SUB007noExo_ST_5XLD.mot');
boxID_10ST = importdata('C:\Twente\IUVO\SUB007\OS\DataFiles\SUB007noExo_ST_10XLD.mot');
boxID_15ST = importdata('C:\Twente\IUVO\SUB007\OS\DataFiles\SUB007noExo_ST_15XLD.mot');

boxID_0SQ = importdata('C:\Twente\IUVO\SUB007\OS\DataFiles\SUB007noExo_SQ_0XLD.mot');
% boxID_irfan = importdata('C:\Users\Dottorato\Downloads\OS\OS\DataFiles\SUB002noExo_ST_75BXID.sto')
boxID_5SQ = importdata('C:\Twente\IUVO\SUB007\OS\DataFiles\SUB007noExo_SQ_5XLD.mot');
boxID_10SQ = importdata('C:\Twente\IUVO\SUB007\OS\DataFiles\SUB007noExo_SQ_10XLD.mot');
boxID_15SQ = importdata('C:\Twente\IUVO\SUB007\OS\DataFiles\SUB007noExo_SQ_15XLD.mot');


figure
subplot(2,2,1)
% plot(movmean(boxID.data(:,21), 25));
hold on
plot(boxID_0ST.data(:,27), LineWidth=2);
plot(boxID_0SQ.data(:,27), LineWidth=2);

subplot(2,2,2)
plot(boxID_5ST.data(:,27), LineWidth=2);
hold on; plot(boxID_5SQ.data(:,27), LineWidth=2);

subplot(2,2,3)
hold on
plot(boxID_10ST.data(:,27), LineWidth=2);
plot(boxID_10SQ.data(:,27), LineWidth=2);

subplot(2,2,4)
hold on
plot(boxID_15ST.data(:,27), LineWidth=2);
plot(boxID_15SQ.data(:,27), LineWidth=2);

title('Hand Force');
xlabel('Time', 'FontSize', 14)
ylabel('Forces [N]', 'FontSize', 14)
grid on
legend('0kg', '5kg', '10kg', '15kg')


figure %% chest
subplot(3,1,1)
plot(boxID.data(1900:2500,32:34), LineWidth=2);
title('Chest Force', 'FontSize', 14);
xlabel('Time', 'FontSize', 14)
ylabel('Forces [N]', 'FontSize', 14)
grid on

% figure %% leg
subplot(3,1,2)
plot(boxID.data(1900:2500,38:40), LineWidth=2);
title('Leg Force', 'FontSize', 14);
xlabel('Time', 'FontSize', 14)
ylabel('Forces [N]', 'FontSize', 14)
grid on

% figure %% pelvis
subplot(3,1,3)
plot(boxID.data(1900:2500,50:52), LineWidth=2);
title('Pelvis Force', 'FontSize', 14);
xlabel('Time', 'FontSize', 14)
ylabel('Forces [N]', 'FontSize', 14)
grid on

%%
forces = boxID.data(:, 5:7);
forces_IR = boxID_irfan.data(:,5:7)
figure
plot(forces(:,1))
hold on
plot(forces_IR(:,1))
figure
plot(forces(:,2))
hold on
plot(forces_IR(:,2))
figure
plot(forces(:,3))
hold on
plot(forces_IR(:,3))


%% change ground reaction forces

% Carica il file .mot
filename = 'C:\Twente\IUVO\SUB009_ricostruiti\OS\DataFiles\SUB009_ricostruitinoExo_SQ_10_noProvaXLD.mot'; % Sostituisci con il nome corretto
data = importdata(filename);

% Identifica la riga dell'header
headerLines = find(contains(data.textdata, 'endheader'), 1); 
if isempty(headerLines)
    error('Header not found, check the file format.');
end

% Estrarre l'intestazione
header = data.textdata(1:headerLines, :);

% Estrarre i dati numerici
numericData = data.data;

% Definisci le colonne da scambiare (modifica gli indici in base alle tue necessità)
% col1 = [3, 9, 6, 12]; % Indice della prima colonna
% col2 = [4, 10, 7, 13]; % Indice della seconda colonna

col1 = [3, 6]; % Indice della prima colonna
col2 = [4, 7]; % Indice della seconda colonna

for i = 1:2
% Scambia le colonne
temp = numericData(:, col1(i));
numericData(:, col1(i)) = numericData(:, col2(i));
numericData(:, col2(i)) = temp;
end
% Salva il nuovo file
outputFile = 'modified_file.mot';
fid = fopen(outputFile, 'w');
for i = 1:length(header)
    fprintf(fid, '%s\n', header{i});
end
fclose(fid);

% Aggiungi i dati numerici
dlmwrite(outputFile, numericData, '-append', 'delimiter', '\t', 'precision', 6);

disp('File modificato e salvato con successo.');
