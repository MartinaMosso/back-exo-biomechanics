% CREATE_COMPRESSIVE_FORCES
% Fig. 6 – Compressive forces (Peak & Mean) L5–S1
% Grafici a barre (mean ± SD) NoExo vs Exo per 3 task, con asterischi p<0.05.
%
% OUTPUT:
%   ./fig/Fig_CompressiveForces.pdf
%   ./fig/Fig_CompressiveForces.png

%% === DATI (sostituisci con i tuoi) ===
% Matrici [nSoggetti × 3] colonne = [Squat, Stoop, Bilateral]
peak_noexo = [5.6507    5.7471    6.2685    5.1436    6.9533    5.4240    6.4065    5.3736;
    5.4409    5.6075    5.7493    5.8567    5.3183    5.4651    5.1340    5.0957;
    4.1002    5.5211    3.4010    5.6506    5.3042    4.5826    5.9413    5.9332]';   % peak compressive force (NoExo)
peak_exo   = [4.7433    4.9645    4.4965    4.6713    6.2512    4.5042    5.4071    5.2161;
     4.5281    6.0603    5.3865    7.1685    6.0748    4.7669    4.8251    5.9943;
      3.0838    5.6178    1.4169    6.0190    5.0341    3.5469    5.1045    6.2147]';
mean_noexo = [2.9103    3.6696    3.5764    3.4283    4.3944    3.8954    3.6565    3.2949;
    2.6861    3.2874    3.7706    4.0175    3.8186    3.8793    3.2652    2.9370;
    2.9227    3.1149    2.3992    4.2894    3.5042    2.7531    3.4865    4.3372]';   % mean compressive force (NoExo)
mean_exo   = [2.6808    3.3162    3.2332    3.3880    4.2755    3.1105    3.2382    3.0465;
    2.8125    3.7737    3.5316    5.1468    4.1015    3.5640    3.3608    3.6300;
    2.1577    3.5227    0.6430    4.1241    3.0551    2.5368    3.0042    4.3898]';

% Esempio fittizio:
%{
n=8;
peak_noexo = randn(n,3)*200 + [3500 3200 3300];
peak_exo   = randn(n,3)*180 + [2800 3100 2900];
mean_noexo = randn(n,3)*120 + [2500 2400 2450];
mean_exo   = randn(n,3)*110 + [2100 2300 2150];
%}

%% === P-VALUE (manuale) ===
% Vettori [1×3] per i 3 task: [Squat, Stoop, Bilateral]
 p_mean = [0.0055 0.14 0.107];   % esempio
 p_peak = [0.0014 0.63 0.074];   % esempio

%% === STILE ===
clrNoExo = [120 160 160]/256;   % NoExo
clrExo   = [150  40 110]/256;   % Exo
tasks = {'Squat','Stoop','Bilateral'};
fs = 11; barW = 0.9; ebLW=1; capSz=6; yPadFrac=0.05;

set(0,'defaultTextInterpreter','latex');
set(0,'defaultAxesTickLabelInterpreter','latex');
set(0,'defaultLegendInterpreter','latex');

outDir = fullfile(pwd,'fig'); if ~exist(outDir,'dir'), mkdir(outDir); end

%% === FIGURA ===
fig = figure('Color','w','Units','centimeters','Position',[2 2 17 10]);
tiledlayout(fig,1,2,'Padding','compact','TileSpacing','compact');

% ================= PANNELLO (A) Peak =================
ax1 = nexttile; hold(ax1,'on'); box(ax1,'on');
muNo = mean(peak_noexo,1,'omitnan'); sdNo = std(peak_noexo,0,1,'omitnan');
muEx = mean(peak_exo, 1,'omitnan'); sdEx = std(peak_exo, 0,1,'omitnan');
MU = [muNo(:), muEx(:)]; SD = [sdNo(:), sdEx(:)];

