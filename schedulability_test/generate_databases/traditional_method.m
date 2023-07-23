function R = traditional_method(C,T,D,J,topologies,processors,path,set_numb,task_numb)

% set_numb = length(C);%%%%表示有多少个任务集
R = zeros(set_numb,1);

for i = 1:set_numb%每组任务分配别计算
%     task_numb = length(C{i});
    for j = task_numb:-1:1
        %C{i}(1:j) 中{i}表示第i行（1：j）表示其中第1~j个task。每个task都是一个矩阵，包含子任务的各种信息
        R_temp = calculate_R_old(C(i,1:j),T(i,1:j),D(i,j),J(i,1:j),topologies{i,j},processors(i,1:j),path{i,j});
        if R_temp ~= inf
            R(i) = R(i) + R_temp;
        else
            R(i) = inf;
            break;
        end
    end
    
end

end