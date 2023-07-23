%�����������������񼯣�����mat���ݱ�����database�ļ�����
%ͨ���޸�m���ı��������񼯵Ĵ���������

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
    
    %%%%%������Ӧ�����ʵ��ļ���%%%%%%%
    mkdir(path_dir);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%% �������ݼ� %%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%����������
    [U,v] = randfixedsum(task_numb,set_numb,u,0,m);
    U = U'; % U��ʾ��ǰ�������£����б�ʾ��i�����񼯣��б�ʾĳһ���񼯵ĵ�j�������������
    %%%%%����C
    C = cell(set_numb,task_numb);
    for i = 1:set_numb
        for j = 1:task_numb
            C{i,j} = randi([1,100],1,subtask_numb);
        end
    end
    %%%%%����T
    T = zeros(set_numb,task_numb);
    for i = 1:set_numb
        for j = 1:task_numb
            T(i,j) = ceil(sum(C{i,j})/U(i,j));
        end
    end
    %%%%%����D
    D = T;
    %%%%%����topologies
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
    %%%%%����processors
    processors = cell(set_numb,task_numb);
    for i = 1:set_numb
        for j = 1:task_numb
            processors{i,j} = randi([1,m],1,subtask_numb);
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%% ����DM�������ȼ� %%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    for i = 1:set_numb
        for j = 1:task_numb-1
            for k = j+1:task_numb
                if D(i,k) < D(i,j)
                    %����U
                    temp_U = U(i,j);
                    U(i,j) = U(i,k);
                    U(i,k) = temp_U;
                    %����C
                    temp_C = C{i,j};
                    C{i,j} = C{i,k};
                    C{i,k} = temp_C;
                    %����T
                    temp_T = T(i,j);
                    T(i,j) = T(i,k);
                    T(i,k) = temp_T;
                    %����D
                    temp_D = D(i,j);
                    D(i,j) = D(i,k);
                    D(i,k) = temp_D;
                    %����topologies
                    temp_topologies = topologies{i,j};
                    topologies{i,j} = topologies{i,k};
                    topologies{i,k} = temp_topologies;
                    %����processors
                    temp_processors = processors{i,j};
                    processors{i,j} = processors{i,k};
                    processors{i,k} = temp_processors;
                end
            end
        end
    end
    
    %%%%%%%%%%%%����������%%%%%%%%%%%%%%%%%%%
    path_U = [path_dir '/U.mat'];
    save(path_U,'u');
    
    %%%%%%%%%%%����C %%%%%%%%%%%%%%%%%%%%%%%
    path_C = [path_dir '/C.mat'];
    save(path_C,'C');
    
    %%%%%%%%%%%%%%���� T %%%%%%%%%%%%%%%%%%%
    path_T = [path_dir '/T.mat'];
    save(path_T,'T');
    
    %%%%%%%%%%%%%%���� D %%%%%%%%%%%%%%%%%%%
    path_D = [path_dir '/D.mat'];
    save(path_D,'D');
    
    %%%%%%%%%%%%%%���� topologies %%%%%%%%%%%%%%%%%%%
    path_topologies = [path_dir '/topologies.mat'];
    save(path_topologies,'topologies');
                        
    %%%%%%%%%%%����processors %%%%%%%%%%%%%%%%%%%%%%%
    path_processors = [path_dir '/processors.mat'];
    save(path_processors,'processors'); 
    
    %%%%%%%%%%%% ����path %%%%%%%%%%%%%%%%%%%%%%%%%%
    path = cell(set_numb,task_numb); %�������񼯣�����ÿ�����񼯵�����ÿ��Ԫ�ض���һ��cell�����������������path
    for i = 1:set_numb
        for j = 1:task_numb
            path{i,j} =  find_path(topologies{i,j});
        end
    end
    path_path = [path_dir '/path.mat'];
    save(path_path,'path');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%% ��ʼ����dagP ���䴦���� %%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
