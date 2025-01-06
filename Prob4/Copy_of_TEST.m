clear;clc;warning off;close all;format longG
% --------ATTENTION: 本程序为实例程序，展示了如何调用接口来给队伍进行排名--------
%  --------为了展示自动化求解结果 其中第1、2阶段的原始分为随机生成的数值--------

% 调用函数generate_EGmatrix 生成第1、2阶段的"专家-组别"数组

Expert_Group_matrix(1).data = xlsread("第一阶段‘专家-组别’数组.xlsx");
Expert_Group_matrix(2).data = xlsread('第二阶段‘专家-组别’数组.xlsx');
% 随机生成第1、2阶段对应评得的原始分
[m,n] = size(Expert_Group_matrix(1).data);
orgScore_round1 = zeros(m,n);
for i = 1:size(Expert_Group_matrix(1).data,1)
    for j = 1:size(Expert_Group_matrix(1).data,2)
        if Expert_Group_matrix(1).data(i,j)~=0
            orgScore_round1(i,j) = randi([10, 100], 1, 1);
        end
    end
end
[m,n] = size(Expert_Group_matrix(2).data);
orgScore_round2 = zeros(m,n);
for i = 1:size(Expert_Group_matrix(2).data,1)
    for j = 1:size(Expert_Group_matrix(2).data,2)
        if Expert_Group_matrix(2).data(i,j)~=0
            orgScore_round2(i,j) = randi([10, 100], 1, 1);
        end
    end
end
writematrix(orgScore_round1,'orgScore_round1.xlsx')
writematrix(orgScore_round2,'orgScore_round2.xlsx')
% orgScore_round1 = xlsread('orgScore_round1.xlsx');
% orgScore_round2 = xlsread('orgScore_round2.xlsx');
% 调用函数generate_rankingExcel 返回"最终评议结果.xlsx"文件 排名与打分情况均在表内
res_ranking = generate_rankingExcel(orgScore_round1, orgScore_round2);
