clear;clc;clf;
global function_calls gradient_calls;

f = @(x) rosenbrock(x); range = [-2,2]; opt = [1,1]; conts = 0:50;
grad = @(x) rosenbrock_grad(x);
hess = @(x) rosenbrock_hess(x);

plot_f(f, range, opt, conts); %function plot

min_norm = 1e-2; max_fcalls = 1e3; %convergence crit.
max_iter = 1e2;

x0 = [-1;-1];
% x0 = range(1)*ones(2,1) + range(2)-range(1)*rand(2,1);
plot3(x0(1),x0(2),0,'kx');
hold on;

%% nelder-mead

function_calls = 0; gradient_calls = 0;

par_eps = 1e-4;
max_iter = 100;
max_fcalls = 1000;

function_calls = 0; 
par_eps = 1e-3;
S = [[1;0],[0;1],[-1;-1]];
% S = [x0 + [1;0],x0 + [0;1],x0 + [-1;-1]];
% S = [x0, x0+randn(2,1), x0+randn(2,1)];
[xs,iter,x_ns] = nelder_mead(f,x0,S,par_eps,max_iter,max_fcalls);

function_calls
iter

for i=1:iter
    plot(x_ns(1,:,i),x_ns(2,:,i),'bo');
end

plot(xs(1,:),xs(2,:),':m','Linewidth',1.5);


for i=1:iter
    plot([x_ns(1,:,i),x_ns(1,1,i)],...
         [x_ns(2,:,i),x_ns(2,1,i)],'b-')
end


%% other
function plot_f(f, range, opt, conts)
    xs = linspace(range(1),range(2));
    ys = linspace(range(1),range(2));
    [Xs,Ys] = meshgrid(xs,ys);
    for i=1:100
        for j=1:100
            Zs(i,j) = f([Xs(i,j),Ys(i,j)]);
        end
    end
    contour(Xs,Ys,Zs,conts); hold on; grid on; axis equal
    plot3(opt(1),opt(2),0,'ro')
end


function [xs,iter,S_s] = nelder_mead(f,x0,S, par_eps,max_iter,max_fcalls)
global function_calls;

xs = [x0]; 
Delta = inf; 
[n,m] = size(S);
alpha = 1; beta = 2; gamma = 2; iter = 1; 
S_s = S;

    for i=1:m
        y(1,i) = f(S(:,i));
    end

    while Delta > par_eps
        [y,p] = sort(y); S = S(:,p);

        x_l = S(:,1); 
        y_l = y(1); 
        x_h = S(:,end); 
        y_h = y(end); 
        x_s = S(:,end-1); 
        y_s = y(end-1); 
        x_m = mean(S(:,1:end-1),2); 
        x_r = x_m + alpha*(x_m - x_h); 
        y_r = f(x_r);
        
        if y_r < y_l
           x_e = x_m + beta*(x_r-x_m); y_e = f(x_e);
           if y_e < y_r 
               S(:,end) = x_e; y(end) = y_e;
            else
               S(:,end) = x_r; y(end) = y_r;
            end

        elseif y_r >= y_s
        
            if y_r < y_h
                x_h = x_r; y_h = y_r; S(:,end) = x_r; y(end) = y_r;
            end
        
            x_c = x_m + gamma*(x_h - x_m);
            y_c = f(x_c);
        
            if y_c > y_h
            
                for i=2:length(y)
                    S(:,i) = (S(:,i)+x_l)/2;
                    y(i) = f(S(:,i));
                end
        
            else
                S(:,end) = x_c; y(end) = y_c;
            end
    
        else
            S(:,end) = x_r; y(end) = y_r;
        end
    
        Delta = std(y);
        xs(:,end+1) = x_l;
        iter = iter + 1; 
        S_s(:,:,iter) = S;
    
        if iter > max_iter || function_calls > max_fcalls
            break;
        end

    end
end

