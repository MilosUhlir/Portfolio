clear;
clc;

J = 3e-6;
b= 3.5e-6;
K = 0.02;
R = 4;
L = 2.7e-6;

%% přenos motoru
s = tf('s');
G_motor = K / (s*((J*s + b)*(L*s + R) + K^2));

%% prenos PID -----------
Kp = 20;
Ki = 10;
% Kd = ;




%% stavový systém
A = [0 1 0;
    0 -b/J K/J;
    0 -K/L -R/L];
B = [0;
    0;
    1/L];
C = [1 0 0];
D = 0;
sss = ss(A,B,C,D);  % State-Space-System

%% LQR regulátor
LQR_Q = 10*eye(3);  % penalizace stavu
LQR_R = 0.1;        % penalizace energie
[LQR_K,~,~] = lqr(sss, LQR_Q, LQR_R);

sss_closed = ss(A-B*LQR_K,B,C,D);


% pocatecni podminky
t = 0:0.01:10;
x0 = [1;0;0];
% pozadovana poloha - desired value xd
xd = 3;
% ud - vypocteny vstup dle xd
ud = -inv(C * inv(A - B * LQR_K) * B) * xd;
u = ud * ones(size(t));
[ini_yOut, ini_tOut, ini_xOut] = lsim(sss_closed,u,t,x0);

plot(ini_tOut, ini_xOut(:,1), 'k'); hold on;    % poloha
plot(ini_tOut, ini_xOut(:,2), 'r');
yline(xd(1),'--k'); grid on












