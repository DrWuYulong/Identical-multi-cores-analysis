function interf_v = find_behind(v,topologies,interf_v)
%������������Ѱ��v��ǰ�̻���ǰ�̽ڵ㣬interf_v��ʾ���ܻ�����Ը��ŵĽڵ㼯��
interf_v(interf_v == v) = [];
pre_v = find(topologies(v,:) == 1);

if ~isempty(pre_v)
    for i = 1:length(pre_v)        
        v = pre_v(i);
        interf_v = find_behind(v,topologies,interf_v);
    end
end
end