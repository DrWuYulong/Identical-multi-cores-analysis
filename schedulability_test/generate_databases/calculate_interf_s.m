function interference_s = calculate_interf_s(path,DAG_C,topologies,processors)
%计算DAG任务内部干扰，path表示被分析路径，DAG_C，子任务计算时间，topologies表示DAG任务结构
%processor表示处理器所分配的处理器。

%%遍历所有的路径上的节点，并把所有会干扰路径的其他节点进行求和，重复的节点不做计算
len_path = length(path);%储存路径长度

interf_v = [];%会对路径产生干扰的节点，重复性判别
interference_s = 0;%DAG任务内自干扰初始化。

for i = 1:len_path%从路径第一个节点开始
    %将所有前继或间接前继节点排除自干扰节点集合
    vi = path(i);
    interf_vi = 1:length(topologies);%会对节点vi产生干扰的节点集合
    interf_vi = find_pre(vi,topologies,interf_vi);
    %再将所有后继或间接后继节点排除自干扰集合
    interf_vi = find_behind(vi,topologies,interf_vi);
    
    if ~isempty(interf_vi)
        %将分配到同一处理器上的点最终保留在自干扰点集合中
        pro_vi = processors(interf_vi);
        interf_vi(pro_vi ~= processors(vi)) = [];
    end
    %%%%%%将会对节点vi产生干扰的集合并到会对路径产生干扰的点集合中
    interf_v = union(interf_v,interf_vi);
end
if ~isempty(interf_v)
    interference_s = sum(DAG_C(interf_v));
end

end

%不会干扰的节点，不是前继节点或间接前继节点，也不是后继或间接后继节点
%如何判断间接:节点i是节点j的间接前后继，j属于当前路径，则i一定有一条路径与当前分析的路径有交叉
