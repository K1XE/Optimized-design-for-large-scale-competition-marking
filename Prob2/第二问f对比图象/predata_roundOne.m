function res = predata_roundOne(data,tag)
% 整理数据 得到题目所说的a1 a2......an
    Expert2_list = data(4:end,6+(tag-1)*3);
    unique_Expert2 = unique(data(4:end,6+(tag-1)*3));
    for i = 1:length(unique_Expert2)
        cnt = 1;
        for j = 1:length(Expert2_list)
            if strcmp(Expert2_list{j}, unique_Expert2(i))
                flag2(i,cnt) = j;
                cnt = cnt + 1;
            end
        end
    end
    matrix2 = num2cell(zeros(size(flag2,1),size(data,1)-3)); %存不同专家对应分数
    org_score2 = data(4:end,7+(tag-1)*3)';
    
    for i = 1:size(matrix2,1)
        tempFlag2 = flag2(i,:);
        tempFlag2 = tempFlag2(tempFlag2~=0);
        matrix2(i,tempFlag2) = org_score2(tempFlag2);
    end
    res = [unique_Expert2 matrix2];
end