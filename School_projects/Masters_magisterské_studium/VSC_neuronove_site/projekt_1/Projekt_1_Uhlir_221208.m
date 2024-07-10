clear all; clc;


% INPUT:
%
% xx = [x1, x2]

x1 = randi([-4, 4], 1);
x2 = randi([-4, 4], 1);
xx = [x1, x2]
[y] = shubert(xx)