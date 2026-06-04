
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

tasks = categorical({'Squat','Stoop','Bilateral'});
tasks = reordercats(tasks, {'Squat','Stoop','Bilateral'});

%% === Impostazioni grafiche ===
colNo = [0.40 0.66 0.66];   % teal
colEx = [0.60 0.20 0.55];   % magenta
yl_peak = [];               % lascia [] per auto; oppure es. [2.5 7]
yl_mean = [];               % lascia [] per auto; oppure es. [1.5 5.5]
boxW = 0.6;

%% === Helper per long table ===
makeLong = @(A_no,A_ex) deal( ...
    [A_no(:); A_ex(:)], ...                                % values
    repmat(repelem(tasks, size(A_no,1))', 2, 1), ...       % task (Nx1)
    [repmat(categorical("NoExo"), numel(A_no),1); ...
     repmat(categorical("Exo"),   numel(A_ex),1)] ...      % condition (Nx1)
);

%% === Figura ===
fig = figure('Color','w','Units','centimeters','Position',[2 2 18.5 8.0]);
tl  = tiledlayout(fig,1,2,'TileSpacing','compact','Padding','compact');

% ---------- (A) PEAK ----------
[nextY, xTask, cond] = makeLong(peak_noexo, peak_exo);
ax1 = nexttile; hold(ax1,'on'); box(ax1,'on');

% usa x come indice dei task
xIdx = double(xTask);
bc = boxchart(ax1, xIdx, nextY, 'GroupByColor', cond, 'BoxWidth', boxW);
% Colori coerenti con condizione
cmap = containers.Map({'NoExo','Exo'}, {colNo, colEx});
for i = 1:numel(bc)
    bc(i).BoxFaceColor    = cmap(char(bc(i).SeriesName));
    bc(i).BoxFaceAlpha    = 0.9;
    bc(i).WhiskerLineColor= [0.2 0.2 0.2];
    bc(i).MarkerStyle     = '.';
end
ax1.XTick = 1:3; ax1.XTickLabel = cellstr(tasks);
ylabel(ax1,'Peak force [kN]');
title(ax1,'(A) Peak L5–S1 compressive force');

% Y-lim (auto con margine, o usa yl_peak se fornito)
if isempty(yl_peak)
    yAll = [peak_noexo(:); peak_exo(:)];
    yPad = 0.08*(max(yAll)-min(yAll));
    ax1.YLim = [min(yAll)-yPad, max(yAll)+2*yPad];
else
    ax1.YLim = yl_peak;
end
grid(ax1,'on'); ax1.XGrid='off';   % niente linee verticali

% Asterischi per ogni task
for i = 1:3
    yMax = max([peak_noexo(:,i); peak_exo(:,i)], [], 'omitnan');
    addSig(ax1, i, yMax, p_peak(i));
end

leg = legend(ax1, {'NoExo','Exo'}, 'Location','northeast');
leg.Box = 'off';

% ---------- (B) MEAN ----------
[nextY, xTask, cond] = makeLong(mean_noexo, mean_exo);
ax2 = nexttile; hold(ax2,'on'); box(ax2,'on');
bc = boxchart(ax2, double(xTask), nextY, 'GroupByColor', cond, 'BoxWidth', boxW);
for i = 1:numel(bc)
    bc(i).BoxFaceColor    = cmap(char(bc(i).SeriesName));
    bc(i).BoxFaceAlpha    = 0.9;
    bc(i).WhiskerLineColor= [0.2 0.2 0.2];
    bc(i).MarkerStyle     = '.';
end
ax2.XTick = 1:3; ax2.XTickLabel = cellstr(tasks);
ylabel(ax2,'Mean force [kN]');
title(ax2,'(B) Mean L5–S1 compressive force');
if isempty(yl_mean)
    yAll = [mean_noexo(:); mean_exo(:)];
    yPad = 0.08*(max(yAll)-min(yAll));
    ax2.YLim = [min(yAll)-yPad, max(yAll)+2*yPad];
else
    ax2.YLim = yl_mean;
end
grid(ax2,'on'); ax2.XGrid='off';

for i = 1:3
    yMax = max([mean_noexo(:,i); mean_exo(:,i)], [], 'omitnan');
    addSig(ax2, i, yMax, p_mean(i));
end
legend(ax2,'off');   % già mostrata a sinistra

title(tl, 'Compressive forces at L5–S1 (NoExo vs Exo)');

%% === Funzione per asterischi ===
function addSig(ax, x0, yMax, p)
    if isnan(p), return; end
    if     p < 0.001, stars='***';
    elseif p < 0.01,  stars='**';
    elseif p < 0.05,  stars='*';
    else,  stars=''; end
    if isempty(stars), return; end
    hold(ax,'on');
    dy  = 0.03 * range(ax.YLim);
    y   = yMax + 1.2*dy;
    plot(ax, [x0-0.20 x0+0.20], [y y], 'k', 'LineWidth', 1);
    text(ax, x0, y+0.5*dy, stars, 'HorizontalAlignment','center', ...
        'VerticalAlignment','bottom', 'FontWeight','bold');
end

%% === Export pulito (niente legenda tagliata) ===
% exportgraphics(fig,'boxplot_compressive_forces.pdf','ContentType','vector');
% exportgraphics(fig,'boxplot_compressive_forces.png','Resolution',600);