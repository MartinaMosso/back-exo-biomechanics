%% ================== DATI (come da tuo messaggio) ==================
% Ogni matrice è [nSoggetti x 3] con colonne = [LT, LL, IL]

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


%% ================== STILE ==================
colNoExo =  [120 160 160]/256;   % NoExo (più scuro dei tuoi)
colExo   = [150  40 110]/256;
muscleLabels = {'LT','LL','IL'};
pos = [1 1.35  2 2.35  3 3.35];   % (LT NoExo, LT Exo, LL NoExo, LL Exo, IL NoExo, IL Exo)
xt  = [mean(pos(1:2)) mean(pos(3:4)) mean(pos(5:6))];
yLims = [
    0 0.25;   % Riga 1 → Peak
    0 0.3;   % Riga 2 → RMS
    0 0.5;  % Riga 3 → iEMG
];

%% ================== FIGURA 3x3 ==================
fig = figure('Color','w','Units','centimeters','Position',[2 2 18 14]);
tl  = tiledlayout(fig,3,3,'Padding','compact','TileSpacing','compact');

% --- Riga 1: PEAK ---
panelBox6(nexttile, peak_sq_noexo, peak_sq_exo, 'Peak', 'Squat',    colNoExo,colExo,pos,xt,muscleLabels);
panelBox6(nexttile, peak_st_noexo, peak_st_exo, '', 'Stoop',    colNoExo,colExo,pos,xt,muscleLabels);
panelBox6(nexttile, peak_bl_noexo, peak_bl_exo, '', 'Bilateral',colNoExo,colExo,pos,xt,muscleLabels);

% --- Riga 2: RMS ---
panelBox6(nexttile, rms_sq_noexo, rms_sq_exo,   'RMS', '',    colNoExo,colExo,pos,xt,muscleLabels);
panelBox6(nexttile, rms_st_noexo, rms_st_exo,   '', '',    colNoExo,colExo,pos,xt,muscleLabels);
panelBox6(nexttile, rms_bl_noexo, rms_bl_exo,   '', '',colNoExo,colExo,pos,xt,muscleLabels);

% --- Riga 3: iEMG ---
panelBox6(nexttile, iemg_sq_noexo, iemg_sq_exo, 'iEMG', '',    colNoExo,colExo,pos,xt,muscleLabels);
panelBox6(nexttile, iemg_st_noexo, iemg_st_exo, '', '',    colNoExo,colExo,pos,xt,muscleLabels);
panelBox6(nexttile, iemg_bl_noexo, iemg_bl_exo, '', '',colNoExo,colExo,pos,xt,muscleLabels);

% ---- Imposta Y-lim diversi per ogni riga (Peak, RMS, iEMG) ----
axs = findall(fig,'Type','axes','-not','Tag','legend');  % trova solo i subplot
nCols = 3;  % 3 colonne (Squat, Stoop, Bilateral)

for r = 1:3   % 3 righe
    for c = 1:nCols
        idx = (r-1)*nCols + c;   % indice subplot
        if idx <= numel(axs)
            ylim(axs(idx), yLims(r,:));
        end
    end
end
% --- Legenda centrata in alto (rettangoli con bordo nero) ---

ax = findall(fig,'Type','axes');

hold(ax(1),'on');
hNoExo = patch(ax(1), NaN,NaN, colNoExo, 'FaceAlpha',0.4, 'EdgeColor','k');
hExo   = patch(ax(1), NaN,NaN, colExo,   'FaceAlpha',0.4, 'EdgeColor','k');

lg = legend(ax(1), [hNoExo hExo], {'NoExo','Exo'}, ...
    'Orientation','horizontal', 'Box','off', ...
    'FontName','Arial','FontSize',10, 'NumColumns',2);


