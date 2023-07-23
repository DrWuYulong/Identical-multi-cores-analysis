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
p = 0.05;
index_r = 1;%ÿ������������Ӧʱ���������������

%%%%%%%%%%%%%%%%
R_average_tra_DM_R = zeros(1,floor((U_max-U_min)/U_step)+1);%ƽ����Ӧʱ��
R_average_new_DM_R = R_average_tra_DM_R;
schedulable_ratio_tra_DM_R = R_average_tra_DM_R;%�ɵ�����
schedulable_ratio_new_DM_R = R_average_tra_DM_R;
%%%%%%%%%%%%%%%%%
R_average_tra_DM_MACRO = R_average_tra_DM_R;
R_average_new_DM_MACRO = R_average_tra_DM_R;
schedulable_ratio_tra_DM_MACRO = R_average_tra_DM_R;%�ɵ�����
schedulable_ratio_new_DM_MACRO = R_average_tra_DM_R;
%%%%%%%%%%%%%%%%%
R_average_tra_DM_dagP = R_average_tra_DM_R;
R_average_new_DM_dagP = R_average_tra_DM_R;
schedulable_ratio_tra_DM_dagP = R_average_tra_DM_R;%�ɵ�����
schedulable_ratio_new_DM_dagP = R_average_tra_DM_R;
%%%%%%%%%%%%%%%%%%%%%%��ͬ�������²�ͬ�����ķ���ʱ��ƽ��ֵ��
execution_time_tra_DM_R = R_average_tra_DM_R;
execution_time_new_DM_R = R_average_tra_DM_R;
execution_time_tra_DM_MACRO = R_average_tra_DM_R;
execution_time_new_DM_MACRO = R_average_tra_DM_R;
execution_time_tra_DM_dagP = R_average_tra_DM_R;
execution_time_new_DM_dagP = R_average_tra_DM_R;

J = cell(set_numb,1); %�������jitter

for u = U_range
%%%%%%%�����ʴӵ͵��ߣ���0.1Ϊ��������
    u
    %%%%%%%%%%%%%%%%%%%%%%% ���ظ�������
    load_dir = ['../database/R_DM/u_' num2str(u)];
    
    load_C = [load_dir '/C.mat'];
    load_D = [load_dir '/D.mat'];
    load_path = [load_dir '/path.mat'];
    load_processors = [load_dir '/processors.mat'];
    load_T = [load_dir '/T.mat'];
    load_topologies = [load_dir '/topologies.mat'];
    load_U = [load_dir '/U.mat'];

    
    load(load_C);
    load(load_D);
    load(load_path);
    load(load_processors);
    load(load_T);
    load(load_topologies);
    load(load_U);
    
    load_tp = ['../database/MACRO_DM/u_' num2str(u) '/processors.mat'];
    tt = load(load_tp);
    processors_MACRO = tt.processors;

    load_tp = ['../database/dagP_DM/u_' num2str(u) '/processors.mat'];
    tt = load(load_tp);
    processors_WF = tt.processors;
    %%%%%%%%%%%%%%%%%%%%%%%% �������

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%���������ʼ������%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%����jitter%%%%%%
    for j1 = 1:set_numb
        for j2 = 1:task_numb
            max_jitter = 0;
            temp_C = C{j1,j2};
            temp_D = D(j1,j2);
            temp_processors = processors{j1,j2};
            for j3 = 1:m
                if sum(temp_processors == j3)
                    max_jitter = max(max_jitter,temp_D - sum(temp_C(temp_processors == j3)));
                end
            end
%             J{j1,j2} = max_jitter;
            J{j1,j2} = 0;
        end
    end
        
    
    %%%%%%�������%%%%%%
    
    tic;                
    R_tra_DM_R = traditional_method(C,T,D,J,topologies,processors,path,set_numb,task_numb);
    execution_time_tra_DM_R(index_r) = toc / set_numb;
    tic;
    R_new_DM_R = new_method(C,T,D,J,topologies,processors,path,set_numb,task_numb);
    execution_time_new_DM_R(index_r) = toc / set_numb;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%DM���ȼ���MACRO����������%%%%%%%%%%%%%%%%%
