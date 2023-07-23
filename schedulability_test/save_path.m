clear all;
clc;

m = 4;
U_min = 0.4;
U_max = m;
U_step = 0.2;
U_range = U_min:U_step:U_max;
set_numb = 1000;
task_numb = 10;
subtask_numb = 10;
p = 0.2;

%%%%%%% ����������������������ȼ�ѡ��DM��ʽ

path_dir = 'database/m4/R_DM/u_';
for u = U_range
    path_name = [path_dir num2str(u) '/topologies.mat'];
    load(path_name);
    
    path = cell(set_numb,task_numb); %�������񼯣�����ÿ�����񼯵�����ÿ��Ԫ�ض���һ��cell�����������������path
    for i = 1:set_numb
        for j = 1:task_numb
            path{i,j} =  find_path(topologies{i,j});
        end
    end
    
    %��ǰ�������µ�path��������ϣ����ڿ�ʼ����
    save_path_dir = [path_dir num2str(u) '/path.mat'];
    save(save_path_dir,'path');
end
    
    
    
%%%%% ����������ѡ��WF���������ȼ�ѡ��DM��ʽ
path_dir = 'database/m4/WF_DM/u_';
for u = U_range
    path_name = [path_dir num2str(u) '/topologies.mat'];
    load(path_name);
    
    path = cell(set_numb,task_numb); %�������񼯣�����ÿ�����񼯵�����ÿ��Ԫ�ض���һ��cell�����������������path
    for i = 1:set_numb
        for j = 1:task_numb
            path{i,j} =  find_path(topologies{i,j});
        end
    end
    
    %��ǰ�������µ�path��������ϣ����ڿ�ʼ����
    save_path_dir = [path_dir num2str(u) '/path.mat'];
    save(save_path_dir,'path');
end
    
    
    
    
    
    
    
    
    
    
    
    
    
    