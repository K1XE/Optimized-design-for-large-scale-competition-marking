clear;clc;warning off;close all;format longG;
% 125名专家
% 125组试卷 每组24份
best_f= 1e4; % 最优目标函数值
best_std = 10;
best_gamma = zeros(125,125);
% 蒙特卡洛
for m = 1 :1e3
    gap = randi(121,[125,1]); % 每组卷随机连续五名专家批阅
    res_gap = zeros(125,125); 
    res_gap(1,1:5) = 1;
    for i = 1:length(gap)
        res_gap(i,:) = [zeros(1,gap(i)-1) ones(1,5) zeros(1,121-gap(i))];
    end
    s = sum(res_gap,1);
    D = zeros(125,125);
    for i=1:125
        for j=1:125
            if i<j
               D(i,j) =sum(res_gap(:,i) == 1 & res_gap(:,j) == 1);
            end
        end
    end
    for i=1:125
        for j=1:125
            if i<j
               gamma(i,j) = 2*D(i,j)/(sum(res_gap(:,i))+sum(res_gap(:,j)));
            end
        end
    end
    gamma(isnan(gamma)) = 0;
    gamma_mean = sum(sum(gamma))/(124*125/2);
    f = sqrt(sum(sum((gamma-gamma_mean).^2))/(124*125/2)); % 目标函数
    if f < best_f && std(s) < best_std
        best_std = std(s);
        best_gamma = gamma;
        best_s = s;
        best_f = f; % 记录更优的fval
        best_gap = gap; % 记录对应评阅细则
    end
end
best_f
best_std = std(best_s*24)

plot(1:125,best_s*24,'b-','LineWidth',1.4);
hold on 
xlim([0,125.5]);
xlabel('专家序号');
ylabel('评阅试卷集（份）');
title('');
line([0,125],[120,120] ,'Color','red','LineStyle','--','LineWidth',1.3);
hold off
%%
h = histogram(gamma(gamma ~= 0),10)

% 添加标题和标签
title('任意两个专家的交叠率');
xlabel('交叠率');
ylabel('频次 ');


% 添加网格
grid on;

% 添加数据标记
hold on; % 允许在同一图上添加其他元素
x_values = h.BinEdges(1:end-1) + h.BinWidth/2;
y_values = h.Values;
plot(x_values, y_values, 'r-o', 'MarkerSize', 2, 'MarkerFaceColor', 'g','LineWidth',1); % 红色圆点标记
hold off;

% 添加图例
legend('频数', '趋势线', 'Location', 'NorthEast');

% 设置图形大小
set(gcf, 'Position', [100, 100, 800, 400]);
