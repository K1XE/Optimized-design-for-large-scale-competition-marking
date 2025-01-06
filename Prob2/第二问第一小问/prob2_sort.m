clear;clc;warning off;close all;format longG
data = readcell("数据1.xlsx");
load plan1.mat;load plan2.mat;load plan3.mat;load plan4.mat;

% 2105个项目成绩
org_score = cell2mat(data(4:end,1));

%% 一致性检验

% 提取各个策略前27名编号
org_rank_27 = [1:27]';
plan_rank_27 = [plan1(1:27,1) plan2(1:27,1) plan3(1:27,1) plan4(1:27,1)];

% 计算一致排名个数
for i = 1:size(plan_rank_27,2)
    plan_equalEles_27(i,1) = sum(org_rank_27 == plan_rank_27(:,i));
end

% 计算一致性
alpha_27 = plan_equalEles_27./27;

%% 差异性检验

% 传统策略的成绩的均值与标准差
mean_org = mean(org_score);
std_org = std(org_score);

% plan1-4的成绩的均值与标准差
plan_total = [plan1(:,2) plan2(:,2) plan3(:,2) plan4(:,2)];
for i = 1:size(plan_total,2)
    mean_plan(i,1) = mean(plan_total(:,i));
    std_plan(i,1) = std(plan_total(:,i));
end

% 计算α (整体一致性)
plan_rank = [plan1(:,1) plan2(:,1) plan3(:,1) plan4(:,1)];
org_rank = [1:size(plan_rank,1)]';
for i = 1:size(plan_rank,2)
    plan_equalEles(i,1) = sum(org_rank == plan_rank(:,i));
end
alpha = plan_equalEles./size(plan_rank,1);

% 计算β与λ 
for i = 1:size(plan_total,2)
    beta(i,1) = sum(abs(mean_org - mean_plan(i))/mean_org);
    lambda(i,1) = sum(abs(std_org - std_plan(i))/std_org);
end

% 计算加权平均指标φ
phi = alpha./(beta.*lambda);

% 标准化
phi_zscore = zscore(phi);
[sorted_val,sorted_idx] = sort(phi_zscore,'descend');

% 最终结果
plan_sorted = [sorted_idx sorted_val];

% 对应指标拼接
plan_total = [["方案" "加权平均指标φ" "β" "λ" "2015份总α" "前27份α"];...
    [plan_sorted beta(sorted_idx) lambda(sorted_idx) alpha(sorted_idx) alpha_27(sorted_idx)]];
writematrix(plan_total,'prob2_sorted.xlsx');









