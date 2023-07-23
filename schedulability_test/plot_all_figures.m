clear all;
clc;


m = 8;
U_min = 1;
U_max = 4;
U_step = 0.5;
U_range = U_min:U_step:U_max;
set_numb = 1000;
task_numb = 10;
subtask_numb = 20;
p = 0.1;

%%%%%%%%%%%%%%%%% º”‘ÿ ˝æ›
dir = 'result';

load_execution_time_tra_DM_R = [dir '/execution_time_tra_DM_R.mat'];
load_execution_time_new_DM_R = [dir '/execution_time_new_DM_R.mat'];
load_execution_time_tra_DM_MACRO = [dir '/execution_time_tra_DM_MACRO.mat'];
load_execution_time_new_DM_MACRO = [dir '/execution_time_new_DM_MACRO.mat'];
load_execution_time_tra_DM_dagP = [dir '/execution_time_tra_DM_dagP.mat'];
load_execution_time_new_DM_dagP = [dir '/execution_time_new_DM_dagP.mat'];

load_R_average_tra_DM_R = [dir '/R_average_tra_DM_R.mat'];
load_R_average_new_DM_R = [dir '/R_average_new_DM_R.mat'];
load_R_average_tra_DM_MACRO = [dir '/R_average_tra_DM_MACRO.mat'];
load_R_average_new_DM_MACRO = [dir '/R_average_new_DM_MACRO.mat'];
load_R_average_tra_DM_dagP = [dir '/R_average_tra_DM_dagP.mat'];
load_R_average_new_DM_dagP = [dir '/R_average_new_DM_dagP.mat'];

load_schedulable_ratio_tra_DM_R = [dir '/schedulable_ratio_tra_DM_R.mat'];
load_schedulable_ratio_new_DM_R = [dir '/schedulable_ratio_new_DM_R.mat'];
load_schedulable_ratio_tra_DM_MACRO = [dir '/schedulable_ratio_tra_DM_MACRO.mat'];
load_schedulable_ratio_new_DM_MACRO = [dir '/schedulable_ratio_new_DM_MACRO.mat'];
load_schedulable_ratio_tra_DM_dagP = [dir '/schedulable_ratio_tra_DM_dagP.mat'];
load_schedulable_ratio_new_DM_dagP = [dir '/schedulable_ratio_new_DM_dagP.mat'];


load(load_execution_time_tra_DM_R);
load(load_execution_time_new_DM_R);
load(load_execution_time_tra_DM_MACRO);
load(load_execution_time_new_DM_MACRO);
load(load_execution_time_tra_DM_dagP);
load(load_execution_time_new_DM_dagP);

load(load_R_average_tra_DM_R);
load(load_R_average_new_DM_R);
load(load_R_average_tra_DM_MACRO);
load(load_R_average_new_DM_MACRO);
load(load_R_average_tra_DM_dagP);
load(load_R_average_new_DM_dagP);

load(load_schedulable_ratio_tra_DM_R);
load(load_schedulable_ratio_new_DM_R);
load(load_schedulable_ratio_tra_DM_MACRO);
load(load_schedulable_ratio_new_DM_MACRO);
load(load_schedulable_ratio_tra_DM_dagP);
load(load_schedulable_ratio_new_DM_dagP);


