clear all;
clc;

m = 4;
U_min = 0.4;
U_max = m;
U_step = 0.2;
U_range = U_min:U_step:U_max;
set_numb = 1000;
task_numb = 10;
subtask_numb = 10;
p = 0.3;

frequent_Str = zeros((U_max-U_min)/U_step + 1,10); 
%%% ��ά���飬�б�ʾ�����ʣ���������Str��Ƶ�ʣ�frequent_Str(2,3) = 15��ʾ
%%% ��������Ϊ0.4+��2-1��*0.2 = 0.6 ʱ1000�������е�10000����������15�������Str�������20%~30%֮��
%%% (������Ϊÿ�������10�����������Գ���10�����ǰٷ�֮10��������)
Str_numb = zeros((U_max-U_min)/U_step + 1,subtask_numb); %%% һά�����ʾ
%%% Str_numb(4,6) = 25 ��ʾ������Ϊ 0.4+��4-1��*0.2 = 1ʱ��
%%% 1000�������е�10000�������У���25�������� 6��Str �ṹ
index_k = 1;

for u = U_range
    load_dir = ['database/m' num2str(m) '/R_DM/u_' num2str(u)];
    load_topologies = [load_dir '/topologies.mat'];
    load(load_topologies);
    
    
    for i = 1:set_numb
        for j = 1:task_numb
            Str_count = 0; %%%% �����ǵ�ǰ�����str����
            current_topology = topologies{i,j};
            Str_subtasks_count = 0;%%%% �����ǵ�ǰ�����ж��ٸ�����������Str�ṹ
            %%%%%% �ҵ����е�Str
            % �ȿ�source 
            if sum(sum(current_topology)==0) > 1 %%% source nodes > 1 ��ʾ��Str
                Str_subtasks_count = sum(sum(current_topology) == 0);
                Str_count = Str_count + 1;
            end            
            % Ȼ���ҵ�ʣ�����е�Str
            one_father_subtasks = find(sum(current_topology) == 1); %����ֻ��һ�����ڵ��������
            one_father = find(current_topology(:,one_father_subtasks) == 1)';
            one_father = mod(one_father,subtask_numb); %%%�õ�����ֻ��һ������������Ǹ������������ţ����ǲ����ж��һ
            
            for ii = 1:subtask_numb
                sum_Str_ii = sum(one_father == ii);
                if sum_Str_ii > 1 % ������str
                    Str_count = Str_count + 1;
                    Str_subtasks_count = Str_subtasks_count + sum_Str_ii;
                end
            end
                        
            percent_subtasks = ceil(Str_subtasks_count / subtask_numb * 100);
            
%             [Str_count Str_subtasks_count percent_subtasks]
%             pause;
            
            if percent_subtasks > 0
                frequent_Str(index_k,percent_subtasks/10) = frequent_Str(index_k,percent_subtasks/10) + 1;%��Ӧ��10%��������
                Str_numb(index_k, Str_count) = Str_numb(index_k, Str_count) + 1;
            end
        end
    end
    
    index_k = index_k + 1;
end

save_dir = ['result/m' num2str(m)];
mkdir(save_dir);

save_frequent_Str = [save_dir '/frequent_Str.mat'];
save(save_frequent_Str, 'frequent_Str');
save_Str_numb = [save_dir '/Str_numb.mat'];
save(save_Str_numb, 'Str_numb');

% 
% Z = frequent_Str';
% figure;
% h = bar3(1:10,Z);
% xlim([0 4]);
% ylim([0 10]);
% for i = 1:numel(h)
%   index = logical(kron(Z(:,i) == 0,ones(6,1)));
%   zData = get(h(i),'ZData');
%   zData(index,:) = nan;
%   set(h(i),'ZData',zData);
% end
% xl = xlabel('The percentage of subtasks in DAG task');
% yl = ylabel('The utilization of DAG task set');
% zlabel('The number of subtasks');
% set(gca,'XTicklabel',{'10','20','30','40','50','60','70','80','90','100'});
% 
% % set(xl,'Rotation',0); 
% % set(yl,'Rotation',-48); 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%    
% figure;
% h = bar3(U_range,Str_numb);
% xlim([0 10]);
% ylim([0 4]);
% for i = 1:numel(h)
%   index = logical(kron(Str_numb(:,i) == 0,ones(6,1)));
%   zData = get(h(i),'ZData');
%   zData(index,:) = nan;
%   set(h(i),'ZData',zData);
% end
% xl = xlabel('The Str numbers in DAG task');
% yl = ylabel('The utilization of DAG task set');
% zlabel('The number of subtasks');
% 
% set(xl,'Rotation',-5); 
% set(yl,'Rotation',47);     
%     
%     
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    