clear;
clc;

xs = [1:5]';
us = [1:3]';
W = zeros(5,5,3);
% u = 1
W(1,1,1) = .7; W(1,2,1) = .2; W(1,3,1) = .1;
               W(2,2,1) = .7; W(2,3,1) = .2; W(2,4,1) = .1;
                              W(3,3,1) = .7; W(3,4,1) = .2; W(3,5,1) = .1;
                                             W(4,4,1) = .7; W(4,5,1) = .3;
                                                            W(5,5,1) = 1;

% u = 2
W(2,1,2) = .9; W(2,2,2) = .1;
               W(3,2,2) = .9; W(3,3,2) = .1;
                              W(4,3,2) = .9; W(4,4,2) = .1;
                                             W(5,4,2) = .9; W(5,5,2) = .1;

% u = 3
W(2:5,1,3) = 1;
g_p = [1, 0.9, 0.7, 0.5, 0];
g_a = [0, -0.4, -1];
g_k = @(x_k, u_k) g_p(x_k) + g_a(u_k);
x0 = 1;
alpha = 0.9;
N = 100;

%% value iteration
J = zeros(length(xs), 1);
mu = zeros(length(xs), 1);
epsilon = 1e-3;
k = 0;
J(:,1) = 0;

%{ 
first try... doesn't work

while k < max_iter
    x=x+1;
    for x_i = 1:length(xs)
        J_temp = zeros(3,1);
        for u = 1:length(us)
            % sum = 0;
            % for x_j = 1:length(xs)
            %     sum = sum + W(xs(x_i), xs(x_j), us(u))*J(x_j, k);
            %     % pause(1)
            % end
            % J_temp(u) = g_k(xs(x_i), us(u)) + sum;

            J_temp(u) = g_k(xs(x_i), us(u)) + W(xs(x_i), :, us(u))*J(:,k);
        end
        [min_val, min_pos] = min(J_temp);
        J(x_i, k+1) = min_val;
        mu(x_i, k+1) = min_pos;
    end

    c_k_min = min(J(:, k+1) - J(:,k));
    c_k_max = max(J(:, k+1) - J(:,k));
    end_condition = norm(c_k_max-c_k_min);
    if end_condition < eps
        J
        mu
        J_optimal = J(:,k+1)
        mu_optimal = mu(:,k+1)
        break
    else
    k = k+1;
    end
end
%}

end_condition = inf;
while end_condition > epsilon
    k=k+1;
    for x = 1:length(xs)
        x_cur = xs(x);
        J_temp = zeros(3,1);
        for u = 1:length(us)
            u_cur = us(u);
            w_cur = W(x_cur, :, u_cur);
            if sum(w_cur) > 0
                J_temp(u_cur) = g_p(x) + g_a(u_cur) + alpha*w_cur*J(:,k);
            else
                J_temp(u_cur) = -Inf;
            end
        end
        [maxval, maxpos] = max(J_temp);
        J(x,k+1) = maxval;
        mu(x, k+1) = maxpos;
    end
    c_k_min = min(J(:, k+1) - J(:,k));
    c_k_max = max(J(:, k+1) - J(:,k));
    end_condition = norm(c_k_max-c_k_min);
end
J
mu
J_optimal_VI = J(:,k+1)
mu_optimal_VI = mu(:,k+1)


%% VI simulation

x_sim_VI = x0;
J_pi = 0;
for i = 1:N
    x_cur = x_sim_VI(i);
    u_cur = mu_optimal_VI(x_cur);
    J_pi = J_pi + alpha^k * g_k(x_cur, u_cur);
    w = W(x_cur,:,u_cur);
    r = rand;
    idxs = find(r < cumsum(w));
    if ~isempty(idxs)
        x_sim_VI(i+1) = idxs(1);
    else
        x_sim_VI(i+1) = 1;
    end
end
J_pi_VI = J_pi + alpha^k * g_p(x_sim_VI(end))


%% Policy Iteration
J = zeros(length(xs), 1);
mu = ones(length(xs), 1);
k = 0;
J(:,1) = 0;
max_iter = 1000;
iter = 0;
epsilon = 1e-8;
for iter = 1:max_iter
    while true
        J_temp = zeros(length(xs),1);
        for x = 1:length(xs)
            u_cur = mu(x);
            w_cur = W(x,:,u_cur);
            if sum(w_cur) > 0
                J_temp(x) = g_k(x,u_cur) + alpha*w_cur*J;
            else
                J_temp(x) = -Inf;
            end
        end
        cond2 = max(abs(J_temp-J));
        if cond2 < epsilon
            break
        end
        J = J_temp;
    end
    new_mu = ones(length(xs), 1);
    for x = 1:length(xs)
        J_temp = zeros(length(us),1);
        for u = 1:length(us)
            J_temp(u) = g_k(x,u) + alpha*W(x,:,u)*J;
        end
        [~, maxpos] = max(J_temp);
        new_mu(x) = maxpos;
    end
    cond1 = isequal(new_mu,mu);
    if cond1 == 1
        break
    end
    mu = new_mu;
end
J_optimal_PI = J
mu_optimal_PI = mu


%% PI simulation
x_sim_PI = x0;
J_pi = 0;
for i = 1:N
    x_cur = x_sim_PI(i);
    u_cur = mu_optimal_PI(x_cur);
    J_pi = J_pi + alpha^k * g_k(x_cur, u_cur);
    w = W(x_cur,:,u_cur);
    r = rand;
    idxs = find(r < cumsum(w));
    if ~isempty(idxs)
        x_sim_PI(i+1) = idxs(1);
    else
        x_sim_PI(i+1) = 1;
    end
end
J_pi_PI = J_pi + alpha^k * g_p(x_sim_PI(end))