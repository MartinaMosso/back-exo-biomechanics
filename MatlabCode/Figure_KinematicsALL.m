%% Plot Kinematic Paper P!

clear; clc; close all

%% data
% ROM [deg]
rom_sq_noexo = [4.7087 3.4830 6.3629 3.5573 5.0176 4.5549 6.9505 7.1550];  % squat senza exo
rom_sq_exo   = [ 4.1063  4.7040 4.6750 5.0498 5.5086 4.1268  5.8258 6.7400];  % squat con exo

rom_st_noexo = [5.6940 5.9444 8.2356 3.7944 4.0257 4.5467 7.2916  7.4424];  % stoop senza exo
rom_st_exo   = [3.8453 7.0973 9.2326 4.6708 4.7493 4.6248 6.7697 8.5010];  % stoop con exo

rom_bl_noexo = [4.0477    4.8467    7.1678    4.4190    4.8792    5.6564    7.0424    5.9817];  % bilateral senza exo
rom_bl_exo   = [ 4.1227    5.8566    5.8488    6.0446    5.4125    6.6873    5.8698    6.0064];  % bilateral con exo

% Mean angle [deg]
mean_sq_noexo = [   -2.8055 -7.1403 -5.0579 -4.0216 -4.3733 -3.7694 -3.0752 -4.4183];
mean_sq_exo   = [-1.9469 -7.9809 -5.4098 -5.0076 -5.0369 -3.3336  -2.8893  -4.2322];

mean_st_noexo = [  -2.2942 -8.2221 -6.2921  -4.8072 -3.8369 -3.2179 -2.5103 -3.8615];
mean_st_exo   = [  -2.0681 -8.2721 -6.1019 -5.4606 -5.1697 -3.5996 -2.7808 -4.7965];

mean_bl_noexo = [-3.3976   -7.8264   -5.5268   -6.3426   -4.6678   -3.9054   -2.6649   -4.8063];
mean_bl_exo   = [-2.6259   -8.2720   -5.5830   -6.7342   -4.7886   -3.9590   -3.1195   -5.4170];

%%
D.squat.ROM_noexo   = rom_sq_noexo(:);
D.squat.ROM_exo     = rom_sq_exo(:);
D.squat.Mean_noexo  = mean_sq_noexo(:);
D.squat.Mean_exo    = mean_sq_exo(:);

D.stoop.ROM_noexo   = rom_st_noexo(:);
D.stoop.ROM_exo     = rom_st_exo(:);
D.stoop.Mean_noexo  = mean_st_noexo(:);
D.stoop.Mean_exo    = mean_st_exo(:);

D.bilateral.ROM_noexo  = rom_bl_noexo(:);
D.bilateral.ROM_exo    = rom_bl_exo(:);
D.bilateral.Mean_noexo = mean_bl_noexo(:);
D.bilateral.Mean_exo   = mean_bl_exo(:);

% ====== CREA LA FIGURA (PDF+PNG) ======
CREATE_ROM_MEAN_BARS(D, './fig/Fig_IK_ROM_Mean');

%% p-value
p_ROM   = [0.75 0.3 0.56];   % esempio: squat, stoop, bilateral
p_MEAN  = [0.55 0.4 0.30];   % esempio: squat, stoop, bilateral

% p2ast = @(p) ternary(p<0.001,'***', ternary(p<0.01,'**', ternary(p<0.05,'*','')) );





%% setting
clrNoExo = [120 160 160]/256;  % colori forniti
clrExo   = [150  40 110]/256;

colNoExo = [120 160 160]/256;  % colori forniti
colExo   = [150  40 110]/256;

tasks = {'Squat','Stoop','Bilateral'};
cond  = {'NoExo','Exo'};

fsBase   = 10;     % font base
lwMedian = 1.2;    % spessore linea mediana box
ms       = 5;      % marker size per overlay punti
boxW     = 0.26;    % larghezza box (boxchart)
sep      = 0.33;   % separazione orizzontale tra NoExo ed Exo
rng(1);            % per jitter riproducibile

