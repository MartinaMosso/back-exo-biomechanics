clear all; close all; clc

task = {'noExo_SQ_0', 'noExo_SQ_5', 'noExo_SQ_10', 'noExo_SQ_15', 'yesExo_SQ_10', 'noExo_ST_0', 'noExo_ST_5', 'noExo_ST_10', 'noExo_ST_15', 'yesExo_ST_10'};

sbj = {'SUB005', 'SUB006', 'SUB007', 'SUB008', 'SUB009', 'SUB010', 'SUB011', 'SUB012'};


s = 1;
t = 5;
['C:\Twente\IUVO\', sbj{s}, '\', sbj{s}, '_', task{t}, '.mat']

load(['C:\Twente\IUVO\', sbj{s}, '\', sbj{s}, '_', task{t}, '.mat'])

Datastr.cutMovements.sharpenedSamplesID=[];
Datastr.cutMovements.sharpenedSamplesID.Start =Datastr.cutMovements.sharpenedSamples.Start;
Datastr.cutMovements.sharpenedSamplesID.Stop =Datastr.cutMovements.sharpenedSamples.Stop;
figure;plot(Datastr.cutMovements.ID.L5_S1_Flex_Ext_moment.Mean)
figure;plot(Datastr.cutMovements.ID.L5_S1_Flex_Ext_moment.Matrix')

Datastr= getMovementPhaseMoments(Datastr, 'ID');
figure;plot(Datastr.cutMovements.ID.L5_S1_Flex_Ext_moment.Mean)
figure;plot(Datastr.cutMovements.ID.L5_S1_Flex_Ext_moment.Matrix')