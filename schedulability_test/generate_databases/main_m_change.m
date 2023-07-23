clear all;
close all;
clc;

% m = [2 4 8 16];%处理器数量
processors_range = 8:2:16;
a = 1000;%同一利用率下的试验组数
numb_v = 12; %一个DAG任务中子任务个数

u = 0.65;%利用率统一固定在0.5
l_m = length(processors_range);%对比m的数量

R_average_tra = zeros(1,l_m);%平均响应时间
R_average_new = R_average_tra;
schedulable_ratio_tra = R_average_tra;%可调度率
schedulable_ratio_new = R_average_tra;
%%%%%%%%%%%%%%%%
R_average_tra_DM = R_average_tra;
R_average_new_DM = R_average_tra;
schedulable_ratio_tra_DM = R_average_tra;%可调度率
schedulable_ratio_new_DM = R_average_tra;
%%%%%%%%%%%%%%%%%
R_average_tra_DM_WF = R_average_tra;
R_average_new_DM_WF = R_average_tra;
schedulable_ratio_tra_DM_WF = R_average_tra;%可调度率
schedulable_ratio_new_DM_WF = R_average_tra;

execution_time_tra = R_average_tra;
execution_time_new = R_average_tra;
execution_time_tra_DM = R_average_tra;
execution_time_new_DM = R_average_tra;
execution_time_tra_DM_WF = R_average_tra;
execution_time_new_DM_WF = R_average_tra;

J = cell(a,1); %用来存放jitter

for m_number = 1:l_m
%%%%%%%利用率从低到高，以0.1为步长递增

