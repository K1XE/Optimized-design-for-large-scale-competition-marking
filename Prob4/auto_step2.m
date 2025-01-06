clear;clc;warning off;close all;format longG

% 导入两阶段含标准分的标准矩阵
orgScore_round1 = xlsread("Expert_Group_matrix_round1.xlsx"); 
orgScore_round2 = xlsread("Expert_Group_matrix_round2.xlsx");

% 调用函数generate_rankingExcel 返回"最终评议结果.xlsx"文件 排名与打分情况均在表内
res_ranking = generate_rankingExcel(orgScore_round1, orgScore_round2);




