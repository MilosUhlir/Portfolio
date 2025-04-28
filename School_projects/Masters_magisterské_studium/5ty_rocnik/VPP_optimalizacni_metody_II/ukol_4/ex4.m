clc; clear all; close all;
%% Initial params
M = 4; N = 15; us = 0:3;
ws_values = [0 1 2 3];
ws_prob = [0.1 0.3 0.5 0.1];
nb_xs = M + 1;
nb_ss = length(us);
xs = 0:M;
ss = us;

%% Functions
f_k = @(x, w, s) min(max(x - w, 0) + s, M);
c1 = @(x) sqrt(0.9 * x);
c2 = @(u) u + (u ~= 0) * 0.3;
c3 = @(x, w) -3 * min(x, w);
g_k = @(x, s, u, w) c1(x) + c2(u) + c3(x, w);

%% Initial condition
Js = zeros(nb_xs, nb_ss, N + 1);
mu = zeros(nb_xs, nb_ss, N);
Js(:, :, N + 1) = repmat(c1(xs'), 1, nb_ss);

%% DP algorithm
for i = N:-1:1
    for ii = 1:nb_xs
        x_cur = xs(ii);
        for jj = 1:nb_ss
            s_cur = ss(jj);
            J_temp = zeros(length(us), 1);
            % This is one fixed table cell in Js table - x_cur, s_cur
            % For this cell I compute best cost-to-go for variable u
            for iii = 1:length(us)
                u_cur = us(iii);
                s_next = u_cur;
                % For each w compute possible next state
                x_next_values = arrayfun(@(w) f_k(x_cur, w, s_cur), ws_values);
                % For each x_next = f(w) somehow compute Js value
                Js_next_values = arrayfun(@(x) Js(x + 1, s_next + 1, i + 1), x_next_values);
                % For each w compute g_k value
                g_k_values = arrayfun(@(w) g_k(x_cur, s_cur, u_cur, w), ws_values);
                % Use scalar multiplication to get average value
                J_temp(iii) = ws_prob * g_k_values' + ws_prob * Js_next_values';
            end
            [min_val, min_pos] = min(J_temp);
            Js(ii, jj, i) = min_val;
            mu(ii, jj, i) = us(min_pos);
            
        end
        % pause(600)
    end
end

Js;
mu;

%% Simulator
n = 100000;
x0 = 0;
s0 = 0;
J_sim = zeros(n, 1);
x_sim = zeros(n, N + 1);
s_sim = zeros(n, N + 1);
x_sim(:, 1) = x0;
s_sim(:, 1) = s0;
for i = 1:n
    for ii = 1:N
        x_cur = x_sim(i, ii);
        s_cur = s_sim(i, ii);
        u_cur = mu(x_cur + 1, s_cur + 1, ii);
        rand_val = rand();
        w_prob = cumsum(ws_prob);
        w = find(rand_val < w_prob, 1) - 1;
        J_sim(i) = J_sim(i) + g_k(x_cur, s_cur, u_cur, w);
        x_sim(i, ii + 1) = f_k(x_cur, w, s_cur);
        s_sim(i, ii + 1) = u_cur;
    end
    J_sim(i) = J_sim(i) + c1(x_sim(i, end));
    % return
end

[min(J_sim), mean(J_sim), Js(1, 1, 1)]
