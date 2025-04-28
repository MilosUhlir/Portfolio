clear;
clc;
clf;
% close all
% rng default % pro testování je nastavený generátor náhodných čísel na default


n = 2000; % počet vzorků

id = 221208;
% id = 999999;
% id = 100000;

a = -1;
b = 3;
u = a:((b-a)/n):b; % rampa s n-vzorky od -1 do 2 pro určení nelinearity
u = u';

t = 0:length(u)-1; % časový vektor


%% test nelinearity
% y_test = odezva_2024(id, u, t');
% y = max(y_test)
% y_max = y*ones(n+1,1);
% % nelinearita má saturaci blížící se hodnotě 1
% % při vstupu v okolí hodnoty 1.18 začíná výstup opět klesat
% 
% % plot nelinearity
% figure(3)
% plot(t,u,'k',t,y_test,'b',t,y_max,'r')
% legend('Vstup','Výstup','Maximum')
% title('Test nelinearity systému')


%% příprava dat
% r = 0.01 + (0.02 - 0.01) * rand();    % generátor náhodnosti frekvence PRBS signálu
r = 0.01;   % frekvence PRBS signálu

% generace PRBS signálu
uw = idinput(n+1,'prbs',[0 r],[-1 1]);

% získání odezvy systému na PRBS signál
y0 = odezva_2024(id, uw, t');

figure(1)
% plot odezvy systému na PRBS signál
subplot(4,1,1)
plot(t,uw,'k',t,y0,'b')
legend('Vstup','Výstup')
title('Odezva systému na PRBS signál')

%% MNC

u1 = uw;
y1 = y0;
PHI1 = [0,0];
u1_sep = [0]; y1_sep = [0];

% separace dat pro MNČ
for k = 2:length(y1)
    if y1(k-1) == 0
        k = k+2;
    else
        u1_sep(end+1) = u1(k-1);
        y1_sep(end+1) = y1(k-1);
        PHI1(k,:) = [-y1(k-1), u1(k-1)];
    end
end

% separovaná data pro ident toolbox
divider = 0.7*length(y1_sep);
y_sep_work = y1_sep(1:divider);
u_sep_work = u1_sep(1:divider);
y_sep_val = y1_sep(divider+1:end);
u_sep_val = u1_sep(divider+1:end);


k = 1:length(uw);
Y = y1(k);
TH1 = PHI1 \ Y

% simulace modelu
y_mnc = zeros(size(uw));
for k = 2:length(uw)
    y_mnc(k) = -TH1(1)*y_mnc(k-1) + TH1(2)*uw(k-1);
end

% plot modelu získaného pomocí obyčejné MNČ
subplot(4,1,2)
plot(t,uw,'k',t,y_mnc,'b',t,y0,'r')
legend('Vstup','Odhad','Realný')
title('Obyčejná MNC')


%% MNČ s zpožděnými pozorováními

u2 = uw;
y2 = y0;
d = 2; % zpoždění
PHI = [0,0];
DZ = [0,0];

% separace dat pro MNČ s zpožděnými pozorováními
for k = 4:length(y2)
    if y2(k-1) == 0
        k = k+2;
    else
        PHI(k,:) = [-y2(k-1), u2(k-1)];
        DZ(k,:) = [-y2(k-1-d), u2(k-1)];
    end
end
k = 1:length(uw);
Y = y2(k);
TH2 = (DZ'*PHI)\(DZ'*Y)

% simulace modelu
y_mnc_zp = zeros(size(uw));
for k = 2:length(uw)
    y_mnc_zp(k) = - TH2(1)*y_mnc_zp(k-1) + TH2(2)*u2(k-1);
end

% plot modelu získaného pomocí MNČ s zpožděnými pozorováními
subplot(4,1,3)
plot(t,uw,'k',t,y_mnc_zp,'b',t,y0,'r')
legend('Vstup','Odhad','Realný')
title('MNC se zpozdenymi pozorovanimi')


%% MNC s dodatecnym modelem
u3 = uw;
y3 = y0;
PHI = [0,0];

% separace dat
for k = 3:length(y3)
    if y3(k-1) == 0
        k = k+2;
    else
        PHI(k,:) = [-y3(k-1), u3(k-1)];
    end
end

% zjištění počátečních parametrů obyčejnou MNČ
k = 1:length(uw);
Y = y3(k);
THivm = PHI \ Y


% simulace obyčejnou MNČ
yivm = zeros(size(uw));
for k = 3:length(uw)
    yivm(k) = - THivm(1)*yivm(k-1) + THivm(2)*uw(k-1);
end


% vlastni metoda pomocnych promenych s dodatecnim modelem
PHI = [0,0];
DZ = [0,0];

for k = 2:length(y3)
    if y3(k-1) == 0
        % y1(k:k+2) = [];
        % u1(k-1:k+1) = [];
        k = k+2;
    else
        PHI(k,:) = [-y3(k-1), uw(k-1)];
        DZ(k,:) = [-yivm(k-1), uw(k-1)];
    end
end
k = 1:length(uw);
Y = y3(k);
TH3 = (DZ'*PHI)\(DZ'*Y)

y_mnc_nm = zeros(size(uw));
for k = 2:length(uw)
    y_mnc_nm(k) = - TH3(1)*y_mnc_nm(k-1) + TH3(2)*uw(k-1);
end


% plot
subplot(4,1,4)
plot(t,uw,'k',t,y_mnc_nm,'b',t,y0,'r')
legend('Vstup','Odhad','Realný')
title('MNC s dodatecnym modelem')


%% porovnání MNČ a ident toolboxu

figure(2)

load('Uhlir_project_ident_data.mat')
tf1_sim = sim(tf1, uw);
arx_sim = sim(arx10101, uw);

plot(t,uw,'k'...        % PRBS
    ,t,y0,'r'...        % Reálný výstup
    ,t,y_mnc,'g'...     % MNČ
    ,t,y_mnc_zp,'b'...  % MNČ + Z.P.
    ,t,y_mnc_nm...      % MNČ + N.M.
    ,t,tf1_sim...       % simulace TF z ident toolboxu
    ,t,arx_sim...       % simulace ARX modelu z ident toolboxu
    )
hold on
legend('PRBS'...
     , 'Reálný výstup'...
     , 'MNČ'...
     , 'MNČ + Z.P.'...
     , 'MNČ + N.M.'...
     , 'ident toolbox TF'...
     , 'ident toolbox ARX'...
     ,'Location','northwest')
title('porovnání metod')

