% CREATE_EMG_BARS_PVALS
% 3 pannelli: (A) Squat, (B) Stoop, (C) Bilateral
% Barre mean±SD per 9 gruppi (LT/LL/IL × RMS/Peak/iEMG), NoExo vs Exo.
% Annotazioni di significatività da tabella manuale PVAL (***, **, *, oppure niente).
clear; close all; clc
%% --------- STILE ----------
clrNoExo = [120 160 160]/256;   % NoExo (più scuro dei tuoi)
clrExo   = [150  40 110]/256;   % Exo   (più scuro dei tuoi)
fsBase   = 10;
barW     = 0.9;
ebLW     = 1.0; capSz = 6;
yPadFrac = 0.06;  % padding verticale per asterischi
muscles  = {'LT','LL','IL'};
tasks    = {'Squat','Stoop','Bilateral'};
rows     = {'Peak','RMS','iEMG'};  % ORDINE DELLE RIGHE

% interpreti LaTeX (facoltativo)
set(0,'defaultTextInterpreter','latex');
set(0,'defaultAxesTickLabelInterpreter','latex');
set(0,'defaultLegendInterpreter','latex');

% cartella output
outDir = fullfile(pwd,'fig'); if ~exist(outDir,'dir'), mkdir(outDir); end

%% --------- INSERISCI I TUOI DATI QUI ---------------------------------
% Ogni matrice è [nSoggetti x 3] (colonne = LT, LL, IL)
% ===== SQUAT =====
rms_sq_noexo  =   [0.1536    0.1568    0.1016    0.1097    0.2192    0.1732    0.0700    0.0560;
    0.1175    0.1751    0.1502    0.1562    0.1115    0.1818    0.1480    0.0804;
    0.1115    0.1277    0.1202    0.0817    0.1086    0.2294    0.0523    0.1001]';
rms_sq_exo  = [0.1431    0.1275    0.0876    0.0931    0.1796    0.1336    0.0740    0.0540;
    0.1179    0.1309    0.0962    0.1600    0.1030    0.1188    0.1032    0.0631;
    0.1235    0.1392    0.0930    0.0716    0.0892    0.1933    0.0592    0.1000]';

peak_sq_noexo = [0.2871    0.2649    0.1926    0.1895    0.3621    0.3262    0.1535    0.0923;
    0.2401    0.2682    0.2660    0.2547    0.1888    0.3145    0.3451    0.1468;
    0.2275    0.2144    0.2715    0.1269    0.1885    0.3569    0.1276    0.1919]'; 
peak_sq_exo = [0.2463    0.2266    0.1413    0.1493    0.2831    0.2284    0.1280    0.0878;
    0.2053    0.2294    0.1880    0.2545    0.1551    0.1875    0.1672    0.1020;
    0.2184    0.2338    0.1845    0.1136    0.1637    0.2860    0.1062    0.1773]';

iemg_sq_noexo = [0.1278    0.1371    0.0854    0.0932    0.1972    0.1584    0.0621    0.0513;
    0.0913    0.1546    0.1328    0.1371    0.1009    0.1682    0.1306    0.0711;
    0.0900    0.1147    0.0956    0.0750    0.0982    0.2163    0.0446    0.0865]';   
iemg_sq_exo = [0.1215    0.1041    0.0811    0.0789    0.1580    0.1114    0.0666    0.0470;
    0.0982    0.1100    0.0838    0.1402    0.0915    0.1039    0.0897    0.0552;
     0.1040    0.1178    0.0795    0.0629    0.0761    0.1762    0.0506    0.0821]';

% ===== STOOP =====
rms_st_noexo  = [0.1259    0.1360    0.1086    0.0932    0.1617    0.1857    0.0727    0.0568;
    0.1090    0.1393    0.1323    0.1559    0.1038    0.2153    0.1282    0.0667;
    0.1159    0.1257    0.1406    0.0740    0.0865    0.2092    0.0559    0.1272]';   
rms_st_exo  = [0.1469    0.1530    0.0962    0.1307    0.1617    0.1710    0.0749    0.0732;
    0.1093    0.1600    0.1127    0.1852    0.0919    0.1615    0.1166    0.0671;
    0.1326    0.1654    0.1247    0.0967    0.1080    0.1906    0.0663    0.1280]';

