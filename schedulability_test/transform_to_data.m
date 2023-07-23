%���������������ɵ�database�е�mat����ת���ɿ�����ʵ����϶�ȡ��ִ�е�txt�ļ�
%�����ļ�������data�ļ����У�ͬ���޸�m�ı䴦����������
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
    %%%%%%%%%%%%%% R_DM ��д������ %%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    u
    
    %%%%%%%%%%%%%%% ��ȡ���� %%%%%%%%%%%%%%
	path = ['database/m' num2str(m) '/R_DM/u_' num2str(u)];
    %%% ��ȡC
    path_C = [path '/C.mat'];
    load(path_C);
    %%% ��ȡT
    path_T = [path '/T.mat'];
    load(path_T);
    %%% ��ȡD
    path_D = [path '/D.mat'];
    load(path_D);
%     %%% ��ȡU      %%%%%��ʱ�ò���
%     path_U = [path '/U.mat'];
%     load(path_U);
    %%% ��ȡprocessors
    path_processors = [path '/processors.mat'];
    load(path_processors);
    %%% ��ȡtopologies
    path_topologies = [path '/topologies.mat'];
    load(path_topologies);
    
%     %%%%%%%%%%%%%%%��ʼת��%%%%%%%%%%%%%%%%%
    path = ['data/m' num2str(m) '/R_DM/u_' num2str(u)];
    %%%%%%%%%% д��C
    path_C = [path '/C'];
    mkdir(path_C);
    
    for i = 1:set_numb
        path_C_name = [path_C '/task_set_' num2str(i) '_C.txt'];
        fd = fopen(path_C_name,'w');
        for j = 1:task_numb %j�ǵڼ�������
            temp_C = C{i,j};
            for k = 1:subtask_numb %k������j�ĵڼ���������
                if k ~= subtask_numb %����ĳһ��������һ��������
                    fprintf(fd,'%d ',temp_C(k));
                else if j ~= task_numb %�����һ�������񣬵��������񼯵����һ������
                        fprintf(fd,'%d\n',temp_C(k));
                    else
                        fprintf(fd,'%d\n',temp_C(k)); %���һ�����񼯵����һ��
                    end
                end
            end
        end
        fclose(fd);
    end
    %%%%%%%%%% д��T
    path_T = [path '/T'];
    mkdir(path_T);
    
    for i = 1:set_numb
        path_T_name = [path_T '/task_set_' num2str(i) '_T.txt'];
        fd = fopen(path_T_name,'w');
        for j = 1:task_numb %j�ǵڼ�������
            if j ~= task_numb %�������һ������
                fprintf(fd,'%d\n',T(i,j));
            else
                fprintf(fd,'%d\n',T(i,j));
            end
        end
        fclose(fd);
    end
        
     %%%%%%%%%% д��D
    path_D = [path '/D'];
    mkdir(path_D);
    
    for i = 1:set_numb
        path_D_name = [path_D '/task_set_' num2str(i) '_D.txt'];
        fd = fopen(path_D_name,'w');
        for j = 1:task_numb %j�ǵڼ�������
            if j ~= task_numb %�������һ������
                fprintf(fd,'%d\n',D(i,j));
            else
                fprintf(fd,'%d\n',D(i,j));
            end
        end
        fclose(fd);
    end
    
    %%%%%%%%%% д��processors
    path_processors = [path '/processors'];
    mkdir(path_processors);
    
    for i = 1:set_numb
        path_processors_name = [path_processors '/task_set_' num2str(i) '_processors.txt'];
        fd = fopen(path_processors_name,'w');
        for j = 1:task_numb %j�ǵڼ�������
            temp_processors = processors{i,j};
            for k = 1:subtask_numb %k������j�ĵڼ���������
                if k ~= subtask_numb %����ĳһ��������һ��������
                    fprintf(fd,'%d ',temp_processors(k));
                else if j ~= task_numb %�����һ�������񣬵��������񼯵����һ������
                        fprintf(fd,'%d\n',temp_processors(k));
                    else
                        fprintf(fd,'%d\n',temp_processors(k)); %���һ�����񼯵����һ��
                    end
                end
            end
        end
        fclose(fd);
    end
    %%%%%%%%%% д��topologies
       
    for i = 1:set_numb
        path_topologies = [path '/topologies/task_set_' num2str(i)];
        mkdir(path_topologies);
        for j = 1:task_numb %��i�����񼯵ĵ�j�����������˽ṹ��һ�� sub_numb * sub_numb �ľ��� 
            path_topologies_name = [path_topologies '/task_' num2str(j) '_topologies.txt'];
            temp_topologies = topologies{i,j};
            fd = fopen(path_topologies_name,'w');
            for k = 1:subtask_numb 
                for l = 1:subtask_numb
                    if l ~= subtask_numb %����һ�е����һ��Ԫ�أ��ͼӿո񲻻���
                        fprintf(fd,'%d ',temp_topologies(k,l));
                    else if k ~= subtask_numb %��һ�е����һ������������������һ�����ͻ���
                            fprintf(fd,'%d\n',temp_topologies(k,l));
                        else %%%%��������һ��Ԫ��
                            fprintf(fd,'%d\n',temp_topologies(k,l));
                        end
                    end
                end
            end
            fclose(fd);
        end
    end
                    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%% MACRO_DM ��д������ %%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
    %%%%%%%%%%%%%%% ��ȡ���� %%%%%%%%%%%%%%
