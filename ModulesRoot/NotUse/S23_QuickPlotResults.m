function [Datastr] = S23_QuickPlotResults(Datastr)

% Load MVC values
MVClocation = strcat(Datastr.Info.SubjRoot, '\dynMVCvalue.mat');
load(MVClocation, 'MVCvalueMax')

% Get movement
Movement = Datastr.Info.Trial;
Movement = regexprep(Movement,'_','','emptymatch');

% Get subject
Subject = regexp(Datastr.Info.SubjRoot, '\', 'split');
Subject = Subject(4); 

% Get emg data and normalize based on dynMVC data
EMGabd = Datastr.Resample.EMG(:,1:6)./MVCvalueMax(1:6);
EMGback = Datastr.Resample.EMG(:,9:14)./MVCvalueMax(9:14);

% Get L5S1 moments, and normalize wrt subject weight
L5S1Moments = Datastr.Resample.IDTrqData(:,18:20)./Datastr.Info.subjMass(1);  

% Get labels
abdEMGLabels = Datastr.EMG.DataLabel(1:6);
backEMGlabels = Datastr.EMG.DataLabel(9:14);
L5S1labels = Datastr.Resample.IDTrqDataLabel(18:20);

% Plot results
f1 = figure('visible','off');
f11 = stackedplot(EMGabd, "Title", strcat(Movement, ' ', Subject), "DisplayLabels",abdEMGLabels);
for i = 1:numel(f11.AxesProperties)
    f11.AxesProperties(i).YLimits = [0 1];
end
fileNamef1 = strcat(Movement, '_EMGabd');

f2 = figure('visible','off');
f22 = stackedplot(EMGback, "Title", strcat(Movement, ' ', Subject), "DisplayLabels",backEMGlabels);
for i = 1:numel(f22.AxesProperties)
    f22.AxesProperties(i).YLimits = [0 1];
end
fileNamef2 = strcat(Movement, '_EMGback');

f3 = figure('visible','off');
stackedplot(L5S1Moments, "Title", strcat(Movement, ' ', Subject), "DisplayLabels",L5S1labels)
fileNamef3 = strcat(Movement, '_L5S1Moments');

% Save figures in folder
oldFolderMain = cd(Datastr.Info.SubjRoot);
status = mkdir('quickCheckDataPlots');

% Save Results
filenamef1 = strcat(fileNamef1, '.jpeg');
filenamef2 = strcat(fileNamef2, '.jpeg');
filenamef3 = strcat(fileNamef3, '.jpeg');
            oldfolder = cd('quickCheckDataPlots');
            saveas (f1, filenamef1)
            saveas (f2, filenamef2)
            saveas (f3, filenamef3)
            cd(oldfolder)
cd(oldFolderMain)
end
