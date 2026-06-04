function [Datastr] = S2_selectTrialandWeightSTATIC(Datastr)

% Select, based on the filename of the trial, the movement and the lifted
% weight and add this info to the Info tab of the Datastruct.
%
% Jan Willem Rook, 08-11-2023, j.w.a.rook@student.utwente.nl

% Obtain trial info from file name
MovemenInfo = regexp(Datastr.Info.Trial, '_', 'split');     % (no)Exo | Movement | Weight
ExoCond  = MovemenInfo(1);
Movement = MovemenInfo(2);
% Weight   = MovemenInfo(3);

% Select if the movement is horizontal or vertical and save in Datastruct
if contains(Movement, 'UT') || contains(Movement, 'BT')
    Datastr.Info.horMovFlag     = 1;
    Datastr.Info.vertMovFlag    = 0;
elseif contains(Movement, 'SQ') || contains(Movement, 'ST')
    Datastr.Info.horMovFlag     = 0;
    Datastr.Info.vertMovFlag    = 1;
else
    Datastr.Info.horMovFlag     = 0;
    Datastr.Info.vertMovFlag    = 1;

end

% Select the correct box model based on the weight and save in Datastruct
% if contains(Weight, '150')
%     Datastr.Info.objectosmodfile = 'BoxModel\BOX_16.2kg.osim';
% elseif contains(Weight, '75')
%     Datastr.Info.objectosmodfile = 'BoxModel\BOX_8.7kg.osim';
% elseif contains(Weight, '0')
%     Datastr.Info.objectosmodfile = 'BoxModel\BOX_1.2kg.osim';
% else
%     disp('Invalid file name. Unable to select the correct Box model')
% end
%
% Flag if exo is used during this trial
if contains(ExoCond, 'noExo')
    Datastr.Info.exoFlag = 0;
else
    Datastr.Info.exoFlag = 1;
end

end