%     processors_MACRO = allocate_processors(m,numb_v,C,T);
    %%%%%%%%%%%%%����jitter
    for j1 = 1:set_numb
        for j2 = 1:task_numb
            max_jitter = 0;
            temp_C = C{j1,j2};
            temp_D = D(j1,j2);
            temp_processors = processors{j1,j2};
            for j3 = 1:m
                if sum(temp_processors == j3)
                    max_jitter = max(max_jitter,temp_D - sum(temp_C(temp_processors == j3)));
                end
            end
%             J{j1,j2} = max_jitter;
            J{j1,j2} = 0;
        end
    end
    %%%%%%%%%%%%%%%%%�������
    %%%%%%%%%%%DM���ȼ���MACRO����������%%%%%%%%%%%%%%%%%
    tic;
    R_tra_DM_MACRO = traditional_method(C,T,D,J,topologies,processors_MACRO,path,set_numb,task_numb);
    execution_time_tra_DM_MACRO(index_r) = toc / set_numb;
    tic;
    R_new_DM_MACRO = new_method(C,T,D,J,topologies,processors_MACRO,path,set_numb,task_numb);
    execution_time_new_DM_MACRO(index_r) = toc / set_numb;
    
    %%%%%%%%%%%DM���ȼ���dagP ����������%%%%%%%%%%%%%%%%%
    %%%%%%%%%%
    tic;
    R_tra_DM_dagP = traditional_method(C,T,D,J,topologies,processors_WF,path,set_numb,task_numb);
    execution_time_tra_DM_dagP(index_r) = toc / set_numb;
    tic;
    R_new_DM_dagP = new_method(C,T,D,J,topologies,processors_WF,path,set_numb,task_numb);
    execution_time_new_DM_dagP(index_r) = toc / set_numb;
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%���ڼ�����Ӧʱ��Ϳɵ�����%%%%%%%%%%%%%%%%%%%%%%%%   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ʹ��DM�������ȼ������%%%%%%%%
    %���㵱ǰ����������Ӧʱ���ƽ��ֵ
    %%%%%��ͳ����
    R_tra_DM_R(R_tra_DM_R == inf,:) = [];
    if isempty(R_tra_DM_R)
        R_average_tra_DM_R(index_r) = NaN;
    else
        R_average_tra_DM_R(index_r) = mean(R_tra_DM_R);
    end
    %%%%%�·��� MACRO
    R_new_DM_R(R_new_DM_R == inf) = [];
    if isempty(R_new_DM_R)
        R_average_new_DM_R(index_r) = NaN;
    else
        R_average_new_DM_R(index_r) = mean(R_new_DM_R);
    end

    %���㵱ǰ�������µĿɵ�����
    schedulable_ratio_tra_DM_R(index_r) = length(R_tra_DM_R)*100/set_numb;%��Ϊ�Ѿ������ɵ��ȵ������޳�
    schedulable_ratio_new_DM_R(index_r) = length(R_new_DM_R)*100/set_numb;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ʹ�� MACRO ���д����������%%%%%%%%
    
    %���㵱ǰ����������Ӧʱ���ƽ��ֵ
    %%%%%��ͳ����
    R_tra_DM_MACRO(R_tra_DM_MACRO == inf) = [];
    if isempty(R_tra_DM_MACRO)
        R_average_tra_DM_MACRO(index_r) = NaN;
    else
        R_average_tra_DM_MACRO(index_r) = mean(R_tra_DM_MACRO);
    end
    %%%%%�·���
    R_new_DM_MACRO(R_new_DM_MACRO == inf) = [];
    if isempty(R_new_DM_MACRO)
        R_average_new_DM_MACRO(index_r) = NaN;
    else
        R_average_new_DM_MACRO(index_r) = mean(R_new_DM_MACRO);
    end

    %���㵱ǰ�������µĿɵ�����
    schedulable_ratio_tra_DM_MACRO(index_r) = length(R_tra_DM_MACRO)*100/set_numb;%��Ϊ�Ѿ������ɵ��ȵ������޳�
    schedulable_ratio_new_DM_MACRO(index_r) = length(R_new_DM_MACRO)*100/set_numb;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ʹ�� dagP ���д����������%%%%%%%%
    
    %���㵱ǰ����������Ӧʱ���ƽ��ֵ
    %%%%%��ͳ����
    R_tra_DM_dagP(R_tra_DM_dagP == inf) = [];
    if isempty(R_tra_DM_dagP)
        R_average_tra_DM_dagP(index_r) = NaN;
    else
        R_average_tra_DM_dagP(index_r) = mean(R_tra_DM_dagP);
    end
    %%%%%�·���
    R_new_DM_dagP(R_new_DM_dagP == inf) = [];
    if isempty(R_new_DM_dagP)
        R_average_new_DM_dagP(index_r) = NaN;
    else
        R_average_new_DM_dagP(index_r) = mean(R_new_DM_dagP);
    end

    %���㵱ǰ�������µĿɵ�����
    schedulable_ratio_tra_DM_dagP(index_r) = length(R_tra_DM_dagP)*100/set_numb;%��Ϊ�Ѿ������ɵ��ȵ������޳�
    schedulable_ratio_new_DM_dagP(index_r) = length(R_new_DM_dagP)*100/set_numb;
    
    index_r = index_r + 1;%��������    
