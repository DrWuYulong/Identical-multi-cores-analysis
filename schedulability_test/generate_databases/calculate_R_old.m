function R = calculate_R_old(hep_c,hep_t,d,hep_j,topology,hep_processors,path)
%hep_c �ǰ�����DAG����ĸ����ȼ�����ִ��ʱ�䣬hep_t�����ڣ�d�Ǹ���������ڣ�topologies�Ǹ���������˽ṹ���������������ڸ���
%hep_processors�ǰ���������ķ��䴦������������Ĵ���,path�ǵ�ǰ���������������·�����Ǹ�һάԪ�����飬ÿ��Ԫ����һ�����󣬴���·��
%hep_j�Ǵ��ڵ��ڵ�ǰ���ȼ�������Ķ���
R = 0;
%%%%%%���һ��
%%%�ȼ�������ȼ�����һ����
len_hp = length(hep_c);
if len_hp == 1 %��ʾ�Ѿ���������ȼ��ˣ�ֻ��Ҫ�����Լ��ĸ��ź�ִ�г��ȡ�
    c = hep_c{end};%����
    processors = hep_processors{end};%����
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
    return;
end

hp_c = hep_c(1:len_hp-1);%Ԫ������1��
hp_t = hep_t(1:len_hp-1);%Ԫ������1��
hp_processors = hep_processors(1:len_hp-1);%Ԫ������1��
hp_j = hep_j(1:len_hp-1);%Ԫ������1��
c = hep_c{end};%����
l_hp = length(hp_c);
processors = hp_processors{end};%����

lp = length(path);%��ǰ�����������ж�����·��
% R_path = 0;%·������Ӧʱ��
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
    while R_n ~= R_n1
        R_n = R_n1;
        sum_high = 0;
        for j = 1:l_hp
            current_set_c = hp_c{j};
            temp_sum = sum(current_set_c(ismember(hp_processors{j},proc) == 1));
            sum_high = sum_high + ceil((R_n + hp_j{j})/hp_t(j))*temp_sum;
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