peak_st_noexo = [ 0.2482    0.3135    0.2135    0.1520    0.2491    0.3334    0.1354    0.0941;
    0.2586    0.2813    0.2278    0.2519    0.1605    0.3699    0.2254    0.1159;
    0.2699    0.2601    0.3160    0.1147    0.1489    0.3507    0.1147    0.2603]';   
peak_st_exo = [0.2373    0.3095    0.2180    0.2100    0.3299    0.3111    0.1269    0.1391;
    0.1910    0.3183    0.2403    0.2984    0.1759    0.2742    0.1929    0.1219;
    0.2254    0.3583    0.3206    0.1662    0.2273    0.3502    0.1349    0.2761]';

iemg_st_noexo = [0.1060    0.0996    0.0844    0.0822    0.1392    0.1602    0.0664    0.0492;
    0.0848    0.1097    0.1034    0.1406    0.0905    0.1925    0.1139    0.0578;
    0.0906    0.0971    0.1001    0.0680    0.0714    0.1881    0.0481    0.1062]';   
iemg_st_exo = [0.1284    0.1179    0.0801    0.1192    0.1346    0.1468    0.0685    0.0641;
    0.0908    0.1263    0.0937    0.1656    0.0802    0.1425    0.1045    0.0559;
    0.1140    0.1282    0.0939    0.0862    0.0921    0.1662    0.0585    0.1073]';

% ===== BILATERAL =====


rms_bl_noexo  = [0.1539    0.1523    0.1350; 
    0.1555    0.1410   0.1980;
    0.1528    0.1497    0.0980]';   
rms_bl_exo  = [0.1182    0.1350  0.1226;
    0.1087    0.1562   0.1969;
     0.1261    0.1557     0.0857]';
peak_bl_noexo = [0.3031    0.3107    0.2149  ;
    0.3433    0.2821      0.3383    ;
    0.3678    0.3042       0.1709   ]';   
peak_bl_exo = [0.2136    0.3309       0.2595   ;
    0.2136    0.3309        0.2595   ;
    0.3063    0.3510        0.1894  ]';
iemg_bl_noexo = [0.1175    0.1085       0.1139 ;
    0.1131    0.1052       0.1694  ;
    0.1132    0.1122       0.0860   ]';   
iemg_bl_exo = [0.0873    0.0915      0.1003   ;
    0.0738    0.1190     0.1594   ;
    0.0876    0.1133      0.0697    ]';
% rms_bl_noexo  = [0.1539    0.1523    0.0913    0.1350    0.1869    0.1859    0.0608    0.0678; 
%     0.1555    0.1410    0.0975    0.1980    0.0987    0.1718    0.1387    0.0802;
%     0.1528    0.1497    0.1173    0.0980    0.1333    0.2377    0.0645    0.1486]';   
% rms_bl_exo  = [0.1182    0.1350    0.0000    0.1226    0.1467    0.1519    0.0489    0.0564;
%     0.1087    0.1562    0.0000    0.1969    0.0816    0.1299    0.0983    0.0722;
%      0.1261    0.1557    0.0000    0.0857    0.1035    0.2017    0.0524    0.1313]';
% peak_bl_noexo = [0.3031    0.3107    0.1858    0.2149    0.3540    0.4131    0.1346    0.1153;
%     0.3433    0.2821    0.1987    0.3383    0.1828    0.3254    0.3078    0.1383;
%     0.3678    0.3042    0.2581    0.1709    0.2584    0.4604    0.1466    0.2802]';   
% peak_bl_exo = [0.2136    0.3309    0.0000    0.2595    0.3256    0.3242    0.0968    0.0983;
%     0.2136    0.3309    0.0000    0.2595    0.3256    0.3242    0.0968    0.0983;
%     0.3063    0.3510    0.0000    0.1894    0.2322    0.4288    0.1159    0.2575]';
% iemg_bl_noexo = [0.1175    0.1085    0.0671    0.1139    0.1482    0.1362    0.0471    0.0572;
%     0.1131    0.1052    0.0722    0.1694    0.0800    0.1347    0.1100    0.0680;
%     0.1132    0.1122    0.0803    0.0860    0.1039    0.1933    0.0474    0.1183]';   
% iemg_bl_exo = [0.0873    0.0915    0.0000    0.1003    0.1162    0.1134    0.0391    0.0477;
%     0.0738    0.1190    0.0000    0.1594    0.0664    0.1049    0.0785    0.0600;
%     0.0876    0.1133    0.0000    0.0697    0.0803    0.1664    0.0411    0.1034]';

