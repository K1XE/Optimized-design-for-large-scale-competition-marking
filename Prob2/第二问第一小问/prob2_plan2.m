clear;clc;warning off;close all;format longG
data = readcell("数据1.xlsx");
load score_num_res_round2.mat


%% 方案2
dataPrepare1 = [data(:,2) data(:,6:20)];
dataPrepared = dataPrepare1(4:end,[4 7 10 13 16]);
dataPrepared_num = cell2mat(dataPrepared);

% 找到每行五个元素中最大最小值index
[~, max_indices] = max(dataPrepared_num, [], 2);
[~, min_indices] = min(dataPrepared_num, [], 2);
% 修改其分数为0
for i = 1:size(dataPrepared_num, 1)
    dataPrepared_num(i, [max_indices(i), min_indices(i)]) = 0;
end
% 变化后，求和
data_sum = sum(dataPrepared_num,2);
% 找出既有第一阶段又有第二阶段的作品 单独算
for i = 1:size(score_num_res_round2,2)
    res_score_round12(i,1) = data_sum(i)/3 + sum(score_num_res_round2(:,i));
end
% 只有第一阶段的
cnt = 1;
for i = size(score_num_res_round2,2)+1:size(data_sum,1)
    res_score_round1(cnt,1) = data_sum(i);
    cnt = cnt + 1;
end
[sorted_sums12, sorted_indices12] = sort(res_score_round12,"descend");
[sorted_sums1, sorted_indices1] = sort(res_score_round1,"descend");


plan2 = [[sorted_indices12;sorted_indices1] [sorted_sums12;sorted_sums1]];

save('plan2.mat',"plan2");






