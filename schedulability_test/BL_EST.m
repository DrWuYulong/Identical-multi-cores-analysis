function processors = BL_EST(C,topology,m,subtask_numb)

processors = zeros(1,subtask_numb);
bl = zeros(1,subtask_numb);
curr_bl = find(sum(topology,2) == 0);


while ~isempty(curr_bl)
    vi = curr_bl(end);
    curr_bl(end) = [];
    if sum(topology(vi,:)) == 0 %表示末节点
        bl(vi) = C(vi);
    else
        bl_i = C(vi) + max(bl(topology(vi,:) == 1));
        bl(vi) = max(bl(vi),bl_i);
    end
    
    curr_bl = union(find(topology(:,vi) == 1),curr_bl);
    
end


%%%%%%%%%%%% bl 计算结束%%%%%%%%%
Ready = find(sum(topology) == 0);
comp_k = zeros(1,m);
send_k = comp_k;
recv_k = comp_k;
begin_k = comp_k;
st = zeros(1,subtask_numb);

while ~isempty(Ready)
    vi = Ready(find(bl(Ready) == max(bl(Ready))));
    vi = vi(1);
    Ready(Ready == vi) = [];
    pred_vi = find(topology(:,vi) == 1);
    for k = 1:m
        begin_k(k) = comp_k(k);
        for l = 1:length(pred_vi)
            vj = pred_vi(l);%%%%更新 begink
        end
    end
    k_opt = find(begin_k == min(begin_k));
    
    k_opt = k_opt(1);
    processors(vi) = k_opt;
%     st(vi) = comp_k(k_opt);
    
    for l = 1:length(pred_vi)
        vj = pred_vi(l);
        if processors(vj) == k_opt
            com_ji = st(vj) + C(vj);
        else
            com_ji = max([st(vj) + C(vj), send_k(processors(vj)), recv_k(k_opt)]);
            send_k(processors(vj)) = com_ji;
            recv_k(k_opt) = com_ji;
        end
        st(vi) = max(st(vi), com_ji);
    end

    comp_k(k_opt) = st(vi) + C(vi);
   
    insert_ready = find(topology(vi,:) == 1);
    if ~isempty(insert_ready)
        for i = 1:length(insert_ready)
            if find(processors(find(topology(:,insert_ready(i)) == 1)) == 0)
                insert_ready(i) = 0;
            end
        end
    end

    insert_ready(insert_ready == 0) = [];

    
    Ready = union(Ready,insert_ready);

end


end















