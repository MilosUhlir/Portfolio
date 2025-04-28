clear all; clc; close all

xs = [1, 2, 3, 4, 5];
us = [0, 1, 2];

x0 = 1;
N = 10;

g_k = @(x_k, u_k) g_p(x_k) + g_a(u_k);
g_N = @(x_n) g_p(x_n);

% J = NaN * zeros(length(xs), N+1);
J = zeros(length(xs), N+1);


% mu = NaN * zeros(length(xs), N);
mu = zeros(length(xs), N);


J_kk = @(x_k, u_k, w_k) min(0, x_k + u_k - w_k) ;
% J_k = @(x_k, u_k, w_k) u_k + (x_k+u_k-w_k).^2 + J_kk(x_k, u_k, w_k) ;

J_k = @(x_k, u_k, w_k, k, x) u_k + (x_k+u_k-w_k).^2 + J(x, k+1);

for i = 1:length(xs)
    J(i,N+1) = g_N(xs(i));
    
end

% J_temp = NaN * zeros(1, length(xs));
J_temp = zeros(1, length(xs));

E = 0;

x = x0;

for k = N:-1:1

    for i = 1:length(xs)
        
        x = g_p(x);

        for u = 1:length(us)
            
            w = W(us(u), xs(x));

            J_temp = J_k(xs(x), us(u), w, k, x);

            % E = E_w(xs, us, N, g_k, g_N, x, u);
        end

        J_x = max(J_temp);

        [minval, minpos] = max(J_temp);
        J(x, k) = minval;
        mu(x, k) = minpos;
    end

end

E;
J
mu


%% kopie kódu ze cvičení
% for i = N:-1:1
%     for ii = 1:nb_points
%         us = xs(1:ii);
%         nb_pos = length(us);
%         J_temp = zeros(nb_points,1);
%         for iii = 1:nb_pos
%             x_next = xs(ii-iii+1);
%             row = ii - iii + 1;
%             J_temp(iii) = g_k(us(iii)) + alpha*J(row, i+1);
%         end
%         [minval, minpos] = min(J_temp);
%         J(ii, i) = minval;
%         mu(ii, i) = minpos;
%     end
% end



%% prob
function w = W(u_k, x_k)
    switch u_k
        case 0
            switch x_k
                case 1
                    w = [.6, .3, .1];
                case 2
                    w = [.7, .2, .1];
                case 3
                    w = [.75, .15, .15];
                case 4
                    w = [.8, .2, 0];
                case 5
                    w = [1, 0, 0];
            end
        case 1
            switch x_k
                case 1
                    w = zeros(1,3);
                otherwise
                    w = [.9, .1, 0];
            end
        case 2
            switch x_k
                case 1
                    w = zeros(1,3);
                otherwise
                    w = [1, 0, 0];
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



%% E_w

% E_w = @(x_k, u_k) g_N(x_k) + g_k(x_k, u_k);

function E = E_w(xs, us, N, g_k, g_N, x, u)

    s = 0;
    for i = 1:N
        s = s + g_k(xs(x), us(u));
    end

    E = g_N(xs(N-1)) + s;

end