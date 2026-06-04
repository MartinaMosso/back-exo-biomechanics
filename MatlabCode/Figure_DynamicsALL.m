%% === Fig. 4 — Dynamics (L5S1 joint moment): Peak reduction (%) ===
% Dati di input (sostituisci con i tuoi):
% Matrici nS x 3 (colonne: [Squat, Stoop, Bilateral]), righe = soggetti
% Esempio di struttura (SOSTITUISCI con i tuoi valori):
peakNoExo = [2.0467    2.6238    2.5065    2.2230    2.5761    1.9265 2.1818    2.1721;
2.0837    2.5571    2.3051    1.9917    1.9213    2.1484    2.2593    2.1557;
2.2973    2.5524    2.4099    2.2884    2.1910    2.2178    2.4513    2.1893]';
peakExo = [  1.7091    1.6700    1.4844    1.4459    1.3781    1.0149 1.2836    1.7674;
1.6626    1.9176    1.9249    1.6835    1.7709    1.6416    2.0082    2.2567;
1.4530    1.5372    1.6384    1.4802    1.9693    1.6023    1.7401    1.8373]';

% ===>> INCOLLA QUI I TUOI DATI <<===
% peakNoExo = [...];
% peakExo   = [...];

% --- Controlli di base ---
%% === Fig. 4 — Dynamics (L5S1 joint moment): Peak (mean ± SD) + significance ===
% Dati di input: nS x 3 (colonne = [Squat Stoop Bilateral])
% SOSTITUISCI con i tuoi valori:
% peakNoExo = [...];   % nS x 3


%% --------- STILE (copiato dal tuo EMG) ----------
clrNoExo = [120 160 160]/256;   % NoExo
clrExo   = [150  40 110]/256;   % Exo
fsBase   = 10;
barW     = 0.9;
ebLW     = 1.0; capSz = 6;
yPadFrac = 0.06;  % padding verticale per asterischi
tasks    = {'Squat','Stoop','Bilateral'};

% interpreti LaTeX
set(0,'defaultTextInterpreter','latex');
set(0,'defaultAxesTickLabelInterpreter','latex');
set(0,'defaultLegendInterpreter','latex');

% cartella output
outDir = fullfile(pwd,'fig'); if ~exist(outDir,'dir'), mkdir(outDir); end

%% --------- INSERISCI I TUOI DATI QUI ---------------------------------
% Matrici [nSoggetti x 3], colonne = [Squat Stoop Bilateral]
% peakNoExo = [...];   % nS x 3
% peakExo   = [...];   % nS x 3

% --- Controlli
assert(exist('peakNoExo','var')==1 && exist('peakExo','var')==1, ...
    'Inserisci peakNoExo e peakExo (nS x 3).');
assert(all(size(peakNoExo) == size(peakExo)), 'Le due matrici devono avere stessa dimensione nS x 3.');
[nS, nTasks] = size(peakNoExo); assert(nTasks==3, 'Usa 3 colonne: [Squat Stoop Bilateral].');

%% --------- STATISTICHE ------------------------------------------------
muNo = mean(peakNoExo,1,'omitnan');  sdNo = std(peakNoExo,0,1,'omitnan');
muEx = mean(peakExo,  1,'omitnan');  sdEx = std(peakExo,  0,1,'omitnan');

MU = [muNo(:), muEx(:)];   % 3x2
SD = [sdNo(:), sdEx(:)];   % 3x2

%% --------- FIGURA -----------------------------------------------------
fig = figure('Color','w','Units','centimeters','Position',[2 2 9 7]);
ax  = axes(fig); hold(ax,'on'); box(ax,'on');

% Barre raggruppate (NoExo, Exo)
b = bar(MU, 'grouped', 'BarWidth', barW);
b(1).FaceColor = clrNoExo; b(1).EdgeColor = 'k';
b(2).FaceColor = clrExo;   b(2).EdgeColor = 'k';

% Errorbar (± SD) centrati sulle barre
x1 = b(1).XEndPoints;  x2 = b(2).XEndPoints;
errorbar(x1, MU(:,1), SD(:,1), 'k', 'linestyle','none', 'LineWidth', ebLW, 'CapSize', capSz, 'HandleVisibility','off');
errorbar(x2, MU(:,2), SD(:,2), 'k', 'linestyle','none', 'LineWidth', ebLW, 'CapSize', capSz, 'HandleVisibility','off');

% Assi, etichette
set(ax,'XTick',1:3,'XTickLabel',tasks,'FontSize',fsBase);
ylabel(ax, 'Peak L5S1 moment (Nm/BW)', 'FontSize', fsBase);

% Legenda in alto a destra
legend([b(1) b(2)], {'NoExo','Exo'}, 'Location','northeast', ...
       'Box','off', 'FontSize', fsBase-1);

% Griglia stile reference
grid(ax,'on'); ax.GridLineStyle = ':'; ax.GridAlpha = 0.2;

% Limiti y con padding
yMax = max(MU(:)+SD(:)); yMin = min(MU(:)-SD(:)); yr = max(1e-6, yMax - yMin);
ylim(ax, [max(0, yMin - 0.05*yr), yMax + 0.15*yr]); % più spazio per bracket/asterischi

%% --------- SIGNIFICATIVITÀ: t-test appaiato e asterischi -------------
for t = 1:3
    [~, p] = ttest(peakNoExo(:,t), peakExo(:,t));    % paired
    if p < 0.05
        % quota della bracket sopra la coppia
        topL = MU(t,1) + SD(t,1);
        topR = MU(t,2) + SD(t,2);
        yB   = max(topL, topR) + yPadFrac*yr;
        % disegno linea orizzontale tra le due barre
        plot(ax, [x1(t) x2(t)], [yB yB], 'k-', 'LineWidth', 1, 'HandleVisibility','off');
        % asterischi
        text(mean([x1(t), x2(t)]), yB + 0.015*yr, p2ast(p), ...
            'HorizontalAlignment','center','VerticalAlignment','bottom', ...
            'FontSize', fsBase+2, 'FontWeight','bold');
    end
end

% Margini stretti
set(ax,'LooseInset', max(get(ax,'TightInset'), 0.02*[1 1 1 1]));
set(fig,'Renderer','painters'); % vettoriale

%% --------- ESPORTA ----------------------------------------------------
pdfFile = fullfile(outDir,'Fig4_L5S1_Peak_Bargroup_SD_sig.pdf');
pngFile = fullfile(outDir,'Fig4_L5S1_Peak_Bargroup_SD_sig.png');
exportgraphics(fig, pdfFile, 'ContentType','vector');
exportgraphics(fig, pngFile, 'Resolution', 600);
fprintf('Saved:\n  %s\n  %s\n', pdfFile, pngFile);

%% ===== helper: mappa p->asterischi (come nel tuo script EMG) ==========
function ast = p2ast(p)
if     p < 0.001, ast = '**';
elseif p < 0.01,  ast = '**';
elseif p < 0.05,  ast = '*';
else,             ast = '';
end
end