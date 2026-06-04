%% MUSCLE ANALYSIS BMP e OS

clear; close all; clc

%% import BMP

length_BMP = importdata('C:\Twente\IUVO\SUB009\OS\muscleAnalysis\SUB009noExo_SQ_10_MusA_MTULen.sto');
length_BMP = length_BMP.data(:,2);


ma_BMP = importdata('C:\Twente\IUVO\SUB009\OS\muscleAnalysis\SUB009noExo_SQ_10_MusA_MA_L5_S1_Flex_Ext.sto');
ma_BMP = ma_BMP.data(:,2);


%% import OS

length_OS = importdata('C:\Twente\IUVO\SUB009\OS\muscleAnalysis\ResultsOS\SUB009noExo_SQ_10_Length.sto');
length_OS = length_OS.data(:,2);

ma_OS = importdata('C:\Twente\IUVO\SUB009\OS\muscleAnalysis\ResultsOS\SUB009noExo_SQ_10_MomentArm_L5_S1_Flex_Ext.sto');
ma_OS = ma_OS.data(:,2);

%% import CEINSM

length_ceinms = importdata('C:\Twente\IUVO\SUB009\CEINMS\execution\OP\EMG\SUB009noExo_SQ_10\FiberLenghts.sto');
length_ceinms = length_ceinms.data(:,2);

normLength_CEINMS = importdata('C:\Twente\IUVO\SUB009\CEINMS\execution\OP\EMG\SUB009noExo_SQ_10\NormFiberLengths.sto')
normLength_CEINMS = normLength_CEINMS.data(:,2);

figure
plot(length_ceinms)
hold on; plot(normLength_CEINMS)
%%
figure
plot(length_OS)
hold on; plot(length_BMP);plot(length_ceinms); plot(normLength_CEINMS)
legend('OS', 'BMP', 'CEINMS', 'NormCEINMS')

figure
plot(ma_OS)
hold on; plot(ma_BMP)