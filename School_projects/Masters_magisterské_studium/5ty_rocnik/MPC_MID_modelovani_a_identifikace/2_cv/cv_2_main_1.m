clear all; clc; close all;


%%

t = 0:0.01:20;
u = ones(size(t));
y = cviceni02_1(u, t);


% zobrazení charakteristiky systému
figure(1)
plot(t, y);
hold on

% dopravní zpoždění
I = find(y>0, 1)
if I == 1
    I = 2
end


% zesílení systému
K = mean(y(end-2: end))

% aproximace derivace
d = ( y(I) - y(I-1) ) / ( t(I) - t(I-1) )

%časová konstanta
T = K / d

% systém
p = tf('p');
F = K/(T*p+1);

%step(F);
yv = lsim(F, u, t);
plot(t, yv);