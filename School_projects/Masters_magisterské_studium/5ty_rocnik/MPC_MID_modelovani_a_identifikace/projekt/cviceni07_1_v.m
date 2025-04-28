clear
% close all
clc
clf


u = ones(1575,1);u(1:5)=0;u(100:200)=0;u(350:425)=-1;u(605:725)=0;u(900:1025)=-1;u(1200:1300)=0;u(1400:end)=0;  % vstupni signal - data pro validaci
t = 0:length(u)-1;
y0 = zeros(length(u),1);
for k = 2:length(u)     % Vystup ze systemu bez sumu pro validaci
    y0(k) = 0.1535*u(k-1) + 0.8465*y0(k-1);
end

uw = idinput(length(u),'prbs',[0 0.04],[-3 3]);     % vstupni signal pro identifikaci - PRBS delky u vzorku s frekveni 0.05 a velikosti [-3 3]                           
e = randn(length(u),1);     % chyba - bily sum
y1 = zeros(length(u),1); 
yb = zeros(length(u),1); 
for k = 2:length(u)         % y1 - vystup pro identifikaci, y2 - vystup bez sumu pro vykresleni
    y1(k) = 0.1535*uw(k-1) + 0.8465*y1(k-1) + 0.523*e(k) + 0.351*e(k-1);
    yb(k) = 0.1535*uw(k-1) + 0.8465*yb(k-1);
end

figure(1)
subplot(4,1,1)
hold on
plot(t,uw,'k',t,y1,'b',t,yb,'g')
ylim([-6 6]);
legend('Vstup','Zasumeny vystup','Vystup bez sumu' ,'Location','NorthEast')
title('Odezva systemu')

%% Klasicka MNC
k = 2:length(uw);
PHI = [-y1(k-1), uw(k-1)];      % vektor pozorovani
Y = y1(k);
TH = PHI \ Y

y2 = zeros(size(u));
for k = 2:length(u)
    y2(k) = TH(2)*u(k-1) - TH(1)*y2(k-1);
end
subplot(4,1,2)
hold on
plot(t,u,'k',t,y2,'b',t,y0,'r')
ylim([-2 2]);
legend('Vstup','Odhad','Skutecny' ,'Location','NorthEast')
title('Klasicka MNC')

%% MNC s zpozdenymi pozorovanimi
k = 4:length(uw);
d = 2; % zpozdeni
PHI2 = [-y1(k-1), uw(k-1)];     % vektor pozorovani
DZ = [-y1(k-1-d), uw(k-1)];     % vektor zpozdenych pozorovani
Y = y1(k);
TH2 = (DZ'*PHI2)\(DZ'*Y)

y3 = zeros(size(u));
for k = 2:length(u)
    y3(k) = TH2(2)*u(k-1) - TH2(1)*y3(k-1);
end
subplot(4,1,3)
hold on
plot(t,u,'k',t,y3,'b',t,y0,'r')
ylim([-2 2]);
legend('Vstup','Odhad','Skutecny' ,'Location','NorthEast')
title('MNC se zpozdenymi pozorovanimi')

%% MNC s dodatecnym modelem
% zjisteni pocatecnich parametru klasickou mnc
k = 2:length(uw);
PHI = [-y1(k-1), uw(k-1)];
Y = y1(k);
THivm = PHI \ Y

yivm = zeros(size(uw));
for k = 3:length(uw)
    yivm(k) = THivm(2)*uw(k-1) - THivm(1)*yivm(k-1);
end
% vlastni metoda pomocnych promenych s dodatecnim modelem
k = 2:length(uw);
PHI = [-y1(k-1), uw(k-1)];      % vektor pozorovani
DZ = [-yivm(k-1), uw(k-1)];
Y = y1(k);
TH4 = (DZ'*PHI)\(DZ'*Y)

y4 = zeros(size(u));
for k = 2:length(u)
    y4(k) = TH4(2)*u(k-1) - TH4(1)*y4(k-1);
end
subplot(4,1,4)
hold on
plot(t,u,'k',t,y4,'b',t,y0,'r')
ylim([-2 2]);
legend('Vstup','Odhad','Skutecny' ,'Location','NorthEast')
title('MNC s dodatecnym modelem')


%% REKURZIVNI METODY %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% P0 = 1e5*eye(2,2);      % inicializace kovarincni matice
% th0 = [0, 1]';          % inicializace vektoru neznamych parametru
% 
% % RMNC
% THr0m = cv7rmncp0 (uw,y1,P0,th0);
% THr0 = [THr0m(1,end); THr0m(2,end);]
% 
% y5 = zeros(size(u));
% for k = 2:length(u)
%     y5(k) = THr0(2)*u(k-1) - THr0(1)*y5(k-1);
% end
% figure(2)
% subplot(3,1,1)
% hold on
% plot(t,u,'k',t,y5,'b',t,y0,'r')
% ylim([-2 2]);
% legend('Vstup','Odhad','Skutecny' ,'Location','NorthEast')
% title('RMNC')
% 
% % RMNC s zpozdenymi pozorovanimi
% THr1m = cv7rmncp1 (uw,y1,P0,th0);
% THr1 = [THr1m(1,end); THr1m(2,end);]
% 
% y6 = zeros(size(u));
% for k = 2:length(u)
%     y6(k) = THr1(2)*u(k-1) - THr1(1)*y6(k-1);
% end
% figure(2)
% subplot(3,1,2)
% hold on
% plot(t,u,'k',t,y6,'b',t,y0,'r')
% ylim([-2 2]);
% legend('Vstup','Odhad','Skutecny' ,'Location','NorthEast')
% title('RMNC se zpozdenymi pozorovanimi')
% 
% % RMNC s dodatecnym modelem
% THr2m = cv7rmncp2 (uw,y1,yivm,P0,th0);
% THr2 = [THr2m(1,end); THr2m(2,end);]
% 
% y7 = zeros(size(u));
% for k = 2:length(u)
%     y7(k) = THr2(2)*u(k-1) - THr2(1)*y7(k-1);
% end
% figure(2)
% subplot(3,1,3)
% hold on
% plot(t,u,'k',t,y7,'b',t,y0,'r')
% ylim([-2 2]);
% legend('Vstup','Odhad','Skutecny' ,'Location','NorthEast')
% title('RMNC s dodatecnym modelem')