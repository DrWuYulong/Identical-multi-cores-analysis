function struct_c_time = calculate_struct_c(proc,C,topologies,processors)
%%%%%%%%本函数用于计算具有struct结构而导致重复计算的时间。
%%%%%%%%proc是当前分析路径占用处理器的集合，C是当前高优先级DAG任务的子任务执行时间，topologies是高优先级拓扑结构，processors是子任务处理器分配情况。
%找只有一个父节点的所有子节点，

ch_index = find(sum(topologies)==1);
struct_c_time = 0;
%如果存在多个节点只有一个父节点
if ~isempty(ch_index)

    %找多个子节点有相同父节点的内个父节点
    f_index = find(sum(topologies(:,ch_index)')>1);
    if ~isempty(f_index)%如果存在多个任务有且只有一个子节点
        %%%找出这些任务是哪些，并且得到他们属于哪个节点。
        
        aa = topologies(f_index,ch_index);%表示具有struct结构的矩阵    
        
        %具有struct结构的元素不超过length(ch_index)个，行表示有多少个struct个数，每行第一列表示这个结构的父节点
        %后续列表示其派生的只有该节点作为父节点的子节点
        len_f = length(f_index);
        if sum(sum(topologies)==0) > 1%%%%%%%有多个初始节点
            struct_c = zeros(len_f+1,max(length(ch_index)+1,sum(sum(topologies)==0)+1));%%%第一行保存多个初始节点信息
            struct_c(1,2:sum(sum(topologies)==0)+1) = find(sum(topologies)==0);
            struct_c(2:len_f+1,1) = f_index';
            %从第二行开始是具有内部struct结构的集合
            for k = 2:len_f+1
                %从aa里面找到具体的任务，存到struct_c中
                ch_v = ch_index(aa(k-1,:)==1);
                struct_c(k,2:2+length(ch_v)-1) = ch_v;
            end
        else
            struct_c = zeros(len_f,length(ch_index)+1);
            struct_c(:,1) = f_index';
            %从第一行开始是具有内部struct结构的集合
            for k = 1:len_f
                %从aa里面找到具体的任务，存到struct_c中
                ch_v = ch_index(aa(k,:)==1);
                struct_c(k,2:2+length(ch_v)-1) = ch_v;
            end
        end
           
        
    else%%%%%%有只有一个父节点的节点，但是他们的父节点都不相同，也就是没有一个节点派生出多个子节点
        if sum(sum(topologies)==0) > 1%具有多个初始节点source node
            struct_c(1,1) = 0;
            struct_c(1,2:sum(sum(topologies)==0)+1) = find(sum(topologies)==0);
        else%%%%%%不存在只有一个父节点的节点，又不存在多个初始节点
            struct_c = [];
        end
    end
    
else%%%%%也就是不存在多个点有且只有一个父节点，就看初始节点
    if sum(sum(topologies)==0) > 1%具有多个初始节点source node
        struct_c(1,1) = 0;
        struct_c(1,2:sum(sum(topologies)==0)+1) = find(sum(topologies)==0);
    else%%%%%%不存在只有一个父节点的节点，又不存在多个初始节点
        return;
    end
end


for i = 1:size(struct_c,1)
    parallel_v = struct_c(i,:);
    parallel_v(parallel_v == 0) = [];%第i个具有struct结构的点集合
    parallel_v_p = processors(parallel_v);%第i个具有struct结构的点对应处理器集合
%     parallel_v_c = C(parallel_v);%第i个具有struct结构的点执行时间集合
    %%筛选出struct结构中包含proc的节点。
    index_interf_v = parallel_v(ismember(parallel_v_p,proc) == 1);%ismember用来得到占用pro的处理器，find得到位置，parallel_v确定是哪些节点
    if length(index_interf_v) >= 2%具有两个以上的节点
        struct_c_time = min(C(index_interf_v)) * (length(index_interf_v)-1);
    end

end

end



