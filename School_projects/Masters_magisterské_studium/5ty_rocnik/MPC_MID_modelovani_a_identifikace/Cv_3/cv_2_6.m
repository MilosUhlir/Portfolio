clear all;
% close all;
clc;

mult = 10000;

t = 0:0.01:15;
u = ones(size(t));
y = cviceni02_6(mult*u, t) / mult;

% zobrazení charakteristiky systému
figure(1)
plot(t, y);
hold on

%%

k = mean(y(end-2:end));


%% postup od učitele

% t_1 = t(find(y > 0.72), 1)

% p1 = find(y > k, 1)

I = find(y>0.001, 1);
Td = (I-1)*(t(2)-t(1));


Ta1 = find(y > k, 1);
T_temp = find(y(Ta1:end)<k, 1)+Ta1;
Ta2 = find(y(T_temp:end) > k, 1)+T_temp;

TA = t(Ta2) - t(Ta1);

A1 = max(y);
A2 = max(y(Ta2:end));

A1 = A1 - k;
A2 = A2 - k;



theta = log(A1/A2);

ksi = theta/ sqrt(4*pi^2 + theta^2);

T = (TA / 2*pi) * sqrt(1-ksi^2);

p = tf('p');
F = k/(T^2*p^2 + 2*ksi*T*p + 1) * exp(-Td*p);
% step(F);

yv = lsim(F, u, t);
plot(t, yv)








%% postup ze zadání
% M = (y1 - y2) / y1