clear;clc;warning off;close all;format longG

% 调用函数generate_EGmatrix 生成第1、2阶段的"专家-组别"数组
Expert_Group_matrix = generate_EGmatrix();
save('Expert_Group_matrix.mat',"Expert_Group_matrix")


