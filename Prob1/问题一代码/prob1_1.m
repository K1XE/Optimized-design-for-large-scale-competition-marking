clear;clc;warning off;close all;format longG;
numExpert = 125; % 125名专家
packExam = 125; % 125组试卷 每组24份

%% 偏移量 = 1
temp_gap1 = zeros(125,125); %开空矩阵，行代表卷的组号，列代表专家的编号
numExpert_cnt1 = 1; %计数器 偏移量所需
% 计算偏移矩阵temp_gap1
for i = 1:packExam
    temp_gap1(i,numExpert_cnt1:numExpert_cnt1+4) = ones(1,5);
    numExpert_cnt1 = numExpert_cnt1 + 1;
end
[m,n] = size(temp_gap1);
% 找到溢出量 即出现126、127...号的专家，需要重置为1、2...号的专家
diffValue = abs(m-n); 

overflow = temp_gap1(1:end,end - diffValue + 1:end); %计算溢出
cnt = 1;
overflow_temp = overflow;
% 当溢出数量超过一轮后，多次判断，累加
while size(overflow_temp,2)>125
    overflow_struct(cnt).overflow = overflow_temp(:,1:125);
    overflow_temp = overflow(:,125*cnt + 1:end);
    cnt = cnt + 1;
end
overflow_struct(cnt).overflow = overflow_temp;
for i=1:size(overflow_struct,2)
    temp_gap1(1:end,1:size(overflow_struct(i).overflow,2)) = temp_gap1(1:end,1:size(overflow_struct(i).overflow,2)) + overflow_struct(i).overflow;
end
% 最终结果矩阵
res_gap1 = temp_gap1(:,1:numExpert);
sum(res_gap1);
D1 = zeros(125,125);
for i=1:125
    for j=1:125
        if i<j
           D1(i,j) =sum(res_gap1(:,i) == 1 & res_gap1(:,j) == 1);
        end
    end
end

for i=1:125
    for j=1:125
        if i<j
           gamma_1(i,j) = 2*D1(i,j)/(sum(res_gap1(:,i))+sum(res_gap1(:,j)));
        end
    end
end

gamma1_mean = sum(sum(gamma_1))/(124*125/2);
f = sqrt(sum(sum((gamma_1-gamma1_mean).^2))/(124*125/2))

clearvars
numExpert = 125; % 125名专家
packExam = 125; % 125组试卷 每组24份

%% 偏移量 = 2
temp_gap2 = zeros(125,125); %开空矩阵，行代表卷的组号，列代表专家的编号
numExpert_cnt2 = 1; %计数器 偏移量所需
% 计算偏移矩阵temp_gap1
for i = 1:packExam
    temp_gap2(i,numExpert_cnt2:numExpert_cnt2+4) = ones(1,5);
    numExpert_cnt2 = numExpert_cnt2 + 2;
end
[m,n] = size(temp_gap2);
% 找到溢出量 即出现126、127...号的专家，需要重置为1、2...号的专家
diffValue = abs(m-n); 

overflow = temp_gap2(1:end,end - diffValue + 1:end); %计算溢出
cnt = 1;
overflow_temp = overflow;
% 当溢出数量超过一轮后，多次判断，累加
while size(overflow_temp,2)>125
    overflow_struct(cnt).overflow = overflow_temp(:,1:125);
    overflow_temp = overflow(:,125*cnt + 1:end);
    cnt = cnt + 1;
end
overflow_struct(cnt).overflow = overflow_temp;
for i=1:size(overflow_struct,2)
    temp_gap2(1:end,1:size(overflow_struct(i).overflow,2)) = temp_gap2(1:end,1:size(overflow_struct(i).overflow,2)) + overflow_struct(i).overflow;
end
% 最终结果矩阵
res_gap2 = temp_gap2(:,1:numExpert);
D2 = zeros(125,125);
for i=1:125
    for j=1:125
        if i<j
           D2(i,j) =sum(res_gap2(:,i) == 1 & res_gap2(:,j) == 1);
        end
    end
end

for i=1:125
    for j=1:125
        if i<j
           gamma_2(i,j) = 2*D2(i,j)/(sum(res_gap2(:,i))+sum(res_gap2(:,j)));
        end
    end
end

gamma2_mean = sum(sum(gamma_2))/(124*125/2);
f = sqrt(sum(sum((gamma_2-gamma2_mean).^2))/(124*125/2))





clearvars
numExpert = 125; % 125名专家
packExam = 125; % 125组试卷 每组24份
%% 偏移量 = 3
temp_gap3 = zeros(125,125); %开空矩阵，行代表卷的组号，列代表专家的编号
numExpert_cnt3 = 1; %计数器 偏移量所需
% 计算偏移矩阵temp_gap1
for i = 1:packExam
    temp_gap3(i,numExpert_cnt3:numExpert_cnt3+4) = ones(1,5);
    numExpert_cnt3 = numExpert_cnt3 + 3;
end
[m,n] = size(temp_gap3);
% 找到溢出量 即出现126、127...号的专家，需要重置为1、2...号的专家
diffValue = abs(m-n); 

overflow = temp_gap3(1:end,end - diffValue + 1:end); %计算溢出
cnt = 1;
overflow_temp = overflow;
% 当溢出数量超过一轮后，多次判断，累加
while size(overflow_temp,2)>125
    overflow_struct(cnt).overflow = overflow_temp(:,1:125);
    overflow_temp = overflow(:,125*cnt + 1:end);
    cnt = cnt + 1;
end
overflow_struct(cnt).overflow = overflow_temp;
for i=1:size(overflow_struct,2)
    temp_gap3(1:end,1:size(overflow_struct(i).overflow,2)) = temp_gap3(1:end,1:size(overflow_struct(i).overflow,2)) + overflow_struct(i).overflow;
end
% 最终结果矩阵
res_gap3 = temp_gap3(:,1:numExpert);
s = sum(res_gap3,1);
D3 = zeros(125,125);
for i=1:125
    for j=1:125
        if i<j
           D3(i,j) =sum(res_gap3(:,i) == 1 & res_gap3(:,j) == 1);
        end
    end
end

for i=1:125
    for j=1:125
        if i<j
           gamma_3(i,j) = 2*D3(i,j)/(sum(res_gap3(:,i))+sum(res_gap3(:,j)));
        end
    end
end

gamma3_mean = sum(sum(gamma_3))/(124*125/2);
f = sqrt(sum(sum((gamma_3-gamma3_mean).^2))/(124*125/2))
std(s)
%%
plot(1:125,s*24,'b-','LineWidth',1.4);
hold on 
xlim([0,125.5]);
xlabel('专家序号');
ylabel('评阅试卷集（份）');
title('');
line([0,125],[120,120] ,'Color','red','LineStyle','--','LineWidth',1.3);
hold off
%%
h = histogram(gamma_3(gamma_3 ~= 0),10)

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









