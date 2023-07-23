%本函数用于生成任务集，并将mat数据保存在database文件夹中
%通过修改m来改变生成任务集的处理器数量

clear all;
clc;

m = 8;
U_min = 1;
U_max = 4;
U_step = 0.5;
U_range = U_min:U_step:U_max;
set_numb = 1000;
task_numb = 10;
subtask_numb = 20;
p = 0.05;

mkdir database;

for u = U_range
    u
    path_dir = 'database/R_DM/u_';
    path_dir = [path_dir num2str(u)]; 
    
    %%%%%创建对应利用率的文件夹%%%%%%%
    mkdir(path_dir);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%% 生成数据集 %%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%生成利用率
    [U,v] = randfixedsum(task_numb,set_numb,u,0,m);
    U = U'; % U表示当前利用率下，的行表示第i个任务集，列表示某一任务集的第j个任务的利用率
    %%%%%生成C
    C = cell(set_numb,task_numb);
    for i = 1:set_numb
        for j = 1:task_numb
            C{i,j} = randi([1,100],1,subtask_numb);
        end
    end
    %%%%%生成T
    T = zeros(set_numb,task_numb);
    for i = 1:set_numb
        for j = 1:task_numb
            T(i,j) = ceil(sum(C{i,j})/U(i,j));
        end
    end
    %%%%%生成D
    D = T;
    %%%%%生成topologies
    topologies = cell(set_numb,task_numb);
    for i = 1:set_numb
        for j = 1:task_numb
            temp_topology = zeros(subtask_numb,subtask_numb);
            for k = 1:subtask_numb-1
                for l = k+1:subtask_numb
                    if rand() < p
                        temp_topology(k,l) = 1;
                    else
                        temp_topology(k,l) = 0;
                    end
                end
            end
            topologies{i,j} = temp_topology;
        end
    end
    %%%%%生成processors
    processors = cell(set_numb,task_numb);
    for i = 1:set_numb
        for j = 1:task_numb
            processors{i,j} = randi([1,m],1,subtask_numb);
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%% 根据DM排序优先级 %%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    for i = 1:set_numb
        for j = 1:task_numb-1
            for k = j+1:task_numb
                if D(i,k) < D(i,j)
                    %交换U
                    temp_U = U(i,j);
                    U(i,j) = U(i,k);
                    U(i,k) = temp_U;
                    %交换C
                    temp_C = C{i,j};
                    C{i,j} = C{i,k};
                    C{i,k} = temp_C;
                    %交换T
                    temp_T = T(i,j);
                    T(i,j) = T(i,k);
                    T(i,k) = temp_T;
                    %交换D
                    temp_D = D(i,j);
                    D(i,j) = D(i,k);
                    D(i,k) = temp_D;
                    %交换topologies
                    temp_topologies = topologies{i,j};
                    topologies{i,j} = topologies{i,k};
                    topologies{i,k} = temp_topologies;
                    %交换processors
                    temp_processors = processors{i,j};
                    processors{i,j} = processors{i,k};
                    processors{i,k} = temp_processors;
                end
            end
        end
    end
    
    %%%%%%%%%%%%保存利用率%%%%%%%%%%%%%%%%%%%
    path_U = [path_dir '/U.mat'];
    save(path_U,'u');
    
    %%%%%%%%%%%保存C %%%%%%%%%%%%%%%%%%%%%%%
    path_C = [path_dir '/C.mat'];
    save(path_C,'C');
    
    %%%%%%%%%%%%%%保存 T %%%%%%%%%%%%%%%%%%%
    path_T = [path_dir '/T.mat'];
    save(path_T,'T');
    
    %%%%%%%%%%%%%%保存 D %%%%%%%%%%%%%%%%%%%
    path_D = [path_dir '/D.mat'];
    save(path_D,'D');
    
    %%%%%%%%%%%%%%保存 topologies %%%%%%%%%%%%%%%%%%%
    path_topologies = [path_dir '/topologies.mat'];
    save(path_topologies,'topologies');
                        
    %%%%%%%%%%%保存processors %%%%%%%%%%%%%%%%%%%%%%%
    path_processors = [path_dir '/processors.mat'];
    save(path_processors,'processors'); 
    
    %%%%%%%%%%%% 保存path %%%%%%%%%%%%%%%%%%%%%%%%%%
    path = cell(set_numb,task_numb); %行是任务集，列是每个任务集的任务，每个元素都是一个cell，包含该任务的所有path
    for i = 1:set_numb
        for j = 1:task_numb
            path{i,j} =  find_path(topologies{i,j});
        end
    end
    path_path = [path_dir '/path.mat'];
    save(path_path,'path');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%% 开始进行dagP 分配处理器 %%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
