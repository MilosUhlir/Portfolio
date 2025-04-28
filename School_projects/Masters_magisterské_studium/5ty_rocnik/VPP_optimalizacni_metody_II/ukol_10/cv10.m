clc; clear var; close all;
%% Initial condition
x0 = 1;
alpha = 0.9;
nb_xs = 5;
xs = 1:nb_xs;
us = 1:3; % Adjusted to start from 1 due to Matlab

%% Probability matrix
W = zeros(5,5,3);
% u = 0 (do nothing)
W(:,:,1) = [0.7 0.2 0.1 0 0; 0 0.7 0.2 0.1 0; 0 0 0.7 0.2 0.1; 0 0 0 0.7 0.3; 0 0 0 0 1];
% u = 1 (repair)
W(:,:,2) = [0 0 0 0 0; 0.9 0.1 0 0 0; 0 0.9 0.1 0 0; 0 0 0.9 0.1 0; 0 0 0 0.9 0.1];
% u = 2 (buy new)
W(:,:,3) = [0 0 0 0 0; 1 0 0 0 0; 1 0 0 0 0; 1 0 0 0 0; 1 0 0 0 0];

%% Cost functions
profits = [1 0.9 0.7 0.5 0];
costs = [0 -0.4 -1];
g_p = @(x) profits(x);
g_a = @(u) costs(u);
g_k = @(x,u) g_p(x) + g_a(u);

%% Value Iteration
J_val = zeros(nb_xs, 1);
mus = zeros(nb_xs, 1);
tolerance = 1e-8;
max_iter = 1000;

for iter = 1:max_iter
    J_new = zeros(nb_xs, 1);
    for x = 1:nb_xs
        J_temp = zeros(length(us), 1);
        for u = 1:length(us)
            w_cur = W(x,:,u);
            if sum(w_cur) > 0
                J_temp(u) = g_k(x, u) + alpha * w_cur * J_val;
            else
                J_temp(u) = -Inf;
            end
        end
        [J_new(x), mus(x)] = max(J_temp); % We want to maximize the profit.
    end
    if max(abs(J_new - J_val)) < tolerance
        break;
    end
    J_val = J_new;
end
disp('Optimal Value Function:');
disp(J_val);
disp('Optimal policy:');
disp(mus);

%% Policy Iteration
mus = ones(nb_xs, 1); % Create any feasible policy
J_pol = zeros(nb_xs, 1);
tolerance = 1e-8;
max_iter = 1000;

for iter = 1:max_iter
    % Policy Evaluation
    while true
        J_new = zeros(nb_xs, 1);
        for x = 1:nb_xs
            u = mus(x);
            w_cur = W(x,:,u);
            if sum(w_cur) > 0
                J_new(x) = g_k(x, u) + alpha * w_cur * J_pol;
            else
                J_new(x) = -Inf;
            end
        end
        if max(abs(J_new - J_pol)) < tolerance
            break;
        end
        J_pol = J_new;
    end
    
    % Policy Improvement
    new_mus = zeros(nb_xs, 1);
    for x = 1:nb_xs
        J_temp = zeros(length(us), 1);
        for u = 1:length(us)
            J_temp(u) = g_k(x, u) + alpha * W(x,:,u) * J_pol;
        end
        [~, new_mus(x)] = max(J_temp);
    end
    
    if isequal(mus, new_mus)
        break;
    end
    mus = new_mus;
end

disp('Optimal Value Function:');
disp(J_pol);
disp('Optimal Policy:');
disp(mus);
%% DP algorithm for control
N = 200; % Simulate infinite horizont
Js = zeros(nb_xs, N+1);
mu = zeros(nb_xs, N);
Js(:,N+1) = profits';

for i = N:-1:1
    for ii = 1:nb_xs
        x_cur = xs(ii);
        J_temp = zeros(length(us), 1);
        for iii = 1:length(us)
            u_cur = us(iii);
            w_cur = W(x_cur,:,u_cur);
            if sum(w_cur) > 0
                J_temp(iii) = g_k(x_cur, u_cur) + alpha * (w_cur * Js(:,i+1));
            else
                J_temp(iii) = -Inf;
            end
        end
        [max_val, max_pos] = max(J_temp);
        Js(x_cur, i) = max_val;
        mu(x_cur, i) = us(max_pos);
    end
end

disp('Optimal Value Function:');
disp(Js(:,1));
disp('Optimal Policy:');
disp(mu(:,1));