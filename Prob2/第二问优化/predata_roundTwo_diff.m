function res = predata_roundTwo_diff(data,tag)
    Expert4_list = data(4:end,24+(tag-1)*4);
    unique_Expert4 = unique(data(4:end,24+(tag-1)*4));
    for i = 1:length(unique_Expert4)
        cnt = 1;
        for j = 1:length(Expert4_list)
            if strcmp(Expert4_list{j}, unique_Expert4(i))
                flag4(i,cnt) = j;
                cnt = cnt + 1;
            end
        end
    end
    matrix4 = num2cell(zeros(size(flag4,1),size(data,1)-3)); %存不同专家对应分数
    org_score4 = data(4:end,26+(tag-1)*4)';
    [m,n] = size(org_score4);
    temp = num2cell(zeros(m,n));
    fuyi_score = data(4:end,27+(tag-1)*4)';
    for i = 1:length(org_score4)
        if ~ismissing(fuyi_score{i})
            temp{i} = fuyi_score{i} - org_score4{i};
            org_score4{i} = fuyi_score{i};
        end
    end
    for i = 1:size(matrix4,1)
        tempFlag4 = flag4(i,:);
        tempFlag4 = tempFlag4(tempFlag4~=0);
        matrix4(i,tempFlag4) = temp(tempFlag4);
    end
    res = [unique_Expert4 matrix4];




end