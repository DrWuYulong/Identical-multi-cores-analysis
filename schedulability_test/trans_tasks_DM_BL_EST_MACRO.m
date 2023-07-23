function trans_tasks_DM_BL_EST_MACRO(U_min,U_max,U_step,set_numb,task_numb,subtask_numb,m)

for u = U_min:U_step:U_max%%%%%%%%%%读入对应的数据
%     m = 4;%处理器的数量
%     set_numb = 100;
%     task_numb = 10;
%     subtask_numb = 10;

    file_path = 'data_base-utilization_m-4_subTask-10/';
    file_name = [file_path num2str(u) '_C.mat'];
    load(file_name,'C');

    file_name = [file_path num2str(u) '_D.mat'];
    load(file_name,'D');

    file_name = [file_path num2str(u) '_T.mat'];
    load(file_name,'T');

    file_name = [file_path num2str(u) '_processors.mat'];
    load(file_name,'processors');
    
    file_name = [file_path num2str(u) '_topologies.mat'];
    load(file_name,'topologies');
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%% 根据拓扑结构分级并分配处理器%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    for i = 1:set_numb
        for j = 1:task_numb%每个任务集10个任务
            temp_C = C{i,j};
            temp_T = T(i,j);
            temp_topology = topologies{i}{j};
            temp_processors = MACRO(temp_C,temp_T,temp_topology,m,subtask_numb);
            processors{i}{j} = temp_processors;
        end
    end


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%% 按照D对优先级进行排序%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    
    for t1 = 1:set_numb%a个任务集
%         task_numb = length(C{t1});
        for t2 = 1:task_numb-1
            for t3 = t2+1:task_numb
                if D(t1,t3) < D(t1,t2)%升序排列
                    temp_C = C{t1,t3};%调换C
                    C{t1,t3} = C{t1,t2};
                    C{t1,t2} = temp_C;
                    temp_T = T(t1,t3);%调换T
                    T(t1,t3) = T(t1,t2);
                    T(t1,t2) = temp_T;
                    temp_D = D(t1,t3);%调换D
                    D(t1,t3) = D(t1,t2);
                    D(t1,t2) = temp_D;
                    temp_topologies = topologies{t1}{t3};%调换拓扑结构
                    topologies{t1}{t3} = topologies{t1}{t2};
                    topologies{t1}{t2} = temp_topologies;
                    temp_processors = processors{t1}{t3};%调换处理器分配
                    processors{t1}{t3} = processors{t1}{t2};
                    processors{t1}{t2} = temp_processors;
                end
            end
        end
    end
    
    %%%%%%%%%%%%%%%%从C开始%%%%%%%%%%%%%%%%%%


    file_path = ['database/DM_BL_E_M/u_' num2str(u) '/C/'];
    
    if exist(file_path,'dir') == 0
            mkdir(file_path);
    end
    

    for i = 1:set_numb
        %%%%%%%%%%%对应文件名，一个文件夹表示一个利用率；一个文件表示一个数据集，有sub_numb行（12行）
        file_name = [file_path 'task_set_' num2str(i) '_C.txt'];

        % 
        % 'r'打开要读取的文件。
        % 'w'打开或创建要写入的新文件。放弃现有内容（如果有）。
        % 'a'打开或创建要写入的新文件。追加数据到文件末尾。
        % 'r+'打开要读写的文件。
        % 'w+'打开或创建要读写的新文件。放弃现有内容（如果有）。
        % 'a+'打开或创建要读写的新文件。追加数据到文件末尾。
        % 'A'打开文件以追加（但不自动刷新）当前输出缓冲区。
        % 'W'打开文件以写入（但不自动刷新）当前输出缓冲区。
       
        fd = fopen(file_name,'w','n');
        for j = 1:task_numb
            temp_C = C{i,j};
            len_C = length(temp_C);
            for k = 1:len_C-1
                fprintf(fd,'%d ',temp_C(k));
            end
            if j ~= task_numb
                fprintf(fd,'%d\n',temp_C(len_C));
            else
                fprintf(fd,'%d\n',temp_C(len_C));
            end
        end

        fclose(fd);
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%读入数据 D %%%%%%%%%%%%%%%%%%%%
%     file_path = '../';
%     file_name = [file_path num2str(u) '_D.mat'];
%     load(file_name,'D');


%     set_numb = length(D);
    

    file_path = ['database/DM_BL_E_M/u_' num2str(u) '/D/'];
    
    if exist(file_path,'dir') == 0
            mkdir(file_path);
    end

    for i = 1:set_numb
        %%%%%%%%%%%对应文件名，一个文件夹表示一个利用率；一个文件表示一个数据集，有sub_numb行（12行）
        file_name = [file_path 'task_set_' num2str(i) '_D.txt'];

        % 
        % 'r'打开要读取的文件。
        % 'w'打开或创建要写入的新文件。放弃现有内容（如果有）。
        % 'a'打开或创建要写入的新文件。追加数据到文件末尾。
        % 'r+'打开要读写的文件。
        % 'w+'打开或创建要读写的新文件。放弃现有内容（如果有）。
        % 'a+'打开或创建要读写的新文件。追加数据到文件末尾。
        % 'A'打开文件以追加（但不自动刷新）当前输出缓冲区。
        % 'W'打开文件以写入（但不自动刷新）当前输出缓冲区。

        fd = fopen(file_name,'w','n');
        for j = 1:task_numb
            if j ~= task_numb
            	fprintf(fd,'%d\n',D(i,j));
            else
                fprintf(fd,'%d\n',D(i,j));
            end
        end
        fclose(fd);
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%读入数据T（等于数据D）%%%%%%%%%%%%%%%%%%%%
%     file_path = '../';
%     file_name = [file_path num2str(u) '_T.mat'];
%     load(file_name,'T');


