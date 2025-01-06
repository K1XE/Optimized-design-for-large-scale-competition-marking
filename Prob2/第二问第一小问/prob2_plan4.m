clear;clc;warning off;close all;format longG

data = readcell("数据1.xlsx");




%% 第二阶段
data_round2 = data(1:355,:);
for i = 1 :3
    res_round2(i).data = predata_roundTwo(data_round2,i);
end

% 将第二次评审成绩放到一个大元胞中
res = [res_round2(1).data;res_round2(2).data;res_round2(3).data];
Expert_list = res(:,1);
unique_Expert = unique(res(:,1));
% 找到大元胞中出现专家编号的索引
for i = 1:length(unique_Expert)
    cnt = 1;
    for j = 1:length(Expert_list)
        if strcmp(Expert_list{j}, unique_Expert(i))
            flag(i,cnt) = j;
            cnt = cnt + 1;
        end
    end
end
% 找到不同专家编号和对应判的分数
for i = 1:length(unique_Expert)
    expert(i,1) = unique_Expert(i);
    flag_temp = flag(i,:);
    flag_temp = flag_temp(flag_temp~=0);
    score(i,1).data = res(flag_temp,:);
    
end
% 找到每个专家打的分数 即a1 a2......an
for i = 1:length(score)
    score_num = zeros(2,352);
    for j = 1:size(score(i).data,1)
        score_num(j,:) = cell2mat(score(i).data(j,2:end));
    end
    score_num_res(:,i) = sum(score_num);
end
score_num_res = score_num_res'; 
non_zero_counts = sum(score_num_res ~= 0, 2);
a_mean = sum(score_num_res,2)./non_zero_counts; % 某位专家给出成绩的样本均值
a_mean_total = sum(a_mean)/length(a_mean);
% 某位专家给出成绩样本标准差
for i = 1:size(score_num_res,1)
    for j = 1:size(score_num_res,2)
        temp = score_num_res(i,:);
        temp = temp(temp~=0);
        s(i,1) = sqrt(sum((temp - a_mean(i)).^2)./(non_zero_counts(i) - 1));
    end
end

s_total=0;
for i = 1:size(score_num_res,1)
    for j = 1:size(score_num_res,2)
       
        temp = score_num_res(i,:);
        temp = temp(temp~=0);
        s_total = s_total + sum((temp - a_mean_total).^2);
    end
end
s_total = sqrt(s_total/sum(non_zero_counts-1));


% 题目声明的标准分
for i = 1:size(score_num_res,1)
    for j = 1:size(score_num_res,2)
        if score_num_res(i,j) ~= 0
            x(i,j) = 50 + 10*(score_num_res(i,j) - a_mean(i))/s(i);
        else
            x(i,j) = 0;
        end
    end
end
% 本方案计算的新标准分
mean_m = sum(score_num_res)/5;
for i = 1:size(score_num_res,1)
    for j = 1:size(score_num_res,2)
        if score_num_res(i,j) ~= 0
            x_new(i,j) = x(i,j) - ((score_num_res(i,j) - a_mean_total)/s_total) .* ((score_num_res(i,j) - mean_m(j)));
        else
            x_new(i,j) = 0;
        end
        
    end
end
score_num_res_round2 = x_new;
save('score_num_res_round2.mat',"score_num_res_round2");
clearvars
%% 第一阶段
data = readcell("数据1.xlsx");
for i = 1:5
    res_round1(i).data = predata_roundOne(data,i);
end
load score_num_res_round2.mat
% 将第一次评审成绩放到一个大元胞中
res = [res_round1(1).data;res_round1(2).data;res_round1(3).data;...
       res_round1(4).data;res_round1(5).data];
Expert_list = res(:,1);
unique_Expert = unique(res(:,1));
% 找到大元胞中出现专家编号的索引
for i = 1:length(unique_Expert)
    cnt = 1;
    for j = 1:length(Expert_list)
        if strcmp(Expert_list{j}, unique_Expert(i))
            flag(i,cnt) = j;
            cnt = cnt + 1;
        end
    end
end
% 找到不同专家编号和对应判的分数
for i = 1:length(unique_Expert)
    expert(i,1) = unique_Expert(i);
    flag_temp = flag(i,:);
    flag_temp = flag_temp(flag_temp~=0);
    score(i,1).data = res(flag_temp,:);
    
end
% 找到每个专家打的分数 即a1 a2......an
for i = 1:length(score)
    score_num = zeros(5,2015);
    for j = 1:size(score(i).data,1)
        score_num(j,:) = cell2mat(score(i).data(j,2:end));
    end
    score_num_res(:,i) = sum(score_num);
end
score_num_res = score_num_res'; 
non_zero_counts = sum(score_num_res ~= 0, 2);
a_mean = sum(score_num_res,2)./non_zero_counts; % 某位专家给出成绩的样本均值
a_mean_total = sum(a_mean)/length(a_mean);
% 某位专家给出成绩样本标准差
for i = 1:size(score_num_res,1)
    for j = 1:size(score_num_res,2)
        temp = score_num_res(i,:);
        temp = temp(temp~=0);
        s(i,1) = sqrt(sum((temp - a_mean(i)).^2)./(non_zero_counts(i) - 1));
    end
end

s_total=0;
for i = 1:size(score_num_res,1)
    for j = 1:size(score_num_res,2)
       
        temp = score_num_res(i,:);
        temp = temp(temp~=0);
        s_total = s_total + sum((temp - a_mean_total).^2);
    end
end
s_total = sqrt(s_total/sum(non_zero_counts-1));


% 题目声明的标准分
for i = 1:size(score_num_res,1)
    for j = 1:size(score_num_res,2)
        if score_num_res(i,j) ~= 0
            x(i,j) = 50 + 10*(score_num_res(i,j) - a_mean(i))/s(i);
        else
            x(i,j) = 0;
        end
    end
end
% 本方案计算的新标准分
mean_m = sum(score_num_res)/5;
for i = 1:size(score_num_res,1)
    for j = 1:size(score_num_res,2)
        if score_num_res(i,j) ~= 0
            x_new(i,j) = x(i,j) - ((score_num_res(i,j) - a_mean_total)/s_total) .* ((score_num_res(i,j) - mean_m(j)));
        else
            x_new(i,j) = 0;
        end
        
    end
end
% 找出既有第一阶段又有第二阶段的作品 单独算
for i = 1:size(score_num_res_round2,2)
    res_score_round12(i,1) = sum(x_new(:,i))/5 + sum(score_num_res_round2(:,i));
end
% 只有第一阶段的
cnt = 1;
for i = size(score_num_res_round2,2)+1:size(score_num_res,2)
    res_score_round1(cnt,1) = sum(x_new(:,i));
    cnt = cnt + 1;
end

res_score = [res_score_round12;res_score_round1];

[sorted_sums12, sorted_indices12] = sort(res_score_round12,"descend");
[sorted_sums1, sorted_indices1] = sort(res_score_round1,"descend");

plan4 = [[ sorted_indices12;sorted_indices1] [sorted_sums12;sorted_sums1]];



save('plan4.mat',"plan4");







