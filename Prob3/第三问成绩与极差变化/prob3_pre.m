clear;clc;warning off;close all;format longG
%% 数据2.1
data21 = readcell("数据2.1 .xlsx");
% 两阶段成绩变化（标准分）
dataPrepare1 = [data21(:,2) data21(:,6:20)];
dataPrepared = dataPrepare1(4:240,[3 6 9 12 15]+1);
dataPrepared_num21_round1 = cell2mat(dataPrepared);
dataPrepared_num21_mean_round1 = mean(dataPrepared_num21_round1,2);
dataPrepare1 = [data21(:,2) data21(:,24:end)];
dataPrepared = dataPrepare1(4:240,[3 7 11]+1);
dataPrepared_num21_round2 = cell2mat(dataPrepared);
dataPrepared_num21_mean_round2 = mean(dataPrepared_num21_round2,2);
score_means = (dataPrepared_num21_mean_round2+dataPrepared_num21_mean_round1)./2;
volatility = abs((dataPrepared_num21_mean_round2-dataPrepared_num21_mean_round1)./(score_means));% 波动率
win = 5;
% 计算连续十个元素的均值
for i = 1:win:(length(volatility) - win +1)
    round1 = dataPrepared_num21_mean_round1(i:(i + win -1));
    round2 = dataPrepared_num21_mean_round2(i:(i + win -1));
    volatility0 = volatility(i:(i + win -1));
    average_round(i,:) = [mean(round1) mean(round2) mean(volatility0)] ;
end


figure()
subplot(2,3,1);
area([1:length(dataPrepared_num21_mean_round1)],dataPrepared_num21_mean_round1)
set(gca, 'LineWidth', 1) 
set(gca, 'FontWeight','bold')
xlabel('获奖队伍编号')
ylabel('两阶段成绩波动率')
xlim([0 237])
hold on;
plot([1:win:length(dataPrepared_num21_mean_round1)-win+1], average_round(1:win:end,1),'r-','Linewidth',1.25);
h = sum(average_round(1:win:end,1))/length(average_round(1:win:end,1));
line([0 237],[h h],'color','red','LineStyle', '--','Linewidth',1.2)
hold off;

subplot(2,3,2);
area([1:length(dataPrepared_num21_mean_round2)],dataPrepared_num21_mean_round2)
set(gca, 'LineWidth', 1) 
set(gca, 'FontWeight','bold')
xlabel('获奖队伍编号')
ylabel('两阶段成绩波动率')
xlim([0 237])
hold on;
plot([1:win:length(dataPrepared_num21_mean_round1)-win+1], average_round(1:win:end,2),'r-','Linewidth',1.25);
h = sum(average_round(1:win:end,2))/length(average_round(1:win:end,2));
line([0 237],[h h],'color','red','LineStyle', '--','Linewidth',1.2)
hold off;

subplot(2,3,3);
area([1:length(dataPrepared_num21_mean_round2)],volatility)
set(gca, 'LineWidth', 1) 
set(gca, 'FontWeight','bold')
xlabel('获奖队伍编号')
ylabel('两阶段成绩波动率')
xlim([0 237])
hold on;
plot([1:win:length(dataPrepared_num21_mean_round1)-win+1], average_round(1:win:end,3),'r-','Linewidth',1.25);
h = sum(average_round(1:win:end,3))/length(average_round(1:win:end,3));
line([0 237],[h h],'color','red','LineStyle', '--','Linewidth',1.2)
hold off;

clearvars
data21 = readcell("数据2.1 .xlsx");
% 两阶段极差变化
dataPrepare = cell2mat(data21(4:240,[4 23]));
mean_diff = (dataPrepare(:,1) + dataPrepare(:,2))./2;
volatility = abs((dataPrepare(:,1) - dataPrepare(:,2))./mean_diff);

