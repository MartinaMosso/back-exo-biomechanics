clear, close all; clc

%% import file noExo 

file = dir('C:\Twente\IUVO\PHASE2\SUB005');
indice1 = 1:3:31;
indice1 = [indice1, indice1];
indice2 = 2:3:29;
indice2 = [indice2, indice2];
indice3 = 3:3:30;
indice3 = [indice3, indice3];

file(73:77) = [];
file(1:10) = [];

for i=1:22%% soll 1
    if i <12
    soll1{i} = ['SUB005_noExo_one', num2str(indice1(i)), '_10.mat'];
    else 
            soll1{i} = ['SUB005_noExo_five',num2str(indice1(i)), '_10.mat'];
    end
end

for i=1:20%% soll 2
    if i <11
    soll2{i} = ['SUB005_noExo_one', num2str(indice2(i)), '_10.mat'];
    else 
            soll2{i} = ['SUB005_noExo_five',num2str(indice2(i)), '_10.mat'];
    end
end


for i=1:20%% soll 3
    if i <11
    soll3{i} = ['SUB005_noExo_one', num2str(indice3(i)), '_10.mat'];
    else 
            soll3{i} = ['SUB005_noExo_five',num2str(indice3(i)), '_10.mat'];
    end
end

%% media IK

for i=1:length(soll2)
    load(soll2{i})
    IKangle = oneRepCutMovements(Datastr, 'IK')
    IK_matrix2(i,:)= IKangle.cutMovements.IK.L5_S1_Flex_Ext_moment.rep1;
end

for i=1:length(soll3)
    load(soll3{i})
    IKangle = oneRepCutMovements(Datastr, 'IK')
    IK_matrix3(i,:)= IKangle.cutMovements.IK.L5_S1_Flex_Ext_moment.rep1;
end

for i=1:length(soll1)
    load(soll1{i})
    IKangle = oneRepCutMovements(Datastr, 'IK')
    IK_matrix1(i,:)= IKangle.cutMovements.IK.L5_S1_Flex_Ext_moment.rep1;
end
%%
% for i=1:length(file)
%     % if contains(file(i).name, 'one')
%         load(['C:\Twente\IUVO\PHASE2\SUB005\', file(i).name])
%         % one(i,:) = Datastr.cutMovements.ID.L5_S1_Flex_Ext_moment.rep1;
%         angle = Datastr.Resample.IKAngData(:,24);
%         % figure
%         %     plot(angle)
%     % else load(['C:\Twente\IUVO\PHASE2\SUB005\', file(i).name])
%     %     % five(i,:) = Datastr.cutMovements.ID.L5_S1_Flex_Ext_moment.rep1;
%     %       angle = Datastr.Resample.IKAngData(:,24);
%     %         figure
%     %         plot(angle)
%     end
% end

for i = 1:size(one,1)
figure
plot(one(i,:))
end

for i = 1:size(one,1)
figure
plot(five(i,:))
end