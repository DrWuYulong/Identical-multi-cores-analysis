function longest_len = find_longest_len(path,sub_c)
% function [longest_len,index] = find_longest_len(path,sub_c)
%longest_len表示最长的路径值，index表示这条路径是第几条。
%path 表示路径的元胞数组，包含了所有路径信息，sub_c是该任务所有子任务的WCET
    longest_len = 0;%初始值最长路径设为0
%     index = 1;
    l = length(path);%l储存共有多少条路径
    for i = 1:l
        current_len = sum(sub_c(path{i}));
        if current_len > longest_len
            longest_len = current_len;
%             index = i;
        end
    end  

end