%% --------- TABELLA P-VALUE (COMPILA QUI) ------------------------------
% Inserisci i p-value manuali (metti NaN per “non mostrare”).
% Ordine colonne = [LT  LL  IL]
PVAL.Squat.RMS  = [0.0152 0.0176 0.2674];
PVAL.Squat.Peak = [0.0027 0.0143 0.0578];
PVAL.Squat.iEMG = [0.0321 0.0240 0.1881];

PVAL.Stoop.RMS  = [0.2255 0.5445 0.5142];
PVAL.Stoop.Peak = [0.2258 0.6009 0.13];
PVAL.Stoop.iEMG = [0.007 0.0343 0.0281];

%old
% PVAL.Bilateral.RMS  = [0.0122 0.0478 0.0531];
% PVAL.Bilateral.Peak = [0.1053 0.2845 0.2034];
% PVAL.Bilateral.iEMG = [0.007 0.0343 0.0281];

PVAL.Bilateral.RMS  = [0.0919 0.6167 0.3652];
PVAL.Bilateral.Peak = [0.8601 0.8359 0.9721];
PVAL.Bilateral.iEMG = [0.0566 0.5206 0.2233];

% Esempio:
% PVAL.Squat.RMS = [0.012 0.20 0.0004];  % LT*, LL n.s., IL***

%% --------- PACK DATI (non modificare) -------------
DATA.Squat.Peak.no = peak_sq_noexo; DATA.Squat.Peak.ex = peak_sq_exo;
DATA.Squat.RMS .no = rms_sq_noexo;  DATA.Squat.RMS .ex = rms_sq_exo;
DATA.Squat.iEMG.no = iemg_sq_noexo; DATA.Squat.iEMG.ex = iemg_sq_exo;

DATA.Stoop.Peak.no = peak_st_noexo; DATA.Stoop.Peak.ex = peak_st_exo;
DATA.Stoop.RMS .no = rms_st_noexo;  DATA.Stoop.RMS .ex = rms_st_exo;
DATA.Stoop.iEMG.no = iemg_st_noexo; DATA.Stoop.iEMG.ex = iemg_st_exo;

DATA.Bilateral.Peak.no = peak_bl_noexo; DATA.Bilateral.Peak.ex = peak_bl_exo;
DATA.Bilateral.RMS .no = rms_bl_noexo;  DATA.Bilateral.RMS .ex = rms_bl_exo;
DATA.Bilateral.iEMG.no = iemg_bl_noexo; DATA.Bilateral.iEMG.ex = iemg_bl_exo;

% PV = pack_pval(PVAL);



%% Boxplot with spacing

fig = figure('Color','w','Units','centimeters','Position',[2 2 18.5 16.0]);
tiledlayout(fig,3,3,'Padding','compact','TileSpacing','compact');

