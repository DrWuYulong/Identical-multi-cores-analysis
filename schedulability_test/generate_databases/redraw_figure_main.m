clear all
close all
clc

file_path = 'data_base\utilization_m-8_subTask-12\results\';
%%%%%%����ִ��ʱ�䣬���ʱ���Ѿ��Ǻ����ˣ������ٷŴ�
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

%%%%����ƽ����Ӧʱ��
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

%%%���ؿɵ�����
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

%%%%���������ʷ�Χ
file_name = [file_path 'utilization_range.mat'];
load(file_name,'utilization_range');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%���ַ��䷽������Ӧ����ʱ������%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%Tr-Rand��������ʱ������ms
% time_raise_percent_tra = (execution_time_new - execution_time_tra)./execution_time_tra * 100;
time_raise_tra = (execution_time_new - execution_time_tra);
%%%%%%Tr-Rand-DM��������ʱ������ms
time_raise_tra_DM = (execution_time_new_DM - execution_time_tra_DM);
%%%%%%Tr-Rand-DM-WF��������ʱ������ms
time_raise_tra_DM_WF = (execution_time_new_DM_WF - execution_time_tra_DM_WF);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%���ַ��䷽������Ӧ��Ӧʱ����ٰٷֱ�%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%Tr-Rand������Ӧʱ�����ʱ��
response_reduce_percent_R_R = (R_average_new - R_average_tra) ./ R_average_tra * 100;
response_reduce_percent_R_R(response_reduce_percent_R_R > 0) = NaN;%�Ѵ�ͳ�������ɵ��ȵ��ų���������Ƚ�
%%%%%%Tr-Rand-DM������Ӧʱ�����ʱ��
response_reduce_percent_DM_R = (R_average_new_DM - R_average_tra_DM) ./ R_average_tra_DM * 100;
response_reduce_percent_DM_R(response_reduce_percent_DM_R > 0) = NaN;
%%%%%%Tr-Rand-DM-WF������Ӧʱ�����ʱ��
response_reduce_percent_DM_WF = (R_average_new_DM_WF - R_average_tra_DM_WF) ./ R_average_tra_DM_WF * 100;
response_reduce_percent_DM_WF(response_reduce_percent_DM_WF > 0) = NaN;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%���ַ��䷽������Ӧ�ɵ��������Ӱٷֱ�%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%Tr-Rand�����ɵ��������Ӱٷֱ�
scheduling_raise_R_R = (schedulable_ratio_new - schedulable_ratio_tra);
%%%%%%Tr-Rand-DM�����ɵ��������Ӱٷֱ�
scheduling_raise_DM_R = (schedulable_ratio_new_DM - schedulable_ratio_tra_DM);
%%%%%%Tr-Rand-DM-WF�����ɵ��������Ӱٷֱ�
scheduling_raise_tra_DM_WF = (schedulable_ratio_new_DM_WF - schedulable_ratio_tra_DM_WF);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%�������㣬��ʼ��ͼ%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%��ͳͼ��
figure 
plot(utilization_range,R_average_tra,'b-o');
hold on;
plot(utilization_range,R_average_new,'r-*');
hold on;
plot(utilization_range,R_average_tra_DM,'g-x');
hold on;
plot(utilization_range,R_average_new_DM,'k-s');
hold on;
plot(utilization_range,R_average_tra_DM_WF,'c-p');
hold on;
plot(utilization_range,R_average_new_DM_WF,'m-v');


% title('��������Ӧʱ��ƽ��ֵ');
xlabel('The total utilization of DAG task sets');
ylabel('The average response time of DAG task sets');
gca=legend('Tr-Rand','New-Rand','Tr-DM','New-DM','Tr-DM-WF','New-DM-WF'); 
set(gca,'Position',[0.69,0.705,0.2,0.2]);

figure 
plot(utilization_range,schedulable_ratio_tra,'b-o');
hold on;
plot(utilization_range,schedulable_ratio_new,'r-*');
hold on;
plot(utilization_range,schedulable_ratio_tra_DM,'g-x');
hold on;
plot(utilization_range,schedulable_ratio_new_DM,'k-s');
hold on;
plot(utilization_range,schedulable_ratio_tra_DM_WF,'c-p');
hold on;
plot(utilization_range,schedulable_ratio_new_DM_WF,'m-v');