end
%%%%%%%%%%%%%%%%%%%ʱ��ת���ɺ���
% execution_time_tra = execution_time_tra*1000;
% execution_time_new = execution_time_new*1000;
execution_time_tra_DM_R = execution_time_tra_DM_R*1000;
execution_time_new_DM_R = execution_time_new_DM_R*1000;
execution_time_tra_DM_MACRO = execution_time_tra_DM_MACRO*1000;
execution_time_new_DM_MACRO = execution_time_new_DM_MACRO*1000;
execution_time_tra_DM_dagP = execution_time_tra_DM_dagP*1000;
execution_time_new_DM_dagP = execution_time_new_DM_dagP*1000;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%���ַ��䷽������Ӧ����ʱ������%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%Tr-Rand��������ʱ������ms
% time_raise_percent_tra = (execution_time_new - execution_time_tra)./execution_time_tra * 100;
% % % % % time_raise_tra = (execution_time_new - execution_time_tra);
%%%%%%Tr-Rand-DM��������ʱ������ms
time_raise_tra_DM = (execution_time_new_DM_R - execution_time_tra_DM_R);
%%%%%%Tr-Rand-DM-MACRO��������ʱ������ms
time_raise_tra_DM_MACRO = (execution_time_new_DM_MACRO - execution_time_tra_DM_MACRO);
time_raise_tra_DM_dagP = (execution_time_new_DM_dagP - execution_time_tra_DM_dagP);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%���ַ��䷽������Ӧ��Ӧʱ����ٰٷֱ�%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%Tr-Rand������Ӧʱ�����ʱ��
% % % % % response_reduce_percent_R_R = (R_average_new - R_average_tra) ./ R_average_tra * 100;
% % % % % response_reduce_percent_R_R(response_reduce_percent_R_R > 0) = NaN;%�Ѵ�ͳ�������ɵ��ȵ��ų���������Ƚ�
%%%%%%Tr-Rand-DM������Ӧʱ�����ʱ��
response_reduce_percent_DM_R = (R_average_new_DM_R - R_average_tra_DM_R) ./ R_average_tra_DM_R * 100;
response_reduce_percent_DM_R(response_reduce_percent_DM_R > 0) = NaN;
%%%%%%Tr-Rand-DM-MACRO������Ӧʱ�����ʱ��
response_reduce_percent_DM_MACRO = (R_average_new_DM_MACRO - R_average_tra_DM_MACRO) ./ R_average_tra_DM_MACRO * 100;
response_reduce_percent_DM_MACRO(response_reduce_percent_DM_MACRO > 0) = NaN;

% response_reduce_percent_DM_WF = (R_average_new_DM_dagP - R_average_tra_DM_dagP) ./ R_average_tra_DM_dagP * 100;
% response_reduce_percent_DM_WF(response_reduce_percent_DM_WF > 0) = NaN;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%���ַ��䷽������Ӧ�ɵ��������Ӱٷֱ�%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%Tr-Rand�����ɵ��������Ӱٷֱ�
% % % % % scheduling_raise_R_R = (schedulable_ratio_new - schedulable_ratio_tra);
%%%%%%Tr-Rand-DM�����ɵ��������Ӱٷֱ�
scheduling_raise_DM_R = (schedulable_ratio_new_DM_R - schedulable_ratio_tra_DM_R);
%%%%%%Tr-Rand-DM-MACRO�����ɵ��������Ӱٷֱ�
scheduling_raise_tra_DM_MACRO = (schedulable_ratio_new_DM_MACRO - schedulable_ratio_tra_DM_MACRO);
% scheduling_raise_tra_DM_WF = (schedulable_ratio_new_DM_dagP - schedulable_ratio_tra_DM_dagP);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% �������� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
save_dir = '../result';
mkdir(save_dir);