% R_average_real_DM_R = 12400:200:16000;
% R_average_real_DM_R(18:19) = NaN;
% schedulable_ratio_real_DM_R = ones(1,19)*100;
% schedulable_ratio_real_DM_R(8:19) = [99.8 99.2 98 90.2 76.9 55.9 25.7 11.5 1.8 0.1 0 0];
% 
% R_average_real_DM_MACRO = 11400:200:15000;
% R_average_real_DM_MACRO(18:19) = NaN;
% schedulable_ratio_real_DM_MACRO = ones(1,19)*100;
% schedulable_ratio_real_DM_MACRO(9:19) = [99.8 99.2 98 90.2 76.9 55.9 25.7 11.5 1.8 0.1 0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% WCRT
figure;
plot(U_range,R_average_tra_DM_R,'b:o');
hold on;
plot(U_range,R_average_new_DM_R,'r-*');
hold on;
plot(U_range,R_average_tra_DM_MACRO,'g:x');
hold on;
plot(U_range,R_average_new_DM_MACRO,'k-s');
hold on;
plot(U_range,R_average_tra_DM_dagP,'c:p');
hold on;
plot(U_range,R_average_new_DM_dagP,'m-v');

xlim([U_min U_max]);
% xticks(U_range);
xlabel('The utilization of DAG task sets');
ylabel('The average WCRT of DAG task sets (ms)');
gca=legend('Tr-R','RRC-R','Tr-MACRO','RRC-MACRO','Tr-dagP','RRC-dagP'); 
set(gca,'Position',[0.73 0.68 0.1 0.2]);

%%%%%%%%%% schedulable

figure;
plot(U_range,schedulable_ratio_tra_DM_R,'b:o');
hold on;
plot(U_range,schedulable_ratio_new_DM_R,'r-*');
hold on;
plot(U_range,schedulable_ratio_tra_DM_MACRO,'g:x');
hold on;
plot(U_range,schedulable_ratio_new_DM_MACRO,'k-s');
hold on;
plot(U_range,schedulable_ratio_tra_DM_dagP,'c:p');
hold on;
plot(U_range,schedulable_ratio_new_DM_dagP,'m-v');


xlim([U_min U_max]);
xlabel('The utilization of DAG task sets');
ylabel('The acceptance ratio of DAG task sets(%)');
gca=legend('Tr-R','RRC-R','Tr-MACRO','RRC-MACRO','Tr-dagP','RRC-dagP'); 
set(gca,'Position',[0.73 0.68 0.1 0.2]);

%%%%%%%%%%%%% execution time

figure;
plot(U_range,execution_time_tra_DM_R,'b:o');
hold on;
plot(U_range,execution_time_new_DM_R,'r-*');
hold on;
plot(U_range,execution_time_tra_DM_MACRO,'g:x');
hold on;
plot(U_range,execution_time_new_DM_MACRO,'k-s');
hold on;
plot(U_range,execution_time_tra_DM_dagP,'c:p');
hold on;
plot(U_range,execution_time_new_DM_dagP,'m-v');


xlim([U_min U_max]);
xlabel('The utilization of DAG task sets');
ylabel('The analysis time (ms)');
gca=legend('Tr-R','RRC-R','Tr-MACRO','RRC-MACRO','Tr-dagP','RRC-dagP'); 
set(gca,'Position',[0.73 0.68 0.1 0.2]);



%%%%%%%%%% WCRT   R_DM
% % figure;
% % plot(U_range,R_average_tra_DM_R,'b:o');
% % hold on;
% % plot(U_range,R_average_new_DM_R,'r-*');
% % hold on;
% % plot(U_range,R_average_tra_DM_MACRO,'g:x');
% % hold on;
% % plot(U_range,R_average_new_DM_MACRO,'k-s');
% % hold on;
% % plot(U_range,R_average_tra_DM_dagP,'c:p');
% % hold on;
% % plot(U_range,R_average_new_DM_dagP,'m-v');
% % 
% % xlim([U_min U_max]);
% % xlabel('The utilization of DAG task sets');
% % ylabel('The average response time of DAG task sets');
% % gca=legend('Tr-DM-R','RRC-DM-R','Tr-DM-MACRO','RRC-DM-MACRO','Tr-DM-dagP','RRC-DM-dagP'); 
% % set(gca,'Position',[0.775922331138721 0.693095238095238 0.119417473644886 0.2]);
% % %%
% % figure;
% % plot(U_range,schedulable_ratio_tra_DM_R,'b:o');
% % hold on;
% % plot(U_range,schedulable_ratio_new_DM_R,'r-.*');
% % hold on;
% % plot(U_range,schedulable_ratio_real_DM_R,'k-s');
% % 
% % xlim([U_min U_max]);
% % xlabel('The utilization of DAG task sets');
% % ylabel('The acceptance ratio of DAG task sets(%)');
% % gca=legend('Tr-dagP-DM','RRC-dagP-DM','real-dagP-DM'); 
% % set(gca,'Position',[0.7 0.65 0.1 0.2]);
% % %%
% % figure;
% % plot(U_range,execution_time_tra_DM,'b:o');
% % hold on;
% % plot(U_range,execution_time_new_DM,'r-.*');
% % 
% % xlim([U_min U_max]);
% % xlabel('The utilization of DAG task sets');
% % ylabel('The analysis time (ms)');
% % gca=legend('Tr-dagP-DM','RRC-dagP-DM'); 
% % set(gca,'Position',[0.7 0.65 0.1 0.2]);
% % 
% % %%%%%%%%% WCRT   MACRO_DM
% % figure;
% % plot(U_range,R_average_tra_DM_MACRO,'b:o');
% % hold on;
% % plot(U_range,R_average_new_DM_MACRO,'r-.*');
% % hold on;
% % plot(U_range,R_average_real_DM_MACRO,'k-s');
% % 
% % xlim([U_min U_max]);
% % xlabel('The utilization of DAG task sets');
% % ylabel('The average response time of DAG task sets (ms)');
% % gca=legend('Tr-MACRO-DM','RRC-MACRO-DM','real-MACRO-DM'); 
% % set(gca,'Position',[0.7 0.65 0.1 0.2]);
% % %%
% % figure;
% % plot(U_range,schedulable_ratio_tra_DM_MACRO,'b:o');
% % hold on;
% % plot(U_range,schedulable_ratio_new_DM_MACRO,'r-.*');
% % hold on;
% % plot(U_range,schedulable_ratio_real_DM_MACRO,'k-s');
% % 
% % xlim([U_min U_max]);
% % xlabel('The utilization of DAG task sets');
% % ylabel('The acceptance ratio of DAG task sets(%)');
% % gca=legend('Tr-MACRO-DM','RRC-MACRO-DM','real-MACRO-DM'); 
% % set(gca,'Position',[0.7 0.65 0.1 0.2]);
% % %%
% % figure;
% % plot(U_range,execution_time_tra_DM_MACRO,'b:o');
% % hold on;
% % plot(U_range,execution_time_new_DM_MACRO,'r-.*');
% % 
% % xlim([U_min U_max]);
% % xlabel('The utilization of DAG task sets');
% % ylabel('The analysis time (ms)');
% % gca=legend('Tr-MACRO-DM','RRC-MACRO-DM'); 
% % set(gca,'Position',[0.7 0.65 0.1 0.2]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% bar3 %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure;
% h = bar3(U_range,frequent_Str);
% xlim([0 10]);
% ylim([0 4]);
% for i = 1:numel(h)
%   index = logical(kron(frequent_Str(:,i) == 0,ones(6,1)));
%   zData = get(h(i),'ZData');
%   zData(index,:) = nan;
%   set(h(i),'ZData',zData);
% end
% xl = xlabel('The percentage of subtasks in DAG task');
% yl = ylabel('The utilization of the DAG task set');
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
% yl = ylabel('The utilization of the DAG task set');
% zlabel('The number of DAG tasks');
% 
% set(xl,'Rotation',-5); 
% set(yl,'Rotation',47);     
    
    






