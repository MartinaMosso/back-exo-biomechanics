
% CREATE_KNEE_HIP_BARS
% Grafici a barre "publish-ready" per Knee e Hip flexion (ROM e Media),
% separati per task Squat e Bilateral. Barre NoExo vs Exo con ±SD e annotazioni di significatività.
%
% OUTPUT:
%   ./fig/Fig_KneeHip.pdf  (PDF vettoriale per Overleaf)
%   ./fig/Fig_KneeHip.png  (PNG 600 dpi)

%% ---------- STILE ----------
clrNoExo = [120 160 160]/256;   % NoExo (più scuro)
clrExo   = [150  40 110]/256;   % Exo   (più scuro)
fsBase   = 11;      % font base
barW     = 0.8;     % larghezza gruppo (per categoria ROM/Mean)
ebLW     = 1.1;     % spessore barre d'errore
astFS    = 12;      % font asterisco
yPad     = 0.06;    % padding verticale per asterischi (in frazione del range)

% interpreti LaTeX (opzionale)
set(0,'defaultTextInterpreter','latex');
set(0,'defaultAxesTickLabelInterpreter','latex');
set(0,'defaultLegendInterpreter','latex');

% cartella output
outDir = fullfile(pwd,'fig');
if ~exist(outDir,'dir'), mkdir(outDir); end

%% ---------- INSERISCI I TUOI DATI QUI ----------
% Inserisci VETTORI (uno per soggetto) in gradi [deg].
% Se vuoi che il codice calcoli i p-value: lascia p = NaN (fa paired t-test NoExo vs Exo).
% Se hai già i p-value: metti il numero (es. 0.012).

% -------- SQUAT --------
% Knee
knee_sq_rom_noexo  = [68.6750   85.9661   92.3417   94.6491   94.9984   92.9386   78.9215   91.9969];   
knee_sq_rom_exo  = [51.6476   67.5074   81.1033   80.1855   75.9514   89.6138   63.0007   90.1167];
p_knee_sq_rom  = 0.001;

knee_sq_mean_noexo = [-23.0821  -47.1543  -36.3193  -47.7273  -46.2155  -48.5153  -54.0121  -52.7152];
knee_sq_mean_exo = [ -25.2908  -40.0276  -49.4427  -38.7999  -42.2807  -46.5375  -49.0661  -54.7463];  
p_knee_sq_mean = 0.64;
% Hip

hip_sq_rom_noexo   = [93.1859   93.9049   84.9693   83.5471   79.0789   70.3868   73.1080   59.3876];
hip_sq_rom_exo   = [81.1174   61.8038   60.0260   63.1086   62.2621   54.0955   66.3363  54.5921 ];   
p_hip_sq_rom   = 0.0012;

hip_sq_mean_noexo  = [30.7746   32.1107   26.6625   43.3766   39.8509   36.2188   57.5160   43.1154];   
hip_sq_mean_exo  = [40.0732   16.1123   34.5152   31.9283   32.4152   23.2159   54.0012   35.8139];  
p_hip_sq_mean  = 0.1594;

% -------- STOOP --------
% (PLACEHOLDER) Inserisci qui i tuoi vettori; se lasci p = NaN calcola il t-test.
% Knee
knee_st_rom_noexo  = [4.2438   14.3785   14.3713   20.3719   11.8445   32.9653    8.4864 11.4046];   % <-- INSERISCI DATI
knee_st_rom_exo    = [5.1705   17.9322    8.3922   15.4078   10.8488    7.1403   13.1773   21.0786];   % <-- INSERISCI DATI
p_knee_st_rom      = 0.5544;  % nel tuo caso atteso n.s.

knee_st_mean_noexo = [6.6932    0.1104   -3.7139   -6.0132    3.7418   -9.9537   -8.9509  -17.4927];   % <-- INSERISCI DATI
knee_st_mean_exo   = [1.2130    3.8115   -1.5930   12.4187    1.3176    2.1630  -11.9231   -9.3731];   % <-- INSERISCI DATI
p_knee_st_mean     = 0.1920;  % nel tuo caso atteso n.s.

