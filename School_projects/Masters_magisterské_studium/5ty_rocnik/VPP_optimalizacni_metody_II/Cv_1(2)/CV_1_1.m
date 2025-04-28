clear; clc; close all

x0 = 1;
N = 4;
alpha = 0.8;
gamma = zeros(N, 1);

for i=2:N
    gamma(i) = alpha*sqrt(gamma(i-1)^2+1);
end

u = zeros(N,1);
V = zeros(N,1);
xs = zeros(N+1,1);
xs(1) = x0;

for i = 1:N
    u(i) = xs(i)/(gamma(N-i+1)^2+1);
    V(i) = -2*sqrt(gamma(N-i+1)^2+1)+sqrt(xs(1));
    xs(i+1) = xs(i) - u(i);
end

pie(u)