%% 1 DOF simulation
clc; clear all; %clf; %close all;

%% simulation
timespan = 500; % simulation time in seconds
out = sim("Cv_7_simulink_model.slx", timespan);

%% damping
omega_0 = sqrt(k/m);
freq_0 = omega_0 / (2*pi)
delta = b / (2*m);
bp = delta / omega_0

%% plot
time = out.simout.Time;
x = out.simout.Data;

%figure;
plot(time, x)
xlabel('time [s]')
ylabel('x, x_dot')
legend('x [m]', 'v [m/s]')
grid on;
grid minor;