% Crea cartella output
outDir = fullfile(pwd,'fig');
if ~exist(outDir,'dir'), mkdir(outDir); end

% Imposta rendering e interpreti
set(0,'defaultTextInterpreter','latex');
set(0,'defaultAxesTickLabelInterpreter','latex');
set(0,'defaultLegendInterpreter','latex');

% ====== Impostazioni comuni ======
pos = [1 2  4 5  7 8];   % coppie (SQ, ST, BL) con spazio tra task
xt  = [mean(pos(1:2)) mean(pos(3:4)) mean(pos(5:6))];
task_labels = {'Squat','Stoop','Bilateral'};

% ====== FIGURA ======
figure('Color','w','Units','centimeters','Position',[2 2 18 10]);
tiledlayout(2,1,'Padding','compact','TileSpacing','compact');


%% ======= ROM =======
nexttile
ROM = [rom_sq_noexo rom_sq_exo rom_st_noexo rom_st_exo rom_bl_noexo rom_bl_exo]';
grp = [...
    repmat({'SQ-NoExo'},8,1);
    repmat({'SQ-Exo'},8,1);
    repmat({'ST-NoExo'},8,1);
    repmat({'ST-Exo'},8,1);
    repmat({'BL-NoExo'},8,1);
    repmat({'BL-Exo'},8,1)];

h = boxplot(ROM,grp,'Positions',pos,'Widths',0.55,'Symbol','k+','Colors',[0 0 0]);
set(h,{'LineWidth'},{1.1}); hold on; grid on

boxes = flipud(findobj(gca,'Tag','Box'));
for i = 1:numel(boxes)
    if mod(i,2)==1
        patch(get(boxes(i),'XData'), get(boxes(i),'YData'), colNoExo, ...
            'FaceAlpha',0.4, 'EdgeColor','k');
    else
        patch(get(boxes(i),'XData'), get(boxes(i),'YData'), colExo, ...
            'FaceAlpha',0.4, 'EdgeColor','k');
    end
end

set(gca,'XTick',xt,'XTickLabel',task_labels,'FontName','Arial','FontSize',14);
ylabel('L5S1 Flex-Ext ROM [deg]','FontName','Arial','FontSize',14);
title('Range of Motion','FontName','Arial','FontWeight','normal','FontSize',14);
yl = ylim;
plot([3 3; 6 6],[yl(1) yl(2); yl(1) yl(2)],':','Color',[0.7 0.7 0.7]);

% legenda
p1 = patch(NaN,NaN,colNoExo,'FaceAlpha',0.4,'EdgeColor','k');
p2 = patch(NaN,NaN,colExo,'FaceAlpha',0.4,'EdgeColor','k');
% legend([p1 p2],{'NoExo','Exo'},'Location','northeast','Orientation','horizontal','Box','off','FontSize',10);

%% ======= MEAN =======
nexttile
MEAN = [mean_sq_noexo mean_sq_exo mean_st_noexo mean_st_exo mean_bl_noexo mean_bl_exo]';
h2 = boxplot(MEAN,grp,'Positions',pos,'Widths',0.55,'Symbol','k+','Colors',[0 0 0]);
set(h2,{'LineWidth'},{1.1}); hold on; grid on

boxes2 = flipud(findobj(gca,'Tag','Box'));
for i = 1:numel(boxes2)
    if mod(i,2)==1
        patch(get(boxes2(i),'XData'), get(boxes2(i),'YData'), colNoExo, ...
            'FaceAlpha',0.4, 'EdgeColor','k');
    else
        patch(get(boxes2(i),'XData'), get(boxes2(i),'YData'), colExo, ...
            'FaceAlpha',0.4, 'EdgeColor','k');
    end
end

set(gca,'XTick',xt,'XTickLabel',task_labels,'FontName','Arial','FontSize',14);
ylabel('Mean [deg]','FontName','Arial','FontSize',14);
% title('Mea','FontName','Arial','FontWeight','normal','FontSize',14);
yl = ylim;
plot([3 3; 6 6],[yl(1) yl(2); yl(1) yl(2)],':','Color',[0.7 0.7 0.7]);%% ---------- VALIDAZIONE INPUT ----------
req = {rom_sq_noexo, rom_sq_exo, rom_st_noexo, rom_st_exo, rom_bl_noexo, rom_bl_exo, ...
       mean_sq_noexo, mean_sq_exo, mean_st_noexo, mean_st_exo, mean_bl_noexo, mean_bl_exo};