for r = 1:3          % rows: Peak, RMS, iEMG
    for c = 1:3      % columns: Squat, Stoop, Bilateral
        nexttile; hold on; box on;

        met = rows{r};   % 'Peak'/'RMS'/'iEMG'
        tsk = tasks{c};  % 'Squat'/'Stoop'/'Bilateral'

        A_no = DATA.(tsk).(met).no;  % [n x 3] -> NoExo
        A_ex = DATA.(tsk).(met).ex;  % [n x 3] -> Exo

        % --- Combine data into one vector for boxplot ---
        muscles_n = numel(muscles);
        group = [];
        condition = [];
        values = [];
        xpos = [];  % custom x positions for spacing

        spacing = 0.5;  % gap between muscle groups

        for m = 1:muscles_n
            nSamples = size(A_no,1);
            % Append data
            values = [values; A_no(:,m); A_ex(:,m)];
            % Assign labels
            group = [group; repmat(m, nSamples*2, 1)];
            condition = [condition; repmat({'NoExo'}, nSamples, 1); repmat({'Exo'}, nSamples, 1)];

            % Define custom positions (2 per muscle, plus spacing)
            baseX = (m-1)*(2 + spacing);
            xpos = [xpos; baseX + 1; baseX + 2];
        end

        % --- Create grouped boxplot (no vertical separators) ---
        % boxplot(values, {group, condition}, ...
        %     'positions', xpos, ...
        %     'colors', [clrNoExo; clrExo], ...
        %     'symbol', '', ...
        %     'outliersize', 3, ...
        %     'widths', 0.7);
        boxplot(values, {group, condition}, ...
    'positions', xpos, ...
    'colors', 'k', ...      % contorni neri (poi riempiamo con patch)
    'symbol', '', ...
    'outliersize', 3, ...
    'widths', 0.7);

