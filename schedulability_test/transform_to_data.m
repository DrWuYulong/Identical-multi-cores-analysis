%本函数用来将生成的database中的mat数据转换成可以在实体机上读取并执行的txt文件
%并将文件保存在data文件夹中，同过修改m改变处理器数量，
clear all;
clc;

m = 4;
U_range = 0.2:0.2:3;
set_numb = 100;
task_numb = 10;
subtask_numb = 10;
p = 0.05;

for u = U_range
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%% R_DM 的写入数据 %%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    u
    
    %%%%%%%%%%%%%%% 读取数据 %%%%%%%%%%%%%%
	path = ['database/m' num2str(m) '/R_DM/u_' num2str(u)];
    %%% 读取C
    path_C = [path '/C.mat'];
    load(path_C);
    %%% 读取T
    path_T = [path '/T.mat'];
    load(path_T);
    %%% 读取D
    path_D = [path '/D.mat'];
    load(path_D);
%     %%% 读取U      %%%%%暂时用不到
%     path_U = [path '/U.mat'];
%     load(path_U);
    %%% 读取processors
    path_processors = [path '/processors.mat'];
    load(path_processors);
    %%% 读取topologies
    path_topologies = [path '/topologies.mat'];
    load(path_topologies);
    
%     %%%%%%%%%%%%%%%开始转换%%%%%%%%%%%%%%%%%
    path = ['data/m' num2str(m) '/R_DM/u_' num2str(u)];
    %%%%%%%%%% 写入C
    path_C = [path '/C'];
    mkdir(path_C);
    
    for i = 1:set_numb
        path_C_name = [path_C '/task_set_' num2str(i) '_C.txt'];
        fd = fopen(path_C_name,'w');
        for j = 1:task_numb %j是第几个任务
            temp_C = C{i,j};
            for k = 1:subtask_numb %k是任务j的第几个子任务
                if k ~= subtask_numb %不是某一任务的最后一个子任务
                    fprintf(fd,'%d ',temp_C(k));
                else if j ~= task_numb %是最后一个子任务，但不是任务集的最后一个任务
                        fprintf(fd,'%d\n',temp_C(k));
                    else
                        fprintf(fd,'%d\n',temp_C(k)); %最后一个任务集的最后一个
                    end
                end
            end
        end
        fclose(fd);
    end
    %%%%%%%%%% 写入T
    path_T = [path '/T'];
    mkdir(path_T);
    
    for i = 1:set_numb
        path_T_name = [path_T '/task_set_' num2str(i) '_T.txt'];
        fd = fopen(path_T_name,'w');
        for j = 1:task_numb %j是第几个任务
            if j ~= task_numb %不是最后一个任务
                fprintf(fd,'%d\n',T(i,j));
            else
                fprintf(fd,'%d\n',T(i,j));
            end
        end
        fclose(fd);
    end
        
     %%%%%%%%%% 写入D
    path_D = [path '/D'];
    mkdir(path_D);
    
    for i = 1:set_numb
        path_D_name = [path_D '/task_set_' num2str(i) '_D.txt'];
        fd = fopen(path_D_name,'w');
        for j = 1:task_numb %j是第几个任务
            if j ~= task_numb %不是最后一个任务
                fprintf(fd,'%d\n',D(i,j));
            else
                fprintf(fd,'%d\n',D(i,j));
            end
        end
        fclose(fd);
    end
    
    %%%%%%%%%% 写入processors
    path_processors = [path '/processors'];
    mkdir(path_processors);
    
    for i = 1:set_numb
        path_processors_name = [path_processors '/task_set_' num2str(i) '_processors.txt'];
        fd = fopen(path_processors_name,'w');
        for j = 1:task_numb %j是第几个任务
            temp_processors = processors{i,j};
            for k = 1:subtask_numb %k是任务j的第几个子任务
                if k ~= subtask_numb %不是某一任务的最后一个子任务
                    fprintf(fd,'%d ',temp_processors(k));
                else if j ~= task_numb %是最后一个子任务，但不是任务集的最后一个任务
                        fprintf(fd,'%d\n',temp_processors(k));
                    else
                        fprintf(fd,'%d\n',temp_processors(k)); %最后一个任务集的最后一个
                    end
                end
            end
        end
        fclose(fd);
    end
    %%%%%%%%%% 写入topologies
       
    for i = 1:set_numb
        path_topologies = [path '/topologies/task_set_' num2str(i)];
        mkdir(path_topologies);
        for j = 1:task_numb %第i个任务集的第j个任务，其拓扑结构是一个 sub_numb * sub_numb 的矩阵 
            path_topologies_name = [path_topologies '/task_' num2str(j) '_topologies.txt'];
            temp_topologies = topologies{i,j};
            fd = fopen(path_topologies_name,'w');
            for k = 1:subtask_numb 
                for l = 1:subtask_numb
                    if l ~= subtask_numb %不是一行的最后一个元素，就加空格不换行
                        fprintf(fd,'%d ',temp_topologies(k,l));
                    else if k ~= subtask_numb %是一行的最后一个，但不是总体的最后一个，就换行
                            fprintf(fd,'%d\n',temp_topologies(k,l));
                        else %%%%总体的最后一个元素
                            fprintf(fd,'%d\n',temp_topologies(k,l));
                        end
                    end
                end
            end
            fclose(fd);
        end
    end
                    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%% MACRO_DM 的写入数据 %%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
    %%%%%%%%%%%%%%% 读取数据 %%%%%%%%%%%%%%
