function trans_tasks_DM_BL_EST_MACRO(U_min,U_max,U_step,set_numb,task_numb,subtask_numb,m)

for u = U_min:U_step:U_max%%%%%%%%%%�����Ӧ������
%     m = 4;%������������
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
    %%%%%%%%%%%%% �������˽ṹ�ּ������䴦����%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    for i = 1:set_numb
        for j = 1:task_numb%ÿ������10������
            temp_C = C{i,j};
            temp_T = T(i,j);
            temp_topology = topologies{i}{j};
            temp_processors = MACRO(temp_C,temp_T,temp_topology,m,subtask_numb);
            processors{i}{j} = temp_processors;
        end
    end


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%% ����D�����ȼ���������%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    
    for t1 = 1:set_numb%a������
%         task_numb = length(C{t1});
        for t2 = 1:task_numb-1
            for t3 = t2+1:task_numb
                if D(t1,t3) < D(t1,t2)%��������
                    temp_C = C{t1,t3};%����C
                    C{t1,t3} = C{t1,t2};
                    C{t1,t2} = temp_C;
                    temp_T = T(t1,t3);%����T
                    T(t1,t3) = T(t1,t2);
                    T(t1,t2) = temp_T;
                    temp_D = D(t1,t3);%����D
                    D(t1,t3) = D(t1,t2);
                    D(t1,t2) = temp_D;
                    temp_topologies = topologies{t1}{t3};%�������˽ṹ
                    topologies{t1}{t3} = topologies{t1}{t2};
                    topologies{t1}{t2} = temp_topologies;
                    temp_processors = processors{t1}{t3};%��������������
                    processors{t1}{t3} = processors{t1}{t2};
                    processors{t1}{t2} = temp_processors;
                end
            end
        end
    end
    
    %%%%%%%%%%%%%%%%��C��ʼ%%%%%%%%%%%%%%%%%%


    file_path = ['database/DM_BL_E_M/u_' num2str(u) '/C/'];
    
    if exist(file_path,'dir') == 0
            mkdir(file_path);
    end
    

    for i = 1:set_numb
        %%%%%%%%%%%��Ӧ�ļ�����һ���ļ��б�ʾһ�������ʣ�һ���ļ���ʾһ�����ݼ�����sub_numb�У�12�У�
        file_name = [file_path 'task_set_' num2str(i) '_C.txt'];

        % 
        % 'r'��Ҫ��ȡ���ļ���
        % 'w'�򿪻򴴽�Ҫд������ļ��������������ݣ�����У���
        % 'a'�򿪻򴴽�Ҫд������ļ���׷�����ݵ��ļ�ĩβ��
        % 'r+'��Ҫ��д���ļ���
        % 'w+'�򿪻򴴽�Ҫ��д�����ļ��������������ݣ�����У���
        % 'a+'�򿪻򴴽�Ҫ��д�����ļ���׷�����ݵ��ļ�ĩβ��
        % 'A'���ļ���׷�ӣ������Զ�ˢ�£���ǰ�����������
        % 'W'���ļ���д�루�����Զ�ˢ�£���ǰ�����������
       
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%�������� D %%%%%%%%%%%%%%%%%%%%
%     file_path = '../';
%     file_name = [file_path num2str(u) '_D.mat'];
%     load(file_name,'D');


%     set_numb = length(D);
    

    file_path = ['database/DM_BL_E_M/u_' num2str(u) '/D/'];
    
    if exist(file_path,'dir') == 0
            mkdir(file_path);
    end

    for i = 1:set_numb
        %%%%%%%%%%%��Ӧ�ļ�����һ���ļ��б�ʾһ�������ʣ�һ���ļ���ʾһ�����ݼ�����sub_numb�У�12�У�
        file_name = [file_path 'task_set_' num2str(i) '_D.txt'];

        % 
        % 'r'��Ҫ��ȡ���ļ���
        % 'w'�򿪻򴴽�Ҫд������ļ��������������ݣ�����У���
        % 'a'�򿪻򴴽�Ҫд������ļ���׷�����ݵ��ļ�ĩβ��
        % 'r+'��Ҫ��д���ļ���
        % 'w+'�򿪻򴴽�Ҫ��д�����ļ��������������ݣ�����У���
        % 'a+'�򿪻򴴽�Ҫ��д�����ļ���׷�����ݵ��ļ�ĩβ��
        % 'A'���ļ���׷�ӣ������Զ�ˢ�£���ǰ�����������
        % 'W'���ļ���д�루�����Զ�ˢ�£���ǰ�����������

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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%��������T����������D��%%%%%%%%%%%%%%%%%%%%
%     file_path = '../';
%     file_name = [file_path num2str(u) '_T.mat'];
%     load(file_name,'T');


