function res_total = generate_rankingExcel(orgScore_round1, orgScore_round2)
% 提供第1、2阶段对应评得的原始分orgScore_round1、orgScore_round2,提供第2阶段所需专家数expert_num_round2-> 调用接口 即可返回最终结果
% 分别提供1、2、3等奖获奖率medal_ratio1、medal_ratio2、medal_ratio3
    disp("------------------------------------生成最终结果矩阵中...------------------------------------")
    medal_ratio1 = input("请输入1等奖获奖率:");
    medal_ratio2 = input("请输入2等奖获奖率:");
    medal_ratio3 = input("请输入3等奖获奖率:");
    tic
    save('medal_ratio1.mat','medal_ratio1');
    save('medal_ratio2.mat','medal_ratio2');
    save('medal_ratio3.mat','medal_ratio3');
    score_round1 = orgScore_round1;
    save('score_round1.mat','score_round1');
    % 计算得奖队伍数
    medal_ratio = medal_ratio1 + medal_ratio2 + medal_ratio3;
    medal_num = floor(medal_ratio*size(orgScore_round1,2));
    save('medal_num.mat','medal_num');
    %% 计算排名
    score_round2 = orgScore_round2;
    score_num_res = score_round2; 
    non_zero_counts = sum(score_num_res ~= 0, 2);
    for i = 1:size(non_zero_counts,1)
        if non_zero_counts(i,1) == 0
            non_zero_counts(i,1) = 1;
        end
    end
    a_mean = sum(score_num_res,2)./non_zero_counts; % 某位专家给出成绩的样本均值
    a_mean_total = sum(a_mean)/length(a_mean);
    % 某位专家给出成绩样本标准差
    for i = 1:size(score_num_res,1)
        for j = 1:size(score_num_res,2)
            temp = score_num_res(i,:);
            temp = temp(temp~=0);
            if non_zero_counts(i) ~= 1
                s(i,1) = sqrt(sum((temp - a_mean(i)).^2)./(non_zero_counts(i) - 1));
            else
                s(i,1) = sqrt(sum((temp - a_mean(i)).^2)./(non_zero_counts(i)));

            end
        end
    end
    for i = 1:size(s,1)
        if s(i,1) == 0
            s(i,1) = 1;
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
                x_new(i,j) = x(i,j) + sym *((score_num_res(i,j) - a_mean_total)/s_total) .* ((abs(score_num_res(i,j) - mean_m(j))).^(score_num_res(i,j)./sum(score_num_res(:,j))));
            else
                x_new(i,j) = 0;
            end
        end
    end
    x_new = round(x_new .* 100)./100;
    score_res_round2 = x_new;
    save('score_res_round2.mat','score_res_round2')
    clearvars
    %% 第一阶段复议
    load score_res_round2.mat;load score_round1.mat
    score_num_res = score_round1;
    non_zero_counts = sum(score_num_res ~= 0, 2);
    a_mean = sum(score_num_res,2)./non_zero_counts; % 某位专家给出成绩的样本均值
    a_mean_total = sum(a_mean)/length(a_mean);
    % 某位专家给出成绩样本标准差
    for i = 1:size(score_num_res,1)
        for j = 1:size(score_num_res,2)
            temp = score_num_res(i,:);
            temp = temp(temp~=0);
            if non_zero_counts(i) ~= 1
                s(i,1) = sqrt(sum((temp - a_mean(i)).^2)./(non_zero_counts(i) - 1));
            else
                s(i,1) = sqrt(sum((temp - a_mean(i)).^2)./(non_zero_counts(i)));
                if s(i,1) == 0
                    s(i,1) = 1;
                end
            end
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
    x_new = round(x_new .* 100)./100;
    x_new_temp = x';
    save('x_new_temp.mat','x_new_temp');
    load medal_num.mat
    % 筛选出每支队伍的标准分与极差
    [m,n] = size(x_new_temp);
    for i = 1:m
        cnt = 1;
        for j = 1:n
            if x_new_temp(i,j) ~= 0
                standard_score(i,cnt) = x_new_temp(i,j);
                cnt = cnt + 1;
            end
        end
    end
    % 计算极差
    for i = 1:size(standard_score,1)
        max_val = max(standard_score(i,:));
        min_val = min(standard_score(i,:));
        diff(i,1) = abs(max_val - min_val);
    end
    data_already_temp = [[1:length(diff)]' standard_score diff];
    cnt = 1;
    % 找到极差大于20的组别
    for i = 1:size(data_already_temp,1)
        if data_already_temp(i,end)>20
            data_already(cnt,:) = data_already_temp(i,:);
            cnt = cnt + 1;
        end
    end
    % 对五位专家打分进行排序
    for i = 1:size(data_already,1)
        data_sorted(i,:) = [data_already(i,1) sort(data_already(i,2:end-1)) data_already(i,end)];
    end
    % 分别求最小、最大两个评分均值 五个评分均值
    for i = 1:size(data_sorted,1)
        data_mean(i,:) = [data_sorted(i,1) (data_sorted(i,2)+data_sorted(i,3))/2 (data_sorted(i,5)+data_sorted(i,6))/2 sum(data_sorted(i,2:6))/5 data_already(i,end)];
    end
    % 求最小、最大两个评分均值与五个评分均值的差值
    for i = 1:size(data_mean,1)
        data_diff(i,:) = [data_mean(i,1) abs(data_mean(i,2)-data_mean(i,4)) abs(data_mean(i,3)-data_mean(i,4)) data_mean(i,end)];
    end
    % 标记012
    cnt_diff_0 = 0;
    cnt_diff_1 = 0;
    cnt_diff_2 = 0;
    for i = 1:size(data_diff,1)
        if data_diff(i,2)>data_diff(i,3)
            data_diff(i,5) = 0;
            cnt_diff_0 = cnt_diff_0 + 1;
        elseif data_diff(i,2)<data_diff(i,3)
            data_diff(i,5) = 1;
            cnt_diff_1 = cnt_diff_1 + 1;
        else
            data_diff(i,5) = 2;
            cnt_diff_2 = cnt_diff_2 + 1;
        end
    end
    
    score_round1_flag = data_sorted; % 找到第1阶段需要调整的队伍的5个标准分
    
    data_f_already = [score_round1_flag mean(score_round1_flag(:,2:end),2) data_mean(:,2:3) data_diff(:,5)];
    
    % 复议得分
    for i = 1:size(data_f_already,1)
        if data_f_already(i,end) == 0
            data_f_changed1(i,:) = init_changed_Up(data_f_already(i,2) , data_f_already(i,7) , data_f_already(i,8),data_f_already(i,9)-data_f_already(i,4),data_f_already(i,10)-data_f_already(i,4));
        else
            data_f_changed5(i,:) = init_changed_Down(data_f_already(i,6),data_f_already(i,7),data_f_already(i,8),data_f_already(i,9)-data_f_already(i,4),data_f_already(i,10)-data_f_already(i,4));
        end
    end
    data_prepare = data_f_already;
    for i = 1:size(data_prepare,1)
        if i<=size(data_f_changed1,1) && data_f_changed1(i,1)~=0
            data_prepare(i,2) = data_f_changed1(i,1) + data_f_already(i,2);
        elseif i<=size(data_f_changed5,1) && data_f_changed5(i,1)~=0
            data_prepare(i,6) = data_f_changed5(i,1) + data_f_already(i,6);
        end
    end
    
    fuyi_score_round1_temp = data_prepare(:,1:6);
    data_res = data_already_temp(:,1:6);
    for i = 1:size(fuyi_score_round1_temp,1)
        data_res(fuyi_score_round1_temp(i,1),2:end) = fuyi_score_round1_temp(i,2:end);
    end
    fuyi_score_round1 = data_res(:,2:end);
    
    
    
    save('fuyi_score_round1.mat','fuyi_score_round1');
    clearvars
    
    %% 第二阶段复议
    load x_new_temp.mat;load medal_num.mat;load score_res_round2.mat;
    x_new_temp = x_new_temp(1:medal_num,:);
    x_new_temp = score_res_round2';
    
    % 筛选出每支队伍的标准分与极差
    [m,n] = size(x_new_temp);
    for i = 1:m
        cnt = 1;
        for j = 1:n
            if x_new_temp(i,j) ~= 0
                standard_score(i,cnt) = x_new_temp(i,j);
                cnt = cnt + 1;
            end
        end
    end
    % 计算极差
    for i = 1:size(standard_score,1)
        max_val = max(standard_score(i,:));
        min_val = min(standard_score(i,:));
        diff(i,1) = abs(max_val - min_val);
    end
    data_already_temp = [[1:length(diff)]' standard_score diff];
    cnt = 1;
    % 找到极差大于20的组别
    for i = 1:size(data_already_temp,1)
        if data_already_temp(i,end)>20
            data_already(cnt,:) = data_already_temp(i,:);
            cnt = cnt + 1;
        end
    end
    % 对五位专家打分进行排序
    for i = 1:size(data_already,1)
        data_sorted(i,:) = [data_already(i,1) sort(data_already(i,2:end-1)) data_already(i,end)];
    end
    % 分别求最小、最大两个评分均值 五个评分均值
    for i = 1:size(data_sorted,1)
        data_mean(i,:) = [data_sorted(i,1) data_sorted(i,2) data_sorted(i,4) sum(data_sorted(i,2:4))/3 data_already(i,end)];
    end
    % 求最小、最大两个评分均值与五个评分均值的差值
    for i = 1:size(data_mean,1)
        data_diff(i,:) = [data_mean(i,1) abs(data_mean(i,2)-data_mean(i,4)) abs(data_mean(i,3)-data_mean(i,4)) data_mean(i,end)];
    end
    % 标记012
    cnt_diff_0 = 0;
    cnt_diff_1 = 0;
    cnt_diff_2 = 0;
    for i = 1:size(data_diff,1)
        if data_diff(i,2)>data_diff(i,3)
            data_diff(i,5) = 0;
            cnt_diff_0 = cnt_diff_0 + 1;
        elseif data_diff(i,2)<data_diff(i,3)
            data_diff(i,5) = 1;
            cnt_diff_1 = cnt_diff_1 + 1;
        else
            data_diff(i,5) = 2;
            cnt_diff_2 = cnt_diff_2 + 1;
        end
    end
    score_res_round2_temp = score_res_round2';
    [m,n] = size(score_res_round2_temp);
    for i = 1:m
        cnt = 1;
        for j = 1:n
            if score_res_round2_temp(i,j) ~= 0
                standard_score_round2(i,cnt) = score_res_round2_temp(i,j);
                cnt = cnt + 1;
            end
        end
    end
    standard_score_round2 = sort(standard_score_round2,2);
    score_round2_flag = [data_diff(:,1) standard_score_round2(data_diff(:,1),:)]; % 找到第二阶段需要调整的队伍的三个标准分
    
    data_f_already = [score_round2_flag data_diff(:,4) mean(score_round2_flag(:,2:end),2) data_mean(:,2:3) data_diff(:,5)];
    
    % 复议得分
    for i = 1:size(data_f_already,1)
        if data_f_already(i,end) == 0
            data_f_changed1(i,:) = init_changed_Up(data_f_already(i,2) , data_f_already(i,5) , data_f_already(i,6),data_f_already(i,7)-data_f_already(i,3),data_f_already(i,8)-data_f_already(i,3));
        else
            data_f_changed5(i,:) = init_changed_Down(data_f_already(i,4),data_f_already(i,5),data_f_already(i,6),data_f_already(i,7)-data_f_already(i,3),data_f_already(i,8)-data_f_already(i,3));
        end
    end
    data_prepare = data_f_already;
    for i = 1:size(data_prepare,1)
        if i<=size(data_f_changed1,1) && data_f_changed1(i,1)~=0
            data_prepare(i,2) = data_f_changed1(i,1) + data_f_already(i,2);
        elseif i<=size(data_f_changed5,1) && data_f_changed5(i,1)~=0
            data_prepare(i,4) = data_f_changed5(i,1) + data_f_already(i,4);
        end
    end
    
    fuyi_score_round1_temp = data_prepare(:,1:4);
    data_res = data_already_temp(:,1:4);
    for i = 1:size(fuyi_score_round1_temp,1)
        data_res(fuyi_score_round1_temp(i,1),2:end) = fuyi_score_round1_temp(i,2:end);
    end
    fuyi_score_round2 = data_res(:,2:end);
    save('fuyi_score_round2.mat','fuyi_score_round2');
    %%
    load fuyi_score_round1.mat;load fuyi_score_round2.mat;load medal_num.mat
    load medal_ratio1.mat;load medal_ratio2.mat;load medal_ratio3.mat
    % 找出既有第一阶段又有第二阶段的作品 单独算
    for i = 1:size(fuyi_score_round2,1)
        res_score_round12(i,1) = sum(fuyi_score_round1(i,:))/5 + sum(fuyi_score_round2(i,:));
    end
    % 只有第一阶段的
    cnt = 1;
    for i = size(fuyi_score_round2,1)+1:size(fuyi_score_round1,1)
        res_score_round1(cnt,1) = sum(fuyi_score_round1(i,:));
        cnt = cnt + 1;
    end
    
    res_score = [res_score_round12;res_score_round1];
    
    [sorted_sums12, sorted_indices12] = sort(res_score_round12,"descend");
    [sorted_sums1, sorted_indices1] = sort(res_score_round1,"descend");
    fuyi_score_round1_res = fuyi_score_round1(([sorted_indices12;sorted_indices1+medal_num]),:);
    minValue = min(fuyi_score_round1_res(:));
    maxValue = max(fuyi_score_round1_res(:));
    fuyi_score_round1_res = 95 * (fuyi_score_round1_res - minValue) / (maxValue - minValue);
    
    
    fuyi_score_round12_res = fuyi_score_round2(sorted_indices12,:);
    fuyi_score_round12_res = [fuyi_score_round12_res;zeros(size(fuyi_score_round1_res,1)-medal_num,size(fuyi_score_round12_res,2))];
    minValue = min(fuyi_score_round12_res(:));
    maxValue = max(fuyi_score_round12_res(:));
    fuyi_score_round12_res = 95 * (fuyi_score_round12_res - minValue) / (maxValue - minValue);
    
    
    res_ranking = [[ sorted_indices12;sorted_indices1+medal_num] [sorted_sums12;sorted_sums1] fuyi_score_round1_res fuyi_score_round12_res];
    level1_num = floor(size(res_ranking,1)*medal_ratio1);
    level2_num = floor(size(res_ranking,1)*medal_ratio2);
    level3_num = medal_num - level1_num - level2_num;
    level0_num = size(res_ranking,1) - medal_num;
    res_ranking = [[ones(level1_num,1);2*ones(level2_num,1);3*ones(level3_num,1);zeros(level0_num,1)] res_ranking];
    
    save('res_ranking.mat',"res_ranking");
    header = ["奖项等级" "队伍编号" "最终分数" "第一阶段专家1分数" "第一阶段专家2分数" "第一阶段专家3分数" "第一阶段专家4分数" "第一阶段专家5分数" "第二阶段专家1分数" "第二阶段专家2分数" "第二阶段专家3分数"];
    res_total = [header;num2cell(res_ranking)];
    for i = size(fuyi_score_round2,1)+1:size(fuyi_score_round1,1)
        for j = 9:11
            if res_total(i, j) == "0"
                res_total(i, j) = ""; % 将0替换为空字符串
            end
        end
    end
    writematrix(res_total,'最终评议结果.xlsx');
    delete('*.mat')
    disp("------------------------------------处理完成，结果请查看#最终评议结果.xlsx#------------------------------------")
    toc







end