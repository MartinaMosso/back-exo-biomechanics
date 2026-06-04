%% ID from CEINMS and OS
clear; close all; clc

%% SQUAT 5

load('C:\Twente\IUVO\SUB011\SUB011_noExo_SQ_5.mat')
SQ_5 = Datastr;

SQ_5_os = importdata('C:\Twente\IUVO\SUB011\CEINMS\execution\OP\EMG\SUB011noExo_SQ_5\torques.sto');
% SQ_5_SQST= importdata('C:\Twente\IUVO\SUB011\CEINMS\execution\OP\EMG\CalibSQ_ST0_5_10\SUB011noExo_SQ_5\Torques.sto');

figure;
hold on; plot(movmean(SQ_5_os.data(:,end), 30), LineWidth=2)
% hold on; plot(movmean(SQ_5_SQST.data(:,end), 30), LineWidth=2)
plot(SQ_5.Resample.IDTrqData(:,18), '--k', LineWidth=2)
grid on

title('SQUAT 5: L5S1 moment')
xlabel('Time [Frame]')
ylabel('Moment [Nm]')
legend( 'CEINMS', 'OS')

%% squat 0
load('C:\Twente\IUVO\SUB011\SUB011_noExo_SQ_0.mat')
SQ_0 = Datastr;

SQ_0_os = importdata('C:\Twente\IUVO\SUB011\CEINMS\execution\OP\EMG\SUB011noExo_SQ_0\torques.sto');
% SQ_5_SQST= importdata('C:\Twente\IUVO\SUB011\CEINMS\execution\OP\EMG\CalibSQ_ST0_5_10\SUB011noExo_SQ_0\Torques.sto');

figure
hold on; plot(movmean(SQ_0_os.data(:,end), 20), LineWidth=2)
% hold on; plot(movmean(SQ_5_SQST.data(:,end), 20), LineWidth=2)
plot(SQ_0.Resample.IDTrqData(:,18), '--k', LineWidth=2)
grid on
title('SQUAT 0: L5S1 moment')
xlabel('Time [Frame]')
ylabel('Moment [Nm]')
legend( 'CEINMS', 'OS')

%% squat 10
load('C:\Twente\IUVO\SUB005\SUB005_noExo_SQ_10.mat')
SQ_10 = Datastr;

SQ_10_os = importdata('C:\Twente\IUVO\SUB005\CEINMS\execution\OP\EMG\SUB005noExo_SQ_10\torques.sto');
% SQ_5_SQST= importdata('C:\Twente\IUVO\SUB011\CEINMS\execution\OP\EMG\CalibSQ_ST0_5_10\SUB011noExo_SQ_10\Torques.sto');

figure
grid on
hold on; plot(movmean(SQ_10_os.data(:,end), 20), LineWidth=2)
% hold on; plot(movmean(SQ_5_SQST.data(:,end), 20), LineWidth=2)
plot(SQ_10.Resample.IDTrqData(:,18), '--k', LineWidth=2)
title('SQUAT 10: L5S1 moment')
xlabel('Time [Frame]')
ylabel('Moment [Nm]')
legend( 'CEINMS', 'OS')
%% squat 15
load('C:\Twente\IUVO\SUB011\SUB011_noExo_SQ_15.mat')
SQ_15 = Datastr;

SQ_15_os = importdata('C:\Twente\IUVO\SUB011\CEINMS\execution\OP\EMG\SUB011noExo_SQ_15\torques.sto');
% SQ_5_SQST= importdata('C:\Twente\IUVO\SUB011\CEINMS\execution\OP\EMG\CalibSQ_ST0_5_10\SUB011noExo_SQ_15\Torques.sto');

figure
grid on
hold on; plot(movmean(SQ_15_os.data(:,end), 20), LineWidth=2)
% hold on; plot(movmean(SQ_5_SQST.data(:,end), 20), LineWidth=2)
plot(SQ_15.Resample.IDTrqData(:,18), '--k', LineWidth=2)
title('SQUAT 15: L5S1 moment')
xlabel('Time [Frame]')
ylabel('Moment [Nm]')
legend( 'CEINMS', 'OS')

%% STOOP 5

load('C:\Twente\IUVO\SUB011\SUB011_noExo_ST_5.mat')
ST_5 = Datastr;

ST_5_os = importdata('C:\Twente\IUVO\SUB011\CEINMS\execution\OP\EMG\SUB011noExo_ST_5\Torques.sto');
% ST_5_os = importdata('C:\Twente\IUVO\SUB011\CEINMS\execution\OP\EMG\CalibSQ_ST0_5_10\SUB011noExo_ST_5\Torques.sto');

figure;plot(ST_5.Resample.IDTrqData(:,18), LineWidth=2)
hold on; plot(movmean(ST_5_os.data(:,end), 20),LineWidth=2)
title('STOOP 5: L5S1 moment')
xlabel('Time [Frame]')
ylabel('Moment [Nm]')
legend('OS', 'CEINMS')


