


%% init
clear all; clc; close all


xs = [1, 2, 3, 4, 5];
us = [0, 1, 2];

x0 = 1;
N = 10;

g_k = @(x_k, u_k) g_p(x_k) + g_a(u_k);
g_N = @(x_n) g_p(x_n);

J = zeros(length(xs), N+1);

mu = zeros(length(xs), N);

J_k = @(x_k, u_k, w_k, k, x) max(u_k + (x_k+u_k-w_k).^2 + J(x, k+1));

for i = 1:length(xs)
    J(i,end-1) = g_N(xs(i));
    J(i,end) = xs(i);
    % J(i,end-2) = 0;

    
end
i=0;

w_progress = zeros(length(xs), N, 3);
ws_history = nan*zeros(3, 1);
% test = g_k(1, 3)

%% main loop
for k = N-1:-1:1
    
    for x = 1:1:length(xs)

        J_temp = zeros(length(us), 1);
        
        for u = 1:1:length(us)
            % us_temp = us(u)
            % xs_temp = xs(x)
            
            ws = Ws(us(u), xs(x));
            
            % ws_history(:,end+1) = ws
            % pause(5)
            
            
            [w_sum, w_progress] = W_sum(ws, us(u), xs(x), J, g_k, w_progress, k);
            
            if k == N-1
                
                % g_k
                % k
                % x
                % xs_temp = xs(x)
                % u
                % us_temp = us(u)
                % w_progress
                % J;
            end

            
            J_temp(u) = g_N(xs(end-1)) + w_sum;

        end

        J_x = max(J_temp);
        
        [maxval, maxpos] = max(J_temp);
        J(x, k) = maxval;
        mu(x, k) = us(maxpos);

    end

    

end
% w_progress
% ws_history
J
mu

%% suma pravděpodobností

function [w_sum, w_progress] = W_sum(ws, u, x, J, g_k, w_progress, k)
    
    w_size = length(ws);
    % w_size = 3;
    w_sum = 0;
    
    for w_i = w_size:-1:1
        % w_sum;
        % test = x+u-ws(w_i);

        w_sum = w_sum + (g_k(x, u) + J(x, max(1, round(x+u-ws(w_i)))));
        % w_sum = w_sum + (g_k(x, u) + J(x, max(1, g_k(x,u))));


        w_progress(x, k, w_i) = w_sum;

    end

end

%% prob
function ws = Ws(u_k, x_k)
    switch u_k
        case 0
            switch x_k
                case 1
                    ws = [.6, .3, .1];
                case 2
                    ws = [.7, .2, .1];
                case 3
                    ws = [.75, .15, .10];
                case 4
                    ws = [.8, .2, 0];
                case 5
                    ws = [1, 0, 0];
            end
        case 1
            switch x_k
                case 1
                    ws = zeros(1,3);
                otherwise
                    ws = [.9, .1, 0];
            end
        case 2
            switch x_k
                case 1
                    ws = zeros(1,3);
                otherwise
                    ws = [1, 0, 0];
            end
    end
end

%% g_p
function g_p = g_p(x_k)
    switch x_k
        case 1
            g_p = 1;
        case 2
            g_p = 0.9;
        case 3
            g_p = 0.6;
        case 4
            g_p = 0.4;
        case 5
            g_p = 0;
    end
end

%% g_a
function g_a = g_a(u_k)
    switch u_k
        case 0
            g_a = 0;
        case 1
            g_a = -0.4;
        case 2
            g_a = -1;
    end
end



