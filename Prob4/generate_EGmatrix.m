function res_EGmatrix = generate_EGmatrix()
% 结果返回两阶段的"专家-组别"数组
    rng(0)
    
    expert_num_round1 = input("请输入第一阶段专家总数:"); % 批阅第一阶段专家数
    group_num = input("请输入组别总数:"); % 总组别数
    medal_ratio = input("请输入总获奖率:"); % 总获奖率
    expert_num_round2 = input("请输入第二阶段专家总数:"); % 批阅第二阶段专家数
    disp("------------------------------------生成最终结果矩阵中...------------------------------------")
    tic
    % 调用函数 生成第一阶段的"专家-组别"数组
    Expert_Group_matrix_round1 = generate_EGmatrix_round1(expert_num_round1, group_num);
    
    % 调用函数 生成第二阶段的"专家-组别"数组
    Expert_Group_matrix_round2 = generate_EGmatrix_round2(group_num, medal_ratio, expert_num_round2);
    
    res_EGmatrix(1).data = Expert_Group_matrix_round1;
    res_EGmatrix(2).data = Expert_Group_matrix_round2;
    
    disp("------------------------------------处理完成，分配结果请查看返回的结构体------------------------------------")
    toc
end
