% %% 1DOF using ODE45 and Simscape
% clc;
% clear;
% clf;
% 
% %% Parameters
% m = 1; % kg
% b = 2; % Ns/m
% k = 50; % N/m
% 
% F0 = 1; % N
% omega = 5; % rad/s
% 
% x0 = -0.5;
% v0 = 0;
% 
% %% ODE
% time_range = 0:1e-2:5; % [s] time
% initial_conditions = [x0, v0];
% [T, X] = ode45(@(t,x) ODE_DOF1(m,b,k,x), time_range, initial_conditions);
% 
% %% plot
% figure(1);
% plot(T,X);
% xlabel('time [s]')
% ylabel('x [m], x_dot [m/s]')
% grid on, grid minor





%% 1DOF using ODE45 and Simscape
clc;
clear;
clf;

%% Parameters
m = 1; % kg
b = 2; % Ns/m
k = 50; % N/m

F0 = 1; % N
omega = 5; % rad/s

x0 = 0;
v0 = 0;

%% ODE
time_range = 0:1e-2:10; % [s] time
initial_conditions = [x0, v0];
[T, X] = ode45(@(t,x) ODE_DOF1(m,b,k,x, F0, omega, t), time_range, initial_conditions);

%% plot
figure(1);
plot(T,X);
xlabel('time [s]')
ylabel('x [m], x_dot [m/s]')
grid on, grid minor