function processors = MACRO(C,T,topology,m,subtask_numb)

%%%%%%%%%%% 计算bl
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
%%%%%%%%% bl计算结束


all_part = 1:m;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% part = BL_EST(C,topology,m,subtask_numb);
% part = zeros(1,subtask_numb);
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for i = 1:subtask_numb
%     part(i) = mod(i,4)+1;
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % wf 分配初始part
part = zeros(1,subtask_numb);
U_remain = ones(1,m);
for i = 1:subtask_numb
    U_index = find(U_remain == max(U_remain));
    U_index = U_index(1);
    part(i) = U_index;
    U_remain(U_index) = U_remain(U_index) - C(i)/T;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% part = zeros(1,subtask_numb);
% lb = 0.9*subtask_numb/m;
% count = 0;
% temp_processor = 1;
% for i = 1:subtask_numb
%     if count > lb
%         count = 1;
%         temp_processor = temp_processor + 1;
%     else
%         count = count + 1;
%     end
%     part(i) = temp_processor;
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% part = randi([1,m],1,subtask_numb);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ReadyParts = part(sum(topology) == 0);
ReadyParts = union(ReadyParts,ReadyParts);
all_part(ReadyParts) = [];
scheduled = zeros(1,subtask_numb);
scheduled(sum(topology) == 0) = 1;

end_k = zeros(1,m);
comp_k = end_k;
recv_k = end_k;
send_k = end_k;
st = zeros(1,subtask_numb);

miu = ones(1,subtask_numb);

valid_processors = 1:m;

while ~isempty(ReadyParts)
    
    Vi = ReadyParts(1);
    all_part(all_part == Vi) = [];
    ReadyParts(1) = [];
    curr_ReadyPart = find(part == Vi);
    for k = 1:m
        end_k(k) = comp_k(k);
        Ready = curr_ReadyPart(find(scheduled(curr_ReadyPart) == 1));
        
        for ttt = 1:length(curr_ReadyPart)
            if part(find(topology(:,curr_ReadyPart(ttt)))) == 1
                Ready = union(Ready,ttt);
            end
        end
        
        if ~isempty(Ready)
            Ready = Ready(1);
        end

        while ~isempty(Ready)
            vx = Ready(1);
            Ready(1) = [];
            pred_vx = find(topology(:,vx) == 1);
            %%%%%%bl 越小 finish 越大，pred_vx按照finish升序排列，也就是按照bl降序排列
            for ii = 1:length(pred_vx)-1
                for jj = ii:length(pred_vx)
                    if bl(pred_vx(jj)) > bl(pred_vx(ii))
                        temp_store = pred_vx(ii);
                        pred_vx(ii) = pred_vx(jj);
                        pred_vx(jj) = temp_store;
                    end
                end
            end
            
            miu(curr_ReadyPart) = k;
            st(vx) = comp_k(k);
            
            for l = 1:length(pred_vx)
                vj = pred_vx(l);
                if miu(vj) == k
                    com_jx = st(vj) + C(vj);
                else
                    com_jx = max([st(vj) + C(vj), send_k(miu(vj)), recv_k(k)]);
                    send_k(miu(vj)) = com_jx;
                    recv_k(k) = com_jx;
                end
                st(vx) = max(st(vx), com_jx);
            end
            comp_k(k) = st(vx) + C(vx);
            end_k(k) = comp_k(k);
            scheduled(vx) = 1;
            %%%%%%%%%insert new ready tasks into Ready
            un_execute = find(scheduled == 0);
            pre_v = intersect(un_execute,curr_ReadyPart);

            for l = 1:length(pre_v)
                pred_y = find(topology(:,pre_v(l)) == 1);
                if scheduled(pred_y) == 1
                    Ready = union(Ready,pre_v(l));
                end
            end
        end
    end
    temp_endk =end_k;
    temp_endk = temp_endk(valid_processors);
    temp_index = find(temp_endk == min(temp_endk));
    temp_index = temp_index(1);
    k_opt = valid_processors(temp_index);
    valid_processors(temp_index) = [];
    
%     end_k
%     k_opt = find(end_k ==min(end_k))
%     pause;
%     k_opt = intersect(k_opt,valid_processors)
%     k_opt = k_opt(1);
%     valid_processors(valid_processors == k_opt) = [];
    processors(find(part == Vi)) = k_opt;
        
    tt = [];
    %%%%%%%%%%找到新的 ready part 放到 ReadyPart List
    for kk = 1:length(all_part)
        check_Vx =  find(part == all_part(kk));
        
        for ll = 1:length(check_Vx)
            if scheduled(find(topology(:,check_Vx(ll)) == 1)) == 1
               ReadyParts = union(ReadyParts, all_part(kk));
               tt = [tt all_part(kk)];
               break;
            end
        end
    end
    while ~isempty(tt)
        all_part(all_part == tt(1)) = [];
        tt(1) = [];
%         all_part(find(all_part == tt)) = [];
    end
        
end

if ~isempty(valid_processors)
    processors(processors == 0) = valid_processors(1);
end

end