%     set_numb = length(T);
    

    file_path = ['database/DM_BL_E_M/u_' num2str(u) '/T/'];
    
    if exist(file_path,'dir') == 0
            mkdir(file_path);
    end

    for i = 1:set_numb
        %%%%%%%%%%%��Ӧ�ļ�����һ���ļ��б�ʾһ�������ʣ�һ���ļ���ʾһ�����ݼ�����sub_numb�У�12�У�
        file_name = [file_path 'task_set_' num2str(i) '_T.txt'];

        % 
        % 'r'��Ҫ��ȡ���ļ���
        % 'w'�򿪻򴴽�Ҫд������ļ��������������ݣ�����У���
        % 'a'�򿪻򴴽�Ҫд������ļ���׷�����ݵ��ļ�ĩβ��
        % 'r+'��Ҫ��д���ļ���
        % 'w+'�򿪻򴴽�Ҫ��д�����ļ��������������ݣ�����У���
        % 'a+'�򿪻򴴽�Ҫ��д�����ļ���׷�����ݵ��ļ�ĩβ��
        % 'A'���ļ���׷�ӣ������Զ�ˢ�£���ǰ�����������
        % 'W'���ļ���д�루�����Զ�ˢ�£���ǰ�����������

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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%��������processors %%%%%%%%%%%%%%%%%%%%
%     file_path = '../';
%     file_name = [file_path num2str(u) '_processors.mat'];
%     load(file_name,'processors');


%     set_numb = length(processors);

    file_path = ['database/DM_BL_E_M/u_' num2str(u) '/processors/'];
    
    if exist(file_path,'dir') == 0
            mkdir(file_path);
    end

    for i = 1:set_numb
        %%%%%%%%%%%��Ӧ�ļ�����һ���ļ��б�ʾһ�������ʣ�һ���ļ���ʾһ�����ݼ�����sub_numb�У�12�У�
        file_name = [file_path 'task_set_' num2str(i) '_processors.txt'];

        % 
        % 'r'��Ҫ��ȡ���ļ���
        % 'w'�򿪻򴴽�Ҫд������ļ��������������ݣ�����У���
        % 'a'�򿪻򴴽�Ҫд������ļ���׷�����ݵ��ļ�ĩβ��
        % 'r+'��Ҫ��д���ļ���
        % 'w+'�򿪻򴴽�Ҫ��д�����ļ��������������ݣ�����У���
        % 'a+'�򿪻򴴽�Ҫ��д�����ļ���׷�����ݵ��ļ�ĩβ��
        % 'A'���ļ���׷�ӣ������Զ�ˢ�£���ǰ�����������
        % 'W'���ļ���д�루�����Զ�ˢ�£���ǰ�����������
        
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%��������topologies %%%%%%%%%%%%%%%%%%%%
%     file_path = '../';
%     file_name = [file_path num2str(u) '_topologies.mat'];
%     load(file_name,'topologies');


%     set_numb = length(topologies);

    file_path = ['database/DM_BL_E_M/u_' num2str(u) '/topologies/'];
    
    if exist(file_path,'dir') == 0
            mkdir(file_path);% file_path =  'topologies/u_0.25/'
    end
 

    for i = 1:set_numb
        %%%%%%%%%%%ÿ�������ٴ���һ���ļ���
        file_path_task_set = [file_path 'task_set_' num2str(i) '/'];
        
        if exist(file_path_task_set,'dir') == 0
            mkdir(file_path_task_set);
        end
        
%         file_name = [file_path 'task_set_' num2str(i) '_processors.txt'];

        % 
        % 'r'��Ҫ��ȡ���ļ���
        % 'w'�򿪻򴴽�Ҫд������ļ��������������ݣ�����У���
        % 'a'�򿪻򴴽�Ҫд������ļ���׷�����ݵ��ļ�ĩβ��
        % 'r+'��Ҫ��д���ļ���
        % 'w+'�򿪻򴴽�Ҫ��д�����ļ��������������ݣ�����У���
        % 'a+'�򿪻򴴽�Ҫ��д�����ļ���׷�����ݵ��ļ�ĩβ��
        % 'A'���ļ���׷�ӣ������Զ�ˢ�£���ǰ�����������
        % 'W'���ļ���д�루�����Զ�ˢ�£���ǰ���������  
        
        %%%%%%����i���ж��ٸ�����
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

