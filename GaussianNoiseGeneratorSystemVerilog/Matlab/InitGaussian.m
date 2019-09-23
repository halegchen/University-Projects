clear all; clc; close all;

N = 1024/2;

u1 = rand([N 1]);
u2 = rand([N 1]);

z1 = sqrt(-2*log(u1)).*cos(2*pi*u2);
z2 = sqrt(-2*log(u1)).*sin(2*pi*u2);

z = [z1;z2];
%z = (z+abs(min(z)))./(max(z)-min(z));
figure;
hist(z);

gua = randn([1000 1]);
gua = (gua+abs(min(gua)))./(max(gua)-min(gua));
figure;
hist(gua);

z_data = dec2hex(floor(z*2^24), 6);
z_data = string(z_data(:, 2:7));
%xlswrite('InitGaussian.xlsx',z_data);