if any(cellfun(@isempty, req))
    warning('Alcuni vettori sono vuoti. Inserisci i dati prima di eseguire il salvataggio.');
end
%% export
exportgraphics(gcf,'Boxplot_ROM_Mean_out.pdf', ...
    'ContentType','vector', ...
    'BackgroundColor','none', ...
    'Resolution',300);
%% ---------- PREPARA FIGURA ----------
fig = figure('Color','w','Units','centimeters','Position',[2 2 17 13]); % dimensioni per journal
tiledlayout(fig,1,2,'Padding','compact','TileSpacing','compact');

% ===================== PANNELLO (A): ROM =====================
nexttile(1); hold on; box on;
title('(A) ROM L5S1','FontSize',fsBase+1,'FontWeight','bold');

% posizioni per i 3 task (1,2,3) e offset per condizioni
xBase = 1:3;
xNoExo = xBase - sep/2;
xExo   = xBase + sep/2;

% Dati ROM per condizione
romNoExo = {rom_sq_noexo, rom_st_noexo, rom_bl_noexo};
romExo   = {rom_sq_exo,   rom_st_exo,   rom_bl_exo};

% Plot NoExo
for i = 1:3
    if ~isempty(romNoExo{i})
        b = boxchart(ones(size(romNoExo{i}))*xNoExo(i), romNoExo{i}, ...
            'BoxFaceColor', clrNoExo, 'BoxEdgeColor', 'k', 'WhiskerLineColor','k', ...
            'LineWidth', lwMedian, 'BoxWidth', boxW);
        set(b,'MarkerStyle','none'); % niente marker default
        swarmchart(ones(size(romNoExo{i}))*xNoExo(i), romNoExo{i}, ms, 'filled', ...
            'MarkerFaceColor', clrNoExo, 'MarkerEdgeColor','k', 'XJitter','density','XJitterWidth',0.12);
    end
end

% Plot Exo
for i = 1:3
    if ~isempty(romExo{i})
        b = boxchart(ones(size(romExo{i}))*xExo(i), romExo{i}, ...
            'BoxFaceColor', clrExo, 'BoxEdgeColor', 'k', 'WhiskerLineColor','k', ...
            'LineWidth', lwMedian, 'BoxWidth', boxW);
        set(b,'MarkerStyle','none');
        swarmchart(ones(size(romExo{i}))*xExo(i), romExo{i}, ms, 'filled', ...
            'MarkerFaceColor', clrExo, 'MarkerEdgeColor','k', 'XJitter','density','XJitterWidth',0.12);
    end
end

xlim([0.4 3.6]);
set(gca,'XTick',xBase,'XTickLabel',tasks,'FontSize',fsBase);
ylabel('ROM [deg]','FontSize',fsBase);
% Legend (patch per coerenza cromatica)
p1 = patch(NaN,NaN,clrNoExo,'EdgeColor','k'); 
p2 = patch(NaN,NaN,clrExo,  'EdgeColor','k');
legend([p1 p2], {'NoExo','Exo'}, 'Location','northwest','Box','off','FontSize',fsBase-1);

% ---- Asterischi ROM (usa p_ROM) ----
yL = ylim; yr = diff(yL);
for i = 1:3
    pv = p_ROM(i);
    % costruisci l'etichetta in base al p-value
    ast = '';
    if ~isnan(pv)
        if     pv < 0.001, ast = '***';
        elseif pv < 0.01,  ast = '**';
        elseif pv < 0.05,  ast = '*';
        end
    end
    if ~isempty(ast)
        % altezza poco sopra i dati di quel task
        yMax_i = max([romNoExo{i}(:); romExo{i}(:)], [], 'omitnan');
        yH = yMax_i + 0.08*yr;
        plot([xNoExo(i) xExo(i)], [yH yH], 'k-', 'LineWidth', 1);
        text(mean([xNoExo(i) xExo(i)]), yH + 0.02*yr, ast, ...
             'HorizontalAlignment','center','VerticalAlignment','bottom', ...
             'FontSize',fsBase+2,'FontWeight','bold');
    end
