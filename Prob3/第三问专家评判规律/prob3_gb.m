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

% 一轮和二轮综合成绩
data_12 = zscore(dataPrepared_num21_mean_round1 + sum(dataPrepared_num21_round2,2));

% 单单一轮成绩
data_1 = zscore(dataPrepared_num21_mean_round1);

figure()
plot(1:length(dataPrepared_num21_mean_round1),data_1,'b-','Linewidth',1);
hold on;
plot(1:length(dataPrepared_num21_mean_round1),data_12,'r','Linewidth',1.3);
legend('单阶段','两阶段');
xlabel('获奖队伍编号');
ylabel('归一化综合评分');
hold off

clearvars
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

% 一轮和二轮综合成绩
data_12 = zscore(dataPrepared_num21_mean_round1 + sum(dataPrepared_num21_round2,2));

% 单单一轮成绩
data_1 = zscore(dataPrepared_num21_mean_round1);

figure()
plot(1:length(dataPrepared_num21_mean_round1),data_1,'b-','Linewidth',1);
hold on;
plot(1:length(dataPrepared_num21_mean_round1),data_12,'r','Linewidth',1.3);
legend('单阶段','两阶段');
xlabel('获奖队伍编号');
ylabel('归一化综合评分');