% >>>> AGGIUNTA: colora i box (NoExo/Exo) mantenendo il bordo nero
colorizeBoxplot(gca, clrNoExo, clrExo);

        % --- Adjust x-axis (labels only on 3rd row) ---
        centers = mean(reshape(xpos, 2, [])', 2);   % centers between NoExo/Exo
        xticks(centers);
        xlim([min(xpos)-1, max(xpos)+1]);
        set(gca, 'FontSize', fsBase);
        
        % If you need a specific order on the bottom row, set it here:
        desiredLabels = {'LL','LT','IL'};   % << change if you want barplot order
        
        if r == 3
            % show labels only on the last row
            if numel(desiredLabels) == numel(centers)
                xticklabels(desiredLabels);
            else
                xticklabels(muscles);  % fallback to your original order/variable
            end
        else
            % hide labels for the upper rows AND remove boxplot’s own tick texts
            xticklabels([]);
            delete(findobj(gca,'Tag','XTickLabel'));  % prevents boxplot from showing text ticks
        end

        % --- Adjust y-axis dynamically ---
        % yMin = min(values, [], 'omitnan');
        % yMax = max(values, [], 'omitnan');
        % yRange = yMax - yMin;
        % if yRange == 0, yRange = 1; end
        % ylim([yMin - 0.05*yRange, yMax + 0.15*yRange]);  % add margins

        if r == 1
            ylim([0 0.5]);
        else
            ylim([0 0.3]);
        end

        %set(gca, 'XTickLabel', muscles, 'FontSize', fsBase);
        if r==1 && c ==1
            ylabel('Peak (norm. EMG)', 'FontSize', fsBase);
            title('Squat')
        end
        if r==2 && c ==1
            ylabel('RMS (norm. EMG)', 'FontSize', fsBase);
        end
        if r==3 && c ==1
            ylabel('iEMG (norm. EMG)', 'FontSize', fsBase);
        end
        if r==1 && c ==2
            title('Stoop')
        end
        if r==1 && c ==3
            title('Bilateral')
        end
        % Squat Stoop Bilateral

        % --- Significance annotation (centered & height adapted to subplot) ---
        pvec = PVAL.(tsk).(met);   % [1 x muscles_n] p for LT/LL/IL

        % Get current axis range
        yL = ylim;
        yr = diff(yL);

   % padTop = 0.06 * yr;   % margine sotto il top
   %      barH   = 0.015 * yr;  % spessore simbolico linea
   %      txtOff = 0.010 * yr;  % offset testo sopra la linea

        % Define vertical positioning relative to axis
 baseFrac = 0.70;   % posizione verticale della linea (70% dell'asse)
lineFrac = 0.02;   % “spessore” simbolico della linea
txtFrac  = 0.01;   % offset del testo sopra la linea

        % For each muscle, place annotation centered on its pair
        for m = 1:muscles_n
            pv = pvec(m);
            if ~isnan(pv) && pv < 0.05

                % --- Adjust y-axis dynamically ---
                % yMin = min(values, [], 'omitnan');
                % yMax = max(values, [], 'omitnan');
                % yRange = yMax - yMin;
                % if yRange == 0, yRange = 1; end
                % ylim([yMin - 0.05*yRange, yMax + 0.15*yRange+0.07]);  % add margins

                % X positions from custom spacing
                x1 = xpos(2*m - 1);
                x2 = xpos(2*m);
                xC = mean([x1, x2]);  % center

                % Y positions relative to axis height
  %               yBar = yL(1) + baseFrac * yr;
  %               yTxt = yBar + txtFrac * yr;
  % yBar = yL(1) + 0.80*yr;     % linea all’80% dell’altezza
  %       yTxt = yBar + 0.02*yr; 
   % Posizione dal top, ma sempre dentro i limiti
                % yBar = yL(2) - padTop - barH;
                % yTxt = yBar + txtOff;
                % yBar = max(yBar, yL(1) + 0.60*yr);
                % yTxt = min(yTxt, yL(2) - 0.01*yr);
                % 
                  yBar = yL(1) + baseFrac*yr;
        yTxt = yBar + txtFrac*yr;

        % Clamping di sicurezza: non toccare i bordi
        yBar = min(max(yBar, yL(1) + 0.05*yr), yL(2) - 0.10*yr);
        yTxt = min(max(yTxt, yL(1) + 0.06*yr), yL(2) - 0.05*yr);

                % Draw bar and text
                plot([x1 x2], [yBar yBar], 'k-', 'LineWidth', 1, 'Clipping', 'on');
                text(xC, yTxt, p2ast(pv), ...
                    'HorizontalAlignment', 'center', ...
                    'VerticalAlignment', 'bottom', ...
                    'FontSize', fsBase+2, 'FontWeight', 'bold', ...
                    'Clipping', 'on');
            end
        end

        grid on; ax=gca; ax.GridLineStyle=':'; ax.GridAlpha=0.2;
        if r==1 && c==3
            % legend({'NoExo','Exo'},'Location','northoutside', ...
                   % 'Orientation','horizontal','Box','off','FontSize',fsBase-1);
        end
    end
end
%%
exportgraphics(fig, 'EMG_boxplots_colored.pdf', 'ContentType', 'vector');
disp('✅ Esportato: EMG_boxplots_colored.pdf');
%%

function colorizeBoxplot(ax, clrNoExo, clrExo)
% Colora i boxplot alternando NoExo/Exo con riempimento pastello
% e mantiene il bordo/median/whisker/caps neri.
if nargin < 1 || isempty(ax), ax = gca; end

% Trova gli elementi del boxplot
boxes = findobj(ax,'Tag','Box');
med   = findobj(ax,'Tag','Median');
uw    = findobj(ax,'Tag','Upper Whisker');
lw    = findobj(ax,'Tag','Lower Whisker');
uav   = findobj(ax,'Tag','Upper Adjacent Value');
lav   = findobj(ax,'Tag','Lower Adjacent Value');
out   = findobj(ax,'Tag','Outliers');

% MATLAB restituisce i box in ordine inverso di disegno
n = numel(boxes);
for i = 1:n
    xd = get(boxes(i),'XData');
    yd = get(boxes(i),'YData');
    if mod(n - i, 2) == 0        % NoExo
        c = clrNoExo;
    else                         % Exo
        c = clrExo;
    end
    patch(xd, yd, c, ...
        'FaceAlpha', 0.35, ...
        'EdgeColor', 'k', ...
        'LineWidth', 1.0, ...
        'Parent', ax);
end

% Stile nero per mediane, baffi e cap
set(med, 'Color','k', 'LineWidth',1.2);
set([uw; lw; uav; lav], 'Color','k', 'LineWidth',1.0);

% Outlier (se presenti) neri
if ~isempty(out), set(out, 'MarkerEdgeColor','k'); end

% Griglia leggera davanti (come tua figura)
ax.Layer = 'top';
ax.GridAlpha = 0.25;
ax = gca; ax.YGrid = 'on'; ax.XGrid = 'off';
end


%% ===== helper: mappa p->asterischi (niente se non significativo) =====
function ast = p2ast(p)
if   p < 0.05,  ast = '*';
else,             ast = '';
end
end