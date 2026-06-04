clear; close all; clc

%% === DATI ===
peak_noexo = [5.6507 5.7471 6.2685 5.1436 6.9533 5.4240 6.4065 5.3736;
              5.4409 5.6075 5.7493 5.8567 5.3183 5.4651 5.1340 5.0957;
              4.1002 5.5211 3.4010 5.6506 5.3042 4.5826 5.9413 5.9332]';

peak_exo   = [4.7433 4.9645 4.4965 4.6713 6.2512 4.5042 5.4071 5.2161;
              4.5281 6.0603 5.3865 7.1685 6.0748 4.7669 4.8251 5.9943;
              3.0838 5.6178 1.4169 6.0190 5.0341 3.5469 5.1045 6.2147]';

mean_noexo = [2.9103 3.6696 3.5764 3.4283 4.3944 3.8954 3.6565 3.2949;
              2.6861 3.2874 3.7706 4.0175 3.8186 3.8793 3.2652 2.9370;
              2.9227 3.1149 2.3992 4.2894 3.5042 2.7531 3.4865 4.3372]';

mean_exo   = [2.6808 3.3162 3.2332 3.3880 4.2755 3.1105 3.2382 3.0465;
              2.8125 3.7737 3.5316 5.1468 4.1015 3.5640 3.3608 3.6300;
              2.1577 3.5227 0.6430 4.1241 3.0551 2.5368 3.0042 4.3898]';

p_peak = [0.0014 0.63 0.074];
p_mean = [0.0055 0.14 0.107];
tasks = {'Squat','Stoop','Bilateral'};

%% === STILE ===
clrNoExo = [120 160 160]/256;
clrExo   = [150  40 110]/256;
pos = [1 2 4 5 7 8];            % posizioni per le coppie NoExo/Exo
grpCodes = [1 2 4 5 7 8];       % codici G corrispondenti alle posizioni

fig = figure('Color','w','Units','centimeters','Position',[2 2 18.5 16]);
tiledlayout(fig,2,1,'Padding','compact','TileSpacing','compact')
sgtitle('L5–S1 compressive forces','FontWeight','bold');

%% ===== (A) PEAK =====
nexttile; hold on; box on; grid on
ax = gca; ax.Layer='top'; ax.GridAlpha=0.25; ax.YGrid = 'on'; ax.XGrid = 'off';

X = [peak_noexo(:,1); peak_exo(:,1); ...
     peak_noexo(:,2); peak_exo(:,2); ...
     peak_noexo(:,3); peak_exo(:,3)];
G = [repmat(1,8,1); repmat(2,8,1); repmat(4,8,1); ...
     repmat(5,8,1); repmat(7,8,1); repmat(8,8,1)];

bh = boxplot(X, G, 'Positions',pos, 'Widths',0.7, ...
    'Symbol','k+', 'Colors','k', 'Whisker',1.5);
set(bh, 'LineWidth',1);

% Colora le box
boxes = findobj(gca,'Tag','Box');
for k = 1:numel(boxes)
    xd = get(boxes(k),'XData');  yd = get(boxes(k),'YData');
    if mod(numel(boxes)-k,2)==0
        patch(xd, yd, clrNoExo, 'FaceAlpha',0.35, 'EdgeColor','k');
    else
        patch(xd, yd, clrExo,   'FaceAlpha',0.35, 'EdgeColor','k');
    end
end

% Assi e limiti
set(gca,'XTick',[1.5 4.5 7.5], 'XTickLabel',[], 'FontSize',11)
ylabel('Peak [BW]')
ylim([1 8])

