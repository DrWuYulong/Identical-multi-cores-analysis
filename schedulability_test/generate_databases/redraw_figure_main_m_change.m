clear all
close all
clc

u = 0.4;

file_path = ['data_base\processors_u-',num2str(u),'\results\'];
%%%%%%加载执行时间，存的时候已经是毫秒了，无需再放大
file_name = [file_path 'execution_time_tra.mat'];
load(file_name,'execution_time_tra');
file_name = [file_path 'execution_time_new.mat'];
load(file_name,'execution_time_new');
file_name = [file_path 'execution_time_tra_DM.mat'];
load(file_name,'execution_time_tra_DM');
file_name = [file_path 'execution_time_new_DM.mat'];
load(file_name,'execution_time_new_DM');
file_name = [file_path 'execution_time_tra_DM_WF.mat'];
load(file_name,'execution_time_tra_DM_WF');
file_name = [file_path 'execution_time_new_DM_WF.mat'];
load(file_name,'execution_time_new_DM_WF');

%%%%加载平均响应时间
file_name = [file_path 'R_average_tra.mat'];
load(file_name,'R_average_tra');
file_name = [file_path 'R_average_new.mat'];
load(file_name,'R_average_new');
file_name = [file_path 'R_average_tra_DM.mat'];
load(file_name,'R_average_tra_DM');
file_name = [file_path 'R_average_new_DM.mat'];
load(file_name,'R_average_new_DM');
file_name = [file_path 'R_average_tra_DM_WF.mat'];
load(file_name,'R_average_tra_DM_WF');
file_name = [file_path 'R_average_new_DM_WF.mat'];
load(file_name,'R_average_new_DM_WF');

%%%加载可调度率
file_name = [file_path 'schedulable_ratio_tra.mat'];
load(file_name,'schedulable_ratio_tra');
file_name = [file_path 'schedulable_ratio_new.mat'];
load(file_name,'schedulable_ratio_new');
file_name = [file_path 'schedulable_ratio_tra_DM.mat'];
load(file_name,'schedulable_ratio_tra_DM');
file_name = [file_path 'schedulable_ratio_new_DM.mat'];
load(file_name,'schedulable_ratio_new_DM');
file_name = [file_path 'schedulable_ratio_tra_DM_WF.mat'];
load(file_name,'schedulable_ratio_tra_DM_WF');
file_name = [file_path 'schedulable_ratio_new_DM_WF.mat'];
load(file_name,'schedulable_ratio_new_DM_WF');

%%%%加载利用率范围
file_name = [file_path 'processors_range.mat'];
load(file_name,'processors_range');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%三种分配方法，对应分析时间增加%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%Tr-Rand方法分析时间增加ms
% time_raise_percent_tra = (execution_time_new - execution_time_tra)./execution_time_tra * 100;
time_raise_tra = (execution_time_new - execution_time_tra);
%%%%%%Tr-Rand-DM方法分析时间增加ms
time_raise_tra_DM = (execution_time_new_DM - execution_time_tra_DM);
%%%%%%Tr-Rand-DM-WF方法分析时间增加ms
time_raise_tra_DM_WF = (execution_time_new_DM_WF - execution_time_tra_DM_WF);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%三种分配方法，对应响应时间减少百分比%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%Tr-Rand方法响应时间减少时间
response_reduce_percent_R_R = (R_average_new - R_average_tra) ./ R_average_tra * 100;
response_reduce_percent_R_R(response_reduce_percent_R_R > 0) = NaN;%把传统方法不可调度的排除，不参与比较
%%%%%%Tr-Rand-DM方法响应时间减少时间
response_reduce_percent_DM_R = (R_average_new_DM - R_average_tra_DM) ./ R_average_tra_DM * 100;
response_reduce_percent_DM_R(response_reduce_percent_DM_R > 0) = NaN;
%%%%%%Tr-Rand-DM-WF方法响应时间减少时间
response_reduce_percent_DM_WF = (R_average_new_DM_WF - R_average_tra_DM_WF) ./ R_average_tra_DM_WF * 100;
response_reduce_percent_DM_WF(response_reduce_percent_DM_WF > 0) = NaN;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%三种分配方法，对应可调度率增加百分比%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%Tr-Rand方法可调度率增加百分比
scheduling_raise_R_R = (schedulable_ratio_new - schedulable_ratio_tra);
%%%%%%Tr-Rand-DM方法可调度率增加百分比
scheduling_raise_DM_R = (schedulable_ratio_new_DM - schedulable_ratio_tra_DM);
%%%%%%Tr-Rand-DM-WF方法可调度率增加百分比
scheduling_raise_tra_DM_WF = (schedulable_ratio_new_DM_WF - schedulable_ratio_tra_DM_WF);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%结束计算，开始作图%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%传统图，
figure 
gca = axes;
bar(1:length(processors_range),[R_average_tra;R_average_new;R_average_tra_DM;R_average_new_DM;R_average_tra_DM_WF;R_average_new_DM_WF]');
xlabel('The number of processors');
ylabel('The average response time of DAG task sets');
set(gca,'XTickLabel',{'4','6','8','10','12'});
ax = legend('Tr-Rand','New-Rand','Tr-DM','New-DM','Tr-DM-WF','New-DM-WF');
set(ax,'Position',[0.65,0.7,0.2,0.2]);

figure 
gca = axes;
bar(1:length(processors_range),[schedulable_ratio_tra;schedulable_ratio_new;schedulable_ratio_tra_DM;schedulable_ratio_new_DM;schedulable_ratio_tra_DM_WF;schedulable_ratio_new_DM_WF]');
xlabel('The number of processors');
ylabel('The schedulable ratio of DAG task sets(%)');
set(gca,'XTickLabel',{'4','6','8','10','12'});
ax = legend('Tr-Rand','New-Rand','Tr-DM','New-DM','Tr-DM-WF','New-DM-WF');
set(ax,'Position',[0.15,0.7,0.2,0.2]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%分析时间对比
figure 
gca = axes;
plot(processors_range,execution_time_tra,'b-o');%单位变成ms
hold on;
plot(processors_range,execution_time_new,'r-*');
hold on;
plot(processors_range,execution_time_tra_DM,'g-x');
hold on;
plot(processors_range,execution_time_new_DM,'k-s');
hold on;
plot(processors_range,execution_time_tra_DM_WF,'c-p');
hold on;
plot(processors_range,execution_time_new_DM_WF,'m-v');
xlim([2 14])
set(gca,'XTick',[4,6,8,10,12])

xlabel('The number of processors');
ylabel('The average analysis time of DAG task sets(/ms)');
gca=legend('Tr-Rand','New-Rand','Tr-DM','New-DM','Tr-DM-WF','New-DM-WF'); 
set(gca,'Position',[0.15,0.7,0.2,0.2]);
%%%%%%%%%%%%%%%%%%%%%分析时间，响应时间变换，可调度率变化对比柱状图

figure
yyaxis left
b1 = bar(processors_range,[response_reduce_percent_R_R;response_reduce_percent_DM_R;response_reduce_percent_DM_WF]');
b1(1).FaceColor = [0/255 130/255 200/255];
b1(2).FaceColor = [255/255 100/255 0/255];
b1(3).FaceColor = [255/255 200/255 0/255];
hold on;
b2 = bar(processors_range,[scheduling_raise_R_R;scheduling_raise_DM_R;scheduling_raise_tra_DM_WF]');
b2(1).FaceColor = [58/255 186/255 45/255];
b2(2).FaceColor = [165/255 55/255 212/255];
b2(3).FaceColor = [255/255 0/255 0/255];
xlabel('The number of processors');
ylabel('The increased percentage of the RRC over the traditional(%)');
ylim([-30 100]);

yyaxis right
plot(processors_range,time_raise_tra,'b-*');
hold on;
plot(processors_range,time_raise_tra_DM,'r-v');
hold on;
plot(processors_range,time_raise_tra_DM_WF,'g-o');
ylim([-30 100]);
xlabel('The number of processors');
ylabel('The increased value of analysis time(/ms)');
gca=legend('Response time of scenarios 1','Response time of scenarios 2','Response time of scenarios 3'...
    ,'Schedulable ratio of scenarios 1','Schedulable ratio of scenarios 2','Schedulable ratio of scenarios 3'...
    ,'Increased time of scenarios 1','Increased time of scenarios 2','Increased time of scenarios 3'); 
set(gca,'Position',[0.6,0.64,0.2,0.2]);






