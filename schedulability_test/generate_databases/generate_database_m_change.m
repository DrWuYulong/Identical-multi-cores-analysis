%利用率固定为0.4，处理器改变为2,4,8,16 observe不同算法的区别
function generate_database_m_change
    a = 1000;% a      用来确定每个利用率下有多少个任务集做平均实验
%     m = [2 4 8 16];%   m   处理器个数
    m = 8:2:16;
    u = 0.65;
    numb_v = 12;% numb_v 每个DAG任务的子任务数量
    C_min = 1;%每个子任务c的随机范围
    C_max = 10;
    k_min = 10;%每个任务周期/DDL 随机生成是C的倍数，10~20保证了每个任务集的任务数范围10~20个
    k_max = 20;
    p = 0.3;%添加边的概率
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%标准化利用率%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    l_m = length(m);
    % topologies = generate_topologies(a,b,numb_v,0.85);%%%%%拓扑结构
    for m_number = 1:l_m
        C = cell(a,1);%C 和 T 要对应拓扑结构，因为是添加任务生成模型，所以不能提前分配空间
        T = cell(a,1);
        U = cell(a,1); 
        D = cell(a,1);
        processors = cell(a,1);
        topologies = cell(a,1);%储存拓扑结构
        path = cell(a,1);
        
        for i = 1:a
            U_remain = u;
            j = 1;%用来计数每个任务集有多少个任务
            while U_remain > 0
                topologies{i}{j} =generate_topologies(numb_v,p);
                C{i}{j} = randi([C_min,C_max],1,numb_v);%每个子任务对应的计算时间
                processors{i}{j} = randi(m(m_number),[1,numb_v]);
                %%%%%%%%%%%%%计算对应处理器上C的总和%%%%%%%%%%%%%%%%
                temp_C = C{i}{j};
                temp_p = processors{i}{j};
                C_mean = 0;
                for k1 = 1:m(end)
                    if temp_p == k1
                        C_mean = max(C_mean, sum(temp_C(temp_p == k1)));
                    end
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                C_mean = C_mean / m(m_number);
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
        file_path = ['data_base\processors_u-',num2str(u),'\'];
        if exist(file_path,'dir') == 0
            mkdir(file_path);
        end
        filename = [file_path num2str(m(m_number)) '_C.mat'];
        save(filename,'C');
        filename = [file_path num2str(m(m_number)) '_T.mat'];
        save(filename,'T');
        filename = [file_path num2str(m(m_number)) '_D.mat'];
        save(filename,'D');
        filename = [file_path num2str(m(m_number)) '_U.mat'];
        save(filename,'U');
        filename = [file_path num2str(m(m_number)) '_topologies.mat'];
        save(filename,'topologies');  
        filename = [file_path num2str(m(m_number)) '_path.mat'];
        save(filename,'path');
        filename = [file_path num2str(m(m_number)) '_processors.mat'];
        save(filename,'processors');
    end
    


end