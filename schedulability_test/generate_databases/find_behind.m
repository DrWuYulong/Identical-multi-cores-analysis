function interf_v = find_behind(v,topologies,interf_v)
%本函数用来找寻点v的前继或间接前继节点，interf_v表示可能会产生自干扰的节点集合
interf_v(interf_v == v) = [];
pre_v = find(topologies(v,:) == 1);

if ~isempty(pre_v)
    for i = 1:length(pre_v)        
        v = pre_v(i);
        interf_v = find_behind(v,topologies,interf_v);
    end
end
end