% title('���񼯿ɵ�����ƽ��ֵ');
xlabel('The total utilization of DAG task sets');
ylabel('The schedulable ratio of DAG task sets(%)');
gca=legend('Tr-Rand','New-Rand','Tr-DM','New-DM','Tr-DM-WF','New-DM-WF'); 
set(gca,'Position',[0.68,0.7,0.2,0.2]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%��ͬ�㷨�ֿ���ͼ
%%%%%��������������ȼ����
figure 
plot(utilization_range,R_average_tra,'b-o');
hold on;
plot(utilization_range,R_average_new,'r-*');

xlabel('The total utilization of DAG task sets');
ylabel('The average response time of DAG task sets');
gca=legend('Tr-Rand','New-Rand'); 
set(gca,'Position',[0.7,0.725,0.2,0.2]);

figure 
plot(utilization_range,schedulable_ratio_tra,'b-o');
hold on;
plot(utilization_range,schedulable_ratio_new,'r-*');

xlabel('The total utilization of DAG task sets');
ylabel('The schedulable ratio of DAG task sets(%)');
gca=legend('Tr-Rand','New-Rand'); 
set(gca,'Position',[0.68,0.7,0.2,0.2]);
%%%%%���ȼ�DM�����������
figure
plot(utilization_range,R_average_tra_DM,'g-x');
hold on;
plot(utilization_range,R_average_new_DM,'k-s');

xlabel('The total utilization of DAG task sets');
ylabel('The average response time of DAG task sets');
gca=legend('Tr-DM','New-DM'); 
set(gca,'Position',[0.7,0.725,0.2,0.2]);

figure
plot(utilization_range,schedulable_ratio_tra_DM,'g-x');
hold on;
plot(utilization_range,schedulable_ratio_new_DM,'k-s');

xlabel('The total utilization of DAG task sets');
ylabel('The schedulable ratio of DAG task sets(%)');
gca=legend('Tr-DM','New-DM'); 
set(gca,'Position',[0.68,0.7,0.2,0.2]);
%%%%%%%%%%%%%%%%%WF���䴦������DM�������ȼ�
figure
plot(utilization_range,R_average_tra_DM_WF,'c-p');
hold on;
plot(utilization_range,R_average_new_DM_WF,'m-v');

xlabel('The total utilization of DAG task sets');
ylabel('The average response time of DAG task sets');
gca=legend('Tr-DM-WF','New-DM-WF'); 
set(gca,'Position',[0.69,0.725,0.2,0.2]);

figure
plot(utilization_range,schedulable_ratio_tra_DM_WF,'c-p');
hold on;
plot(utilization_range,schedulable_ratio_new_DM_WF,'m-v');

xlabel('The total utilization of DAG task sets');
ylabel('The schedulable ratio of DAG task sets(%)');
gca=legend('Tr-DM-WF','New-DM-WF'); 
set(gca,'Position',[0.68,0.7,0.2,0.2]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%����ʱ����ͼ
figure 
plot(utilization_range,execution_time_tra,'b-o');%��λ���ms
hold on;
plot(utilization_range,execution_time_new,'r-*');
hold on;
plot(utilization_range,execution_time_tra_DM,'g-x');
hold on;
plot(utilization_range,execution_time_new_DM,'k-s');
hold on;
plot(utilization_range,execution_time_tra_DM_WF,'c-p');
hold on;
plot(utilization_range,execution_time_new_DM_WF,'m-v');


xlabel('The total utilization of DAG task sets');
ylabel('The average analysis time of DAG task sets(/ms)');
gca=legend('Tr-Rand','New-Rand','Tr-DM','New-DM','Tr-DM-WF','New-DM-WF'); 
set(gca,'Position',[0.65,0.65,0.2,0.2]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%��ͬά�ȶԱ�ͼ
%%%%%%%%%%%%%%%%%%%%%����ʱ�䣬��Ӧʱ��任���ɵ����ʱ仯�Ա���״ͼ

figure
yyaxis left
b1 = bar(utilization_range,[response_reduce_percent_R_R;response_reduce_percent_DM_R;response_reduce_percent_DM_WF]');
b1(1).FaceColor = [0/255 130/255 200/255];
b1(2).FaceColor = [255/255 100/255 0/255];
b1(3).FaceColor = [255/255 200/255 0/255];
hold on;
b2 = bar(utilization_range,[scheduling_raise_R_R;scheduling_raise_DM_R;scheduling_raise_tra_DM_WF]');
b2(1).FaceColor = [58/255 186/255 45/255];
b2(2).FaceColor = [165/255 55/255 212/255];
b2(3).FaceColor = [255/255 0/255 0/255];
xlabel('The total utilization of DAG task sets');
ylabel('The increased percentage of the RRC over the traditional(%)');
ylim([-20 50]);

yyaxis right
plot(utilization_range,time_raise_tra,'b-*');
hold on;
plot(utilization_range,time_raise_tra_DM,'r-v');
hold on;
plot(utilization_range,time_raise_tra_DM_WF,'g-o');
ylim([-20 50]);
xlabel('The total utilization of DAG task sets');
ylabel('The increased value of analysis time(/ms)');
gca=legend('Response time of scenarios 1','Response time of scenarios 2','Response time of scenarios 3'...
    ,'Schedulable ratio of scenarios 1','Schedulable ratio of scenarios 2','Schedulable ratio of scenarios 3'...
    ,'Increased time of scenarios 1','Increased time of scenarios 2','Increased time of scenarios 3'); 
set(gca,'Position',[0.6,0.64,0.2,0.2]);