% 	path = ['database/m' num2str(m) '/MACRO_DM/u_' num2str(u)];
%     %%% ��ȡC
%     path_C = [path '/C.mat'];
%     load(path_C);
%     %%% ��ȡT
%     path_T = [path '/T.mat'];
%     load(path_T);
%     %%% ��ȡD
%     path_D = [path '/D.mat'];
%     load(path_D);
% %     %%% ��ȡU      %%%%%��ʱ�ò���
% %     path_U = [path '/U.mat'];
% %     load(path_U);
%     %%% ��ȡprocessors
%     path_processors = [path '/processors.mat'];
%     load(path_processors);
%     %%% ��ȡtopologies
%     path_topologies = [path '/topologies.mat'];
%     load(path_topologies);
%     
    %%%%%%%%%%%%%%%��ʼת��%%%%%%%%%%%%%%%%%
    path = ['data/m' num2str(m) '/MACRO_DM/u_' num2str(u)];
    %%%%%%%%%% д��C
    path_C = [path '/C'];
    mkdir(path_C);
    
    for i = 1:set_numb
        path_C_name = [path_C '/task_set_' num2str(i) '_C.txt'];
        fd = fopen(path_C_name,'w');
        for j = 1:task_numb %j�ǵڼ�������
            temp_C = C{i,j};
            for k = 1:subtask_numb %k������j�ĵڼ���������
                if k ~= subtask_numb %����ĳһ��������һ��������
                    fprintf(fd,'%d ',temp_C(k));
                else if j ~= task_numb %�����һ�������񣬵��������񼯵����һ������
                        fprintf(fd,'%d\n',temp_C(k));
                    else
                        fprintf(fd,'%d\n',temp_C(k)); %���һ�����񼯵����һ��
                    end
                end
            end
        end
        fclose(fd);
    end
    %%%%%%%%%% д��T
    path_T = [path '/T'];
    mkdir(path_T);
    
    for i = 1:set_numb
        path_T_name = [path_T '/task_set_' num2str(i) '_T.txt'];
        fd = fopen(path_T_name,'w');
        for j = 1:task_numb %j�ǵڼ�������
            if j ~= task_numb %�������һ������
                fprintf(fd,'%d\n',T(i,j));
            else
                fprintf(fd,'%d\n',T(i,j));
            end
        end
        fclose(fd);
    end
        
     %%%%%%%%%% д��D
    path_D = [path '/D'];
    mkdir(path_D);
    
    for i = 1:set_numb
        path_D_name = [path_D '/task_set_' num2str(i) '_D.txt'];
        fd = fopen(path_D_name,'w');
        for j = 1:task_numb %j�ǵڼ�������
            if j ~= task_numb %�������һ������
                fprintf(fd,'%d\n',D(i,j));
            else
                fprintf(fd,'%d\n',D(i,j));
            end
        end
        fclose(fd);
    end
    
    %%%%%%%%%% д��processors
    path_processors = [path '/processors'];
    mkdir(path_processors);
    
    path_MA = ['database/m' num2str(m) '/MACRO_DM/u_' num2str(u)];
    path_processors_MA = [path_MA '/processors.mat'];
    tt = load(path_processors_MA);
    processors_MA = tt.processors;
    
    for i = 1:set_numb
        path_processors_name = [path_processors '/task_set_' num2str(i) '_processors.txt'];
        fd = fopen(path_processors_name,'w');
        for j = 1:task_numb %j�ǵڼ�������
            temp_processors = processors_MA{i,j};
            for k = 1:subtask_numb %k������j�ĵڼ���������
                if k ~= subtask_numb %����ĳһ��������һ��������
                    fprintf(fd,'%d ',temp_processors(k));
                else if j ~= task_numb %�����һ�������񣬵��������񼯵����һ������
                        fprintf(fd,'%d\n',temp_processors(k));
                    else
                        fprintf(fd,'%d\n',temp_processors(k)); %���һ�����񼯵����һ��
                    end
                end
            end
        end
        fclose(fd);
    end
    %%%%%%%%%% д��topologies
       
    for i = 1:set_numb
        path_topologies = [path '/topologies/task_set_' num2str(i)];
        mkdir(path_topologies);
        for j = 1:task_numb %��i�����񼯵ĵ�j�����������˽ṹ��һ�� sub_numb * sub_numb �ľ��� 
            path_topologies_name = [path_topologies '/task_' num2str(j) '_topologies.txt'];
            temp_topologies = topologies{i,j};
            fd = fopen(path_topologies_name,'w');
            for k = 1:subtask_numb 
                for l = 1:subtask_numb
                    if l ~= subtask_numb %����һ�е����һ��Ԫ�أ��ͼӿո񲻻���
                        fprintf(fd,'%d ',temp_topologies(k,l));
                    else if k ~= subtask_numb %��һ�е����һ������������������һ�����ͻ���
                            fprintf(fd,'%d\n',temp_topologies(k,l));
                        else %%%%��������һ��Ԫ��
                            fprintf(fd,'%d\n',temp_topologies(k,l));
                        end
                    end
                end
            end
            fclose(fd);
        end
    end
    
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%% dagP_DM ��д������ %%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
   
    %%%%%%%%%%%%%%%��ʼת��%%%%%%%%%%%%%%%%%
    path = ['data/m' num2str(m) '/dagP_DM/u_' num2str(u)];
    %%%%%%%%%% д��C
    path_C = [path '/C'];
    mkdir(path_C);
    
    for i = 1:set_numb
        path_C_name = [path_C '/task_set_' num2str(i) '_C.txt'];
        fd = fopen(path_C_name,'w');
        for j = 1:task_numb %j�ǵڼ�������
            temp_C = C{i,j};
            for k = 1:subtask_numb %k������j�ĵڼ���������
                if k ~= subtask_numb %����ĳһ��������һ��������
                    fprintf(fd,'%d ',temp_C(k));
                else if j ~= task_numb %�����һ�������񣬵��������񼯵����һ������
                        fprintf(fd,'%d\n',temp_C(k));
                    else
                        fprintf(fd,'%d\n',temp_C(k)); %���һ�����񼯵����һ��
                    end
                end
            end
        end
        fclose(fd);
    end
    %%%%%%%%%% д��T
    path_T = [path '/T'];
    mkdir(path_T);
    
    for i = 1:set_numb
        path_T_name = [path_T '/task_set_' num2str(i) '_T.txt'];
        fd = fopen(path_T_name,'w');
        for j = 1:task_numb %j�ǵڼ�������
            if j ~= task_numb %�������һ������
                fprintf(fd,'%d\n',T(i,j));
            else
                fprintf(fd,'%d\n',T(i,j));
            end
        end
        fclose(fd);
    end
        
     %%%%%%%%%% д��D
    path_D = [path '/D'];
    mkdir(path_D);
    
    for i = 1:set_numb
        path_D_name = [path_D '/task_set_' num2str(i) '_D.txt'];
        fd = fopen(path_D_name,'w');
        for j = 1:task_numb %j�ǵڼ�������
            if j ~= task_numb %�������һ������
                fprintf(fd,'%d\n',D(i,j));
            else
                fprintf(fd,'%d\n',D(i,j));
            end
        end
        fclose(fd);
    end
    
    %%%%%%%%%% д��processors
    path_processors = [path '/processors'];
    mkdir(path_processors);
    
    path_dagP = ['database/m' num2str(m) '/dagP_DM/u_' num2str(u)];
    path_processors_dagP = [path_dagP '/processors.mat'];
    tt = load(path_processors_dagP);
    processors_dagP = tt.processors;
    
    for i = 1:set_numb
        path_processors_name = [path_processors '/task_set_' num2str(i) '_processors.txt'];
        fd = fopen(path_processors_name,'w');
        for j = 1:task_numb %j�ǵڼ�������
            temp_processors = processors_dagP{i,j};
            for k = 1:subtask_numb %k������j�ĵڼ���������
                if k ~= subtask_numb %����ĳһ��������һ��������
                    fprintf(fd,'%d ',temp_processors(k));
                else if j ~= task_numb %�����һ�������񣬵��������񼯵����һ������
                        fprintf(fd,'%d\n',temp_processors(k));
                    else
                        fprintf(fd,'%d\n',temp_processors(k)); %���һ�����񼯵����һ��
                    end
                end
            end
        end
        fclose(fd);
    end
    %%%%%%%%%% д��topologies
       
    for i = 1:set_numb
        path_topologies = [path '/topologies/task_set_' num2str(i)];
        mkdir(path_topologies);
        for j = 1:task_numb %��i�����񼯵ĵ�j�����������˽ṹ��һ�� sub_numb * sub_numb �ľ��� 
            path_topologies_name = [path_topologies '/task_' num2str(j) '_topologies.txt'];
            temp_topologies = topologies{i,j};
            fd = fopen(path_topologies_name,'w');
            for k = 1:subtask_numb 
                for l = 1:subtask_numb
                    if l ~= subtask_numb %����һ�е����һ��Ԫ�أ��ͼӿո񲻻���
                        fprintf(fd,'%d ',temp_topologies(k,l));
                    else if k ~= subtask_numb %��һ�е����һ������������������һ�����ͻ���
                            fprintf(fd,'%d\n',temp_topologies(k,l));
                        else %%%%��������һ��Ԫ��
                            fprintf(fd,'%d\n',temp_topologies(k,l));
                        end
                    end
                end
            end
            fclose(fd);
        end
    end
    
    
    
end
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    