end

% ===================== PANNELLO (B): MEAN ANGLE =====================
nexttile(2); hold on; box on;
title('(B) Mean L5S1 angle','FontSize',fsBase+1,'FontWeight','bold');

meanNoExo = {mean_sq_noexo, mean_st_noexo, mean_bl_noexo};
meanExo   = {mean_sq_exo,   mean_st_exo,   mean_bl_exo};

% Plot NoExo
for i = 1:3
    if ~isempty(meanNoExo{i})
        b = boxchart(ones(size(meanNoExo{i}))*xNoExo(i), meanNoExo{i}, ...
            'BoxFaceColor', clrNoExo, 'BoxEdgeColor', 'k', 'WhiskerLineColor','k', ...
            'LineWidth', lwMedian, 'BoxWidth', boxW);
        set(b,'MarkerStyle','none');
        swarmchart(ones(size(meanNoExo{i}))*xNoExo(i), meanNoExo{i}, ms, 'filled', ...
            'MarkerFaceColor', clrNoExo, 'MarkerEdgeColor','k', 'XJitter','density','XJitterWidth',0.12);
    end
end

% Plot Exo
for i = 1:3
    if ~isempty(meanExo{i})
        b = boxchart(ones(size(meanExo{i}))*xExo(i), meanExo{i}, ...
            'BoxFaceColor', clrExo, 'BoxEdgeColor', 'k', 'WhiskerLineColor','k', ...
            'LineWidth', lwMedian, 'BoxWidth', boxW);
        set(b,'MarkerStyle','none');
        swarmchart(ones(size(meanExo{i}))*xExo(i), meanExo{i}, ms, 'filled', ...
            'MarkerFaceColor', clrExo, 'MarkerEdgeColor','k', 'XJitter','density','XJitterWidth',0.12);
    end
end

xlim([0.4 3.6]);
set(gca,'XTick',xBase,'XTickLabel',tasks,'FontSize',fsBase);
ylabel('Mean angle [deg]','FontSize',fsBase);

% Linee guida sottili per leggibilità
arrayfun(@(y) plot([0.4 3.6],[y y],'k:','LineWidth',0.4), ylim);

% ---- Asterischi Mean (usa p_MEAN) ----
yL = ylim; yr = diff(yL);

for i = 1:3
    pv = p_MEAN(i);
    ast = '';
    if ~isnan(pv)
        if     pv < 0.001, ast = '***';
        elseif pv < 0.01,  ast = '**';
        elseif pv < 0.05,  ast = '*';
        end
    end
    if ~isempty(ast)
        yMax_i = max([meanNoExo{i}(:); meanExo{i}(:)], [], 'omitnan');
        yH = yMax_i + 0.08*yr;
        plot([xNoExo(i) xExo(i)], [yH yH], 'k-', 'LineWidth', 1);
        text(mean([xNoExo(i) xExo(i)]), yH + 0.02*yr, ast, ...
             'HorizontalAlignment','center','VerticalAlignment','bottom', ...
             'FontSize',fsBase+2,'FontWeight','bold');
    end
end
%% ---------- ESPORTAZIONE ----------
% Consiglio: PDF vettoriale (perfetto per Overleaf). PNG 600 dpi per eventuale preview.
set(fig,'Renderer','painters'); % vector-safe
pdfFile = fullfile(outDir,'Fig_Kinematics.pdf');
pngFile = fullfile(outDir,'Fig_Kinematics.png');
exportgraphics(fig, pdfFile, 'ContentType','vector');
exportgraphics(fig, pngFile, 'Resolution',600);

fprintf('Saved:\n  %s\n  %s\n', pdfFile, pngFile);

