%% ================== DATI (già inseriti) ==================
% --- SQUAT
knee_sq_rom_noexo  = [68.6750 85.9661 92.3417 94.6491 94.9984 92.9386 78.9215 91.9969];
knee_sq_rom_exo    = [51.6476 67.5074 81.1033 80.1855 75.9514 89.6138 63.0007 90.1167];
p_knee_sq_rom      = 0.001;

knee_sq_mean_noexo = [-23.0821 -47.1543 -36.3193 -47.7273 -46.2155 -48.5153 -54.0121 -52.7152];
knee_sq_mean_exo   = [-25.2908 -40.0276 -49.4427 -38.7999 -42.2807 -46.5375 -49.0661 -54.7463];
p_knee_sq_mean     = 0.64;

hip_sq_rom_noexo   = [93.1859 93.9049 84.9693 83.5471 79.0789 70.3868 73.1080 59.3876];
hip_sq_rom_exo     = [81.1174 61.8038 60.0260 63.1086 62.2621 54.0955 66.3363 54.5921];
p_hip_sq_rom       = 0.0012;

hip_sq_mean_noexo  = [30.7746 32.1107 26.6625 43.3766 39.8509 36.2188 57.5160 43.1154];
hip_sq_mean_exo    = [40.0732 16.1123 34.5152 31.9283 32.4152 23.2159 54.0012 35.8139];
p_hip_sq_mean      = 0.1594;

% --- STOOP
knee_st_rom_noexo  = [4.2438 14.3785 14.3713 20.3719 11.8445 32.9653 8.4864 11.4046];
knee_st_rom_exo    = [5.1705 17.9322 8.3922 15.4078 10.8488 7.1403 13.1773 21.0786];
p_knee_st_rom      = 0.5544;

knee_st_mean_noexo = [6.6932 0.1104 -3.7139 -6.0132 3.7418 -9.9537 -8.9509 -17.4927];
knee_st_mean_exo   = [1.2130 3.8115 -1.5930 12.4187 1.3176 2.1630 -11.9231 -9.3731];
p_knee_st_mean     = 0.1920;

hip_st_rom_noexo   = [62.2636 56.8993 57.7764 66.0294 50.1303 77.5957 49.8502 50.4172];
hip_st_rom_exo     = [19.3968 -0.8337 16.1702 28.0440 14.6118 30.3502 36.6755 32.2405];
p_hip_st_rom       = 0.0205;

hip_st_mean_noexo  = [60.1035 40.4461 58.9513 46.1362 51.1193 60.0682 44.1144 36.5727];
hip_st_mean_exo    = [32.2173 -1.4277 15.3042 13.0281 16.5838 20.8595 38.4780 25.3061];
p_hip_st_mean      = 0.5183;

% --- BILATERAL
knee_bl_rom_noexo  = [61.8304 50.4782 64.2194 60.7149 9.2834 70.0253 55.2462 38.5026];
knee_bl_rom_exo    = [83.6553 43.4302 31.0325 55.5939 27.3466 46.1208 53.6097 25.1061];
p_knee_bl_rom      = 0.43;

knee_bl_mean_noexo = [-19.7232 -23.4063 -17.5775 -24.9022 1.5321 -20.5292 -34.2752 -32.2567];
knee_bl_mean_exo   = [-32.9742 -21.3555 -7.3193 -23.4859 -8.7887 -10.5379 -38.6648 -25.2010];
p_knee_bl_mean     = 0.91;

hip_bl_rom_noexo   = [87.3809 85.6424 64.5949 80.7144 45.9529 81.0300 70.7266 49.4991];
hip_bl_rom_exo     = [77.3699 60.8065 43.2264 63.5778 57.5247 48.4247 66.0531 31.2640];
p_hip_bl_rom       = 0.018;

hip_bl_mean_noexo  = [29.4601 10.6341 14.3890 32.1320 15.0219 24.9953 41.3303 39.5793];
hip_bl_mean_exo    = [30.2618 5.5661 8.5938 21.2772 15.0037 12.7687 42.4846 32.0021];
p_hip_bl_mean      = 0.03;

%% ================== STILE & COSTANTI ==================
   % teal
