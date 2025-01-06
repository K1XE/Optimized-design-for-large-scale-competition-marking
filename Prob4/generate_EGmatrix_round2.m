function Expert_Group_matrix_round2 = generate_EGmatrix_round2(group_num, medal_ratio, expert_num)
% 需要提供队伍总数group_num 1、2、3等奖总体获奖率medal_ratio 第一阶段专家人数expert_num -> 调用接口 即可返回一个存有每个专家应评阅的队伍号的数组
% 返回的数组行号代表专家标号 列号代表组别编号 1代表第x号专家需评阅第x号组别 0则代表不评阅
    rng(0)
    % 计算得奖队伍数
    medal_num = floor(group_num*medal_ratio);
    % 第二阶段所需专家数
    expert_num = expert_num;
    paperGroup_num = 30; % 假设分30组
    paper_num = medal_num/paperGroup_num;
    save('expert_num.mat','expert_num');
    
    
    % expert_num125名专家
    % paperGroup_num125组试卷 每组paper_num24份
    best_f= 1e4; % 最优目标函数值
    best_std = 10;
    best_gamma = zeros(expert_num,expert_num);
    % 蒙特卡洛
    for m = 1 :1e1
        gap = randi(expert_num-2,[expert_num,1]); % 每组卷随机连续五名专家批阅
        res_gap = zeros(medal_num,expert_num); 
    %     res_gap(1,1:5) = 1;
    %     rand_idx = randi(expert_num,[medal_num,3]);
        % 初始化一个空矩阵
        rand_idx = zeros(medal_num, 3);
        
        for i = 1:medal_num
            % 在每行生成5个不同的随机数
            rand_idx(i, :) = randperm(expert_num, 3);
        end
        cnt=0;
        for i = 1:length(rand_idx)
    %         res_gap(i+1,:) = [zeros(1,gap(i)-1) ones(1,5) zeros(1,121-gap(i))];
            res_gap(i,:) = zeros(1,expert_num);
            cnt = cnt+1;
            res_gap(i,[rand_idx(cnt,:)]) = [1 1 1];
        end
        s = sum(res_gap,1);
        D = zeros(expert_num,expert_num);
        for i=1:expert_num
            for j=1:expert_num
                if i<j
                   D(i,j) =sum(res_gap(:,i) == 1 & res_gap(:,j) == 1);
                end
            end
        end
        for i=1:expert_num
            for j=1:expert_num
                if i<j
                   gamma(i,j) = 2*D(i,j)/(sum(res_gap(:,i))+sum(res_gap(:,j)));
                end
            end
        end
        gamma(isnan(gamma)) = 0;
        gamma_mean = sum(sum(gamma))/((expert_num-1)*expert_num/2);
        f = sqrt(sum(sum((gamma-gamma_mean).^2))/((expert_num-1)*expert_num/2)); % 目标函数
        if f < best_f && std(s) < best_std
            best_std = std(s);
            best_gamma = gamma;
            best_s = s;
            best_f = f; % 记录更优的fval
            best_gap = gap; % 记录对应评阅细则
            best_res_gap = res_gap;
        end
    end
    Expert_Group_matrix_round2 = best_res_gap';
    writematrix(Expert_Group_matrix_round2,'Expert_Group_matrix_round2.xlsx');
end