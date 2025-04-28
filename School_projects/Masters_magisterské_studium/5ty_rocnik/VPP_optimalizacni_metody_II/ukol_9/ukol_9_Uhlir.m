clear; clc; clf;
% rng default
% rng('default')
% rng(1)
%% Assingnment a):
% dt = 1;
% N_k = 0.1;
% N = 20;
% x0 = 1;
% x0_1 = 0;
% S = 1000;
% M_k = 0;

% x_kk = @(xk, wk) xk;
% z_k = @(xk, vk) xk + vk;

% A = 1;
% C = 1;


%% b):
dt = 1;
N_k = 0.1;
N = 100;
x0 = [0, 0.1]';
x0_1 = [0, 0]';
S = diag([1000, 1000]);
M_k = [0.001, 0.0005;
       0.0005, 0.0008];

A = [1, dt; 0, 1];
C = [1, 0];

x_kk = @(xk, wk) ...
    A * xk + wk;
z_k = @(xk, vk) ...
    C * xk + vk;




%% Kalman Filter
    % prediction
    x_kk_k = @(A_k, x_k_k) ...
        A_k*x_k_k;

    sigma_kk_k = @(A_k, sigma_k_k, M_k) ...
        A_k*sigma_k_k*A_k' + M_k;

    % Update
    x_k_k = @(x_k_k_, sigma_k_k_, C_k, N_k, z_k) ...
        x_k_k_ + sigma_k_k_*C_k'*(C_k*sigma_k_k_*C_k' + N_k)^-1 * (z_k-C_k*x_k_k_);
    
    sigma_k_k = @(sigma_k_k_, C_k, N_k) ...
        sigma_k_k_ - sigma_k_k_*C_k'*(C_k*sigma_k_k_*C_k' + N_k)^-1 * C_k*sigma_k_k_;

%%

zs = 0;
preds = [0;0];
xs = [0;0];
sigmas = zeros(2,2,1);
t = [1:N];

for k = 1:N
    % rng('default')
    if k == 1
        w = mvnrnd(zeros(1,width(M_k)), M_k)';
        x_new = x_kk(x0, w);
        z = z_k(x_new, mvnrnd(0, N_k));

        % prediction
        x_new_cur = x0_1;
        sigma_new_cur = S;
        
        % update
        
        x_cur_cur = x_k_k(x_new_cur, sigma_new_cur, C, N_k, z);
        sigma_cur_cur = sigma_k_k(sigma_new_cur, C, N_k);
    else
        w = mvnrnd(zeros(1,width(M_k)), M_k)';
        x_new = x_kk(x_new, w);
        z = z_k(x_new, mvnrnd(0, N_k));
        
        % prediction
        x_new_cur = x_kk_k(A, x_cur_cur);
        sigma_new_cur = sigma_kk_k(A, sigma_cur_cur, M_k);
        
        % update
        x_cur_cur = x_k_k(x_new_cur, sigma_new_cur, C, N_k, z);
        sigma_cur_cur = sigma_k_k(sigma_new_cur, C, N_k);
    end
    
    if k == 1
        zs(1) = z;
        xs(:,1) = x_cur_cur;
        sigmas(:,:,1) = sigma_cur_cur;
    else
        zs(end+1) = z;
        xs(:,end+1) = x_cur_cur;
        sigmas(:,:,end+1) = sigma_cur_cur;
    end

end

% zs
% preds
% xs
% sigmas

figure(1)
subplot(2,1,1)
plot(t, xs(1,:), 'b-', t, zs, 'r.');
legend('Estimates', 'Measurements', 'Location','southeast');
xlabel('Time');
ylabel('Water level');

subplot(2,1,2)
plot(t, xs(2,:));
xlabel('Time');
ylabel('Filling Rate');