colNoExo = [120 160 160]/256;   % NoExo (più scuro)
colExo   = [150  40 110]/256;   % Exo   (più scuro)

posPair  = [1 1.6  3.4 4.0];   % [ROM-NoExo  ROM-Exo   MEAN-NoExo  MEAN-Exo]
xt       = [mean(posPair(1:2)) mean(posPair(3:4))];
xlabels  = {'ROM','Mean'};
taskLbl  = {'Squat','Stoop','Bilateral'};
jointLbl = {'Knee','Hip'};

% ---------- FIGURA ----------
fig = figure('Color','w','Units','centimeters','Position',[2 2 22 10]);
tl  = tiledlayout(fig,2,3,'Padding','compact','TileSpacing','compact');

ax = gobjects(6,1);

% ---- 1a RIGA: KNEE ----
ax(1) = nexttile(1); 
pairBox(ax(1), knee_sq_rom_noexo,knee_sq_rom_exo, knee_sq_mean_noexo,knee_sq_mean_exo, ...
        p_knee_sq_rom,p_knee_sq_mean, 'Squat', colNoExo,colExo,posPair,xt,xlabels);
ylabel(ax(1),'Knee Flex-Ext Angle [deg]','FontName','Arial','FontSize',14);

ax(2) = nexttile(2); 
pairBox(ax(2), knee_st_rom_noexo,knee_st_rom_exo, knee_st_mean_noexo,knee_st_mean_exo, ...
        p_knee_st_rom,p_knee_st_mean, 'Stoop', colNoExo,colExo,posPair,xt,xlabels);
% ylabel(ax(2),'Flexion [deg]','FontName','Arial','FontSize',10);

ax(3) = nexttile(3); 
pairBox(ax(3), knee_bl_rom_noexo,knee_bl_rom_exo, knee_bl_mean_noexo,knee_bl_mean_exo, ...
        p_knee_bl_rom,p_knee_bl_mean, 'Bilateral', colNoExo,colExo,posPair,xt,xlabels);
% ylabel(ax(3),'Flexion [deg]','FontName','Arial','FontSize',10);

% ---- 2a RIGA: HIP ----
ax(4) = nexttile(4); 
pairBox(ax(4), hip_sq_rom_noexo,hip_sq_rom_exo, hip_sq_mean_noexo,hip_sq_mean_exo, ...
        p_hip_sq_rom,p_hip_sq_mean, '', colNoExo,colExo,posPair,xt,xlabels);
ylabel(ax(4),'Hip Flex-Ext Angle [deg]','FontName','Arial','FontSize',14);

ax(5) = nexttile(5); 
pairBox(ax(5), hip_st_rom_noexo,hip_st_rom_exo, hip_st_mean_noexo,hip_st_mean_exo, ...
        p_hip_st_rom,p_hip_st_mean, '', colNoExo,colExo,posPair,xt,xlabels);
% ylabel(ax(5),'Flexion [deg]','FontName','Arial','FontSize',10);

ax(6) = nexttile(6); 
pairBox(ax(6), hip_bl_rom_noexo,hip_bl_rom_exo, hip_bl_mean_noexo,hip_bl_mean_exo, ...
        p_hip_bl_rom,p_hip_bl_mean, '', colNoExo,colExo,posPair,xt,xlabels);
% ylabel(ax(6),'Flexion [deg]','FontName','Arial','FontSize',10);

% ---- Legenda in alto al centro ----
axes(ax(1)); %#ok<LAXES>
p1 = patch(NaN,NaN,colNoExo,'FaceAlpha',0.4,'EdgeColor','k');
p2 = patch(NaN,NaN,colExo,  'FaceAlpha',0.4,'EdgeColor','k');
% legend([p1 p2],{'NoExo','Exo'},'Location','northoutside','Orientation','horizontal',...
       % 'Box','off','FontName','Arial','FontSize',10);

%--------- y lim -------
ylim(ax(1), [-60 110]);   % Knee - Squat
ylim(ax(2), [-20 40]);     % Knee - Stoop
ylim(ax(3), [-40 90]);     % Knee - Bilateral

