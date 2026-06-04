function PLOT_L5S1_MOMENTS(D, outfile)
% PLOT_L5S1_MOMENTS
% Tre pannelli (Squat, Stoop, Bilateral) con curva media e fascia ±SD per NoExo/Exo.
% Legenda SOLO "NoExo" e "Exo" (le fasce non entrano in legenda).
%
% INPUT (struct D):
%   D.<task>.t            [1xN] opzionale, altrimenti 0..100
%   D.<task>.noexo.mean   [1xN] o [Nx1]
%   D.<task>.noexo.std    [1xN] o [Nx1]
%   D.<task>.exo.mean     [1xN] o [Nx1]
%   D.<task>.exo.std      [1xN] o [Nx1]
%   task = squat | stoop | bilateral
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
if nargin < 2 || isempty(outfile), outfile = './fig/Fig_L5S1_Moments'; end
[outDir,~,~] = fileparts(outfile);
if ~isempty(outDir) && ~exist(outDir,'dir'), mkdir(outDir); end

% ---------- Figura ----------
fig = figure('Color','w','Units','centimeters','Position',[2 2 18 7.5]);
tiledlayout(fig,1,3,'Padding','compact','TileSpacing','compact');

tasks  = {'squat','stoop','bilateral'};
titles = {'Squat','Stoop','Bilateral'};

for i = 1:3
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

    nexttile(i); hold on; box on;

    % --- fasce ±SD (escluse dalla legenda) ---
    hNoFill = fillBand(t, mNo, sNo, clrNoExo, 0.25); set(hNoFill,'HandleVisibility','off');
    hExFill = fillBand(t, mEx, sEx, clrExo,   0.25); set(hExFill,'HandleVisibility','off');

    % --- curve medie (ENTRANO in legenda) ---
    hNo = plot(t, mNo, 'Color', clrNoExo, 'LineWidth', lwLine, 'DisplayName','NoExo');
    hEx = plot(t, mEx, 'Color', clrExo,   'LineWidth', lwLine, 'DisplayName','Exo');

    % assi/etichette
    xlabel('Lifting cycle (\%)','FontSize',fsBase);
    if i ==1
    ylabel('L5S1 Moment (Nm/BW)','FontSize',fsBase);
    end
    title(titles{i},'FontSize',fsBase+1,'FontWeight','bold');
    set(gca,'FontSize',fsBase);

    % griglia leggera
    grid on; ax = gca; ax.GridLineStyle=':'; ax.GridAlpha=0.20;

    % legenda "NoExo / Exo" in alto a destra UNA SOLA VOLTA (pannello centrale)
    if i==3
        % legend([hNo hEx], {'NoExo','Exo'}, ...
            % 'Location','northeast', 'Box','off', 'FontSize', fsBase-1);
    
% % lg = legend({'NoExo','Exo'},'Location','northoutside', ...
                   % 'Orientation','horizontal','Box','off','FontSize',fsBase-1);
% set(lg,'Color','none');   % sfondo trasparente

    end
    % limiti Y puliti
    allY = [mNo+sNo, mNo-sNo, mEx+sEx, mEx-sEx];
    yMax = max(allY,[],'all','omitnan'); 
    yMin = min(allY,[],'all','omitnan');
    if ~isfinite(yMax), yMax = 1; end
    if ~isfinite(yMin), yMin = 0; end
    yr = yMax - yMin; if yr<=0, yr = 1; end
    ylim([yMin-0.05*yr, yMax+0.05*yr]);
end

% ---------- Export ----------
set(fig,'Renderer','painters'); % vettoriale
exportgraphics(fig, [outfile '.pdf'], 'ContentType','vector');
exportgraphics(fig, [outfile '.png'], 'Resolution',600);
fprintf('Saved:\n  %s.pdf\n  %s.png\n', outfile, outfile);
end

% ===== helper: fascia ±SD (ritorna handle per gestire la legenda) =====
function h = fillBand(x, m, s, col, alpha)
    xx = [x, fliplr(x)];
    yy = [m+s, fliplr(m-s)];
    h = fill(xx, yy, col, 'EdgeColor','none'); 
    h.FaceAlpha = alpha;
end