%% STOOP 0
load('C:\Twente\IUVO\SUB011\SUB011_noExo_ST_0.mat')
ST_0 = Datastr;

ST_0_os = importdata('C:\Twente\IUVO\SUB011\CEINMS\execution\OP\EMG\CalibSQ_ST0_5_10\SUB011noExo_ST_0\torques.sto');

figure;plot(ST_0.Resample.IDTrqData(:,18))
hold on; plot(movmean(ST_0_os.data(:,end), 20))

%% STOOP 10
load('C:\Twente\IUVO\SUB005\SUB005_noExo_SQ_10.mat')
ST_10 = Datastr;

ST_10_os = importdata('C:\Twente\IUVO\SUB005\CEINMS\execution\OP\EMG\SUB005noExo_SQ_10\torques.sto');
% ST_5_SQST= importdata('C:\Twente\IUVO\SUB011\CEINMS\execution\OP\EMG\CalibSQ_ST0_5_10\SUB011noExo_ST_10\Torques.sto');
ST_10_os=movmean(ST_10_os.data(:,end), 20);
figure
grid on
hold on; plot(movmean(ST_10_os,20)/(Datastr.Info.subjMass),  LineWidth=2)
% hold on; plot(movmean(ST_5_SQST.data(:,end), 20), LineWidth=2)
plot(ST_10.Resample.IDTrqData(:,18)/(Datastr.Info.subjMass), '--k', LineWidth=2)
title('STOOP 10: L5S1 moment')
xlabel('Time [Frame]')
ylabel('Moment [Nm]')
legend( 'CEINMS', 'OS')

%%
torque_os     = [ST_10.Resample.IDTrqData(1700:2200,18)/(Datastr.Info.subjMass)];   % <-- OpenSim
torque_ceinms = [movmean(ST_10_os(1700:2200)/(Datastr.Info.subjMass), 20)];   % <-- CEINMS

% (Facoltativo) Esempio fittizio:
%{
N = 250;
t = linspace(0,1,N)';
torque_os     = 60 + 15*sin(2*pi*(t-0.1)) + 2*randn(N,1);
torque_ceinms = 58 + 14*sin(2*pi*(t-0.08)) + 2*randn(N,1);
%}



assert(~isempty(torque_os) && ~isempty(torque_ceinms), 'Inserisci i vettori.');
assert(numel(torque_os)==numel(torque_ceinms), 'Le due serie devono avere la stessa lunghezza.');
torque_os     = torque_os(:);
torque_ceinms = torque_ceinms(:);

%% === Pulizia base e (opzionale) smoothing di OpenSim ===
% Se servisse, converti N·mm -> Nm/BW prima di arrivare qui.
% Utility minima per riempire eventuali NaN agli interni:
fillnan = @(y) (any(isnan(y)) * fillmissing(y,'pchip') + ~any(isnan(y)) * y);
os_raw = fillnan(double(torque_os));
ce_raw = fillnan(double(torque_ceinms));

% Smooth SOLO OpenSim (Savitzky–Golay) — puoi commentare se non serve
N   = numel(os_raw);
win = max(5, 2*floor((N/25)/2)+1);  % finestra ~ N/25, dispari
ord = 3;
os_use = sgolayfilt(os_raw, ord, win);
ce_use = ce_raw;

%% === Ascissa in percentuale 0–100 (nessuna interpolazione) ===
x_pct = linspace(0,100,N);  % un valore per ogni campione originale

%% === Stile ===
clrOS = [230 120  20]/255;   % arancione
clrCE = [  0 150 170]/255;   % turchese
lw    = 1.8; fs = 11;

%% === Figura ===
fig = figure('Color','w','Units','centimeters','Position',[2 2 16 9]);
ax = axes('Position',[0.10 0.18 0.86 0.74]); hold(ax,'on'); box(ax,'on');

p1 = plot(ax, x_pct, os_use, '-', 'Color', clrOS, 'LineWidth', lw);
p2 = plot(ax, x_pct, ce_use, '-', 'Color', clrCE, 'LineWidth', lw);

set(ax,'XLim',[0 100], 'XTick',0:25:100, 'FontSize', fs);
xlabel(ax,'Movement cycle [\%]','FontSize',fs);
ylabel(ax,'L5--S1 moment [Nm/BW]','FontSize',fs);
grid(ax,'on'); ax.GridLineStyle=':'; ax.GridAlpha=0.25;
ax.YAxis.Exponent = 0; % evita ×10^k

% Legenda in alto a destra
lg = legend(ax,[p1 p2], {'OpenSim','CEINMS'}, ...
    'Location','northeast','Box','off','Color','none','FontSize',fs-1);