b=bar(MU,'grouped','BarWidth',barW);
b(1).FaceColor=clrNoExo; b(1).EdgeColor='k';
b(2).FaceColor=clrExo;   b(2).EdgeColor='k';

x1=b(1).XEndPoints; x2=b(2).XEndPoints;
errorbar(x1,MU(:,1),SD(:,1),'k','linestyle','none','LineWidth',ebLW,'CapSize',capSz);
errorbar(x2,MU(:,2),SD(:,2),'k','linestyle','none','LineWidth',ebLW,'CapSize',capSz);

set(ax1,'XTick',1:3,'XTickLabel',tasks,'FontSize',fs);
ylabel(ax1,'Peak force [N]','FontSize',fs);
title('(A) Peak L5--S1 compressive force','FontSize',fs+1,'FontWeight','bold');

% asterischi
yL = ylim(ax1); yr = diff(yL);
for i=1:3
    pv = p_peak(i);
    if ~isnan(pv) && pv<0.05
        yH = max(MU(i,:)+SD(i,:)) + yPadFrac*yr;
        plot([x1(i) x2(i)],[yH yH],'k-','LineWidth',1);
        if     pv<0.001, ast='***';
        elseif pv<0.01,  ast='**';
        else,            ast='*'; end
        text(mean([x1(i) x2(i)]), yH+0.02*yr, ast, ...
            'HorizontalAlignment','center','VerticalAlignment','bottom','FontSize',fs+2,'FontWeight','bold');
    end
end

% ================= PANNELLO (B) Mean =================
ax2 = nexttile; hold(ax2,'on'); box(ax2,'on');
muNo = mean(mean_noexo,1,'omitnan'); sdNo = std(mean_noexo,0,1,'omitnan');
muEx = mean(mean_exo, 1,'omitnan'); sdEx = std(mean_exo, 0,1,'omitnan');
MU = [muNo(:), muEx(:)]; SD = [sdNo(:), sdEx(:)];

b=bar(MU,'grouped','BarWidth',barW);
b(1).FaceColor=clrNoExo; b(1).EdgeColor='k';
b(2).FaceColor=clrExo;   b(2).EdgeColor='k';

x1=b(1).XEndPoints; x2=b(2).XEndPoints;
errorbar(x1,MU(:,1),SD(:,1),'k','linestyle','none','LineWidth',ebLW,'CapSize',capSz);
errorbar(x2,MU(:,2),SD(:,2),'k','linestyle','none','LineWidth',ebLW,'CapSize',capSz);

set(ax2,'XTick',1:3,'XTickLabel',tasks,'FontSize',fs);
ylabel(ax2,'Mean force [N]','FontSize',fs);
title('(B) Mean L5--S1 compressive force','FontSize',fs+1,'FontWeight','bold');

% asterischi
yL = ylim(ax2); yr = diff(yL);
for i=1:3
    pv = p_mean(i);
    if ~isnan(pv) && pv<0.05
        yH = max(MU(i,:)+SD(i,:)) + yPadFrac*yr;
        plot([x1(i) x2(i)],[yH yH],'k-','LineWidth',1);
        if     pv<0.001, ast='***';
        elseif pv<0.01,  ast='**';
        else,            ast='*'; end
        text(mean([x1(i) x2(i)]), yH+0.02*yr, ast, ...
            'HorizontalAlignment','center','VerticalAlignment','bottom','FontSize',fs+2,'FontWeight','bold');
    end
end

% Legenda comune
lg = legend({'NoExo','Exo'}, ...
    'Location','northeast', ...
    'Box','off', ...
    'FontSize',fs-1);
set(lg,'Color','none');   % sfondo trasparente

%% === Export ===
set(fig,'Renderer','painters');
exportgraphics(fig, fullfile(outDir,'Fig_CompressiveForces.pdf'),'ContentType','vector');
exportgraphics(fig, fullfile(outDir,'Fig_CompressiveForces.png'),'Resolution',600);
fprintf('Saved in %s\n', outDir);