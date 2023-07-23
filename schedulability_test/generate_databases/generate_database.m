%�����������������Ҫ����û��׼������0~1֮��
function generate_database
    U_min = 0.1;
    U_max = 0.6;
    U_step = 0.02;
    a = 1000;% a      ����ȷ��ÿ�����������ж��ٸ�������ƽ��ʵ��
    m = 8;%   m   ����������
    numb_v = 12;% numb_v ÿ��DAG���������������
    C_min = 1;%ÿ��������c�������Χ
    C_max = 10;
    k_min = 10;%ÿ����������/DDL ���������C�ı�����10~20��֤��ÿ�����񼯵���������Χ10~20��
    k_max = 20;
    p = 0.2;%��ӱߵĸ���
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%��׼��������%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    
    % topologies = generate_topologies(a,b,numb_v,0.85);%%%%%���˽ṹ
    for u = U_min:U_step:U_max
        C = cell(a,1);%C �� T Ҫ��Ӧ���˽ṹ����Ϊ�������������ģ�ͣ����Բ�����ǰ����ռ�
        T = cell(a,1);
        U = cell(a,1); 
        D = cell(a,1);
        processors = cell(a,1);
        topologies = cell(a,1);%�������˽ṹ
        path = cell(a,1);
        
        for i = 1:a
            U_remain = u;
            j = 1;%��������ÿ�������ж��ٸ�����
            while U_remain > 0
                topologies{i}{j} =generate_topologies(numb_v,p);
                C{i}{j} = randi([C_min,C_max],1,numb_v);%ÿ���������Ӧ�ļ���ʱ��
                processors{i}{j} = randi(m,[1,numb_v]);
                %%%%%%%%%%%%%�����Ӧ��������C���ܺ�%%%%%%%%%%%%%%%%
                temp_C = C{i}{j};
                temp_p = processors{i}{j};
                C_mean = 0;
                for k1 = 1:m
                    if temp_p == k1
                        C_mean = max(C_mean, sum(temp_C(temp_p == k1)));
                    end
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                C_mean = C_mean / m;
                path{i}{j} = find_path(topologies{i}{j});
                longest_len = find_longest_len(path{i}{j},C{i}{j});
%                 [longest_len,index] = find_longest_len(path,C{i}{j});
                C_effective = max(C_mean,longest_len);
                T{i}{j} = ceil(C_effective * randi([k_min,k_max]) / u);
                D{i}{j} = T{i}{j};
                U{i}{j} = C_effective / T{i}{j};
                U_remain = U_remain - U{i}{j};
                j = j + 1;                
            end
        end
        file_path = 'data_base\utilization_m-8_subTask-12\';
        if exist(file_path,'dir') == 0
            mkdir(file_path);
        end
        filename = [file_path num2str(u) '_C.mat'];
        save(filename,'C');
        filename = [file_path num2str(u) '_T.mat'];
        save(filename,'T');
        filename = [file_path num2str(u) '_D.mat'];
        save(filename,'D');
        filename = [file_path num2str(u) '_U.mat'];
        save(filename,'U');
        filename = [file_path num2str(u) '_topologies.mat'];
        save(filename,'topologies');  
        filename = [file_path num2str(u) '_path.mat'];
        save(filename,'path');
        filename = [file_path num2str(u) '_processors.mat'];
        save(filename,'processors');
    end
    


end