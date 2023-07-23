clear all;
clc;

m = 4;
U_range = 0.4:0.2:m;
set_numb = 1000;
task_numb = 10;
subtask_numb = 10;
p = 0.2;

count_over = 0;
for u = U_range
    %%%%%%%%%%%%%%% 读取数据 %%%%%%%%%%%%%%
    path = ['database/R_DM/u_' num2str(u)];
    path_D = [path '/D.mat'];
    load(path_D);
    %%%%%%%%%%%%%%% 开始检查 %%%%%%%%%%%%%%%%%
    for i = 1:set_numb
        for j = 1:task_numb
            if D(i,j) >= 10000000
                count_over = count_over + 1;
                u
                i
                j
                D(i,j)
                count_over
            end
        end
    end
    
    
    
    
end