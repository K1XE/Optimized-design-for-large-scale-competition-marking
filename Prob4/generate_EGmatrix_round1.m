function Expert_Group_matrix_round1 = generate_EGmatrix_round1(expert_num, group_num)
% 需要提供队伍总数group_num 第一阶段专家人数expert_num -> 调用接口 即可返回一个存有每个专家应评阅的队伍号的数组
% 返回的数组行号代表专家标号 列号代表组别编号 1代表第x号专家需评阅第x号组别 0则代表不评阅
    rng(0)
    % 最终即可通过模型给出不同组别的排名
    expert_num_round1 = expert_num;
    total_num = group_num; % 总队伍数
    % 125名专家
    % 125组试卷 每组24份
    best_f= 1e4; % 最优目标函数值
    best_std = 10;
    best_gamma = zeros(expert_num_round1,expert_num_round1);
    % 蒙特卡洛
    for m = 1 :1e1
        gap = randi(expert_num_round1-4,[expert_num_round1,1]); % 每组卷随机连续五名专家批阅
        res_gap = zeros(total_num,expert_num_round1); 
        % 初始化一个空矩阵
        rand_idx = zeros(total_num, 5);
        
        for i = 1:total_num
            % 在每行生成5个不同的随机数
            rand_idx(i, :) = randperm(expert_num_round1, 5);
        end
        cnt=0;
        for i = 1:length(rand_idx)
            res_gap(i,:) = zeros(1,expert_num_round1);
            cnt = cnt+1;
            res_gap(i,[rand_idx(cnt,:)]) = [1 1 1 1 1];
        end
        s = sum(res_gap,1);
        D = zeros(expert_num_round1,expert_num_round1);
        for i=1:expert_num_round1
            for j=1:expert_num_round1
                if i<j
                   D(i,j) =sum(res_gap(:,i) == 1 & res_gap(:,j) == 1);
                end
            end
        end
        for i=1:expert_num_round1
            for j=1:expert_num_round1
                if i<j
                   gamma(i,j) = 2*D(i,j)/(sum(res_gap(:,i))+sum(res_gap(:,j)));
                end
            end
        end
        gamma(isnan(gamma)) = 0;
        gamma_mean = sum(sum(gamma))/((expert_num_round1-1)*expert_num_round1/2);
        f = sqrt(sum(sum((gamma-gamma_mean).^2))/((expert_num_round1-1)*expert_num_round1/2)); % 目标函数
        if f < best_f && std(s) < best_std
            best_std = std(s);
            best_gamma = gamma;
            best_s = s;
            best_f = f; % 记录更优的fval
            best_gap = gap; % 记录对应评阅细则
            best_res_gap = res_gap;
        end
    end
    Expert_Group_matrix_round1 = best_res_gap';
    writematrix(Expert_Group_matrix_round1,'Expert_Group_matrix_round1.xlsx');
end