% 	path = ['database/m' num2str(m) '/MACRO_DM/u_' num2str(u)];
%     %%% 读取C
%     path_C = [path '/C.mat'];
%     load(path_C);
%     %%% 读取T
%     path_T = [path '/T.mat'];
%     load(path_T);
%     %%% 读取D
%     path_D = [path '/D.mat'];
%     load(path_D);
% %     %%% 读取U      %%%%%暂时用不到
% %     path_U = [path '/U.mat'];
% %     load(path_U);
%     %%% 读取processors
%     path_processors = [path '/processors.mat'];
%     load(path_processors);
%     %%% 读取topologies
%     path_topologies = [path '/topologies.mat'];
%     load(path_topologies);
%     
    %%%%%%%%%%%%%%%开始转换%%%%%%%%%%%%%%%%%
    path = ['data/m' num2str(m) '/MACRO_DM/u_' num2str(u)];
    %%%%%%%%%% 写入C
    path_C = [path '/C'];
    mkdir(path_C);
    
    for i = 1:set_numb
        path_C_name = [path_C '/task_set_' num2str(i) '_C.txt'];
        fd = fopen(path_C_name,'w');
        for j = 1:task_numb %j是第几个任务
            temp_C = C{i,j};
            for k = 1:subtask_numb %k是任务j的第几个子任务
                if k ~= subtask_numb %不是某一任务的最后一个子任务
                    fprintf(fd,'%d ',temp_C(k));
                else if j ~= task_numb %是最后一个子任务，但不是任务集的最后一个任务
                        fprintf(fd,'%d\n',temp_C(k));
                    else
                        fprintf(fd,'%d\n',temp_C(k)); %最后一个任务集的最后一个
                    end
                end
            end
        end
        fclose(fd);
    end
    %%%%%%%%%% 写入T
    path_T = [path '/T'];
    mkdir(path_T);
    
    for i = 1:set_numb
        path_T_name = [path_T '/task_set_' num2str(i) '_T.txt'];
        fd = fopen(path_T_name,'w');
        for j = 1:task_numb %j是第几个任务
            if j ~= task_numb %不是最后一个任务
                fprintf(fd,'%d\n',T(i,j));
            else
                fprintf(fd,'%d\n',T(i,j));
            end
        end
        fclose(fd);
    end
        
     %%%%%%%%%% 写入D
    path_D = [path '/D'];
    mkdir(path_D);
    
    for i = 1:set_numb
        path_D_name = [path_D '/task_set_' num2str(i) '_D.txt'];
        fd = fopen(path_D_name,'w');
        for j = 1:task_numb %j是第几个任务
            if j ~= task_numb %不是最后一个任务
                fprintf(fd,'%d\n',D(i,j));
            else
                fprintf(fd,'%d\n',D(i,j));
            end
        end
        fclose(fd);
    end
    
    %%%%%%%%%% 写入processors
    path_processors = [path '/processors'];
    mkdir(path_processors);
    
    path_MA = ['database/m' num2str(m) '/MACRO_DM/u_' num2str(u)];
    path_processors_MA = [path_MA '/processors.mat'];
    tt = load(path_processors_MA);
    processors_MA = tt.processors;
    
    for i = 1:set_numb
        path_processors_name = [path_processors '/task_set_' num2str(i) '_processors.txt'];
        fd = fopen(path_processors_name,'w');
        for j = 1:task_numb %j是第几个任务
            temp_processors = processors_MA{i,j};
            for k = 1:subtask_numb %k是任务j的第几个子任务
                if k ~= subtask_numb %不是某一任务的最后一个子任务
                    fprintf(fd,'%d ',temp_processors(k));
                else if j ~= task_numb %是最后一个子任务，但不是任务集的最后一个任务
                        fprintf(fd,'%d\n',temp_processors(k));
                    else
                        fprintf(fd,'%d\n',temp_processors(k)); %最后一个任务集的最后一个
                    end
                end
            end
        end
        fclose(fd);
    end
    %%%%%%%%%% 写入topologies
       
    for i = 1:set_numb
        path_topologies = [path '/topologies/task_set_' num2str(i)];
        mkdir(path_topologies);
        for j = 1:task_numb %第i个任务集的第j个任务，其拓扑结构是一个 sub_numb * sub_numb 的矩阵 
            path_topologies_name = [path_topologies '/task_' num2str(j) '_topologies.txt'];
            temp_topologies = topologies{i,j};
            fd = fopen(path_topologies_name,'w');
            for k = 1:subtask_numb 
                for l = 1:subtask_numb
                    if l ~= subtask_numb %不是一行的最后一个元素，就加空格不换行
                        fprintf(fd,'%d ',temp_topologies(k,l));
                    else if k ~= subtask_numb %是一行的最后一个，但不是总体的最后一个，就换行
                            fprintf(fd,'%d\n',temp_topologies(k,l));
                        else %%%%总体的最后一个元素
                            fprintf(fd,'%d\n',temp_topologies(k,l));
                        end
                    end
                end
            end
            fclose(fd);
        end
    end
    
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%% dagP_DM 的写入数据 %%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
   
    %%%%%%%%%%%%%%%开始转换%%%%%%%%%%%%%%%%%
    path = ['data/m' num2str(m) '/dagP_DM/u_' num2str(u)];
    %%%%%%%%%% 写入C
    path_C = [path '/C'];
    mkdir(path_C);
    
    for i = 1:set_numb
        path_C_name = [path_C '/task_set_' num2str(i) '_C.txt'];
        fd = fopen(path_C_name,'w');
        for j = 1:task_numb %j是第几个任务
            temp_C = C{i,j};
            for k = 1:subtask_numb %k是任务j的第几个子任务
                if k ~= subtask_numb %不是某一任务的最后一个子任务
                    fprintf(fd,'%d ',temp_C(k));
                else if j ~= task_numb %是最后一个子任务，但不是任务集的最后一个任务
                        fprintf(fd,'%d\n',temp_C(k));
                    else
                        fprintf(fd,'%d\n',temp_C(k)); %最后一个任务集的最后一个
                    end
                end
            end
        end
        fclose(fd);
    end
    %%%%%%%%%% 写入T
    path_T = [path '/T'];
    mkdir(path_T);
    
    for i = 1:set_numb
        path_T_name = [path_T '/task_set_' num2str(i) '_T.txt'];
        fd = fopen(path_T_name,'w');
        for j = 1:task_numb %j是第几个任务
            if j ~= task_numb %不是最后一个任务
                fprintf(fd,'%d\n',T(i,j));
            else
                fprintf(fd,'%d\n',T(i,j));
            end
        end
        fclose(fd);
    end
        
     %%%%%%%%%% 写入D
    path_D = [path '/D'];
    mkdir(path_D);
    
    for i = 1:set_numb
        path_D_name = [path_D '/task_set_' num2str(i) '_D.txt'];
        fd = fopen(path_D_name,'w');
        for j = 1:task_numb %j是第几个任务
            if j ~= task_numb %不是最后一个任务
                fprintf(fd,'%d\n',D(i,j));
            else
                fprintf(fd,'%d\n',D(i,j));
            end
        end
        fclose(fd);
    end
    
    %%%%%%%%%% 写入processors
    path_processors = [path '/processors'];
    mkdir(path_processors);
    
    path_dagP = ['database/m' num2str(m) '/dagP_DM/u_' num2str(u)];
    path_processors_dagP = [path_dagP '/processors.mat'];
    tt = load(path_processors_dagP);
    processors_dagP = tt.processors;
    
    for i = 1:set_numb
        path_processors_name = [path_processors '/task_set_' num2str(i) '_processors.txt'];
        fd = fopen(path_processors_name,'w');
        for j = 1:task_numb %j是第几个任务
            temp_processors = processors_dagP{i,j};
            for k = 1:subtask_numb %k是任务j的第几个子任务
                if k ~= subtask_numb %不是某一任务的最后一个子任务
                    fprintf(fd,'%d ',temp_processors(k));
                else if j ~= task_numb %是最后一个子任务，但不是任务集的最后一个任务
                        fprintf(fd,'%d\n',temp_processors(k));
                    else
                        fprintf(fd,'%d\n',temp_processors(k)); %最后一个任务集的最后一个
                    end
                end
            end
        end
        fclose(fd);
    end
    %%%%%%%%%% 写入topologies
       
    for i = 1:set_numb
        path_topologies = [path '/topologies/task_set_' num2str(i)];
        mkdir(path_topologies);
        for j = 1:task_numb %第i个任务集的第j个任务，其拓扑结构是一个 sub_numb * sub_numb 的矩阵 
            path_topologies_name = [path_topologies '/task_' num2str(j) '_topologies.txt'];
            temp_topologies = topologies{i,j};
            fd = fopen(path_topologies_name,'w');
            for k = 1:subtask_numb 
                for l = 1:subtask_numb
                    if l ~= subtask_numb %不是一行的最后一个元素，就加空格不换行
                        fprintf(fd,'%d ',temp_topologies(k,l));
                    else if k ~= subtask_numb %是一行的最后一个，但不是总体的最后一个，就换行
                            fprintf(fd,'%d\n',temp_topologies(k,l));
                        else %%%%总体的最后一个元素
                            fprintf(fd,'%d\n',temp_topologies(k,l));
                        end
                    end
                end
            end
            fclose(fd);
        end
    end
    
    
    
end
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    