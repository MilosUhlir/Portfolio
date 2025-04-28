clear;clc;clf;
A = [0 1;0 0];
B = [0;1];
R = 1;
Q = eye(2);

syms k1 k2 k3;
K = [k1 k2;k2 k3];
E = -K*A - A'*K + K*B*B'*K - Q;

sol = solve(E == zeros(2,2));
K_sol = zeros(2,2,length(sol.k1));
lambda = zeros(2,1,length(sol.k1));
for i=1:length(sol.k1)
    K_sol(:,:,i) = eval([sol.k1(i),sol.k2(i); ...
                        sol.k2(i),sol.k3(i)]);
    lambda(:,:,i) = eig(K_sol(:,:,i));
end
K_sol(:,:,4);
syms x1(t) x2(t);
ode1 = diff(x1) == x2;
ode2 = diff(x2) == -x1 -sqrt(3)*x2;
odes = [ode1;ode2];
dsolve(odes);

cond1 = x1(0) == -2;
cond2 = x2(0) == 10;
conds = [cond1;cond2];

[x1Sol(t),x2Sol(t)] = dsolve(odes,conds);
n = 100;
ts = linspace(0,10,n);
xs = zeros(2,n);
for i=1:n
    xs(:,i) = eval([x1Sol(ts(i));x2Sol(ts(i))]);
end
subplot(2,1,1)
plot(xs(1,:),xs(2,:),'k-o')
xlabel("x1")
ylabel("x2")
grid on;
subplot(2,1,2)
plot(ts, -xs(1,:) -sqrt(3)*xs(2,:),'k-o');
grid on
xlabel("t")
ylabel("u")