save_R_average_tra_DM_R = [save_dir '/R_average_tra_DM_R.mat'];
save(save_R_average_tra_DM_R, 'R_average_tra_DM_R');
save_R_average_new_DM_R = [save_dir '/R_average_new_DM_R.mat'];
save(save_R_average_new_DM_R, 'R_average_new_DM_R');
save_R_average_tra_DM_MACRO = [save_dir '/R_average_tra_DM_MACRO.mat'];
save(save_R_average_tra_DM_MACRO, 'R_average_tra_DM_MACRO');
save_R_average_new_DM_MACRO = [save_dir '/R_average_new_DM_MACRO.mat'];
save(save_R_average_new_DM_MACRO, 'R_average_new_DM_MACRO');
save_R_average_tra_DM_dagP = [save_dir '/R_average_tra_DM_dagP.mat'];
save(save_R_average_tra_DM_dagP, 'R_average_tra_DM_dagP');
save_R_average_new_DM_dagP = [save_dir '/R_average_new_DM_dagP.mat'];
save(save_R_average_new_DM_dagP, 'R_average_new_DM_dagP');

save_schedulable_ratio_tra_DM_R = [save_dir '/schedulable_ratio_tra_DM_R.mat'];
save(save_schedulable_ratio_tra_DM_R, 'schedulable_ratio_tra_DM_R');
save_schedulable_ratio_new_DM_R = [save_dir '/schedulable_ratio_new_DM_R.mat'];
save(save_schedulable_ratio_new_DM_R, 'schedulable_ratio_new_DM_R');
save_schedulable_ratio_tra_DM_MACRO = [save_dir '/schedulable_ratio_tra_DM_MACRO.mat'];
save(save_schedulable_ratio_tra_DM_MACRO, 'schedulable_ratio_tra_DM_MACRO');
save_schedulable_ratio_new_DM_MACRO = [save_dir '/schedulable_ratio_new_DM_MACRO.mat'];
save(save_schedulable_ratio_new_DM_MACRO, 'schedulable_ratio_new_DM_MACRO');
save_schedulable_ratio_tra_DM_dagP = [save_dir '/schedulable_ratio_tra_DM_dagP.mat'];
save(save_schedulable_ratio_tra_DM_dagP, 'schedulable_ratio_tra_DM_dagP');
save_schedulable_ratio_new_DM_dagP = [save_dir '/schedulable_ratio_new_DM_dagP.mat'];
save(save_schedulable_ratio_new_DM_dagP, 'schedulable_ratio_new_DM_dagP');

save_execution_time_tra_DM_R = [save_dir '/execution_time_tra_DM_R.mat'];
save(save_execution_time_tra_DM_R, 'execution_time_tra_DM_R');
save_execution_time_new_DM_R = [save_dir '/execution_time_new_DM_R.mat'];
save(save_execution_time_new_DM_R, 'execution_time_new_DM_R');
save_execution_time_tra_DM_MACRO = [save_dir '/execution_time_tra_DM_MACRO.mat'];
save(save_execution_time_tra_DM_MACRO, 'execution_time_tra_DM_MACRO');
save_execution_time_new_DM_MACRO = [save_dir '/execution_time_new_DM_MACRO.mat'];
save(save_execution_time_new_DM_MACRO, 'execution_time_new_DM_MACRO');
save_execution_time_tra_DM_dagP = [save_dir '/execution_time_tra_DM_dagP.mat'];
save(save_execution_time_tra_DM_dagP, 'execution_time_tra_DM_dagP');
save_execution_time_new_DM_dagP = [save_dir '/execution_time_new_DM_dagP.mat'];
save(save_execution_time_new_DM_dagP, 'execution_time_new_DM_dagP');



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
return
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



