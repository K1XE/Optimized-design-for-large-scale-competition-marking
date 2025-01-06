clear;clc;warning off;close all;format longG
data = readcell("数据1.xlsx");


%% 方案1
dataPrepare1 = [data(:,2) data(:,6:20)];
dataPrepared = dataPrepare1(4:end,[3 6 9 12 15]);
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
% 排序
[sorted_sums, sorted_indices] = sort(data_sum,"descend");
sorted_data = dataPrepared_num(sorted_indices, :);
plan1_res = [sorted_indices sorted_data];

plan1 = [plan1_res(:,1) sorted_sums];

save('plan1.mat',"plan1");