win = 5;
% 计算连续十个元素的均值
for i = 1:win:(length(volatility) - win +1)
    round1 = dataPrepare(i:(i + win -1),1);
    round2 = dataPrepare(i:(i + win -1),2);
    volatility0 = volatility(i:(i + win -1));
    average_round(i,:) = [mean(round1) mean(round2) mean(volatility0)] ;
end

% 绘制两阶段极差分布图
subplot(2,3,4);
area([1:length(dataPrepare)],dataPrepare(:,1))
set(gca, 'LineWidth', 1) 
set(gca, 'FontWeight','bold')
xlabel('获奖队伍编号')
ylabel('两阶段极差波动率')
xlim([0 237])
hold on;
plot([1:win:length(volatility)-win+1], average_round(1:win:end,1),'r-','Linewidth',1.25);
h = sum(average_round(1:win:end,1))/length(average_round(1:win:end,1));
line([0 237],[h h],'color','red','LineStyle', '--','Linewidth',1.2)
hold off;

subplot(2,3,5);
area([1:length(dataPrepare)],dataPrepare(:,2))
set(gca, 'LineWidth', 1) 
set(gca, 'FontWeight','bold')
xlabel('获奖队伍编号')
ylabel('两阶段极差波动率')
xlim([0 237])
hold on;
plot([1:win:length(volatility)-win+1], average_round(1:win:end,2),'r-','Linewidth',1.25);
h = sum(average_round(1:win:end,2))/length(average_round(1:win:end,2));
line([0 237],[h h],'color','red','LineStyle', '--','Linewidth',1.2)
hold off;

subplot(2,3,6);
area([1:length(dataPrepare)],volatility)
set(gca, 'LineWidth', 1) 
set(gca, 'FontWeight','bold')
xlabel('获奖队伍编号')
ylabel('两阶段极差波动率')
xlim([0 237])
hold on;
plot([1:win:length(volatility)-win+1], average_round(1:win:end,3),'r-','Linewidth',1.25);
h = sum(average_round(1:win:end,3))/length(average_round(1:win:end,3));
line([0 237],[h h],'color','red','LineStyle', '--','Linewidth',1.2)
hold off;


clearvars


%% 数据2.1
data22 = readcell("数据2.2 .xlsx");
% 两阶段成绩变化（标准分）
dataPrepare1 = [data22(:,2) data22(:,7:21)];
dataPrepared = dataPrepare1(4:1503,[3 6 9 12 15]+1);
dataPrepared_num21_round1 = cell2mat(dataPrepared);
dataPrepared_num21_mean_round1 = mean(dataPrepared_num21_round1,2);
dataPrepare1 = [data22(:,2) data22(:,24:end)];
dataPrepared = dataPrepare1(4:1503,[3 7 11]+1);
dataPrepared_num21_round2 = cell2mat(dataPrepared);
dataPrepared_num21_mean_round2 = mean(dataPrepared_num21_round2,2);
score_means = (dataPrepared_num21_mean_round2+dataPrepared_num21_mean_round1)./2;
volatility = abs((dataPrepared_num21_mean_round2-dataPrepared_num21_mean_round1)./(score_means));% 波动率

win = 30;
% 计算连续十个元素的均值
for i = 1:win:(length(volatility) - win +1)
    round1 = dataPrepared_num21_mean_round1(i:(i + win -1));
    round2 = dataPrepared_num21_mean_round2(i:(i + win -1));
    volatility0 = volatility(i:(i + win -1));
    average_round(i,:) = [mean(round1) mean(round2) mean(volatility0)] ;
end

figure()
subplot(2,3,1);
area([1:length(dataPrepared_num21_mean_round1)],dataPrepared_num21_mean_round1)
set(gca, 'LineWidth', 1.25) 
set(gca, 'FontWeight','bold')
xlabel('获奖队伍编号')
ylabel('两阶段成绩波动率')
xlim([0 1500])
hold on;
plot([1:win:length(dataPrepared_num21_mean_round1)-win+1], average_round(1:win:end,1),'r-','Linewidth',1.25);
h = sum(average_round(1:win:end,1))/length(average_round(1:win:end,1));
line([0 1500],[h h],'color','red','LineStyle', '--','Linewidth',1.2)
hold off;

