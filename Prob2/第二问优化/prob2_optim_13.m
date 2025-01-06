clear;clc;warning off;close all;format longG

data = readcell("数据1.xlsx");




%% 第二阶段 xxx_diff处理的是复议与标准分的差值 最后计算出的新标准分+差值，进行排序
data_round2 = data(1:355,:);
for i = 1 :3
    res_round2(i).data = predata_roundTwo(data_round2,i);
    res_round2_diff(i).data = predata_roundTwo_diff(data_round2,i);
end

% 将第二次评审成绩放到一个大元胞中
res = [res_round2(1).data;res_round2(2).data;res_round2(3).data];
res_diff = [res_round2_diff(1).data;res_round2_diff(2).data;res_round2_diff(3).data];
Expert_list = res(:,1);
Expert_list_diff = res_diff(:,1);
unique_Expert = unique(res(:,1));
unique_Expert_diff = unique(res_diff(:,1));
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
for i = 1:length(unique_Expert_diff)
    cnt_diff = 1;
    for j = 1:length(Expert_list_diff)
        if strcmp(Expert_list_diff{j}, unique_Expert_diff(i))
            flag_diff(i,cnt_diff) = j;
            cnt_diff = cnt_diff + 1;
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
for i = 1:length(unique_Expert_diff)
    expert_diff(i,1) = unique_Expert_diff(i);
    flag_temp_diff = flag_diff(i,:);
    flag_temp_diff = flag_temp_diff(flag_temp_diff~=0);
    score_diff(i,1).data = res_diff(flag_temp_diff,:);
    
end
% 找到每个专家打的分数 即a1 a2......an
for i = 1:length(score)
    score_num = zeros(2,352);
    for j = 1:size(score(i).data,1)
        score_num(j,:) = cell2mat(score(i).data(j,2:end));
    end
    score_num_res(:,i) = sum(score_num);
end
for i = 1:length(score_diff)
    score_num_diff = zeros(2,352);
    for j = 1:size(score_diff(i).data,1)
        score_num_diff(j,:) = cell2mat(score_diff(i).data(j,2:end));
    end
    score_num_res_diff(:,i) = sum(score_num_diff);
end
score_num_res = score_num_res'; 
score_num_res_diff = score_num_res_diff'; 
non_zero_counts = sum(score_num_res ~= 0, 2);
non_zero_counts_diff = sum(score_num_res_diff ~= 0, 2);
a_mean = sum(score_num_res,2)./non_zero_counts; % 某位专家给出成绩的样本均值
a_mean_total = sum(a_mean)/length(a_mean);
a_mean_diff = sum(score_num_res_diff,2)./non_zero_counts_diff; % 某位专家给出成绩的样本均值
a_mean_total_diff = sum(a_mean_diff)/length(a_mean_diff);
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
            if score_num_res(i,j) - mean_m(j) < 0 
                sym = -1;
            else
                sym = 1;  % sym = 1或者-1,取决于比均值大或者小
            end
            x_new(i,j) = x(i,j) + sym* ((score_num_res(i,j) - a_mean_total)/s_total) .* ((abs(score_num_res(i,j) - mean_m(j))).^(score_num_res(i,j)./sum(score_num_res(:,j))));

        else
            x_new(i,j) = 0;
        end
    end
end
score_num_res_round2_optim = x_new+score_num_res_diff;
save('score_num_res_round2_optim.mat',"score_num_res_round2_optim");
clearvars
%% 第一阶段
data = readcell("数据1.xlsx");
for i = 1:5
    res_round1(i).data = predata_roundOne(data,i);
end
load score_num_res_round2_optim.mat
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
            if score_num_res(i,j) - mean_m(j) < 0 
                sym = -1;
            else
                sym = 1;  % sym = 1或者-1,取决于比均值大或者小
            end
            x_new(i,j) = x(i,j) + sym* ((score_num_res(i,j) - a_mean_total)/s_total) .* ((abs(score_num_res(i,j) - mean_m(j))).^(score_num_res(i,j)./sum(score_num_res(:,j))));
        else
            x_new(i,j) = 0;
        end
        
    end