%     %%%%%%%%%%%%%%%%%%%%%%%% ���ظ�������
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
    %%%%%%%%%%%%%%%%%%%%%%%% �������
    
    
    path_dir = 'database/dagP_DM/u_';
    path_dir = [path_dir num2str(u)];
    
    mkdir(path_dir);
    %%%%%%%%%%%%%% ���ȱ��治�������
    
     %%%%%%%%%%%%����������%%%%%%%%%%%%%%%%%%%
    path_U = [path_dir '/U.mat'];
    save(path_U,'u');
    
    %%%%%%%%%%%����C %%%%%%%%%%%%%%%%%%%%%%%
    path_C = [path_dir '/C.mat'];
    save(path_C,'C');
    
    %%%%%%%%%%%%%%���� T %%%%%%%%%%%%%%%%%%%
    path_T = [path_dir '/T.mat'];
    save(path_T,'T');
    
    %%%%%%%%%%%%%%���� D %%%%%%%%%%%%%%%%%%%
    path_D = [path_dir '/D.mat'];
    save(path_D,'D');
    
    %%%%%%%%%%%%%%���� topologies %%%%%%%%%%%%%%%%%%%
    path_topologies = [path_dir '/topologies.mat'];
    save(path_topologies,'topologies');
    
    %%%%%%%%%%%%%%���� path %%%%%%%%%%%%%%%%%%%
    path_path = [path_dir '/path.mat'];
    save(path_path,'path');
    
    
    
    %%%%%%%%%%%%%%%%%% Ȼ��ʼ����WF���䴦����
    for i = 1:set_numb
        for j = 1:task_numb%ÿ������10������
            temp_C = C{i,j};
            temp_topology = topologies{i,j};
            temp_processors = BL_EST(temp_C,temp_topology,m,subtask_numb);
            processors{i,j} = temp_processors;
        end
    end
    %%%%%%%%%%%%%%���� processors %%%%%%%%%%%%%%%%%%%
    path_processors = [path_dir '/processors.mat'];
    save(path_processors,'processors');
                
                
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%% ʹ��MACRO ���䴦���� %%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    path_dir = 'database/MACRO_DM/u_';
    path_dir = [path_dir num2str(u)];        
            
    mkdir(path_dir);
    %%%%%%%%%%%%%% ���ȱ��治�������
    
     %%%%%%%%%%%%����������%%%%%%%%%%%%%%%%%%%
    path_U = [path_dir '/U.mat'];
    save(path_U,'u');
    
    %%%%%%%%%%%����C %%%%%%%%%%%%%%%%%%%%%%%
    path_C = [path_dir '/C.mat'];
    save(path_C,'C');
    
    %%%%%%%%%%%%%%���� T %%%%%%%%%%%%%%%%%%%
    path_T = [path_dir '/T.mat'];
    save(path_T,'T');
    
    %%%%%%%%%%%%%%���� D %%%%%%%%%%%%%%%%%%%
    path_D = [path_dir '/D.mat'];
    save(path_D,'D');
    
    %%%%%%%%%%%%%%���� topologies %%%%%%%%%%%%%%%%%%%
    path_topologies = [path_dir '/topologies.mat'];
    save(path_topologies,'topologies');
    
    %%%%%%%%%%%%%%���� path %%%%%%%%%%%%%%%%%%%
    path_path = [path_dir '/path.mat'];
    save(path_path,'path');
    
    %%%%%%%%%%%%%%%%%% Ȼ��ʼ���� MACRO ���䴦����
    for i = 1:set_numb
        for j = 1:task_numb%ÿ������10������
            temp_C = C{i,j};
            temp_T = T(i,j);
            temp_topology = topologies{i,j};
            temp_processors = MACRO(temp_C,temp_T,temp_topology,m,subtask_numb);
            processors{i,j} = temp_processors;
        end
    end
    
    %%%%%%%%%%%%%%���� processors %%%%%%%%%%%%%%%%%%%
    path_processors = [path_dir '/processors.mat'];
    save(path_processors,'processors');
    
    
end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    