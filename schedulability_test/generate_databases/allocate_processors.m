function processors_WF = allocate_processors(m,numb_v,C,T)
    set_numb = length(C);
    processors_WF = cell(set_numb,1);
    for i = 1:set_numb
        task_numb = length(C{i});
        remain_u = ones(1,m);%������Ϊ���������䣬Ҫô���ܻ�����еĴ�������Զ�����ᱻ���䵽��û�����������Ĵ��������ؾ���
        for j = 1:task_numb            
            temp_u = C{i}{j}/T{i}{j};%%%%��ǰDAG����������ʼ���
            processors_WF{i}{j} = [];%Ƕ��Ԫ�������ʼ��������Ҫôj���ܱ����������൱��������
            for k = 1:numb_v                
                index_max_remain_u = find(remain_u == max(remain_u));
                index_max_remain_u = index_max_remain_u(1);%ѡ����һ��ʣ�����������Ĵ�����
                processors_WF{i}{j} = [processors_WF{i}{j} index_max_remain_u];%����ǰ��������䵽�ô�������
                remain_u(index_max_remain_u) = remain_u(index_max_remain_u) - temp_u(k);
            end
        end
    end
                
            
end