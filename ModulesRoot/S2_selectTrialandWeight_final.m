function [Datastr] = S2_selectTrialandWeight_final(Datastr)

% Select, based on the filename of the trial, the movement and the lifted
% weight and add this info to the Info tab of the Datastruct.
%
% Jan Willem Rook, 08-11-2023, j.w.a.rook@student.utwente.nl

% Obtain trial info from file name
MovemenInfo = regexp(Datastr.Info.Trial, '_', 'split')     % (no)Exo | Movement | Weight

ExoCond  = MovemenInfo(1);
Movement = MovemenInfo(2);
Weight   = MovemenInfo(3);

% Select if the movement is horizontal or vertical and save in Datastruct
if contains(Movement, 'BL')
    Datastr.Info.horMovFlag     = 1;
    Datastr.Info.vertMovFlag    = 0;
elseif contains(Movement, 'SQ') || contains(Movement, 'ST')
    Datastr.Info.horMovFlag     = 0;
    Datastr.Info.vertMovFlag    = 1;
else % for phase 2
    Datastr.Info.horMovFlag     = 0;
    Datastr.Info.vertMovFlag    = 1;
    % disp('Invalid file name. Unable to flag the movement')

end

% Select the correct box model based on the weight and save in Datastruct
if contains(Weight, '15')
    Datastr.Info.objectosmodfile = 'BoxModel\BOX_16.2kg.osim';
elseif contains(Weight, '10')
    Datastr.Info.objectosmodfile = 'BoxModel\BOX_11.2kg.osim';
elseif contains(Weight, '5')
    Datastr.Info.objectosmodfile = 'BoxModel\BOX_6.2kg.osim';
elseif contains(Weight, '0')
    Datastr.Info.objectosmodfile = 'BoxModel\BOX_1.2kg.osim';
else 
    disp('Invalid file name. Unable to select the correct Box model')
end

% Flag if exo is used during this trial
if contains(ExoCond, 'noExo')
    Datastr.Info.exoFlag = 0;
else
    Datastr.Info.exoFlag = 1;
end

end