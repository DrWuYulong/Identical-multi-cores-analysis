function R = calculate_R_new(hep_c,hep_t,d,hep_j,hep_topologies,hep_processors,path)
%hep_c 是包含该DAG任务的高优先级任务执行时间，hep_t是周期，d是该任务的周期，topologies是该任务的拓扑结构，用来计算任务内干扰
%hep_processors是包含该任务的分配处理器，所分配的处理,path是当前待分析任务的所有路径，是个一维元胞数组，每个元素是一个矩阵，代表路径
%hep_j是优先级高于都等于当前优先级的jitter
R = 0;
%%%%%%拆分一下
%%%先假设高优先级至少一个。
len_hp = length(hep_c);
if len_hp == 1 %表示已经是最高优先级了，只需要计算自身的干扰和执行长度。
    c = hep_c{end};%矩阵
    processors = hep_processors{end};%矩阵
    topology = hep_topologies{end};%矩阵
    lp = length(path);
    for i = 1:lp
        %%%%计算所有路径的响应时间，并选择最大的作为该任务的响应时间 
        %%%%路径的执行时间
        current_path = path{i};%矩阵
        execution_time_path = sum(c(current_path));
        %%%%DAG任务内自干扰
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

hp_c = hep_c(1:len_hp-1);%元胞数组1层
hp_t = hep_t(1:len_hp-1);%元胞数组1层
hp_processors = hep_processors(1:len_hp-1);%元胞数组1层
hp_topologies = hep_topologies(1:len_hp-1);%元胞数组1层
hp_j = hep_j(1:len_hp-1);%元胞数组1层
c = hep_c{end};%矩阵，当前待分析任务执行时间
l_hp = length(hp_c);
processors = hp_processors{end};%矩阵
topology = hep_topologies{end};%矩阵
% path_set = find_path(topologies);%当前要计算DAG任务的所有路径，肯定至少会有一条路径\
lp = length(path);
% R_path = 0;%路径的响应时间

% for i = 7:lp
for i = 1:lp
%%%%计算所有路径的响应时间，并选择最大的作为该任务的响应时间 
%%%%路径的执行时间
    current_path = path{i};%矩阵
    execution_time_path = sum(c(current_path));
%%%%DAG任务内自干扰
    interference_s = calculate_interf_s(current_path,c,topology,processors);
%%%%高优先级任务对其的干扰
    proc = union(processors(current_path),processors(current_path));%该路径所占用的处理器集合。
    static_time = execution_time_path + interference_s;%%%不变时间
    R_n1 = static_time;
    R_n = -1;
    %当前路径和高优先级任务拓扑结构确定下来之后，RRC结构的时间是不变的
    struct_c_time = zeros(l_hp,1);%struct_c_time(k)表示高优先级的第k个任务中含有的RRC结构造成的干扰值
    for k = 1:l_hp
        struct_c_time(k) = calculate_struct_c(proc,hp_c{k},hp_topologies{k},hp_processors{k});
    end
   
    while R_n ~= R_n1
        R_n = R_n1;
        sum_high = 0;
        for j = 1:l_hp
            current_set_c = hp_c{j};
            temp_sum = sum(current_set_c(ismember(hp_processors{j},proc) == 1));
            %proc-矩阵，表示当前路径所占用cpu，hp_c{j}-第j个高优先级任务的子任务的c，hp_topologies{j}-任务j对应的拓扑，以及处理器
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