% figure;
% plot(U_range,R_average_tra_DM_R,'b:o');
% hold on;
% plot(U_range,R_average_new_DM_R,'r-*');
% hold on;
% plot(U_range,R_average_tra_DM_MACRO,'g:x');
% hold on;
% plot(U_range,R_average_new_DM_MACRO,'k-s');
% hold on;
% plot(U_range,R_average_tra_DM_dagP,'c:p');
% hold on;
% plot(U_range,R_average_new_DM_dagP,'m-v');
% 
% xlim([U_min U_max]);
% xlabel('The utilization of DAG task sets');
% ylabel('The average response time of DAG task sets');
% gca=legend('Tr-DM-R','RRC-DM-R','Tr-DM-MACRO','RRC-DM-MACRO','Tr-DM-dagP','RRC-DM-dagP'); 
% set(gca,'Position',[0.775922331138721 0.693095238095238 0.119417473644886 0.2]);
% 
% 
% figure;
% plot(U_range,schedulable_ratio_tra_DM_R,'b:o');
% hold on;
% plot(U_range,schedulable_ratio_new_DM_R,'r-*');
% hold on;
% plot(U_range,schedulable_ratio_tra_DM_MACRO,'g:x');
% hold on;
% plot(U_range,schedulable_ratio_new_DM_MACRO,'k-s');
% hold on;
% plot(U_range,schedulable_ratio_tra_DM_dagP,'c:p');
% hold on;
% plot(U_range,schedulable_ratio_new_DM_dagP,'m-v');
% 
% 
% xlim([U_min U_max]);
% xlabel('The utilization of DAG task sets');
% ylabel('The acceptance ratio of DAG task sets(%)');
% gca=legend('Tr-DM-R','RRC-DM-R','Tr-DM-MACRO','RRC-DM-MACRO','Tr-DM-dagP','RRC-DM-dagP'); 
% set(gca,'Position',[0.775922331138721 0.693095238095238 0.119417473644886 0.2]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%�������㣬��ʼ��ͼ%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����㷨����
% 
% figure 
% % plot(utilization_range,R_average_tra,'b-o');
% % hold on;
% % plot(utilization_range,R_average_new,'r-*');
% % hold on;
% plot(utilization_range,R_average_tra_DM,'g-x');
% hold on;
% plot(utilization_range,R_average_new_DM,'k-s');
% hold on;
% plot(utilization_range,R_average_tra_DM_dagP,'c-p');
% hold on;
% plot(utilization_range,R_average_new_DM_dagP,'m-v');
% xlim([utilization_range(1) utilization_range(end)]);
% % xlim([0.2 0.8]);
% 
% % title('��������Ӧʱ��ƽ��ֵ');
% xlabel('The total utilization of DAG task sets');
% ylabel('The average response time of DAG task sets');
% gca=legend('Tr-DM','RRC-DM','Tr-DM-WF','RRC-DM-WF'); 
% set(gca,'Position',[0.775922331138721 0.693095238095238 0.119417473644886 0.2]);
% 
% figure 
% % plot(utilization_range,schedulable_ratio_tra,'b-o');
% % hold on;
% % plot(utilization_range,schedulable_ratio_new,'r-*');
% % hold on;
% plot(utilization_range,schedulable_ratio_tra_DM,'g-x');
% hold on;
% plot(utilization_range,schedulable_ratio_new_DM,'k-s');
% hold on;
% plot(utilization_range,schedulable_ratio_tra_DM_dagP,'c-p');
% hold on;
% plot(utilization_range,schedulable_ratio_new_DM_dagP,'m-v');
% xlim([utilization_range(1) utilization_range(end)]);
% % xlim([0.2 0.8]);
% 
% % title('���񼯿ɵ�����ƽ��ֵ');
% xlabel('The total utilization of DAG task sets');
% ylabel('The acceptance ratio of DAG task sets(%)');
% gca=legend('Tr-DM','RRC-DM','Tr-DM-WF','RRC-DM-WF'); 
% set(gca,'Position',[0.775922331138721 0.693095238095238 0.119417473644886 0.2]);
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%����ʱ����ͼ
% figure 
% % plot(utilization_range,execution_time_tra,'b-o');%��λ���ms
% % hold on;
% % plot(utilization_range,execution_time_new,'r-*');
% % hold on;
% plot(utilization_range,execution_time_tra_DM,'g-x');
% hold on;
% plot(utilization_range,execution_time_new_DM,'k-s');
% hold on;
% plot(utilization_range,execution_time_tra_DM_dagP,'c-p');
% hold on;
% plot(utilization_range,execution_time_new_DM_dagP,'m-v');
% xlim([utilization_range(1) utilization_range(end)]);
% % xlim([0.2 0.8]);
% 
% xlabel('The total utilization of DAG task sets');
% ylabel('The average analysis time of DAG task sets(/ms)');
% gca=legend('Tr-DM','RRC-DM','Tr-DM-WF','RRC-DM-WF'); 
% set(gca,'Position',[0.775922331138721 0.693095238095238 0.119417473644886 0.2]);
% %%%%%%%%%%%%%%%%%%%%%����ʱ�䣬��Ӧʱ��任���ɵ����ʱ仯�Ա���״ͼ
% 
% figure;
% yyaxis left
% b1 = bar(utilization_range,[response_reduce_percent_DM_R;response_reduce_percent_DM_WF]');
% b1(1).FaceColor = [255/255 0/255 0/255];
% b1(2).FaceColor = [0/255 200/255 15/255];
% % b1(2).FaceColor = [255/255 200/255 0/255];
% hold on;
% b2 = bar(utilization_range,[scheduling_raise_DM_R;scheduling_raise_tra_DM_WF]');
% b2(1).FaceColor = [0/255 0/255 255/255];
% b2(2).FaceColor = [255/255 120/255 0/255];
% % b2(2).FaceColor = [255/255 0/255 0/255];
% xlabel('The total utilization of DAG task sets');
% ylabel('The increased percentage of the RRC over the traditional(%)');
% ylim([-50 100]);
% 
% yyaxis right
% % plot(utilization_range,time_raise_tra,'b-*');
% % hold on;
% plot(utilization_range,time_raise_tra_DM,'r-v');
% hold on;
% plot(utilization_range,time_raise_tra_DM_dagP,'k-o');
% ylim([-50 100]);
% xlabel('The total utilization of DAG task sets');
% ylabel('The increased value of analysis time(/ms)');
% gca=legend('Response time of scenarios 1','Response time of scenarios 2'...
%     ,'Acceptance ratio of scenarios 1','Acceptance ratio of scenarios 2'...
%     ,'Increased time of scenarios 1','Increased time of scenarios 2'); 
% set(gca,'Position',[0.67830371346723 0.653690479596456 0.215953302435606 0.24404761223566]);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%���д���ļ�%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% results_path = [file_path 'results\'];
% if exist(results_path,'dir') == 0
%     mkdir(results_path);
% end
% 
% % filename = [results_path 'R_average_tra.mat'];
% % save(filename,'R_average_tra');
% % filename = [results_path 'R_average_new.mat'];
% % save(filename,'R_average_new');
% filename = [results_path 'R_average_tra_DM.mat'];
% save(filename,'R_average_tra_DM');
% filename = [results_path 'R_average_new_DM.mat'];
% save(filename,'R_average_new_DM');
% filename = [results_path 'R_average_tra_DM_dagP.mat'];
% save(filename,'R_average_tra_DM_dagP');
% filename = [results_path 'R_average_new_DM_dagP.mat'];
% save(filename,'R_average_new_DM_dagP');
% 
% % filename = [results_path 'schedulable_ratio_tra.mat'];
% % save(filename,'schedulable_ratio_tra');
% % filename = [results_path 'schedulable_ratio_new.mat'];
% % save(filename,'schedulable_ratio_new');
% filename = [results_path 'schedulable_ratio_tra_DM.mat'];
% save(filename,'schedulable_ratio_tra_DM');
% filename = [results_path 'schedulable_ratio_new_DM.mat'];
% save(filename,'schedulable_ratio_new_DM');
% filename = [results_path 'schedulable_ratio_tra_DM_dagP.mat'];
% save(filename,'schedulable_ratio_tra_DM_dagP');
% filename = [results_path 'schedulable_ratio_new_DM_dagP.mat'];
% save(filename,'schedulable_ratio_new_DM_dagP');
% %%%%ִ�з���ʱ��
% % filename = [results_path 'execution_time_tra.mat'];
% % save(filename,'execution_time_tra');
% % filename = [results_path 'execution_time_new.mat'];
% % save(filename,'execution_time_new');
% filename = [results_path 'execution_time_tra_DM.mat'];
% save(filename,'execution_time_tra_DM');
% filename = [results_path 'execution_time_new_DM.mat'];
% save(filename,'execution_time_new_DM');
% filename = [results_path 'execution_time_tra_DM_dagP.mat'];
% save(filename,'execution_time_tra_DM_dagP');
% filename = [results_path 'execution_time_new_DM_dagP.mat'];
% save(filename,'execution_time_new_DM_dagP');
% 
% filename = [results_path 'utilization_range.mat'];
% save(filename,'utilization_range');
% 