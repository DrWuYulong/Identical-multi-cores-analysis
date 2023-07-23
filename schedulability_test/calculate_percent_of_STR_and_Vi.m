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
%%% 二维数组，行表示利用率，列用来存Str的频率，frequent_Str(2,3) = 15表示
%%% 当利用率为0.4+（2-1）*0.2 = 0.6 时1000组任务集中的10000个任务中有15个任务的Str任务比在20%~30%之间
%%% (这是因为每个任务就10个子任务，所以除以10，都是百分之10的整数倍)
Str_numb = zeros((U_max-U_min)/U_step + 1,subtask_numb); %%% 一维数组表示
%%% Str_numb(4,6) = 25 表示利用率为 0.4+（4-1）*0.2 = 1时，
%%% 1000组任务集中的10000个任务中，有25个任务含有 6个Str 结构
index_k = 1;

for u = U_range
    load_dir = ['database/m' num2str(m) '/R_DM/u_' num2str(u)];
    load_topologies = [load_dir '/topologies.mat'];
    load(load_topologies);
    
    
    for i = 1:set_numb
        for j = 1:task_numb
            Str_count = 0; %%%% 用来记当前任务的str个数
            current_topology = topologies{i,j};
            Str_subtasks_count = 0;%%%% 用来记当前任务有多少个子任务属于Str结构
            %%%%%% 找到所有的Str
            % 先看source 
            if sum(sum(current_topology)==0) > 1 %%% source nodes > 1 表示有Str
                Str_subtasks_count = sum(sum(current_topology) == 0);
                Str_count = Str_count + 1;
            end            
            % 然后找到剩余所有的Str
            one_father_subtasks = find(sum(current_topology) == 1); %所有只有一个父节点的子任务
            one_father = find(current_topology(:,one_father_subtasks) == 1)';
            one_father = mod(one_father,subtask_numb); %%%得到所有只有一个父子任务的那个父子任务的序号，看是不是有多对一
            
            for ii = 1:subtask_numb
                sum_Str_ii = sum(one_father == ii);
                if sum_Str_ii > 1 % 出现了str
                    Str_count = Str_count + 1;
                    Str_subtasks_count = Str_subtasks_count + sum_Str_ii;
                end
            end
                        
            percent_subtasks = ceil(Str_subtasks_count / subtask_numb * 100);
            
%             [Str_count Str_subtasks_count percent_subtasks]
%             pause;
            
            if percent_subtasks > 0
                frequent_Str(index_k,percent_subtasks/10) = frequent_Str(index_k,percent_subtasks/10) + 1;%对应上10%的整数倍
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    