%% % ===== BOX 1: ROM =====
nexttile
ROM = [rom_sq_noexo rom_sq_exo rom_st_noexo rom_st_exo rom_bl_noexo rom_bl_exo]';
group = [...
    repmat({'SQ-NoExo'},8,1);
    repmat({'SQ-Exo'},8,1);
    repmat({'ST-NoExo'},8,1);
    repmat({'ST-Exo'},8,1);
    repmat({'BL-NoExo'},8,1);
    repmat({'BL-Exo'},8,1)];

boxplot(ROM, group, 'Colors',[0.3 0.3 0.3],'Symbol','k.');
title('L5S1 Flex-Ext Range of Motion','FontWeight','bold')
ylabel('Angle [deg]')
grid on
set(gca,'FontSize',11,'XTickLabelRotation',30)

% ===== BOX 2: Mean angle =====
nexttile
Mean = [mean_sq_noexo mean_sq_exo mean_st_noexo mean_st_exo mean_bl_noexo mean_bl_exo]';
group = [...
    repmat({'SQ-NoExo'},8,1);
    repmat({'SQ-Exo'},8,1);
    repmat({'ST-NoExo'},8,1);
    repmat({'ST-Exo'},8,1);
    repmat({'BL-NoExo'},8,1);
    repmat({'BL-Exo'},8,1)];

boxplot(Mean, group, 'Colors',[0.3 0.3 0.3],'Symbol','k.');
title('Mean L5S1 Flex-Ext Angle','FontWeight','bold')
ylabel('Angle [deg]')
grid on
set(gca,'FontSize',11,'XTickLabelRotation',30)

% ===== Layout generale =====
sgtitle('Comparison of L5S1 Angles across Lifting Tasks (NoExo vs Exo)','FontWeight','bold');

%%
function CREATE_ROM_MEAN_BARS(D, outfile)
clrNoExo = [120 160 160]/256;   % NoExo (più scuro)
clrExo   = [150  40 110]/256;   % Exo   (più scuro)
fsBase   = 11;      % font base
barW     = 0.8;     % larghezza gruppo (per categoria ROM/Mean)
ebLW     = 1.1;     % spessore barre d'errore
astFS    = 12;      % font asterisco
yPad     = 0.06;    % padding verticale per asterischi (in frazione del range)

% interpreti LaTeX (come nel tuo file)
set(0,'defaultTextInterpreter','latex');
set(0,'defaultAxesTickLabelInterpreter','latex');
set(0,'defaultLegendInterpreter','latex');

% cartella output
outDir = fullfile(pwd,'fig');
if ~exist(outDir,'dir'), mkdir(outDir); end

catLabels = {'ROM','Mean'};

%% ---------- PACK DATI ----------
% Ogni subplot ha due categorie {ROM, Mean}, ognuna con due barre {NoExo, Exo}.
% Se p = NaN viene calcolato il paired t-test (richiede vettori stessa lunghezza).

SQUAT = struct('name','Squat', ...
  'data',{{ {D.squat.ROM_noexo,   D.squat.ROM_exo,   NaN}, ...
            {D.squat.Mean_noexo,  D.squat.Mean_exo,  NaN} }});

STOOP = struct('name','Stoop', ...
  'data',{{ {D.stoop.ROM_noexo,   D.stoop.ROM_exo,   NaN}, ...
            {D.stoop.Mean_noexo,  D.stoop.Mean_exo,  NaN} }});

BILAT = struct('name','Bilateral', ...
  'data',{{ {D.bilateral.ROM_noexo,   D.bilateral.ROM_exo,   NaN}, ...
            {D.bilateral.Mean_noexo,  D.bilateral.Mean_exo,  NaN} }});

PLOTS = {SQUAT, STOOP, BILAT};

%% ---------- FIGURA ----------
fig = figure('Color','w','Units','centimeters','Position',[2 2 17.5 8]);
tiledlayout(fig,1,3,'Padding','compact','TileSpacing','compact');

