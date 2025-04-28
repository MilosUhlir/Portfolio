clear all;
close all;
clc;

t = 0:0.01:30-1;
u = ones(size(t));
y = cviceni02_3(u, t);

% zobrazení charakteristiky systému
figure(1)
plot(t, y);
hold on


%% 1. normalizovat na jednotkové zesílení

y = y/K;
y = y(1);

%% 2. zjištění inflexního bodu

[d, I] = max( diff(y) / t(2) - t(1) )
y_i = y(I)
t_i = t(I)

%% 3. zjištění T_u a T_n

% T_u - průsečík tečny s 0
% T_n - průsečík tečny s 1 - T_u

% y = k * x + q
% y = d * (t - T_u)
% y = d * t - d * T_u
% 0 = -y + d*t - d*T_u

% NO!!
% 1 = -y + d*t - d*T_n


T_u = (y - (d * t)) / d

% T_n = (1 + y - (d * t)) / d
T_n = 1/d

%% 4. tau
tau = T_u / T_n

%% 5. a)
% y_1 = 0.72 -> t_1
t_1 = t(find(y > 0.72), 1)

% (T_1 + T_2) = t_1 / 1.2564

% t_2 = 0.3574 * (T_1 + T_2) -> y_2

% tau_2 = T_2 / T_1




