function R = calculate_R_new(hep_c,hep_t,d,hep_j,hep_topologies,hep_processors,path)
%hep_c �ǰ�����DAG����ĸ����ȼ�����ִ��ʱ�䣬hep_t�����ڣ�d�Ǹ���������ڣ�topologies�Ǹ���������˽ṹ���������������ڸ���
%hep_processors�ǰ���������ķ��䴦������������Ĵ���,path�ǵ�ǰ���������������·�����Ǹ�һάԪ�����飬ÿ��Ԫ����һ�����󣬴���·��
%hep_j�����ȼ����ڶ����ڵ�ǰ���ȼ���jitter
R = 0;
%%%%%%���һ��
%%%�ȼ�������ȼ�����һ����
len_hp = length(hep_c);
if len_hp == 1 %��ʾ�Ѿ���������ȼ��ˣ�ֻ��Ҫ��������ĸ��ź�ִ�г��ȡ�
    c = hep_c{end};%����
    processors = hep_processors{end};%����
    topology = hep_topologies{end};%����
    lp = length(path);
    for i = 1:lp
        %%%%��������·������Ӧʱ�䣬��ѡ��������Ϊ���������Ӧʱ�� 
        %%%%·����ִ��ʱ��
        current_path = path{i};%����
        execution_time_path = sum(c(current_path));
        %%%%DAG�������Ը���
        interference_s = calculate_interf_s(current_path,c,topology,processors);
        R_path = execution_time_path + interference_s;
        if R_path > d 
            R = inf;
            return;
        elseif R_path > R
            R = R_path;          
        end
    end
    return
end

hp_c = hep_c(1:len_hp-1);%Ԫ������1��
hp_t = hep_t(1:len_hp-1);%Ԫ������1��
hp_processors = hep_processors(1:len_hp-1);%Ԫ������1��
hp_topologies = hep_topologies(1:len_hp-1);%Ԫ������1��
hp_j = hep_j(1:len_hp-1);%Ԫ������1��
c = hep_c{end};%���󣬵�ǰ����������ִ��ʱ��
l_hp = length(hp_c);
processors = hp_processors{end};%����
topology = hep_topologies{end};%����
% path_set = find_path(topologies);%��ǰҪ����DAG���������·�����϶����ٻ���һ��·��\
lp = length(path);
% R_path = 0;%·������Ӧʱ��

% for i = 7:lp
for i = 1:lp
%%%%��������·������Ӧʱ�䣬��ѡ��������Ϊ���������Ӧʱ�� 
%%%%·����ִ��ʱ��
    current_path = path{i};%����
    execution_time_path = sum(c(current_path));
%%%%DAG�������Ը���
    interference_s = calculate_interf_s(current_path,c,topology,processors);
%%%%�����ȼ��������ĸ���
    proc = union(processors(current_path),processors(current_path));%��·����ռ�õĴ��������ϡ�
    static_time = execution_time_path + interference_s;%%%����ʱ��
    R_n1 = static_time;
    R_n = -1;
    %��ǰ·���͸����ȼ��������˽ṹȷ������֮��RRC�ṹ��ʱ���ǲ����
    struct_c_time = zeros(l_hp,1);%struct_c_time(k)��ʾ�����ȼ��ĵ�k�������к��е�RRC�ṹ��ɵĸ���ֵ
    for k = 1:l_hp
        struct_c_time(k) = calculate_struct_c(proc,hp_c{k},hp_topologies{k},hp_processors{k});
    end
   
    while R_n ~= R_n1
        R_n = R_n1;
        sum_high = 0;
        for j = 1:l_hp
            current_set_c = hp_c{j};
            temp_sum = sum(current_set_c(ismember(hp_processors{j},proc) == 1));
            %proc-���󣬱�ʾ��ǰ·����ռ��cpu��hp_c{j}-��j�������ȼ�������������c��hp_topologies{j}-����j��Ӧ�����ˣ��Լ�������
            sum_high = sum_high + ceil((R_n+hp_j{j})/hp_t(j))*(temp_sum-struct_c_time(j));
        end
        sum_high = sum_high + static_time;
        if sum_high > d
            R = inf;
            return;
        else
            R_n1 = sum_high;
        end
    end
    R = max(R,R_n1);
end

end








