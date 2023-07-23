function topologies_set = generate_topologies(numb_v,edge_rate)
%�����������˽ṹ��a��ʾһ�����������ж����飬b��ʾÿ�����񼯺��ж��ٸ�dag����numb_v��ʾÿ��dag�ж���������
%edge_rate��ʾ������ɱߵĸ���Ϊ1-edge_rate
    topologies_set = zeros(numb_v);
    for k = 1:numb_v-1
        topologies_set(k,k+1:numb_v) = rand(1,numb_v-k);
    end
    topologies_set(topologies_set>=(1-edge_rate)) = 1;
    topologies_set(topologies_set<(1-edge_rate)) = 0;

end