set(fig,'Renderer','painters'); % PDF vettoriale

%% === Export ===
outDir = fullfile(pwd,'fig'); if ~exist(outDir,'dir'), mkdir(outDir); end
exportgraphics(fig, fullfile(outDir,'Fig_CEINMS_Validation.pdf'), 'ContentType','vector');
exportgraphics(fig, fullfile(outDir,'Fig_CEINMS_Validation.png'), 'Resolution',600);

%% ====== CHECK INPUT ======
assert(numel(torque_os)==numel(torque_ceinms) && ~isempty(torque_os), ...
    'I vettori torque_os e torque_ceinms devono esistere e avere la stessa lunghezza.');
torque_os     = torque_os(:);
torque_ceinms = torque_ceinms(:);

%% ====== STILE ======
clrOS   = [230 120  20]/255;   % arancione (non default MATLAB)
clrCE   = [  0 150 170]/255;   % turchese
lw      = 1.8;                 % spessore linee
fsBase  = 11;

set(0,'defaultTextInterpreter','latex');
set(0,'defaultAxesTickLabelInterpreter','latex');
set(0,'defaultLegendInterpreter','latex');

outDir = fullfile(pwd,'fig'); if ~exist(outDir,'dir'), mkdir(outDir); end

%% ====== NORMALIZZA L’ASCISSA A 0–100% ======
% N = numel(torque_os);
% x_raw = linspace(0,100,N);           % %
% % (opzionale) resampling uniformato a 101 punti esatti (0..100)
% xq = 0:100:1000;
% os_q = interp1(x_raw, torque_os,     xq, 'pchip');
% ce_q = interp1(x_raw, torque_ceinms, xq, 'pchip');
N = numel(torque_os);
win = max(5, 2*floor((N/25)/2)+1);   % arrotonda a dispari >=5
ord = 3;                             % non superare win-2
os_smooth = sgolayfilt(torque_os, ord, win);

xq = linspace(0,100,1000);
os_q = interp1(linspace(0,100,numel(torque_os)), torque_os, xq, 'pchip');
ce_q = interp1(linspace(0,100,numel(torque_ceinms)), torque_ceinms, xq, 'pchip');


%% ====== PLOT ======
fig = figure('Color','w','Units','centimeters','Position',[2 2 16 9]);
ax = axes('Position',[0.10 0.18 0.86 0.74]); hold(ax,'on'); box(ax,'on');

p1 = plot(ax, xq, os_q, '-', 'Color', [230 120 20]/255, 'LineWidth', 1.8);   % arancione
p2 = plot(ax, xq, ce_q, '-', 'Color', [0 150 170]/255, 'LineWidth', 1.8);    % turchese

set(ax,'XLim',[0 100],'XTick',0:25:100,'FontSize',11);
xlabel(ax,'Movement cycle [\%]','FontSize',11);
ylabel(ax,'L5--S1 moment [Nm/BW]','FontSize',11);

grid(ax,'on'); ax.GridLineStyle=':'; ax.GridAlpha=0.25;
ax.YAxis.Exponent = 0;   % evita notazione ×10^k sull’asse Y

lg = legend(ax,[p1 p2], {'OpenSim','CEINMS'}, ...
    'Location','northeast','Box','off','FontSize',10);

set(lg,'Color','none'); % sfondo trasparente

%% ====== FIGURA ======
% fig = figure('Color','w','Units','centimeters','Position',[2 2 16 9]);
% axes('Position',[0.10 0.18 0.86 0.74]); hold on; box on;
% 
% p1 = plot(xq, os_q, '-',  'Color', clrOS, 'LineWidth', lw);
% p2 = plot(xq, ce_q, '-',  'Color', clrCE, 'LineWidth', lw);
% 
% % Assi e tick 0,25,50,75,100%
% set(gca,'XLim',[0 1000], 'XTick',0:25:100, 'FontSize', fsBase);
% xlabel('Movement cycle [\%]','FontSize',fsBase);
% ylabel('L5--S1 moment [Nm/BW]','FontSize',fsBase);   % se usi Nm/BW cambia la label
% grid on; ax = gca; ax.GridLineStyle=':'; ax.GridAlpha=0.25;
% 
% % Legenda
% lg = legend([p1 p2], {'OpenSim','CEINMS'}, ...
%     'Location','northeast','Box','off','FontSize',fsBase-1);
% 
% % Margini e renderer per PDF vettoriale

%% ====== ESPORTA ======
pdfFile = fullfile(outDir,'Fig_CEINMS_Validation.pdf');
pngFile = fullfile(outDir,'Fig_CEINMS_Validation.png');
exportgraphics(fig, pdfFile, 'ContentType','vector');
exportgraphics(fig, pngFile, 'Resolution',600);
fprintf('Saved:\n  %s\n  %s\n', pdfFile, pngFile);
