clear; clc;


%% zadané hodnoty
l = 0.3; % 30 cm
m_r = 2; % kg - hmotnost ramene
m_b = 1*0.4; % 400 g - maximální hmotnost břemene
k = 1480; % Nm/rad
omega = 0*0.5; % rad/s


%% volené hodnoty
b = 0.5;

%% předběžné výpočty
m = m_r + m_b;

% moment setrvačnosti
J_r = (1/3) * m_r * l^2;
J_b = m_b * l^2;
J = J_r + J_b;

% vlastní frekvence
omega_0 = sqrt(k/J);
f_0 = omega_0 / (2*pi);

%% Zatížení v tečném směru statickou silou
F = 10;     % N
M = F * l;  % statické zatížení silou 10 N*m
% při statické síle vzniká statická výchylka
% při dynamické síle (sinusový profil) vznikne přechodový děj
% s následujícím kmitáním o budící frekvencidané síly

%% Radiální síla v ložisku
w = 2*pi*120/60; % rad/s
an = w^2*l/2; % m/s^2

F_loz_min = m_r*an; % síla v ložisku bez břemene
F_loz_max = F_loz_min + m*w^2*l; % síla v ložisku s břemenem

alpha = 5; % rad/s
f_loz_rozbeh = m_r*alpha*l/2 + m*alpha*l; %síla při rozběhu

%% Druhá část
J_p = 1.5e-5;       % kg/m^2
i = 30;             % převodový poměr
J;                  % selkový moment setrvačnosti

Mz = m_r*l/2 + m*l;
P = Mz*w;           % výkon

R = 20;
L = 2.75e-5;
cfi = 0.1;
b_mot = 3.5077e-6;

%% Stavový model
b1 = b_mot;
b2 = b;
k;

A =  [0,     1,      0,      0,            0;
      -k/J,  -b2/J,  k/J,    b2/J,         i*cfi/J;
      0,     0,      0,      1/i,          0;
      k/J_p, b2/J_p, -k/J_p, -(b1+b2)/J_p, cfi/J_p;
      0,     0,      0,      -cfi/L,       -R/L];

B = [0 0 0 0 1/L]';
C = eye(5);
D = zeros(5,1);