% Hip
hip_st_rom_noexo   = [62.2636   56.8993   57.7764   66.0294   50.1303   77.5957   49.8502   50.4172];   % <-- INSERISCI DATI
hip_st_rom_exo     = [19.3968   -0.8337   16.1702   28.0440   14.6118   30.3502   36.6755   32.2405];   % <-- INSERISCI DATI
p_hip_st_rom       = 0.0205;  % nel tuo caso atteso n.s.

hip_st_mean_noexo  = [60.1035   40.4461   58.9513   46.1362   51.1193   60.0682   44.1144   36.5727];   % <-- INSERISCI DATI
hip_st_mean_exo    = [32.2173   -1.4277   15.3042   13.0281   16.5838   20.8595   38.4780   25.3061];   % <-- INSERISCI DATI
p_hip_st_mean      = 0.5183;  % nel tuo caso atteso n.s.

% -------- BILATERAL --------
% Knee
knee_bl_rom_noexo  = [61.8304   50.4782   64.2194   60.7149    9.2834   70.0253   55.2462   38.5026];   
knee_bl_rom_exo  = [83.6553   43.4302   31.0325   55.5939   27.3466   46.1208   53.6097   25.1061];   
p_knee_bl_rom  = 0.43;
knee_bl_mean_noexo = [-19.7232  -23.4063  -17.5775  -24.9022    1.5321  -20.5292  -34.2752  -32.2567];   
knee_bl_mean_exo = [ -32.9742  -21.3555   -7.3193  -23.4859   -8.7887  -10.5379  -38.6648  -25.2010];   
p_knee_bl_mean = 0.91;
% Hip
hip_bl_rom_noexo   = [87.3809   85.6424   64.5949   80.7144   45.9529   81.0300   70.7266   49.4991];   
hip_bl_rom_exo   = [77.3699   60.8065   43.2264   63.5778   57.5247   48.4247   66.0531   31.2640];   
p_hip_bl_rom   = 0.018;
hip_bl_mean_noexo  = [29.4601   10.6341   14.3890   32.1320   15.0219   24.9953   41.3303   39.5793];   
hip_bl_mean_exo  = [30.2618    5.5661    8.5938   21.2772   15.0037   12.7687   42.4846   32.0021];   
p_hip_bl_mean  = 0.03;


%% ---------- PACK DATI (non modificare) ----------
% Ogni subplot ha due categorie: {ROM, Mean}, ognuna con due barre {NoExo, Exo}
SQUAT_KNEE = struct('name','Squat -- Knee', ...
  'data',{{ {knee_sq_rom_noexo,  knee_sq_rom_exo,  p_knee_sq_rom}, ...
            {knee_sq_mean_noexo, knee_sq_mean_exo, p_knee_sq_mean} }});

SQUAT_HIP = struct('name','Squat -- Hip', ...
  'data',{{ {hip_sq_rom_noexo,   hip_sq_rom_exo,   p_hip_sq_rom}, ...
            {hip_sq_mean_noexo,  hip_sq_mean_exo,  p_hip_sq_mean} }});

STOOP_KNEE = struct('name','Stoop -- Knee', ...
  'data',{{ {knee_st_rom_noexo,  knee_st_rom_exo,  p_knee_st_rom}, ...
            {knee_st_mean_noexo, knee_st_mean_exo, p_knee_st_mean} }});
STOOP_HIP = struct('name','Stoop -- Hip', ...
  'data',{{ {hip_st_rom_noexo,   hip_st_rom_exo,   p_hip_st_rom}, ...
            {hip_st_mean_noexo,  hip_st_mean_exo,  p_hip_st_mean} }});

