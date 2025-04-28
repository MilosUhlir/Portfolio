clear all;
close all;
clc;


Ts = 0.1;
t = 0:Ts:20000;

% na vstup se vkládá bílý šum
% aproximuje se PRBS signálem (Pseudo Random Binary Sequence)
N = length(t);

u = idinput(N, 'prbs', [0 1], [-1 1]);

[y, gt, tt] = cviceni03_1(u, t);


% zobrazení v grafu
figure(1)
plot(t, u, t, y);


M = 300;
figure(2)
plot(t(1:M), gt(1:M),'b');
hold on;


%% korelace

R_uy = zeros(M,1);

for i = 1:M
    R_uy_sum = 0;
    for j = 1:N-i
        R_uy_sum = R_uy_sum + u(j) * y(i+j-1);
    end
    R_uy(i) = 1/N * R_uy_sum;
end

R_uy


%% autokorelace

R_uu = zeros(M,1);

for i = 1:M
    R_uu_sum = 0;
    for j = 1:N-i
        R_uu_sum = R_uu_sum + u(j) * u(i+j-1);
    end
    R_uu(i) = 1/N * R_uu_sum;
end
R_uu

g = (R_uy ./ R_uu(1)/Ts);
% figure(3)
plot(t(1:M), g,'r');




