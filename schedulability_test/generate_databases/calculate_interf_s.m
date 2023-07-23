function interference_s = calculate_interf_s(path,DAG_C,topologies,processors)
%����DAG�����ڲ����ţ�path��ʾ������·����DAG_C�����������ʱ�䣬topologies��ʾDAG����ṹ
%processor��ʾ������������Ĵ�������

%%�������е�·���ϵĽڵ㣬�������л����·���������ڵ������ͣ��ظ��Ľڵ㲻������
len_path = length(path);%����·������

interf_v = [];%���·���������ŵĽڵ㣬�ظ����б�
interference_s = 0;%DAG�������Ը��ų�ʼ����

for i = 1:len_path%��·����һ���ڵ㿪ʼ
    %������ǰ�̻���ǰ�̽ڵ��ų��Ը��Žڵ㼯��
    vi = path(i);
    interf_vi = 1:length(topologies);%��Խڵ�vi�������ŵĽڵ㼯��
    interf_vi = find_pre(vi,topologies,interf_vi);
    %�ٽ����к�̻��Ӻ�̽ڵ��ų��Ը��ż���
    interf_vi = find_behind(vi,topologies,interf_vi);
    
    if ~isempty(interf_vi)
        %�����䵽ͬһ�������ϵĵ����ձ������Ը��ŵ㼯����
        pro_vi = processors(interf_vi);
        interf_vi(pro_vi ~= processors(vi)) = [];
    end
    %%%%%%����Խڵ�vi�������ŵļ��ϲ������·���������ŵĵ㼯����
    interf_v = union(interf_v,interf_vi);
end
if ~isempty(interf_v)
    interference_s = sum(DAG_C(interf_v));
end

end

%������ŵĽڵ㣬����ǰ�̽ڵ����ǰ�̽ڵ㣬Ҳ���Ǻ�̻��Ӻ�̽ڵ�
%����жϼ��:�ڵ�i�ǽڵ�j�ļ��ǰ��̣�j���ڵ�ǰ·������iһ����һ��·���뵱ǰ������·���н���
