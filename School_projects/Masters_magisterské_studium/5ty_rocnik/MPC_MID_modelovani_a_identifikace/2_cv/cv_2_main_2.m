clear all;
close all;
clc;

t = 0:0.01:30-1;
u = ones(size(t));
y = cviceni02_2(u, t);

% zobrazení charakteristiky systému
figure(1)
plot(t, y);
hold on


%% zvýšení vstupu / lineární systémy

%zvýšení
z = 10000;

u1 = z * ones(size(t));
y1 = cviceni02_2(u1, t);
y1 = y1/z;

% figure(2);
plot(t, y1);

I = find(y1>0.001, 1)
Td = I * ( t(2) - t(1) )





%% více měření

% počet měření
n = 1000;

ys = cviceni02_2(u, t);

for i = 1:n
%     i
    ys = ys + cviceni02_2(u, t);

end

out = ys ./ n;

% figure(3)
plot(t, out);




%% dvě možnosti odstranění šumu

% 1. zvýšit výstup
% nevýhodou je nutnost linearity systému
% dále to systém nemusí vydržet ( např výbuch kondenzátoru při moc vysokém
% vstupu

% 2. průměr z většího množství měření