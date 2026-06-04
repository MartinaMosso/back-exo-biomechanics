%% comapring L5S1 moment, between OS e CEINMS

clear; close all; clc

%% import

task = {'noExo_BL_10', 'yesExo_BL_10'};
% task = {'noExo_SQ_10',  'yesExo_SQ_10', 'noExo_ST_10',  'yesExo_ST_10'};
% task = {'noExo_SQ_0', 'noExo_SQ_5', 'noExo_SQ_10', 'noExo_SQ_15', 'yesExo_SQ_10', 'noExo_ST_0', 'noExo_ST_5', 'noExo_ST_10', 'noExo_ST_15', 'yesExo_ST_10'};

sbj = {'SUB005', 'SUB006', 'SUB007', 'SUB008', 'SUB009', 'SUB010', 'SUB011', 'SUB012'};

%%
Nresample = [];
for t = 1:length(task)
    for s=1:length(sbj)

        % CEINMSStruct = importdata(['C:\Twente\IUVO\', sbj{s}, '\CEINMS\execution\OP\EMG\', sbj{s}, task{t}, '\torques.sto']);
                CEINMSStruct = importdata(['C:\Twente\IUVO\', sbj{s}, '\CEINMS\execution\OP\EMG_calibOne_standardParam\', sbj{s}, task{t}, '\torques.sto']);

        CEINMS = movmean(CEINMSStruct.data(:,end), 20);

        load(['C:\Twente\IUVO\', sbj{s}, '\', sbj{s}, '_', task{t}, '.mat'])
        OS=Datastr.Resample.IDTrqData(:,18)/(Datastr.Info.subjMass);
        CEINMS =CEINMS/(Datastr.Info.subjMass);

    if length(OS)>length(CEINMS)
        OS = OS(1:end-1,:);
    elseif  length(OS)<length(CEINMS)
        CEINMS =CEINMS(1:end-1,:);
    end
out = quick_compare_series(OS, CEINMS, Nresample);

            RMSE(s,t)  = out.rmse;
            R2(s,t)    = out.R2;
            NRMSE(s,t) = out.nrmse_range; % frazione del range OS


    end
end


for t = 1:2
  
        meanR2(t)  = mean(R2(:,t), 'omitnan');
        sdR2(t)    = std(R2(:,t), 'omitnan');
        meanRMSE(t) = mean(RMSE(:,t), 'omitnan');
        sdRMSE(t)  = std(RMSE(:,t), 'omitnan');

        % fprintf('%s | %s: R^2 = %.3f ± %.3f, RMSE = %.2f ± %.2f Nm\n',...
        %     taskNames{t}, condNames{c}, meanR2, sdR2, meanRMSE, sdRMSE);

end

function out = quick_compare_series(os, ce, N)
% Confronto CEINMS vs OpenSim senza segmentare: RMSE, R^2, NRMSE(%range), lag
% - N opzionale: numero di punti per il resampling comune
% - Gestisce NaN/Inf, niente zscore (niente toolbox), evita std=0

    if nargin < 3 || isempty(N)
        N = min(numel(os), numel(ce));
    end

    % --- sicurezza tipo/shape ---
    os = double(os(:));
    ce = double(ce(:));

    % --- rimuovi campioni non finiti in coppia ---
    ok = isfinite(os) & isfinite(ce);
    os = os(ok); ce = ce(ok);
    if numel(os) < 10 || numel(ce) < 10
        error('quick_compare_series:NotEnoughData', 'Pochi campioni finiti dopo la pulizia.');
    end

    % --- centra alla media (niente zscore) ---
    osd = os - mean(os);
    ced = ce - mean(ce);

    % --- cross-correlazione normalizzata per stimare il lag ---
    try
        [xc,lags] = xcorr(osd, ced, 'coeff');   % 'coeff' = normalizzata all'energia
        [~,imax]  = max(xc);
        lag       = lags(imax);
    catch
        % fallback se xcorr dovesse comunque fallire
        lag = 0;
    end

    % --- applica lag (shift con zeri) ---
    if lag > 0
        % CE in ritardo → shifta CE avanti
        ced = [zeros(lag,1); ced(1:end-lag)];
    elseif lag < 0
        % OS in ritardo → shifta OS avanti
        osd = [zeros(-lag,1); osd(1:end+lag)];
    end

    % --- taglia alla parte comune ---
    L = min(numel(osd), numel(ced));
    osd = osd(1:L); ced = ced(1:L);

    % --- resampling comune a N punti ---
    xi  = linspace(1, L, N);
    osN = interp1(1:L, osd, xi, 'pchip')';
    ceN = interp1(1:L, ced, xi, 'pchip')';

    % --- metriche ---
    diff = ceN - osN;
    rmse = sqrt(mean(diff.^2));

    SSE = sum(diff.^2);
    SST = sum( (osN - mean(osN)).^2 );
    if SST <= eps
        R2 = NaN;  % nel caso degenerato di segnale piatto
    else
        R2 = 1 - SSE / SST;
    end

    rngOS = max(osN) - min(osN);
    if rngOS <= eps, nrmse_range = NaN; else, nrmse_range = rmse / rngOS; end

    out = struct('rmse',rmse, 'R2',R2, ...
                 'nrmse_range', nrmse_range, ...
                 'lag_samples', lag, ...
                 'osN', osN, 'ceN', ceN);
end