BILAT_KNEE = struct('name','Bilateral -- Knee', ...
  'data',{{ {knee_bl_rom_noexo,  knee_bl_rom_exo,  p_knee_bl_rom}, ...
            {knee_bl_mean_noexo, knee_bl_mean_exo, p_knee_bl_mean} }});

BILAT_HIP = struct('name','Bilateral -- Hip', ...
  'data',{{ {hip_bl_rom_noexo,   hip_bl_rom_exo,   p_hip_bl_rom}, ...
            {hip_bl_mean_noexo,  hip_bl_mean_exo,  p_hip_bl_mean} }});

PLOTS = {SQUAT_KNEE, SQUAT_HIP;
         STOOP_KNEE, STOOP_HIP;
         BILAT_KNEE, BILAT_HIP};
catLabels = {'ROM','Mean'};

%% 
fig = figure('Color','w','Units','centimeters','Position',[2 2 18 18.5]);
tiledlayout(fig,3,2,'Padding','compact','TileSpacing','compact');

for r = 1:3
    for c = 1:2
        nexttile((r-1)*2 + c); hold on; box on;

        block = PLOTS{r,c};
        % Prepara medie e SD
        mu   = zeros(2,2);  % [cat x cond]
        sig  = zeros(2,2);
        pval = nan(2,1);

        for k = 1:2 % categorie: ROM(1), Mean(2)
            dNo = block.data{k}{1}; % vettore NoExo
            dEx = block.data{k}{2}; % vettore Exo
            pv  = block.data{k}{3}; % p-val (NaN -> calcola)

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

        % Asse, titoli, labels
        set(gca,'XTick',1:2,'XTickLabel',catLabels,'FontSize',fsBase);
        ylabel('Flexion [deg]','FontSize',fsBase);
        title(block.name,'FontSize',fsBase+1,'FontWeight','bold');

        % Annotazione significatività (ROM, Mean)
        yMax = max([mu(:)+sig(:)],[],'all','omitnan');
        yMin = min([mu(:)-sig(:)],[],'all','omitnan');
        if ~isfinite(yMax), yMax = 1; end
        if ~isfinite(yMin), yMin = 0; end
        yr   = yMax - yMin; if yr==0, yr = 1; end

        for k = 1:2
            if ~isnan(pval(k)) && ~isempty(pval(k))
                xL = b(1).XEndPoints(k); xR = b(2).XEndPoints(k);
                yH = max(mu(k,:) + sig(k,:)) + yPad*yr; % altezza linea
                plot([xL xR],[yH yH],'k-','LineWidth',1);
                ast = p2ast(pval(k));
                text(mean([xL xR]), yH + 0.015*yr, ast, ...
                     'HorizontalAlignment','center','VerticalAlignment','bottom', ...
                     'FontSize',astFS,'FontWeight','bold');
            end
        end

        % Griglia leggera
        grid on; ax = gca; ax.GridLineStyle=':'; ax.GridAlpha=0.2;

        % Legenda una volta sola (in alto a destra del primo row)
        if r==1 && c==2
            legend({'NoExo','Exo'},'Location','northoutside','Orientation','horizontal', ...
                   'Box','off','FontSize',fsBase-1);
        end
    end
end
%% ---------- FIGURA ----------
fig = figure('Color','w','Units','centimeters','Position',[2 2 17.5 12]);
tiledlayout(fig,2,2,'Padding','compact','TileSpacing','compact');