subplot(2,3,2);
area([1:length(dataPrepared_num21_mean_round2)],dataPrepared_num21_mean_round2);
set(gca, 'LineWidth', 1) 
set(gca, 'FontWeight','bold')
xlabel('获奖队伍编号')
ylabel('两阶段成绩波动率')
xlim([0 1500])
hold on;
plot([1:win:length(dataPrepared_num21_mean_round1)-win+1], average_round(1:win:end,2),'r-','Linewidth',1.25);
h = sum(average_round(1:win:end,2))/length(average_round(1:win:end,2));
line([0 1500],[h h],'color','red','LineStyle', '--','Linewidth',1.2)
hold off;


subplot(2,3,3);
area([1:length(dataPrepared_num21_mean_round2)],volatility)
set(gca, 'LineWidth', 1) 
set(gca, 'FontWeight','bold')
xlabel('获奖队伍编号')
ylabel('两阶段成绩波动率')
xlim([0 1500])
hold on;
plot([1:win:length(dataPrepared_num21_mean_round1)-win+1], average_round(1:win:end,3),'r-','Linewidth',1.25);
h = sum(average_round(1:win:end,3))/length(average_round(1:win:end,3));
line([0 1500],[h h],'color','red','LineStyle', '--','Linewidth',1.2)
hold off;

clearvars
data22 = readcell("数据2.2 .xlsx");
% 两阶段极差变化
dataPrepare = cell2mat(data22(4:1503,[5 24]));
mean_diff = (dataPrepare(:,1) + dataPrepare(:,2))./2;
volatility = abs((dataPrepare(:,1) - dataPrepare(:,2))./mean_diff);

win = 30;
% 计算连续十个元素的均值
for i = 1:win:(length(volatility) - win +1)
    round1 = dataPrepare(i:(i + win -1),1);
    round2 = dataPrepare(i:(i + win -1),2);
    volatility0 = volatility(i:(i + win -1));
    average_round(i,:) = [mean(round1) mean(round2) mean(volatility0)] ;
end

% 绘制两阶段极差分布图
subplot(2,3,4);
area([1:length(dataPrepare)],dataPrepare(:,1))
set(gca, 'LineWidth', 1) 
set(gca, 'FontWeight','bold')
xlabel('获奖队伍编号')
ylabel('两阶段极差波动率')
xlim([0 1500])
hold on;
plot([1:win:length(volatility)-win+1], average_round(1:win:end,1),'r-','Linewidth',1.25);
h = sum(average_round(1:win:end,1))/length(average_round(1:win:end,1));
line([0 1500],[h h],'color','red','LineStyle', '--','Linewidth',1.2)
hold off;

subplot(2,3,5);
area([1:length(dataPrepare)],dataPrepare(:,2))
set(gca, 'LineWidth', 1) 
set(gca, 'FontWeight','bold')
xlabel('获奖队伍编号')
ylabel('两阶段极差波动率')
xlim([0 1500])
hold on;
plot([1:win:length(volatility)-win+1], average_round(1:win:end,2),'r-','Linewidth',1.25);
h = sum(average_round(1:win:end,2))/length(average_round(1:win:end,2));
line([0 1500],[h h],'color','red','LineStyle', '--','Linewidth',1.2)
hold off;

subplot(2,3,6);
area([1:length(dataPrepare)],volatility)
set(gca, 'LineWidth', 1) 
set(gca, 'FontWeight','bold')
xlabel('获奖队伍编号')
ylabel('两阶段极差波动率')
xlim([0 1500])
hold on;
plot([1:win:length(volatility)-win+1], average_round(1:win:end,3),'r-','Linewidth',1.25);
h = sum(average_round(1:win:end,3))/length(average_round(1:win:end,3));
line([0 1500],[h h],'color','red','LineStyle', '--','Linewidth',1.2)
hold off;





