%% create segment P2

clear; close all; clc

%% import

sbj = 'SUB004';

indice = 1:31;

for i = 1:31

    trial =  ['SUB005_noExo_five', num2str(indice(i)), '_10.mat'];
    load(trial)
    if  isfield(Datastr, 'Resample') && isfield(Datastr.Resample, 'IKAngData') && isfield(Datastr.Resample, 'IDTrqData')
        ik(i).L5S1Angle = Datastr.Resample.IKAngData(:,24);
        id(i).L5S1 = Datastr.Resample.IDTrqData(:,18);
    else 
        ik(i).L5S1Angle = NaN;
        id(i).L5S1 = NaN;
    end
end

%% divide in 10 segments

nLift = 4; % lift or drop in one segment/cycle
nSegment = 10;


    segment(1).lift = [ik(1).L5S1Angle; ik(2).L5S1Angle; ik(3).L5S1Angle; ik(4).L5S1Angle(1:120,:)];
    segment(2).lift = [ik(4).L5S1Angle(121:end,:); ik(5).L5S1Angle; ik(6).L5S1Angle; ik(7).L5S1Angle(1:130,:)]; %nan
    segment(3).lift = [ik(7).L5S1Angle(131:end,:); ik(8).L5S1Angle; ik(9).L5S1Angle; ik(10).L5S1Angle]; %nan
    segment(4).lift = [ik(10).L5S1Angle; ik(11).L5S1Angle; ik(12).L5S1Angle; ik(13).L5S1Angle];%nan
    segment(5).lift = [ik(13).L5S1Angle; ik(14).L5S1Angle; ik(15).L5S1Angle; ik(16).L5S1Angle(1:160,:)]; %nan
    segment(6).lift = [ik(16).L5S1Angle(161:end,:); ik(17).L5S1Angle; ik(18).L5S1Angle; ik(19).L5S1Angle(1:125,:)]; 
    segment(7).lift = [ik(19).L5S1Angle(126:end,:); ik(20).L5S1Angle; ik(21).L5S1Angle; ik(22).L5S1Angle(1:100,:)];
    segment(8).lift = [ik(22).L5S1Angle(101:end,:); ik(23).L5S1Angle; ik(24).L5S1Angle; ik(25).L5S1Angle(1:130,:)];
    segment(9).lift = [ik(25).L5S1Angle(131:end,:); ik(26).L5S1Angle; ik(27).L5S1Angle; ik(28).L5S1Angle]; 
    segment(10).lift = [ik(28).L5S1Angle; ik(29).L5S1Angle; ik(30).L5S1Angle; ik(31).L5S1Angle];

    segment(1).torque = [id(1).L5S1; id(2).L5S1; id(3).L5S1; id(4).L5S1(1:120,:)];
    segment(2).torque = [id(4).L5S1(121:end,:); id(5).L5S1; id(6).L5S1; id(7).L5S1(1:130,:)];
    segment(3).torque = [id(7).L5S1(131:end,:); id(8).L5S1; id(9).L5S1; id(10).L5S1]; %nan
    segment(4).torque = [id(10).L5S1; id(11).L5S1; id(12).L5S1; id(13).L5S1];%nan
    segment(5).torque = [id(13).L5S1; id(14).L5S1; id(15).L5S1; id(16).L5S1(1:160,:)]; %nan
    segment(6).torque = [id(16).L5S1(161:end,:); id(17).L5S1; id(18).L5S1; id(19).L5S1(1:125,:)]; %nan
    segment(7).torque = [id(19).L5S1(126:end,:); id(20).L5S1; id(21).L5S1; id(22).L5S1(1:100,:)];
    segment(8).torque = [id(22).L5S1(101:end,:); id(23).L5S1; id(24).L5S1; id(25).L5S1(1:130,:)];%nan
    segment(9).torque = [id(25).L5S1(131:end,:); id(26).L5S1; id(27).L5S1; id(28).L5S1]; %nan
    segment(10).torque = [id(28).L5S1; id(29).L5S1; id(30).L5S1; id(31).L5S1];


%  figure 10 segment ik
 figure
 for s =1:nSegment
     plot(segment(s).lift)
     hold on
pause()
 end

 %% all same length

 for s = 1:nSegment
     segment(s).lift = InterpSegmentP2(segment(s).lift, 'IK');
     segment(s).torque = InterpSegmentP2(segment(s).torque, 'ID');

 end
