clear; clc;

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

x_kk = @(xk_, uk_, wk_) A*xk_ + B*uk_ + wk_;

L_k = @(A_k, B_k, R_k, K_kk) (-(B_k'*K_kk*B_k + R_k)^-1) *B_k'*K_kk*B_k; 
K_k = @(A_k, K_kk, B_k, R_k, Q_k) A_k'*(K_kk-K_kk*B_k*(B_k'*K_kk*B_k+R_k)^-1 * B_k'*K_kk)*A_k + Q_k;

Q_k = 0;
Q_N = (1-lambda)*eye(height(A));
R_k = lambda * eye(2,2);

K_N = Q_N;
K = zeros(height(Q_N),length(Q_N),N+1);
L = zeros(2,2,N);
K(:,:,end) = K_N;

for k = N:-1:1
    debug = L_k(A, B, R_k, K(:,:,k+1));
    L(:,:,k) = debug;
    K(:,:,k) = K_k(A, K(:,:,k+1), B, R_k, Q_k);
end

J_0 = x0' * K(:,:,1) * x0;
for k = 1:N
    J_0 = J_0 + trace(K(:,:,k+1)*sigma);
end

fprintf('optimal cost J_0(x_0) = %f\n', J_0)