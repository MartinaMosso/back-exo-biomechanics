

function [DataInterp] = InterpSegmentP2(Data, Method)

% Datastr.cutMovements.ID
% Datastr.cutMovements.EMG

%% Cut data and interpolate to find reps as function of movement cycle
% Define movement phase
movPhase = 0:1:1000;





    % Interpolation to find movement cycle values from 0:1:100

       
        x = linspace(0,length(movPhase),length(Data));
        DataInterp = spline(x,Data,movPhase);

  

   
end
% 
% save(nameFIle, 'Datastr')