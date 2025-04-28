clc; clear; clf;

dt = 0.1;
N = 50;
gamma = 0.2;
lambda = 0.005;
sigma = diag([0.005, 0.002, 0.005, 0.001, 0]);

x0 = [2;
      0;
      2;
      0;
      9.8];

A = [
    1, dt,         0, 0,          0;
    0, 1-dt*gamma, 0, 0,          0;
    0, 0,          1, dt,         0;
    0, 0,          0, 1-dt*gamma, -dt;
    0, 0,          0, 0,          1
    ];

B = [
    0,  0;
    dt, 0;
    0,  0;
    0,  dt;
    0,  0
    ];

Q_k = 0;
Q_N = (1-lambda)*eye(height(A));
R_k = lambda * eye(2,2);

x_kk = @(xk_, uk_, wk_) A*xk_ + B*uk_ + wk_;

L_k = @(A_k, B_k, R_k, K_kk) (-(B_k'*K_kk*B_k + R_k)^-1) *B_k'*K_kk*A_k; 
K_k = @(A_k, K_kk, B_k, R_k, Q_k) A_k'*(K_kk-K_kk*B_k*(B_k'*K_kk*B_k+R_k)^-1 * B_k'*K_kk)*A_k + Q_k;

K_N = Q_N;
K = zeros(height(Q_N),length(Q_N),N+1);
L = zeros(2,5,N);
K(:,:,end) = K_N;

for k = N:-1:1
    temp = L_k(A,B,R_k,K(:,:,k+1));
    L(:,:,k) = temp;
    K(:,:,k) = K_k(A, K(:,:,k+1), B, R_k, Q_k);
end

J_0 = x0' * K(:,:,1) * x0;
for k = 1:N
    J_0 = J_0 + trace(K(:,:,k+1)*sigma);
end
J_0



%% simulation
xs = zeros(5,N+1); xs(:,1) = x0;
us = zeros(2,N);
Cost = 0;
for k=1:N
    us(:,k) = L(:,:,k)*xs(:,k);
    Cost = Cost + xs(:,k)'*Q_k*xs(:,k) + ...
        us(:,k)'*R_k*us(:,k);
    xs(:,k+1) = A*xs(:,k) + B*us(:,k) + ...
        mvnrnd(zeros(5,1),sigma)';
end
Cost = Cost + xs(:,k)'*Q_N*xs(:,k)

subplot(2,1,1)
hold on;
plot(xs(1,:), xs(3,:), 'b-x')
axis equal;
grid on;
subplot(2,1,2)
hold on;
grid on;
plot(us(1,:))
plot(us(2,:))