% Posiziona la legenda in alto a destra (sopra i pannelli)
lg.Units = 'normalized';
lg.Position = [0.1, .98, 0.25, 0.04];   % [x y w h] → regola se serve
% for i = 1:numel(ax)
%     set(ax(i),'XGrid','on','YGrid','on');  % abilita la griglia
%     ax(i).GridLineStyle = ':';             % linee puntinate leggere
%     ax(i).YGrid = 'on';                    % solo orizzontali
%     ax(i).XGrid = 'off';                   % niente verticali
% end
set(fig,'Units','centimeters','Position',[2 3 20 16]);  % aumenta altezza e margini
drawnow;  % forza aggiornamento layout
print(fig,'EMG_Boxplots_3x3','-dpdf','-painters','-bestfit');
% --- Export PDF vettoriale con sfondo trasparente ---
% exportgraphics(fig,'EMG_Boxplots_3x3.pdf','ContentType','vector', ...
    'BackgroundColor','none','Resolution',300);

%% ================== FUNZIONI LOCALI ==================
function panelBox6(ax, dataNoExo, dataExo, ylab, ttl, colNoExo,colExo,pos,xt,muscleLabels)
    % dataNoExo / dataExo: [nS x 3] (LT, LL, IL)
    axes(ax); hold on; box on; grid on;
hold(ax,'on'); box(ax,'on');
ax.YGrid = 'on';          % griglia orizzontale
ax.XGrid = 'off';         % niente griglia verticale
ax.YMinorGrid = 'off';
ax.XMinorGrid = 'off';
ax.GridLineStyle = ':';   % stile griglia (opzionale)
    % --- Disegna tutte le 6 box (LT,LL,IL) con posizioni personalizzate ---
    allData = []; allGrp = []; allPos = [];
    for m = 1:3
        allData = [allData; dataNoExo(:,m); dataExo(:,m)];
        allGrp  = [allGrp; repmat({sprintf('%s-NoExo',muscleLabels{m})}, size(dataNoExo,1),1); ...
                          repmat({sprintf('%s-Exo',  muscleLabels{m})}, size(dataExo,1),1)];
        allPos  = [allPos, pos(2*m-1:2*m)]; %#ok<AGROW>
    end
    h = boxplot(allData, allGrp, 'Positions', allPos, 'Widths',0.32, ...
                'Symbol','k.', 'Colors',[0 0 0]);
    set(h,{'LineWidth'},{1.0});

    % --- Colora tutte le box alternando NoExo/Exo ---
    boxes = findobj(ax,'Tag','Box'); boxes = flipud(boxes);
    for i = 1:numel(boxes)
        if mod(i,2)==1, c = colNoExo; else, c = colExo; end
        patch(get(boxes(i),'XData'),get(boxes(i),'YData'),c,'FaceAlpha',0.4,'EdgeColor','k');
    end

    % --- Asterischi (paired t-test) sopra ogni coppia ---
    for m = 1:3
        a = dataNoExo(:,m); b = dataExo(:,m);
        n = min(numel(a), numel(b));
        a = a(1:n); b = b(1:n);  % se #soggetti differente, usa i comuni
        if n >= 3
            [~,p] = ttest(a,b);
        else
            p = NaN;
        end
        if ~isnan(p) && p < 0.05
            yMax = max([a; b]); pad = 0.04*range([a; b]);
            drawSig(ax, pos(2*m-1), pos(2*m), yMax+pad, p);
        end
    end

    % --- Stile assi e titoli ---
    set(ax,'XTick',xt,'XTickLabel',muscleLabels,'FontName','Arial','FontSize',12);
    ylabel(ax, ylab,'FontName','Arial','FontSize',12);
    title(ax, ttl,'FontName','Arial','FontWeight','normal','FontSize',12);
    % ylim(ax,[0 0.3]); 
end

function drawSig(ax, x1,x2,y,p)
    if p < 0.05, stars='*';
    else, return;
    end
    plot(ax,[x1 x2],[y y],'k','LineWidth',1);
    text(ax, mean([x1 x2]), y + 0.02*abs(y+eps), stars, ...
        'HorizontalAlignment','center','FontName','Arial','FontSize',11);
end
