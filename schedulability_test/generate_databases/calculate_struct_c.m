function struct_c_time = calculate_struct_c(proc,C,topologies,processors)
%%%%%%%%���������ڼ������struct�ṹ�������ظ������ʱ�䡣
%%%%%%%%proc�ǵ�ǰ����·��ռ�ô������ļ��ϣ�C�ǵ�ǰ�����ȼ�DAG�����������ִ��ʱ�䣬topologies�Ǹ����ȼ����˽ṹ��processors���������������������
%��ֻ��һ�����ڵ�������ӽڵ㣬

ch_index = find(sum(topologies)==1);
struct_c_time = 0;
%������ڶ���ڵ�ֻ��һ�����ڵ�
if ~isempty(ch_index)

    %�Ҷ���ӽڵ�����ͬ���ڵ���ڸ����ڵ�
    f_index = find(sum(topologies(:,ch_index)')>1);
    if ~isempty(f_index)%������ڶ����������ֻ��һ���ӽڵ�
        %%%�ҳ���Щ��������Щ�����ҵõ����������ĸ��ڵ㡣
        
        aa = topologies(f_index,ch_index);%��ʾ����struct�ṹ�ľ���    
        
        %����struct�ṹ��Ԫ�ز�����length(ch_index)�����б�ʾ�ж��ٸ�struct������ÿ�е�һ�б�ʾ����ṹ�ĸ��ڵ�
        %�����б�ʾ��������ֻ�иýڵ���Ϊ���ڵ���ӽڵ�
        len_f = length(f_index);
        if sum(sum(topologies)==0) > 1%%%%%%%�ж����ʼ�ڵ�
            struct_c = zeros(len_f+1,max(length(ch_index)+1,sum(sum(topologies)==0)+1));%%%��һ�б�������ʼ�ڵ���Ϣ
            struct_c(1,2:sum(sum(topologies)==0)+1) = find(sum(topologies)==0);
            struct_c(2:len_f+1,1) = f_index';
            %�ӵڶ��п�ʼ�Ǿ����ڲ�struct�ṹ�ļ���
            for k = 2:len_f+1
                %��aa�����ҵ���������񣬴浽struct_c��
                ch_v = ch_index(aa(k-1,:)==1);
                struct_c(k,2:2+length(ch_v)-1) = ch_v;
            end
        else
            struct_c = zeros(len_f,length(ch_index)+1);
            struct_c(:,1) = f_index';
            %�ӵ�һ�п�ʼ�Ǿ����ڲ�struct�ṹ�ļ���
            for k = 1:len_f
                %��aa�����ҵ���������񣬴浽struct_c��
                ch_v = ch_index(aa(k,:)==1);
                struct_c(k,2:2+length(ch_v)-1) = ch_v;
            end
        end
           
        
    else%%%%%%��ֻ��һ�����ڵ�Ľڵ㣬�������ǵĸ��ڵ㶼����ͬ��Ҳ����û��һ���ڵ�����������ӽڵ�
        if sum(sum(topologies)==0) > 1%���ж����ʼ�ڵ�source node
            struct_c(1,1) = 0;
            struct_c(1,2:sum(sum(topologies)==0)+1) = find(sum(topologies)==0);
        else%%%%%%������ֻ��һ�����ڵ�Ľڵ㣬�ֲ����ڶ����ʼ�ڵ�
            struct_c = [];
        end
    end
    
else%%%%%Ҳ���ǲ����ڶ��������ֻ��һ�����ڵ㣬�Ϳ���ʼ�ڵ�
    if sum(sum(topologies)==0) > 1%���ж����ʼ�ڵ�source node
        struct_c(1,1) = 0;
        struct_c(1,2:sum(sum(topologies)==0)+1) = find(sum(topologies)==0);
    else%%%%%%������ֻ��һ�����ڵ�Ľڵ㣬�ֲ����ڶ����ʼ�ڵ�
        return;
    end
end


for i = 1:size(struct_c,1)
    parallel_v = struct_c(i,:);
    parallel_v(parallel_v == 0) = [];%��i������struct�ṹ�ĵ㼯��
    parallel_v_p = processors(parallel_v);%��i������struct�ṹ�ĵ��Ӧ����������
%     parallel_v_c = C(parallel_v);%��i������struct�ṹ�ĵ�ִ��ʱ�伯��
    %%ɸѡ��struct�ṹ�а���proc�Ľڵ㡣
    index_interf_v = parallel_v(ismember(parallel_v_p,proc) == 1);%ismember�����õ�ռ��pro�Ĵ�������find�õ�λ�ã�parallel_vȷ������Щ�ڵ�
    if length(index_interf_v) >= 2%�����������ϵĽڵ�
        struct_c_time = min(C(index_interf_v)) * (length(index_interf_v)-1);
    end

end

end