for r = 1:2
    for c = 1:2
        nexttile((r-1)*2 + c); hold on; box on;

        block = PLOTS{r,c};
        % Prepara medie e SD
        mu   = zeros(2,2);  % [cat x cond]
        sig  = zeros(2,2);
        pval = zeros(2,1);

        for k = 1:2 % categorie: ROM(1), Mean(2)
            dNo = block.data{k}{1}; % vettore NoExo
            dEx = block.data{k}{2}; % vettore Exo
            pv  = block.data{k}{3}; % p-val (NaN -> calcola)
            mu(k,1)  = mean(dNo,'omitnan');   sig(k,1) = std(dNo,'omitnan');
            mu(k,2)  = mean(dEx,'omitnan');   sig(k,2) = std(dEx,'omitnan');

            if isnan(pv) && ~isempty(dNo) && ~isempty(dEx) && numel(dNo)==numel(dEx)
                [~,pv] = ttest(dNo, dEx); % paired t-test
            end
            pval(k) = pv;
        end

        % Disegno barre by category (gruppi) con 2 barre per gruppo (NoExo, Exo)
        % Posizioni XT: 1 = ROM, 2 = Mean
        b = bar(mu, 'grouped', 'BarWidth', barW);
        b(1).FaceColor = clrNoExo; b(1).EdgeColor = 'k';
        b(2).FaceColor = clrExo;   b(2).EdgeColor = 'k';

        % Error bars
        hold on;
        % Calcola le posizioni x dei bar per mettere le errorbar
        ngroups = size(mu,1); nbars = size(mu,2);
        x = nan(nbars, ngroups);
        for i = 1:ngroups
            x(:,i) = b(1).XEndPoints(i) + [0, (b(2).XEndPoints(i)-b(1).XEndPoints(i))];
        end
        % In realtà MATLAB 2020+ fornisce XEndPoints per ciascuna barra:
        x1 = b(1).XEndPoints; % NoExo
        x2 = b(2).XEndPoints; % Exo
        errorbar(x1, mu(:,1), sig(:,1), 'k', 'linestyle','none','LineWidth',ebLW, 'CapSize',6);
        errorbar(x2, mu(:,2), sig(:,2), 'k', 'linestyle','none','LineWidth',ebLW, 'CapSize',6);

        % Asse, titoli, labels
        set(gca,'XTick',1:2,'XTickLabel',catLabels,'FontSize',fsBase);
        ylabel('Flexion [deg]','FontSize',fsBase);
        title(block.name,'FontSize',fsBase+1,'FontWeight','bold');

        % Annotazione significatività per ciascuna categoria (ROM, Mean)
        yMax = max([mu(:)+sig(:)],[],'all','omitnan');
        yMin = min([mu(:)-sig(:)],[],'all','omitnan');
        yr   = yMax - yMin; if yr==0, yr = 1; end
        for k = 1:2
            if ~isnan(pval(k))
                % coord tra le due barre del gruppo k
                xL = b(1).XEndPoints(k); xR = b(2).XEndPoints(k);
                yH = max(mu(k,:) + sig(k,:)) + yPad*yr; % altezza linea
                plot([xL xR],[yH yH],'k-','LineWidth',1);
                % asterischi
                ast = p2ast(pval(k));
                text(mean([xL xR]), yH + 0.015*yr, ast, 'HorizontalAlignment','center', ...
                     'VerticalAlignment','bottom','FontSize',astFS,'FontWeight','bold');
            end
        end

        % Griglietta leggera
        grid on; ax = gca; ax.GridLineStyle=':'; ax.GridAlpha=0.2;
        if r==1 && c==2
            legend({'NoExo','Exo'},'Location','northoutside','Orientation','horizontal','Box','off','FontSize',fsBase-1);
        end
    end
end

%% ---------- ESPORTAZIONE ----------
set(fig,'Renderer','painters'); % vettoriale
pdfFile = fullfile(outDir,'Fig_KneeHip.pdf');
pngFile = fullfile(outDir,'Fig_KneeHip.png');
exportgraphics(fig, pdfFile, 'ContentType','vector');
exportgraphics(fig, pngFile, 'Resolution',600);
fprintf('Saved:\n  %s\n  %s\n 2', pdfFile, pngFile);

 % function

%% ---------- HELPER: p-value -> asterischi ----------
function ast = p2ast(p)
if     p < 0.001, ast = '***';
elseif p < 0.01,  ast = '**';
elseif p < 0.05,  ast = '*';
else,             ast = 'n.s.';
end
end