%%%%%%%%%%%%%%%%%%加载数据%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    file_path = ['data_base\processors_u-',num2str(u),'\'];
    filename = [file_path num2str(processors_range(m_number)) '_C.mat'];
    load(filename,'C');
    filename = [file_path num2str(processors_range(m_number)) '_T.mat'];
    load(filename,'T');
    filename = [file_path num2str(processors_range(m_number)) '_D.mat'];
    load(filename,'D');
    filename = [file_path num2str(processors_range(m_number)) '_U.mat'];
    load(filename,'U');
    filename = [file_path num2str(processors_range(m_number)) '_topologies.mat'];
    load(filename,'topologies');  
    filename = [file_path num2str(processors_range(m_number)) '_path.mat'];
    load(filename,'path');
    filename = [file_path num2str(processors_range(m_number)) '_processors.mat'];
    load(filename,'processors');

    set_numb = length(C);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%任务参数初始化结束%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%随机处理器分配，随机优先级%%%%%%
    %因为数据是随机生成的所以任务优先级直接从高到低默认排列了
%     tic;
%     R_tra = traditional_method(C,T,D,topologies,processors,path);
%     execution_time_tra(m_number) = toc / set_numb;
%     tic;
%     R_new = new_method(C,T,D,topologies,processors,path);
%     execution_time_new(m_number) = toc / set_numb;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%使用DM对任务进行优先级排序%%%%%%%
    for t1 = 1:set_numb%a个任务集
        task_numb = length(C{t1});
        for t2 = 1:task_numb-1
            for t3 = t2+1:task_numb
                if D{t1}{t3} < D{t1}{t2}%升序排列
                    temp_C = C{t1}{t3};%调换C
                    C{t1}{t3} = C{t1}{t2};
                    C{t1}{t2} = temp_C;
                    temp_T = T{t1}{t3};%调换T
                    T{t1}{t3} = T{t1}{t2};
                    T{t1}{t2} = temp_T;
                    temp_D = D{t1}{t3};%调换D
                    D{t1}{t3} = D{t1}{t2};
                    D{t1}{t2} = temp_D;
                    temp_U = U{t1}{t3};%调换U
                    U{t1}{t3} = U{t1}{t2};
                    U{t1}{t2} = temp_U;
                    temp_topologies = topologies{t1}{t3};%调换拓扑结构
                    topologies{t1}{t3} = topologies{t1}{t2};
                    topologies{t1}{t2} = temp_topologies;
                    temp_processors = processors{t1}{t3};%调换处理器分配
                    processors{t1}{t3} = processors{t1}{t2};
                    processors{t1}{t2} = temp_processors;
                    temp_path = path{t1}{t3};%调换路径
                    path{t1}{t3} = path{t1}{t2};
                    path{t1}{t2} = temp_path;
                end
            end
        end
    end
    
    %%%%%计算jitter%%%%%%
    for j1 = 1:a
        task_numb = length(C{j1});
        for j2 = 1:task_numb
            max_jitter = 0;
            temp_C = C{j1}{j2};
            temp_D = D{j1}{j2};
            temp_processors = processors{j1}{j2};
            for j3 = 1:processors_range(m_number)
                if sum(temp_processors == j3)
                    max_jitter = max(max_jitter,temp_D - sum(temp_C(temp_processors == j3)));
                end
            end
            J{j1}{j2} = max_jitter;
        end
    end
        
    
    %%%%%%计算完毕%%%%%%
    
    
    tic;                
    R_tra_DM = traditional_method(C,T,D,J,topologies,processors,path);
    execution_time_tra_DM(m_number) = toc / set_numb;
    tic;
    R_new_DM = new_method(C,T,D,J,topologies,processors,path);
    execution_time_new_DM(m_number) = toc / set_numb;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%DM优先级，Worst-Fit处理器分配%%%%%%%%%%%%%%%%%
    processors_WF = allocate_processors(processors_range(m_number),numb_v,C,T);%%%%%%%%%%%%%%%%%%%%%%%%%%使用Worst-Fit进行处理器分配
    
    %%%%%计算jitter%%%%%%
    for j1 = 1:a
        task_numb = length(C{j1});
        for j2 = 1:task_numb
            max_jitter = 0;
            temp_C = C{j1}{j2};
            temp_D = D{j1}{j2};
            temp_processors = processors{j1}{j2};
            for j3 = 1:processors_range(m_number)
                if sum(temp_processors == j3)
                    max_jitter = max(max_jitter,temp_D - sum(temp_C(temp_processors == j3)));
                end
            end
            J{j1}{j2} = max_jitter;
        end
    end
        
    
    %%%%%%计算完毕%%%%%%
    
    tic;
    R_tra_DM_WF = traditional_method(C,T,D,J,topologies,processors_WF,path);
    execution_time_tra_DM_WF(m_number) = toc / set_numb;
    tic;
    R_new_DM_WF = new_method(C,T,D,J,topologies,processors_WF,path);
    execution_time_new_DM_WF(m_number) = toc / set_numb;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%后期计算响应时间和可调度率%%%%%%%%%%%%%%%%%%%%%%%%   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %计算当前利用率下响应时间的平均值
    %%%%%传统方法
%     R_tra(R_tra == inf) = [];
%     if isempty(R_tra)
%         R_average_tra(m_number) = 0;
%     else
%         R_average_tra(m_number) = mean(R_tra);
%     end
%     %%%%%新方法
%     R_new(R_new == inf) = [];
%     if isempty(R_new)
%         R_average_new(m_number) = 0;
%     else
%         R_average_new(m_number) = mean(R_new);
%     end
%     
%     %计算当前利用率下的可调度率
%     schedulable_ratio_tra(m_number) = length(R_tra)*100/set_numb;%因为已经将不可调度的任务剔除,转换为百分数
%     schedulable_ratio_new(m_number) = length(R_new)*100/set_numb;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%使用DM进行优先级分配后%%%%%%%%
    %计算当前利用率下响应时间的平均值
    %%%%%传统方法
    R_tra_DM(R_tra_DM == inf,:) = [];
    if isempty(R_tra_DM)
        R_average_tra_DM(m_number) = 0;
    else
        R_average_tra_DM(m_number) = mean(R_tra_DM);
    end
    %%%%%新方法
    R_new_DM(R_new_DM == inf) = [];
    if isempty(R_new_DM)
        R_average_new_DM(m_number) = 0;
    else
        R_average_new_DM(m_number) = mean(R_new_DM);
    end

    %计算当前利用率下的可调度率
    schedulable_ratio_tra_DM(m_number) = length(R_tra_DM)*100/set_numb;%因为已经将不可调度的任务剔除
    schedulable_ratio_new_DM(m_number) = length(R_new_DM)*100/set_numb;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%使用Worst-Fit进行处理器分配后%%%%%%%%
    
    %计算当前利用率下响应时间的平均值
    %%%%%传统方法
    R_tra_DM_WF(R_tra_DM_WF == inf) = [];
    if isempty(R_tra_DM_WF)
        R_average_tra_DM_WF(m_number) = 0;
    else
        R_average_tra_DM_WF(m_number) = mean(R_tra_DM_WF);
    end
    %%%%%新方法
    R_new_DM_WF(R_new_DM_WF == inf) = [];
    if isempty(R_new_DM_WF)
        R_average_new_DM_WF(m_number) = 0;
    else
        R_average_new_DM_WF(m_number) = mean(R_new_DM_WF);
    end

    %计算当前利用率下的可调度率
    schedulable_ratio_tra_DM_WF(m_number) = length(R_tra_DM_WF)*100/set_numb;%因为已经将不可调度的任务剔除
    schedulable_ratio_new_DM_WF(m_number) = length(R_new_DM_WF)*100/set_numb;
   
end

%%%%%%%%%%%%%%%%%%%时间转换成毫秒
execution_time_tra = execution_time_tra*1000;
execution_time_new = execution_time_new*1000;
execution_time_tra_DM = execution_time_tra_DM*1000;
execution_time_new_DM = execution_time_new_DM*1000;
execution_time_tra_DM_WF = execution_time_tra_DM_WF*1000;
execution_time_new_DM_WF = execution_time_new_DM_WF*1000;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%三种分配方法，对应分析时间增加%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%Tr-Rand方法分析时间增加ms
% time_raise_percent_tra = (execution_time_new - execution_time_tra)./execution_time_tra * 100;
% time_raise_tra = (execution_time_new - execution_time_tra);
%%%%%%Tr-Rand-DM方法分析时间增加ms
time_raise_tra_DM = (execution_time_new_DM - execution_time_tra_DM);
%%%%%%Tr-Rand-DM-WF方法分析时间增加ms
time_raise_tra_DM_WF = (execution_time_new_DM_WF - execution_time_tra_DM_WF);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%三种分配方法，对应响应时间减少百分比%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%Tr-Rand方法响应时间减少时间
% response_reduce_percent_R_R = (R_average_new - R_average_tra) ./ R_average_tra * 100;
% response_reduce_percent_R_R(response_reduce_percent_R_R > 0) = NaN;%把传统方法不可调度的排除，不参与比较
%%%%%%Tr-Rand-DM方法响应时间减少时间
response_reduce_percent_DM_R = (R_average_new_DM - R_average_tra_DM) ./ R_average_tra_DM * 100;
response_reduce_percent_DM_R(response_reduce_percent_DM_R > 0) = NaN;
%%%%%%Tr-Rand-DM-WF方法响应时间减少时间
response_reduce_percent_DM_WF = (R_average_new_DM_WF - R_average_tra_DM_WF) ./ R_average_tra_DM_WF * 100;
response_reduce_percent_DM_WF(response_reduce_percent_DM_WF > 0) = NaN;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%三种分配方法，对应可调度率增加百分比%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%Tr-Rand方法可调度率增加百分比
% scheduling_raise_R_R = (schedulable_ratio_new - schedulable_ratio_tra);
%%%%%%Tr-Rand-DM方法可调度率增加百分比
scheduling_raise_DM_R = (schedulable_ratio_new_DM - schedulable_ratio_tra_DM);
%%%%%%Tr-Rand-DM-WF方法可调度率增加百分比
scheduling_raise_tra_DM_WF = (schedulable_ratio_new_DM_WF - schedulable_ratio_tra_DM_WF);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%结束计算，开始作图%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%所有算法总体


figure 
gca = axes;
% bar(1:l_m,[R_average_tra;R_average_new;R_average_tra_DM;R_average_new_DM;R_average_tra_DM_WF;R_average_new_DM_WF]');
bar(1:l_m,[R_average_tra_DM;R_average_new_DM;R_average_tra_DM_WF;R_average_new_DM_WF]');
xlabel('The number of processors');
ylabel('The average WCRT of DAG task sets');
set(gca,'XTickLabel',{'8','10','12','14','16'});
% ax = legend('Tr-Rand','New-Rand','Tr-DM','New-DM','Tr-DM-WF','New-DM-WF');
ax = legend('Tr-DM','RRC-DM','Tr-DM-WF','RRC-DM-WF');
set(ax,'Position',[0.775922331138721 0.693095238095238 0.119417473644886 0.2]);

figure 
gca = axes;
% bar(1:l_m,[schedulable_ratio_tra;schedulable_ratio_new;schedulable_ratio_tra_DM;schedulable_ratio_new_DM;schedulable_ratio_tra_DM_WF;schedulable_ratio_new_DM_WF]');
bar(1:l_m,[schedulable_ratio_tra_DM;schedulable_ratio_new_DM;schedulable_ratio_tra_DM_WF;schedulable_ratio_new_DM_WF]');
xlabel('The number of processors');
ylabel('The acceptance ratio of DAG task sets(%)');
set(gca,'XTickLabel',{'8','10','12','14','16'});
ax = legend('Tr-DM','RRC-DM','Tr-DM-WF','RRC-DM-WF');
set(ax,'Position',[0.775922331138721 0.693095238095238 0.119417473644886 0.2]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%分析时间对比
figure 
gca = axes;
% plot(processors_range,execution_time_tra,'b-o');%单位变成ms
% hold on;
% plot(processors_range,execution_time_new,'r-*');
% hold on;
plot(processors_range,execution_time_tra_DM,'g-x');
hold on;
plot(processors_range,execution_time_new_DM,'k-s');
hold on;
plot(processors_range,execution_time_tra_DM_WF,'c-p');
hold on;
plot(processors_range,execution_time_new_DM_WF,'m-v');
xlim([processors_range(1) processors_range(end)]);
set(gca,'XTick',processors_range);

xlabel('The number of processors');
ylabel('The average analysis time of DAG task sets(/ms)');
gca=legend('Tr-DM','RRC-DM','Tr-DM-WF','RRC-DM-WF'); 
set(gca,'Position',[0.775922331138721 0.693095238095238 0.119417473644886 0.2]);
%%%%%%%%%%%%%%%%%%%%%分析时间，响应时间变换，可调度率变化对比柱状图

figure
yyaxis left
b1 = bar(processors_range,[response_reduce_percent_DM_R;response_reduce_percent_DM_WF]');
b1(1).FaceColor = [255/255 0/255 0/255];
b1(2).FaceColor = [0/255 200/255 15/255];

hold on;
b2 = bar(processors_range,[scheduling_raise_DM_R;scheduling_raise_tra_DM_WF]');
b2(1).FaceColor = [0/255 0/255 255/255];
b2(2).FaceColor = [255/255 120/255 0/255];

xlabel('The number of processors');
ylabel('The increased percentage of the RRC over the traditional(%)');
ylim([-50 100]);

yyaxis right

plot(processors_range,time_raise_tra_DM,'r-v');
hold on;
plot(processors_range,time_raise_tra_DM_WF,'k-o');
ylim([-30 60]);
xlabel('The number of processors');
ylabel('The increased value of analysis time(/ms)');
gca=legend('Response time of scenarios 1','Response time of scenarios 2'...
    ,'Acceptance ratio of scenarios 1','Acceptance ratio of scenarios 2'...
    ,'Increased time of scenarios 1','Increased time of scenarios 2'); 
set(gca,'Position',[0.67830371346723 0.653690479596456 0.215953302435606 0.24404761223566]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%结果写入文件%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
results_path = [file_path 'results\'];
if exist(results_path,'dir') == 0
    mkdir(results_path);
end
%%%%%%%%%%%%%%%%%响应时间
filename = [results_path 'R_average_tra.mat'];
save(filename,'R_average_tra');
filename = [results_path 'R_average_new.mat'];
save(filename,'R_average_new');
filename = [results_path 'R_average_tra_DM.mat'];
save(filename,'R_average_tra_DM');
filename = [results_path 'R_average_new_DM.mat'];
save(filename,'R_average_new_DM');
filename = [results_path 'R_average_tra_DM_WF.mat'];
save(filename,'R_average_tra_DM_WF');
filename = [results_path 'R_average_new_DM_WF.mat'];
save(filename,'R_average_new_DM_WF');
%%%%%%%%%%%%%%%%%%%可调度率
filename = [results_path 'schedulable_ratio_tra.mat'];
save(filename,'schedulable_ratio_tra');
filename = [results_path 'schedulable_ratio_new.mat'];
save(filename,'schedulable_ratio_new');
filename = [results_path 'schedulable_ratio_tra_DM.mat'];
save(filename,'schedulable_ratio_tra_DM');
filename = [results_path 'schedulable_ratio_new_DM.mat'];
save(filename,'schedulable_ratio_new_DM');
filename = [results_path 'schedulable_ratio_tra_DM_WF.mat'];
save(filename,'schedulable_ratio_tra_DM_WF');
filename = [results_path 'schedulable_ratio_new_DM_WF.mat'];
save(filename,'schedulable_ratio_new_DM_WF');
%%%%%%%%%%%%%%%%%%%%分析时间
filename = [results_path 'execution_time_tra.mat'];
save(filename,'execution_time_tra');
filename = [results_path 'execution_time_new.mat'];
save(filename,'execution_time_new');
filename = [results_path 'execution_time_tra_DM.mat'];
save(filename,'execution_time_tra_DM');
filename = [results_path 'execution_time_new_DM.mat'];
save(filename,'execution_time_new_DM');
filename = [results_path 'execution_time_tra_DM_WF.mat'];
save(filename,'execution_time_tra_DM_WF');
filename = [results_path 'execution_time_new_DM_WF.mat'];
save(filename,'execution_time_new_DM_WF');

%%%%%%%%%处理器变化范围
filename = [results_path 'processors_range.mat'];
save(filename,'processors_range');

