function topologies_set = generate_topologies(numb_v,edge_rate)
%用来生成拓扑结构，a表示一个利用率下有多少组，b表示每组任务集合有多少个dag任务，numb_v表示每个dag有多少子任务
%edge_rate表示随机生成边的概率为1-edge_rate
    topologies_set = zeros(numb_v);
    for k = 1:numb_v-1
        topologies_set(k,k+1:numb_v) = rand(1,numb_v-k);
    end
    topologies_set(topologies_set>=(1-edge_rate)) = 1;
    topologies_set(topologies_set<(1-edge_rate)) = 0;

end