function longest_len = find_longest_len(path,sub_c)
% function [longest_len,index] = find_longest_len(path,sub_c)
%longest_len��ʾ���·��ֵ��index��ʾ����·���ǵڼ�����
%path ��ʾ·����Ԫ�����飬����������·����Ϣ��sub_c�Ǹ����������������WCET
    longest_len = 0;%��ʼֵ�·����Ϊ0
%     index = 1;
    l = length(path);%l���湲�ж�����·��
    for i = 1:l
        current_len = sum(sub_c(path{i}));
        if current_len > longest_len
            longest_len = current_len;
%             index = i;
        end
    end  

end