end
% 找出既有第一阶段又有第二阶段的作品 单独算
for i = 1:size(score_num_res_round2_optim,2)
    res_score_round12(i,1) = sum(x_new(:,i))/5 + sum(score_num_res_round2_optim(:,i));
end
% 只有第一阶段的
cnt = 1;
for i = size(score_num_res_round2_optim,2)+1:size(score_num_res,2)
    res_score_round1(cnt,1) = sum(x_new(:,i));
    cnt = cnt + 1;
end

res_score = [res_score_round12;res_score_round1];

[sorted_sums12, sorted_indices12] = sort(res_score_round12,"descend");
[sorted_sums1, sorted_indices1] = sort(res_score_round1,"descend");

plan4_optim = [[ sorted_indices12;sorted_indices1] [sorted_sums12;sorted_sums1]];



save('plan4_optim_13.mat',"plan4_optim");



%% 一致性检验

% 提取各个策略前27名编号
org_rank_27 = [1:27]';
plan_rank_27 = plan4_optim(1:27,1);

% 计算一致排名个数
for i = 1:size(plan_rank_27,2)
    plan_equalEles_27(i,1) = sum(org_rank_27 == plan_rank_27(:,i));
end

% 计算一致性
alpha_27 = plan_equalEles_27./27;

%% 同第一阶段对比

% 导入所有队伍总成绩
Total_grade = data(:,1);
Total_grade([1,2,3]) = [];
Total_grade = cell2mat(Total_grade(:,1));

% 传统策略总成绩的均值和标准差
mean_init = mean(Total_grade(:,1));
std_init = std(Total_grade(:,1));

% 第四种策略总成绩的均值和标准差
mean_4 = mean(plan4_optim(1:27,2));
std_4 = std(plan4_optim(1:27,2));

beta = sum(abs(mean_init - mean_4)./mean_init)
lambda = sum(abs(std_init - std_4)./std_init)


%%

% 绘制直方图
subplot(1,2,1)
% 绘制直方图
h1 = histogram(Total_grade(:,1),20); % 10 表示要将数据分为 10 个区间

% 添加标题和标签
title('Histogram of Data');
xlabel('Data Values');
ylabel('Frequency');

% 设置轴的范围
xlim([min(Total_grade) - 1, max(Total_grade) + 1]);

% 添加网格
grid on;

% 添加数据标记
hold on; % 允许在同一图上添加其他元素
x_values = h1.BinEdges(1:end-1) + h1.BinWidth/2;
y_values = h1.Values;
plot(x_values, y_values, 'r-o', 'MarkerSize', 2, 'MarkerFaceColor', 'g','LineWidth',1); % 红色圆点标记
hold off;

% 添加图例
legend('Histogram', 'Data Points', 'Location', 'NorthEast');

% 设置图形大小
set(gcf, 'Position', [100, 100, 800, 400]);

% 显示图形
grid on;

subplot(1,2,2)
% 绘制直方图
h4 = histogram(plan4_optim(:,2), 20); % 10 表示要将数据分为 10 个区间

% 添加标题和标签
title('Histogram of Data');
xlabel('Data Values');
ylabel('Frequency ');

% 设置轴的范围
xlim([min(plan4_optim(:,2)) - 1, max(plan4_optim(:,2)) + 1]);

% 添加网格
grid on;

% 添加数据标记
hold on; % 允许在同一图上添加其他元素
x_values = h4.BinEdges(1:end-1) + h4.BinWidth/2;
y_values = h4.Values;
plot(x_values, y_values, 'r-o', 'MarkerSize', 2, 'MarkerFaceColor', 'g','LineWidth',1); % 红色圆点标记
hold off;

% 添加图例
legend('Histogram', 'Data Points', 'Location', 'NorthEast');

% 设置图形大小
set(gcf, 'Position', [100, 100, 800, 400]);



