clear;clc;warning off;close all;format longG

%% 数据2.1处理
data = readcell("数据2.1 .xlsx");
prepareData = data(4:end,:);
[m,n] = size(prepareData);
cnt = 1;
for i = 1:size(prepareData,1)
    if ~ismissing(prepareData{i,end})
        temp(cnt,:) = prepareData(i,:);
        cnt = cnt + 1;
    end
end
res_2_1 = [data(1:3,:);temp];


%% 数据2.2处理
data_2 = readcell("数据2.2 .xlsx");
prepareData_2 = data_2(4:end,:);
[m,n] = size(prepareData_2);
cnt = 1;
for i = 1:size(prepareData_2,1)
    if ~ismissing(prepareData_2{i,end})
        temp_2(cnt,:) = prepareData_2(i,:);
        cnt = cnt + 1;
    end
end
res_2_2 = [data_2(1:3,[1,2,3,5:end]);temp_2(:,[1,2,3,5:end])];

resed = [res_2_1 ; res_2_2(4:end,:)];

%% 两部分数据整合以及处理
%从前365个只改变一次标准分的子集合中筛选出复议前后的极差
DataPrerared_jicha = resed(4:end,[4,5]);
jicha_num = cell2mat(DataPrerared_jicha(1:356,:)); 

% 计算极差的相对增幅
relative_jicha = (jicha_num(1:356,2)-jicha_num(1:356,1))./jicha_num(1:356,1);

%绘制增图趋势图
subplot(1,2,1);
plot(1:length(relative_jicha),relative_jicha,'Linewidth',1.2);
hold on;
line([0,356.5], [-0.5,-0.5],'color','red','Linewidth',2);
xlim([0,356.5]);
xlabel('试卷编号');
ylabel('复议后极差占据复议前极差的相对降幅');
subplot(1,2,2);
h1 = histogram(relative_jicha);

% 添加标题和标签
title('Histogram of Data');
xlabel('Data Values');
ylabel('Frequency');

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

%% 提取第二阶段参与复议改分的数据
% 提取第二阶段数据集
DataPrerared_grade = resed(4:end,[26 27 30 31 34 35]);
grade_num = cell2mat(DataPrerared_grade); 
    
% 筛选出每份试卷调整分数的打分
for i = 1:356
    shift_grade = zeros(1,2);
    if grade_num(i,1) ~= grade_num(i,2)
        shift_grade = grade_num(i,[1,2]);
    elseif grade_num(i,3) ~= grade_num(i,4)
        shift_grade = grade_num(i,[3,4]);
    elseif grade_num(i,5) ~= grade_num(i,6)
        shift_grade = grade_num(i,[5,6]);
    end
    changed_grade(i,:) = shift_grade;
end

%% 汇总数据集

biaozhunfen = grade_num(1:356,[1,3,5]); % 三位专家给出的标准分

for i = 1:356
    jicha_2(i,1) = max(biaozhunfen(i,:))-min(biaozhunfen(i,:));
end
ss = [jicha_2 jicha_num(:,1)];

% 对五位专家打分进行排序
for i = 1:size(biaozhunfen,1)
    biaozhunfen_sorted(i,:) = sort(biaozhunfen(i,:));
end

[m n] = size(biaozhunfen_sorted);
% x4 -> 排序后中位数，小于中位数的（一位或两位）均值
chazhi(:,1) = biaozhunfen_sorted(:,1) - biaozhunfen_sorted(:,(n+1)/2);
% x5 -> 排序后中位数，大于中位数的（一位或两位）均值
chazhi(:,2) = biaozhunfen_sorted(:,end) - biaozhunfen_sorted(:,(n+1)/2);

tiaozheng = changed_grade(:,2) - changed_grade(:,1);    % 复议分 - 标准分
biaozhun_mean = sum(grade_num(1:356,[1,3,5]),2)./3;     % 三位专家打分均值
biaozhun_std = std(grade_num(1:356,[1,3,5]),0,2);       % 三位专家打分标准差


%% 整体测试
val = [tiaozheng changed_grade(:,1) jicha_num(:,1)  biaozhun_mean chazhi  ];  % 数据整合
y = val(:,1); % 因变量 -> (复议分 - 标准分)
x = val(:,[2 3 4 5 6]);  %自变量
reglm(y,x, 'quadratic')
% histogram(val(:,1));

data_total = sort(val(:,[1 2 3 4 5 6]),1);
total_y = data_total(:,1);
total_x = data_total(:,[2,3,4 5 6]);

xlips = [{'需要修正的标准分'} {'该份试卷对应的极差'} {'一组专家打分的均值'} {'一组后1或2位均值'} {'一组前1或2位均值'} ];
figure();
for i =1:5
    subplot(2,3,i);
    plot(total_x(:,i) ,total_y,'Linewidth',1.5);
    xlip = cell2mat(xlips(i))
    xlabel(xlip,'FontSize',12,'FontWeight','bold');
    ylabel('复议加(减)分','FontSize',12,'FontWeight','bold');
    legend('复议加(减)分','Location', 'NorthWest');
    hold on;