% --- Barretta sopra ai WHISKER superiori (clippata dentro l'asse)
yl = ylim; yr = diff(yl);
topMargin = 0.06*yr;      % distanza dal bordo alto
basePad   = 0.03*yr;      % padding sopra ai whisker
tickh     = 0.02*yr;      % altezza dei cap

whTop = whiskerTops(gca, pos);   % <-- qui leggiamo l'altezza dei whisker
for i = 1:3
    if p_peak(i) < 0.05
        x1 = pos(2*i-1); x2 = pos(2*i);
        pairTop = max([whTop(2*i-1), whTop(2*i)]);
        y_des = pairTop + basePad;
        y_bar = min(yl(2) - topMargin, y_des);
        drawSigBar(gca, x1, x2, y_bar, tickh, '*');
    end
end

%% ===== (B) MEAN =====
nexttile; hold on; box on; grid on
ax = gca; ax.Layer='top'; ax.GridAlpha=0.25; ax.YGrid = 'on'; ax.XGrid = 'off';

X = [mean_noexo(:,1); mean_exo(:,1); ...
     mean_noexo(:,2); mean_exo(:,2); ...
     mean_noexo(:,3); mean_exo(:,3)];
G = [repmat(1,8,1); repmat(2,8,1); repmat(4,8,1); ...
     repmat(5,8,1); repmat(7,8,1); repmat(8,8,1)];

bh = boxplot(X, G, 'Positions',pos, 'Widths',0.7, ...
    'Symbol','k+', 'Colors','k', 'Whisker',1.5);
set(bh, 'LineWidth',1);

% Colora le box
boxes = findobj(gca,'Tag','Box');
for k = 1:numel(boxes)
    xd = get(boxes(k),'XData');  yd = get(boxes(k),'YData');
    if mod(numel(boxes)-k,2)==0
        patch(xd, yd, clrNoExo, 'FaceAlpha',0.35, 'EdgeColor','k');
    else
        patch(xd, yd, clrExo,   'FaceAlpha',0.35, 'EdgeColor','k');
    end
end

set(gca,'XTick',[1.5 4.5 7.5], 'XTickLabel',tasks, 'FontSize',11)
ylabel('Mean [BW]')
ylim([0.5 5])

yl = ylim; yr = diff(yl);
topMargin = 0.06*yr; basePad = 0.03*yr; tickh = 0.02*yr;

whTop = whiskerTops(gca, pos);
for i = 1:3
    if p_mean(i) < 0.05
        x1 = pos(2*i-1); x2 = pos(2*i);
        pairTop = max([whTop(2*i-1), whTop(2*i)]);
        y_des = pairTop + basePad;
        y_bar = min(yl(2) - topMargin, y_des);
        drawSigBar(gca, x1, x2, y_bar, tickh, '*');
    end
end

%% === EXPORT ===
exportgraphics(fig,'L5S1_boxplot_with_stars.pdf','ContentType','vector');
disp('✅ Esportato: L5S1_boxplot_with_stars.pdf')

%% ===== Helper: leggi l'altezza dei WHISKER superiori in base alla posizione =====
function tops = whiskerTops(ax, posOrder)
    % Ritorna un vettore con il valore Y del whisker superiore per ciascuna box,
    % nello stesso ordine delle posizioni 'posOrder'.
    uw = findobj(ax, 'Tag','Upper Whisker');            % line
    uav = findobj(ax, 'Tag','Upper Adjacent Value');    % line
    % Concatena entrambi (dipende dalla versione di MATLAB cosa è visibile)
    cand = [uw(:); uav(:)];
    tops = nan(size(posOrder));
    for i = 1:numel(cand)
        x = get(cand(i),'XData'); y = get(cand(i),'YData');
        xmid = mean(x);  ymax = max(y);
        % trova la posizione 'pos' più vicina
        [~,idx] = min(abs(posOrder - xmid));
        tops(idx) = max(tops(idx), ymax);
    end
end

%% ===== Helper: barretta di significatività con asterisco =====
function drawSigBar(ax, x1, x2, y, tickh, starTxt)
    plot(ax, [x1 x2], [y y], 'k-', 'LineWidth', 1, 'Clipping','on');
    plot(ax, [x1 x1], [y-tickh y], 'k-', 'LineWidth', 1, 'Clipping','on');
    plot(ax, [x2 x2], [y-tickh y], 'k-', 'LineWidth', 1, 'Clipping','on');
    xmid = (x1+x2)/2;
    text(xmid, y + 0.15*tickh, starTxt, ...
        'HorizontalAlignment','center', 'VerticalAlignment','bottom', ...
        'FontSize', 14, 'Parent', ax, 'Clipping','on');
end