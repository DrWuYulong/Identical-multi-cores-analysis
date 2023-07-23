function R = traditional_method(C,T,D,J,topologies,processors,path,set_numb,task_numb)

% set_numb = length(C);%%%%��ʾ�ж��ٸ�����
R = zeros(set_numb,1);

for i = 1:set_numb%ÿ�������������
%     task_numb = length(C{i});
    for j = task_numb:-1:1
        %C{i}(1:j) ��{i}��ʾ��i�У�1��j����ʾ���е�1~j��task��ÿ��task����һ�����󣬰���������ĸ�����Ϣ
        R_temp = calculate_R_old(C(i,1:j),T(i,1:j),D(i,j),J(i,1:j),topologies{i,j},processors(i,1:j),path{i,j});
        if R_temp ~= inf
            R(i) = R(i) + R_temp;
        else
            R(i) = inf;
            break;
        end
    end
    
end

end