%     set_numb = length(T);
    

    file_path = ['database/DM_BL_E_M/u_' num2str(u) '/T/'];
    
    if exist(file_path,'dir') == 0
            mkdir(file_path);
    end

    for i = 1:set_numb
        %%%%%%%%%%%对应文件名，一个文件夹表示一个利用率；一个文件表示一个数据集，有sub_numb行（12行）
        file_name = [file_path 'task_set_' num2str(i) '_T.txt'];

        % 
        % 'r'打开要读取的文件。
        % 'w'打开或创建要写入的新文件。放弃现有内容（如果有）。
        % 'a'打开或创建要写入的新文件。追加数据到文件末尾。
        % 'r+'打开要读写的文件。
        % 'w+'打开或创建要读写的新文件。放弃现有内容（如果有）。
        % 'a+'打开或创建要读写的新文件。追加数据到文件末尾。
        % 'A'打开文件以追加（但不自动刷新）当前输出缓冲区。
        % 'W'打开文件以写入（但不自动刷新）当前输出缓冲区。

        fd = fopen(file_name,'w','n');
        for j = 1:task_numb
            if j ~= task_numb
                fprintf(fd,'%d\n',T(i,j));
            else
                fprintf(fd,'%d\n',T(i,j));
            end
        end
        fclose(fd);
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%读入数据processors %%%%%%%%%%%%%%%%%%%%
%     file_path = '../';
%     file_name = [file_path num2str(u) '_processors.mat'];
%     load(file_name,'processors');


%     set_numb = length(processors);

    file_path = ['database/DM_BL_E_M/u_' num2str(u) '/processors/'];
    
    if exist(file_path,'dir') == 0
            mkdir(file_path);
    end

    for i = 1:set_numb
        %%%%%%%%%%%对应文件名，一个文件夹表示一个利用率；一个文件表示一个数据集，有sub_numb行（12行）
        file_name = [file_path 'task_set_' num2str(i) '_processors.txt'];

        % 
        % 'r'打开要读取的文件。
        % 'w'打开或创建要写入的新文件。放弃现有内容（如果有）。
        % 'a'打开或创建要写入的新文件。追加数据到文件末尾。
        % 'r+'打开要读写的文件。
        % 'w+'打开或创建要读写的新文件。放弃现有内容（如果有）。
        % 'a+'打开或创建要读写的新文件。追加数据到文件末尾。
        % 'A'打开文件以追加（但不自动刷新）当前输出缓冲区。
        % 'W'打开文件以写入（但不自动刷新）当前输出缓冲区。
        
        fd = fopen(file_name,'w','n');
        for j = 1:task_numb
            temp_processors = processors{i}{j};
            len_processors = length(temp_processors);
            for k = 1:len_processors-1
                fprintf(fd,'%d ',temp_processors(k));
            end
            if j ~= task_numb
                fprintf(fd,'%d\n',temp_processors(len_processors));
            else
                fprintf(fd,'%d\n',temp_processors(len_processors));
            end
        end

        fclose(fd);
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%读入数据topologies %%%%%%%%%%%%%%%%%%%%
%     file_path = '../';
%     file_name = [file_path num2str(u) '_topologies.mat'];
%     load(file_name,'topologies');


%     set_numb = length(topologies);

    file_path = ['database/DM_BL_E_M/u_' num2str(u) '/topologies/'];
    
    if exist(file_path,'dir') == 0
            mkdir(file_path);% file_path =  'topologies/u_0.25/'
    end
 

    for i = 1:set_numb
        %%%%%%%%%%%每个任务集再创建一个文件夹
        file_path_task_set = [file_path 'task_set_' num2str(i) '/'];
        
        if exist(file_path_task_set,'dir') == 0
            mkdir(file_path_task_set);
        end
        
%         file_name = [file_path 'task_set_' num2str(i) '_processors.txt'];

        % 
        % 'r'打开要读取的文件。
        % 'w'打开或创建要写入的新文件。放弃现有内容（如果有）。
        % 'a'打开或创建要写入的新文件。追加数据到文件末尾。
        % 'r+'打开要读写的文件。
        % 'w+'打开或创建要读写的新文件。放弃现有内容（如果有）。
        % 'a+'打开或创建要读写的新文件。追加数据到文件末尾。
        % 'A'打开文件以追加（但不自动刷新）当前输出缓冲区。
        % 'W'打开文件以写入（但不自动刷新）当前输出缓冲区  
        
        %%%%%%任务集i中有多少个任务
%         task_numb = 10;
%         fd = fopen(file_name,'w','n');
        for j = 1:task_numb
            file_name = [file_path_task_set 'task_' num2str(j) '_topologies.txt'];
            fd = fopen(file_name,'w','n');
            temp_topologies = topologies{i}{j};
            len_topologies = length(temp_topologies);
            for k = 1:len_topologies
                for l = 1:len_topologies-1                    
                    fprintf(fd,'%d ',temp_topologies(k,l));
                end
                if k ~= len_topologies
                    fprintf(fd,'%d\n',temp_topologies(k,len_topologies));
                else
                    fprintf(fd,'%d\n',temp_topologies(k,len_topologies));
                end
            end
            fclose(fd);
%             fprintf(fd,'%d\n',temp_processors(len_processors));
        end

        
    end
    


end
end

