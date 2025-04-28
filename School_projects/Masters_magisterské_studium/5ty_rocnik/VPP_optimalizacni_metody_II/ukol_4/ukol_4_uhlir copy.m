clear; 
clc;

N = 15;
M = 4;

xs = [1:M+1]';
us = [0+1:3+1]';

W = zeros(M+1,M+1,length(us));

p1 = .1;
p2 = .3;
p3 = .5;
p4 = .1;
p = p1 + p2 + p3 + p4;

% u = 1 (0)
                                                                W(1,1,1) = p;
                                                W(2,2,1) = p1;  W(2,1,1) = p2+p3+p4;
                                W(3,3,1) = p1;  W(3,2,1) = p2;  W(3,1,1) = p3+p4;
                W(4,4,1) = p1;  W(4,3,1) = p2;  W(4,2,1) = p3;  W(4,1,1) = p4;
W(5,5,1) = p1;  W(5,4,1) = p2;  W(5,3,1) = p3;  W(5,2,1) = p4;

% u = 2 (1)
                                                    W(1,2,2) = p1;  W(1,1,2) = p2+p3+p4;
                                    W(2,3,2) = p1;  W(2,2,2) = p2;  W(2,1,2) = p3+p4;
                    W(3,4,2) = p1;  W(3,3,2) = p2;  W(3,2,2) = p3;  W(3,1,2) = p4;
W(4,5,2) = p1;      W(4,4,2) = p2;  W(4,3,2) = p3;  W(4,2,2) = p4;
W(5,5,2) = p1+p2;   W(5,4,2) = p3;  W(5,3,2) = p4;

% u = 3 (2)
                                        W(1,3,3) = p1;  W(1,2,3) = p2;  W(1,1,3) = p3+p4;
                        W(2,4,3) = p1;  W(2,3,3) = p2;  W(2,2,3) = p3;  W(2,1,3) = p4;
W(3,5,3) = p1;          W(3,4,3) = p2;  W(3,3,3) = p3;  W(3,2,3) = p4;
W(4,5,3) = p1+p2;       W(4,4,3) = p3;  W(4,3,3) = p4;
W(5,5,3) = p1+p2+p3;    W(5,4,3) = p4;

% u = 4 (3)
W(1,4,4) = p1; W(1,3,4) = p2; W(1,2,4) = p3; W(1,1,4) = p4;
W(2,5,4) = p1; W(2,4,4) = p2; W(2,3,4) = p3; W(2,2,4) = p4;
W(3,5,4) = p1+p2; W(3,4,4) = p3; W(3,3,4) = p4;
W(4,5,4) = p1+p2+p3; W(4,4,4) = p4;
W(5,5,4) = p;

ws_prob = [0.1 0.3 0.5 0.1];

c1 = @(x) sqrt(0.9 * x);

% c2
c2 = @(u) u + (u ~= 0) * 0.3;

c3 = @(x, w) min(x, w);


f_k = @(x, w, s) min(max(x - w, 0) + s, M);

g_k = @(x,u,w) c1(x) + c2(u) + c3(x, w);

g_N = @(x) c1(x);


Jms = length(xs) * length(us); % J and mu size

J = zeros(length(xs), length(us), N+1);
mu = zeros(length(xs), length(us), N);

ss = us;

for x = 1:length(xs)
    for s = 1:length(us)
        J(x, s, N+1) = g_N(x);
    end
end

% for k = N:-1:1

%     for x = 1:length(xs)
    
%         x_cur = xs(x);
%         J_temp = zeros(length(us), 2);
    
%         for u = 1:length(us)
%             u_cur = us(u);
%             for s = 1:length(xs)
                
%                 w_cur = W(x_cur, :, u_cur);

%                 if sum(w_cur) > 0
        
%                     % J_temp(u) = g_p(x) + g_a(u) + w_cur*J(:,k+1);
%                     % J_temp(u) = g_p(x) + g_a(u) + min(J(w_cur>0, k+1));


%                     for w = 1:length(w_cur)

                        

%                         % J_temp(u) = g_k(x_cur, u_cur, w_cur(w)) + (min(max(x_cur - w_cur, 1) + ss(s, k), M)) * J(:, k+1);
%                         % J_temp(u, 2) = u_cur;

%                         % J_temp(u) = J_temp(u) + g_k(x_cur, u_cur, w_cur(w));

%                         % J_temp(u) = (g_k(x_cur, u_cur, w_cur) + w_cur * J(:, k+1))*ones(5,1);
                        
%                     end

%                     % help_sum = (min(max(x_cur - w_cur, 1) + ss(s, k), M)) * J(:, k+1);
%                     % J_temp(u) = J_temp(u) + help_sum;
                    
                    

%                     % J_temp(u, 2) = u_cur;
                    
%                 else
        
%                     J_temp(u) = -Inf;
%                     J_temp(u, 2) = u_cur;

%                 end
%                 % pause(120);
%             end
            
            

%         end

        
        

%         [maxval, maxpos] = max(J_temp);
%         ss(x, k) = maxval(2);
%         J(x,k) = maxval(1);
%         mu(x, k) = maxpos(1)-1;
        
%     end
%     % J
%     % pause(5)
% end


for k = N:-1:1

    for x = 1:length(xs)
        x_cur = xs(x);

        for s = 1:length(ss)
            s_cur = ss(s);
            J_temp = zeros(length(us),1);
            Js_kk = zeros(length(xs),1);

            for u = 1:length(us)
                u_cur = us(u);
                s_kk = u_cur;
                size_W = size(W);
                w_cur = W(x_cur,:,u);
                for w = 1:size_W(3)
                    
                    x_kk = f_k(x_cur, w, s_cur);
                    gk = g_k(x_cur, u_cur, w_cur);

                    % for i = 1:length(length(w_cur))
                        Js_kk(w) = J(x_kk, s_kk, k + 1);
                    % end
                end
                    J_temp(u_cur) = w_cur * gk' + w_cur * Js_kk;
                    [k, x, s, u];
                    % pause(.25);
                    
                

            end

            [min_val, min_pos] = min(J_temp);
            J(x, s, k) = min_val;
            mu(x, s, k) = us(min_pos);

            [x, s, k, J(x, s, k)];
            % return
            % pause(600)
        end
        
    end

end



ss;
W;
J;
mu;


%% simulator

n = 100000;
x0 = 0+1;
s0 = 0+1;
J_sim = ones(n, 1);
x_sim = ones(n, N + 1);
s_sim = ones(n, N + 1);
x_sim(:, 1) = x0;
s_sim(:, 1) = s0;
for i = 1:n
    for ii = 1:N
        x_cur = x_sim(i, ii);
        s_cur = s_sim(i, ii);
        u_cur = mu(x_cur+1, s_cur, ii);
        rand_val = rand();
        for iii = 1:5
            w_prob = cumsum(W(iii,:,u_cur));
            if w_prob > 0
                w = find(rand_val < w_prob, 1) - 1;
                J_sim(i) = J_sim(i) + g_k(x_cur, u_cur, w);
                x_sim(i, ii + 1) = f_k(x_cur, w, s_cur);
                s_sim(i, ii + 1) = u_cur;
            end
        end
    end
    J_sim(i) = J_sim(i) + c1(x_sim(i, end));
    % return
end

[min(J_sim), mean(J_sim), J(1, 1, 1)]



% function c2 = c2(u)
%     if u == 0
%         c2 = 0;
%     else
%         c2 = 0.3 + u;
%     end
% end