end

x1 = x(:,1);
x2 = x(:,2);
x3 = x(:,3);
x2 = x(:,4);
x3 = x(:,5);

res = init_changed_total(x1,x2,x3);
realticve_fuyi_total = sqrt(sum((res-tiaozheng).^2)/356)
subplot(2,3,6)
plot(1:356,sort(tiaozheng),'b--','Linewidth',1.5);
hold on
plot(1:356,sort(res),'r--','Linewidth',1.5);
xlabel('队伍编号','FontSize',12,'FontWeight','bold');
ylabel('标准分','FontSize',12,'FontWeight','bold');
legend('真实值','预测值','Location', 'NorthWest');
hold off
suptitle_total = suptitle('二阶段整体复议加(减)分整体');
set(suptitle_total, 'FontSize', 16, 'FontName', 'Helvetica');
clear x1 x2 x3 x4 x5

%%  大于零的部分
data_up = sort(val([y>=0],[1 2 3 4 5 6]),1);
Up_y = data_up(:,1);
Up_x = data_up(:,[2,3,4 5 6]);

% 绘图
xlips = [{'需要修正的标准分'} {'该份试卷对应的极差'} {'一组专家打分的均值'} {'一组后1或2位均值'} {'一组前1或2位均值'} ];
figure();
for i =1:5
    subplot(2,3,i);
    plot(Up_x(:,i) ,Up_y,'Linewidth',1.5);
    xlip = cell2mat(xlips(i))
    xlabel(xlip,'FontSize',12,'FontWeight','bold');
    ylabel('复议加(减)分','FontSize',12,'FontWeight','bold');
    legend('复议加(减)分','Location', 'NorthWest');
    hold on;
end
hold off
% 拟合
reglm(Up_y,Up_x, 'quadratic')

% 测试【调整数大于0】
x1 = Up_x(:,1);
x2 = Up_x(:,2);
x3 = Up_x(:,3);
x4 = Up_x(:,4);
x5 = Up_x(:,5);
% cnt =12;
% ins = 182;

res = init_changed_Up(x1,x2,x3,x4,x5);
m = [Up_y res] ;
% realticve_fuyi = sqrt(sum((res-tiaozheng).^2)/356)

subplot(2,3,6)
plot(1:length(Up_y),sort(Up_y),'b','Linewidth',1.5);
hold on
plot(1:length(Up_y),sort(res),'r--','Linewidth',1.5);
xlabel('队伍编号','FontSize',10,'FontWeight','bold');
ylabel('标准分','FontSize',10,'FontWeight','bold');
legend('真实值','预测值','Location', 'NorthWest');
hold off

suptitle_total = suptitle('二阶段整体复议加分整体');
set(suptitle_total, 'FontSize', 16, 'FontName', 'Helvetica');

realticve_fuyi_Up = sqrt(sum((res-Up_y).^2)/356)

clear x1 x2 x3 x4 x5
%%  小于零的部分
data_down = sort(val([y<0],[1 2 3 4 5 6]),1);
Down_y = data_down(:,1);
Down_x = data_down(:,[2,3,4 5 6]);

% 绘图
xlips = [{'需要修正的标准分'} {'该份试卷对应的极差'} {'一组专家打分的均值'} {'一组后1或2位均值'} {'一组前1或2位均值'} ];
figure();
for i =1:5
    subplot(2,3,i);
    plot(Down_x(:,i) ,Down_y,'Linewidth',1.5);
    xlip = cell2mat(xlips(i))
    xlabel(xlip,'FontSize',12,'FontWeight','bold');
    ylabel('复议加(减)分','FontSize',12,'FontWeight','bold');
    legend('复议加(减)分','Location', 'NorthWest');
    hold on;
end
hold off

% 拟合
reglm(Down_y,Down_x, 'quadratic')

% 测试【调整数小于0】
x1 = Down_x(:,1);
x2 = Down_x(:,2);
x3 = Down_x(:,3);
x4 = Down_x(:,4);
x5 = Down_x(:,5);
% cnt =12;
% ins = 182;

res = init_changed_Down(x1,x2,x3,x4,x5);
m = [Down_y res];
% realticve_fuyi = sqrt(sum((res-tiaozheng).^2)/356)
num = abs(res-Down_y)./res;
subplot(2,3,6)
plot(1:length(Down_y),sort(Down_y),'b','Linewidth',1.2);
hold on
plot(1:length(Down_y),sort(res),'r--','Linewidth',1.2);
xlabel('队伍编号','FontSize',10,'FontWeight','bold');
ylabel('标准分','FontSize',10,'FontWeight','bold');
legend('真实值','预测值','Location', 'NorthWest');

suptitle_total = suptitle('二阶段整体复议减分整体');
set(suptitle_total, 'FontSize', 16, 'FontName', 'Helvetica');

hold off



realticve_fuyi_Down = sqrt(sum((res-Down_y).^2)/356)