ylim(ax(4), [10 110]);   % Hip - Squat
ylim(ax(5), [-10 90]);     % Hip - Stoop
ylim(ax(6), [0 100]);   % Hip - Bilateral
% ---- Rimuove le linee verticali dalla griglia ----
for i = 1:numel(ax)
    set(ax(i),'XGrid','on','YGrid','on');  % abilita la griglia
    ax(i).GridLineStyle = ':';             % linee puntinate leggere
    ax(i).YGrid = 'on';                    % solo orizzontali
    ax(i).XGrid = 'off';                   % niente verticali
end

% ---- Esportazione ----
exportgraphics(fig,'KneeHip_Boxplot_Horizontal.pdf','ContentType','vector',...
    'BackgroundColor','none','Resolution',300);

%% ================== FUNZIONI LOCALI (devono stare alla fine) ==================
function pairBox(ax, noexo_rom, exo_rom, noexo_mean, exo_mean, p_rom, p_mean, ttl, colNoExo,colExo,posPair,xt,xlabels)
    axes(ax); hold on; box on; grid on;

    % --- ROM (prime 2 box) ---
    dataRom = [noexo_rom(:); exo_rom(:)];
    grpRom  = [repmat({'NoExo'},numel(noexo_rom),1); repmat({'Exo'},numel(exo_rom),1)];
    h1 = boxplot(dataRom, grpRom, 'Positions',posPair(1:2), 'Widths',0.45, ...
                 'Symbol','k+', 'Colors',[0 0 0]);
    set(h1,{'LineWidth'},{1.1});

    % --- MEAN (altre 2 box) ---
    dataMean = [noexo_mean(:); exo_mean(:)];
    grpMean  = [repmat({'NoExo'},numel(noexo_mean),1); repmat({'Exo'},numel(exo_mean),1)];
    h2 = boxplot(dataMean, grpMean, 'Positions',posPair(3:4), 'Widths',0.45, ...
                 'Symbol','k+', 'Colors',[0 0 0]);
    set(h2,{'LineWidth'},{1.1});

    % ===== COLORA TUTTE LE BOX (ROM e MEAN) =====
    % Prende tutte le box presenti nell'asse, le riordina ROM->MEAN,
    % e colora alternando NoExo/Exo.
    boxes = findobj(ax,'Tag','Box');        % ordine: ultimo disegnato per primo
    boxes = flipud(boxes);                  % ora: ROM-NoExo, ROM-Exo, MEAN-NoExo, MEAN-Exo
    for i = 1:numel(boxes)
        if mod(i,2)==1
            c = colNoExo;                   % NoExo
        else
            c = colExo;                     % Exo
        end
        patch(get(boxes(i),'XData'), get(boxes(i),'YData'), c, ...
              'FaceAlpha',0.4, 'EdgeColor','k');
    end

    % Etichette e titolo
    set(ax,'XTick',xt,'XTickLabel',xlabels,'FontName','Arial','FontSize',14);
    title(ax, ttl, 'FontName','Arial','FontWeight','normal','FontSize',14);

    % --- p-value: se NaN eseguo t-test appaiato ---
    if isnan(p_rom);  [~,p_rom]  = ttest(noexo_rom,  exo_rom);  end
    if isnan(p_mean); [~,p_mean] = ttest(noexo_mean, exo_mean); end

    % --- Asterischi ---
    yAll = [dataRom; dataMean];
    yPad = 0.04*range(yAll);
    yR = max(dataRom)  + yPad;
    yM = max(dataMean) + yPad;
    drawSig(ax, posPair(1), posPair(2), yR, p_rom);
    drawSig(ax, posPair(3), posPair(4), yM, p_mean);
end
function drawSig(ax, x1,x2,y,p)
    % Disegna linea + asterischi solo se significativo
    if  p < 0.05
        stars = '*';
    else
        return  % <-- esce subito, non disegna niente
    end

    % linea orizzontale sopra le box
    plot(ax,[x1 x2],[y y],'k','LineWidth',1);
    % testo centrato sopra la linea
    text(ax, mean([x1 x2]), y + 0.02*abs(y+eps), stars, ...
        'HorizontalAlignment','center','FontName','Arial','FontSize',11);
end