%     %%%%%%%%%%%%%%%%%%%%%%%% 加载各项数据
%     load_dir = ['database/m' num2str(m) '/R_DM/u_' num2str(u)];
%     
%     load_C = [load_dir '/C.mat'];
%     load_D = [load_dir '/D.mat'];
%     load_path = [load_dir '/path.mat'];
%     load_processors = [load_dir '/processors.mat'];
%     load_T = [load_dir '/T.mat'];
%     load_topologies = [load_dir '/topologies.mat'];
%     load_U = [load_dir '/U.mat'];
%     
%     load(load_C);
%     load(load_D);
%     load(load_path);
%     load(load_processors);
%     load(load_T);
%     load(load_topologies);
%     load(load_U);
    %%%%%%%%%%%%%%%%%%%%%%%% 加载完毕
    
    
    path_dir = 'database/dagP_DM/u_';
    path_dir = [path_dir num2str(u)];
    
    mkdir(path_dir);
    %%%%%%%%%%%%%% 首先保存不变的数据
    
     %%%%%%%%%%%%保存利用率%%%%%%%%%%%%%%%%%%%
    path_U = [path_dir '/U.mat'];
    save(path_U,'u');
    
    %%%%%%%%%%%保存C %%%%%%%%%%%%%%%%%%%%%%%
    path_C = [path_dir '/C.mat'];
    save(path_C,'C');
    
    %%%%%%%%%%%%%%保存 T %%%%%%%%%%%%%%%%%%%
    path_T = [path_dir '/T.mat'];
    save(path_T,'T');
    
    %%%%%%%%%%%%%%保存 D %%%%%%%%%%%%%%%%%%%
    path_D = [path_dir '/D.mat'];
    save(path_D,'D');
    
    %%%%%%%%%%%%%%保存 topologies %%%%%%%%%%%%%%%%%%%
    path_topologies = [path_dir '/topologies.mat'];
    save(path_topologies,'topologies');
    
    %%%%%%%%%%%%%%保存 path %%%%%%%%%%%%%%%%%%%
    path_path = [path_dir '/path.mat'];
    save(path_path,'path');
    
    
    
    %%%%%%%%%%%%%%%%%% 然后开始依据WF分配处理器
    for i = 1:set_numb
        for j = 1:task_numb%每个任务集10个任务
            temp_C = C{i,j};
            temp_topology = topologies{i,j};
            temp_processors = BL_EST(temp_C,temp_topology,m,subtask_numb);
            processors{i,j} = temp_processors;
        end
    end
    %%%%%%%%%%%%%%保存 processors %%%%%%%%%%%%%%%%%%%
    path_processors = [path_dir '/processors.mat'];
    save(path_processors,'processors');
                
                
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%% 使用MACRO 分配处理器 %%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    path_dir = 'database/MACRO_DM/u_';
    path_dir = [path_dir num2str(u)];        
            
    mkdir(path_dir);
    %%%%%%%%%%%%%% 首先保存不变的数据
    
     %%%%%%%%%%%%保存利用率%%%%%%%%%%%%%%%%%%%
    path_U = [path_dir '/U.mat'];
    save(path_U,'u');
    
    %%%%%%%%%%%保存C %%%%%%%%%%%%%%%%%%%%%%%
    path_C = [path_dir '/C.mat'];
    save(path_C,'C');
    
    %%%%%%%%%%%%%%保存 T %%%%%%%%%%%%%%%%%%%
    path_T = [path_dir '/T.mat'];
    save(path_T,'T');
    
    %%%%%%%%%%%%%%保存 D %%%%%%%%%%%%%%%%%%%
    path_D = [path_dir '/D.mat'];
    save(path_D,'D');
    
    %%%%%%%%%%%%%%保存 topologies %%%%%%%%%%%%%%%%%%%
    path_topologies = [path_dir '/topologies.mat'];
    save(path_topologies,'topologies');
    
    %%%%%%%%%%%%%%保存 path %%%%%%%%%%%%%%%%%%%
    path_path = [path_dir '/path.mat'];
    save(path_path,'path');
    
    %%%%%%%%%%%%%%%%%% 然后开始依据 MACRO 分配处理器
    for i = 1:set_numb
        for j = 1:task_numb%每个任务集10个任务
            temp_C = C{i,j};
            temp_T = T(i,j);
            temp_topology = topologies{i,j};
            temp_processors = MACRO(temp_C,temp_T,temp_topology,m,subtask_numb);
            processors{i,j} = temp_processors;
        end
    end
    
    %%%%%%%%%%%%%%保存 processors %%%%%%%%%%%%%%%%%%%
    path_processors = [path_dir '/processors.mat'];
    save(path_processors,'processors');
    
    
end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    