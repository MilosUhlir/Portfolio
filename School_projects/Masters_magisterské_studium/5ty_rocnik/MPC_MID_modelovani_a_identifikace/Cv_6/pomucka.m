% close all
clear
clc

u = 20*ones(1000,1);u(100:200)=0;u(300:350)=0;u(400:450)=0;u(550:600)=0;u(700:750)=0;u(800:850)=0;u(900:950)=0;  % vtupni signal
Ts = 1;
t = 0:Ts:length(u)-1;

y = cviceni06_1(u,t);   % ziskani vystupniho signalu

figure(10)
plot(t,u,t,y)
legend('u', 'y')

P0 = 1e5*eye(4,4);      % inicializace kovariancni matice
th0 = [0 0 1 0]';       % inicializace vektoru neznamych parametru
lbd0 = 0.95;            % inicializace koef. zapominani

%% VYTVORTE FUNKCE PRO VYPOCET ALGORITMU RMNC !!! %% 
TH1 = rmnc1 (u,y,P0,th0);            % RMNC
TH2 = rmnc2 (u,y,P0,th0,lbd0);       % RMNC + staticky koeficient expononcialniho zapominani
[TH3, LBD] = rmnc3 (u,y,P0,th0,lbd0); % RMNC + promenny koeficient expononcialniho zapominani
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1)   % prubehu vyvoje identifikovanych parametru
subplot(3,1,1)
plot(t,TH1(1,:),t,TH1(2,:),t,TH1(3,:),t,TH1(4,:))
legend('a1','a2','b1','b2')
title('Parametry soustavy')
subplot(3,1,2)
plot(t,TH2(1,:),t,TH2(2,:),t,TH2(3,:),t,TH2(4,:))
legend('a1','a2','b1','b2')
title('Parametry soustavy - staticky koef. zapominani')
subplot(3,1,3)
plot(t,TH3(1,:),t,TH3(2,:),t,TH3(3,:),t,TH3(4,:))
legend('a1','a2','b1','b2')
title('Parametry soustavy - exponencialni zapominani')

y1 = zeros(size(u));    % vypocet vystupu modelu
y1(1) = 0 + 0 + 0 + 0;
y1(2) = -y1(1)*TH1(1,2) + 0 + u(1)*TH1(3,2) + 0;
for k = 3:1:length(u)
    y1(k) = -y1(k-1)*TH1(1,k) - y1(k-2)*TH1(2,k) + u(k-1)*TH1(3,k) + u(k-2)*TH1(4,k);
end
y2 = zeros(size(u));
y2(1) = 0 + 0 + 0 + 0;
y2(2) = -y2(1)*TH2(1,2) + 0 + u(1)*TH2(3,2) + 0;
for k = 3:1:length(u)
    y2(k) = -y2(k-1)*TH2(1,k) - y2(k-2)*TH2(2,k) + u(k-1)*TH2(3,k) + u(k-2)*TH2(4,k);
end
y3 = zeros(size(u));
y3(1) = 0 + 0 + 0 + 0;
y3(2) = -y3(1)*TH3(1,2) + 0 + u(1)*TH3(3,2) + 0;
for k = 3:1:length(u)
    y3(k) = -y3(k-1)*TH3(1,k) - y3(k-2)*TH3(2,k) + u(k-1)*TH3(3,k) + u(k-2)*TH3(4,k);
end

figure(2)       % srovnani vystupu soustavy a modelu
subplot(4,1,1)
plot(t,u)
title('Vstupni data')
subplot(4,1,2)
plot(t,y1,'b',t,y,'r')
legend('model','soustava')
title('Porovnani soustavy a identifikovaneho modelu')
subplot(4,1,3)
plot(t,y2,'b',t,y,'r')
legend('model','soustava')
title('Porovnani  - staticky koef. zapominani')
subplot(4,1,4)
plot(t,y3,'b',t,y,'r')
legend('model','soustava')
title('Porovnani  - exponencialni zapominani')

figure(3)
plot(t,LBD,'k')
grid on
axis([0 1000 0.9 1])
legend('LBD')
title('Exponencialni zapominani')