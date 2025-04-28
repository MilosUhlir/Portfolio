%% 1 DOF system - TF, SS
clc; clear all; 
% close all;

%% parameters
m = 1; %kg
b = 2; % N*s/m 
k = 50; % N/m
F0 = 1; % N
omega = 5; % rad/sec

%% initial conditions
x0 = 0; % m
v0 = 0; % m/s

%% Transfer function
num = [1];
den = [m, b, k];
TF1DOF = tf(num, den);

bode_opt = bodeoptions('cstprefs');
bode_opt.FreqScale = 'linear';
bode_opt.FreqUnits = 'Hz';
bode_opt.MagScale = 'linear';
bode_opt.MagUnits = 'abs';

freq_bode = 2*pi*linspace(0,3,1000);

figure(1);
bode(TF1DOF, freq_bode, bode_opt)
grid on;
% grid minor;

%% State-Space System
[A1, B1, C1, D1] = tf2ss(num, den);
DOF1TF = ss(A1, B1, C1, D1);

A2 = [0   , 1;
      -k/m, -b/m];
B2 = [0; 1/m];
C2 = eye(2,2);
D2 = zeros(2,1);
DOF1SS = ss(A2, B2, C2, D2);

%%
sim = sim(Cv_8_simulink);

data = out.simout.Data;
time = out.simout.Time;

figure(2);
plot(time, data)
grid on;
% grid minor;









%%