for i = 1:3
    nexttile(i); hold on; box on;

    block = PLOTS{i};

    % Prepara medie e SD
    mu   = zeros(2,2);  % [cat x cond] -> cat: ROM,Mean; cond: NoExo,Exo
    sig  = zeros(2,2);
    pval = nan(2,1);

    for k = 1:2 % categorie: ROM(1), Mean(2)
        dNo = block.data{k}{1}; % vettore NoExo
        dEx = block.data{k}{2}; % vettore Exo
        pv  = block.data{k}{3}; % p (NaN -> calcola)

        mu(k,1)  = mean(dNo,'omitnan');   sig(k,1) = std(dNo,'omitnan');
        mu(k,2)  = mean(dEx,'omitnan');   sig(k,2) = std(dEx,'omitnan');

        if (isnan(pv) || isempty(pv)) && ~isempty(dNo) && ~isempty(dEx) && numel(dNo)==numel(dEx)
            [~,pv] = ttest(dNo, dEx); % paired t-test
        end
        pval(k) = pv;
    end

    % Barre grouped (2 per categoria)
    b = bar(mu, 'grouped', 'BarWidth', barW);
    b(1).FaceColor = clrNoExo; b(1).EdgeColor = 'k';
    b(2).FaceColor = clrExo;   b(2).EdgeColor = 'k';

    % Error bars
    x1 = b(1).XEndPoints; % NoExo
    x2 = b(2).XEndPoints; % Exo
    errorbar(x1, mu(:,1), sig(:,1), 'k', 'linestyle','none','LineWidth',ebLW, 'CapSize',6);
    errorbar(x2, mu(:,2), sig(:,2), 'k', 'linestyle','none','LineWidth',ebLW, 'CapSize',6);

    % Asse, titoli, labels (stesso stile)
    set(gca,'XTick',1:2,'XTickLabel',catLabels,'FontSize',fsBase);
    ylabel('L5S1 Flex-Ext Angle [deg]','FontSize',fsBase);
    title(block.name,'FontSize',fsBase+1,'FontWeight','bold');

    % Annotazione significatività (ROM, Mean)
    yMax = max([mu(:)+sig(:)],[],'all','omitnan');
    yMin = min([mu(:)-sig(:)],[],'all','omitnan');
    if ~isfinite(yMax), yMax = 1; end
    if ~isfinite(yMin), yMin = 0; end
    yr   = yMax - yMin; if yr==0, yr = 1; end

    % for k = 1:2
    %     if ~isnan(pval(k)) && ~isempty(pval(k))
    %         xL = b(1).XEndPoints(k); xR = b(2).XEndPoints(k);
    %         yH = max(mu(k,:) + sig(k,:)) + yPad*yr; % altezza linea
    %         plot([xL xR],[yH yH],'k-','LineWidth',1);
    %         ast = p2ast(pval(k));
    %         text(mean([xL xR]), yH + 0.015*yr, ast, ...
    %              'HorizontalAlignment','center','VerticalAlignment','bottom', ...
    %              'FontSize',astFS,'FontWeight','bold');
    %     end
    % end

    % Griglia leggera (come il tuo)
    grid on; ax = gca; ax.GridLineStyle=':'; ax.GridAlpha=0.2;

    % Legenda una volta sola (tile centrale, in alto)
if i==3
    legend({'NoExo','Exo'}, ...
        'Location','northeast', ...   % 👈 alto a destra
        'Orientation','vertical', ...
        'Box','off','FontSize',fsBase-1);
end
end

%% ---------- ESPORTAZIONE ----------
set(fig,'Renderer','painters'); % vettoriale
pdfFile = fullfile(outDir,'Fig_IK_ROM_Mean.pdf');
pngFile = fullfile(outDir,'Fig_IK_ROM_Mean.png');
exportgraphics(fig, pdfFile, 'ContentType','vector');
exportgraphics(fig, pngFile, 'Resolution',600);
fprintf('Saved:\n  %s\n  %s\n', pdfFile, pngFile);

end

%% ---------- HELPER: p-value -> asterischi ----------
function ast = p2ast(p)
if     p < 0.001, ast = '***';
elseif p < 0.01,  ast = '**';
elseif p < 0.05,  ast = '*';
else,             ast = '';
end
end



