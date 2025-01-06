clear;clc;warning off;close all;format longG
data = readcell("数据1.xlsx");
load score_num_res_round2.mat


%% 方案3
dataPrepare1 = [data(:,2) data(:,6:20)];
dataPrepared = dataPrepare1(4:end,[4 7 10 13 16]);
dataPrepared_num = cell2mat(dataPrepared);
dataPrepared_num_temp = dataPrepared_num;
% 找到每行五个元素中最大最小值index
[max_val, max_indices] = max(dataPrepared_num, [], 2);
[min_val, min_indices] = min(dataPrepared_num, [], 2);
extremelyDiff = max_val - min_val;
% 极差大于20 删除最大最小值 取平均
dataPrepared_res = zeros(size(dataPrepared_num,1),1);
for i = 1:size(dataPrepared_num, 1)
    if extremelyDiff(i) > 20
       dataPrepared_num(i, [max_indices(i), min_indices(i)]) = 0;
       dataPrepared_res(i,1) = sum(dataPrepared_num(i,:))/3;
       dataPrepared_org(i,1) = sum(dataPrepared_num(i,:));
    else
       dataPrepared_res(i,1) = sum(dataPrepared_num(i,:))/5;
       dataPrepared_org(i,1) = sum(dataPrepared_num(i,:));
    end
end
% 找出既有第一阶段又有第二阶段的作品 单独算
for i = 1:size(score_num_res_round2,2)
    res_score_round12(i,1) = dataPrepared_res(i) + sum(score_num_res_round2(:,i));
end
% 只有第一阶段的
cnt = 1;
for i = size(score_num_res_round2,2)+1:size(dataPrepared_org,1)
    res_score_round1(cnt,1) = dataPrepared_org(i);
    cnt = cnt + 1;
end
[sorted_sums12, sorted_indices12] = sort(res_score_round12,"descend");
[sorted_sums1, sorted_indices1] = sort(res_score_round1,"descend");


plan3 = [[sorted_indices12;sorted_indices1] [sorted_sums12;sorted_sums1]];


save('plan3.mat',"plan3");



dataPrepared_std = dataPrepare1(4:end,[3 6 9 12 15]);
dataPrepared_std_num = cell2mat(dataPrepared_std);
temp_std = dataPrepared_num_temp([sorted_indices12;sorted_indices1],:);
temp_std_mean = mean(temp_std,2);
temp = dataPrepared_std_num([sorted_indices12;sorted_indices1],:);
temp_mean = mean(temp,2);

figure('Position', [100, 100, 800, 450]);
subplot(121)
histogram(temp_std_mean,'NumBins',20)
xlabel('原始分均值')
ylabel('数量')
subplot(122)
histogram(temp_mean,'NumBins',20)
xlabel('标准分均值')
ylabel('数量')







