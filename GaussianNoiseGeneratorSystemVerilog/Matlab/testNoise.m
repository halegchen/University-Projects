clear all; clc; close all;

a = [];
data = textread('../sim/noise.txt','%s');
data = cell2mat(data);
for i = 1:1024
    if str2num(data(i,1)) == 1 %negtive numbers
        for j = 1:24
            if str2num(data(i,j)) == 0 
                data(i,j) = '1';
            else
                data(i,j) = '0'; 
            end
        end
        a = [a, -(bin2dec(data(i,2:24))+1)];
    else %positive numbers
        a = [a, bin2dec(data(i,2:24))];
    end
end
a = a./2^16;
hist(a)    