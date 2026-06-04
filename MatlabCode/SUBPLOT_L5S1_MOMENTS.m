function SUBPLOT_L5S1_MOMENTS(D1, D2, outfile)
% SUBPLOT_L5S1_MOMENTS - Confronto di due dataset in 2 righe x 3 colonne.
% Ogni riga mostra i tre task (Squat, Stoop, Bilateral) con curva media e fascia ±SD per NoExo/Exo.
% Legenda unica "NoExo / Exo" (le fasce non entrano in legenda).
%
% INPUT:
%   D1, D2 = strutture con campi:
%       .<task>.t            [1xN] opzionale, altrimenti 0..100
%       .<task>.noexo.mean   [1xN] o [Nx1]
%       .<task>.noexo.std    [1xN] o [Nx1]
%       .<task>.exo.mean     [1xN] o [Nx1]
%       .<task>.exo.std      [1xN] o [Nx1]
%       task = squat | stoop | bilateral
%
% OUTPUT:
%   ./fig/Fig_L5S1_Moments.pdf (vettoriale)
%   ./fig/Fig_L5S1_Moments.png (600 dpi)

% ---------- Stile ----------
clrNoExo = [120 160 160]/256;   % teal
clrExo   = [150  40 110]/256;   % magenta
lwLine   = 1.8;
fsBase   = 11;

% interpreti LaTeX
set(0,'defaultTextInterpreter','latex');
set(0,'defaultAxesTickLabelInterpreter','latex');
set(0,'defaultLegendInterpreter','latex');

% output
if nargin < 3 || isempty(outfile), outfile = './fig/Fig_L5S1_Moments'; end
[outDir,~,~] = fileparts(outfile);
if ~isempty(outDir) && ~exist(outDir,'dir'), mkdir(outDir); end

% ---------- Figura ----------
fig = figure('Color','w','Units','centimeters','Position',[2 2 18 14]);
tl = tiledlayout(fig,2,3,'Padding','compact','TileSpacing','compact');

tasks  = {'squat','stoop','bilateral'};
titles = {'Squat','Stoop','Bilateral'};

% memorizza handle per legenda
hNo_all = gobjects(0); 
hEx_all = gobjects(0);

for r = 1:2                     % due righe (dataset diversi)
    if r==1 
    D = D1;
    else D =D2;         % scegli dataset corrente
    end
    for i = 1:3                 % tre colonne (task)
        T = D.(tasks{i});

        % asse x
        if ~isfield(T,'t') || isempty(T.t)
            N = numel(T.noexo.mean);
            t = linspace(0,100,N);
        else
            t = T.t(:).';
        end

        % dati riga
        mNo = T.noexo.mean(:).';   sNo = T.noexo.std(:).';
        mEx = T.exo.mean(:).';     sEx = T.exo.std(:).';
        assert(numel(t)==numel(mNo) && numel(mNo)==numel(sNo) && ...
               numel(mEx)==numel(sEx), 'Lunghezze non coerenti nel task %s', tasks{i});

        nexttile((r-1)*3 + i); hold on; box on;

        % --- fasce ±SD ---
        hNoFill = fillBand(t, mNo, sNo, clrNoExo, 0.25); set(hNoFill,'HandleVisibility','off');
        hExFill = fillBand(t, mEx, sEx, clrExo,   0.25); set(hExFill,'HandleVisibility','off');

        % --- curve medie ---
        hNo = plot(t, mNo, 'Color', clrNoExo, 'LineWidth', lwLine, 'DisplayName','NoExo');
        hEx = plot(t, mEx, 'Color', clrExo,   'LineWidth', lwLine, 'DisplayName','Exo');

        % Salva handle per legenda solo una volta
        if r==1 && i==1
            hNo_all = hNo;
            hEx_all = hEx;
        end

        % assi/etichette
        if r==2 
        xlabel('Lifting cycle (\%)','FontSize',fsBase);
        end
        if i==1 && r==1
            ylabel('L5S1 Moment [Nm/BW]','FontSize',fsBase);
        elseif i ==1 && r==2
                        ylabel('L5S1 Comp. Force [BW]','FontSize',fsBase);

        end
        if r==1
            title(titles{i},'FontSize',fsBase+1,'FontWeight','bold');
        end
        set(gca,'FontSize',fsBase);

        % griglia leggera
        grid on; ax = gca; ax.GridLineStyle=':'; ax.GridAlpha=0.20;

        % limiti Y puliti per pannello
        allY = [mNo+sNo, mNo-sNo, mEx+sEx, mEx-sEx];
        yMax = max(allY,[],'all','omitnan'); 
        yMin = min(allY,[],'all','omitnan');
        if ~isfinite(yMax), yMax = 1; end
        if ~isfinite(yMin), yMin = 0; end
        yr = yMax - yMin; if yr<=0, yr = 1; end
        ylim([yMin-0.05*yr, yMax+0.05*yr]);
    end
end

% ---------- Legenda unica ----------
% lgd = legend(tl, [hNo_all hEx_all], {'NoExo','Exo'}, ...
    % 'Location','northeast','Box','off','FontSize',fsBase-1);
% lgd.Color = 'none';

% ---------- Export ----------
set(fig,'Renderer','painters');
exportgraphics(fig, [outfile '.pdf'], 'ContentType','vector');
exportgraphics(fig, [outfile '.png'], 'Resolution',600);
fprintf('Saved:\n  %s.pdf\n  %s.png\n', outfile, outfile);
end

% ===== helper: fascia ±SD =====
function h = fillBand(x, m, s, col, alpha)
    xx = [x, fliplr(x)];
    yy = [m+s, fliplr(m-s)];
    h = fill(xx, yy, col, 'EdgeColor','none'); 
    h.FaceAlpha = alpha;
end
