clear;clc;clf;

dt = 0.01;
%dt = 1;

A = [1 dt;
     0 1];
B = [0; dt];

us = linspace(-20,20,41);
%us = linspace(-1,1,11);

f = @(x,u) A*x + B*u;
%g = @(x,u) 1-(norm([x(1) x(2)])< 1e-6);
g = @(x,u) (x'*x + u'*u)*dt;

nr_disc = 21;
lb1 = -5; ub1 = 5;
xs1 = linspace(lb1,ub1,nr_disc);
lb2 = -5; ub2 = 5;
xs2 = linspace(lb2,ub2,nr_disc);
[Xs1,Xs2] = meshgrid(xs1,xs2);

obj = @(alpha) objective(alpha,Xs1,Xs2,us,f,g);

obj([sqrt(3);1;sqrt(3)])

Problem.f = obj;
opts.dimension = 3;
opts.maxevals = 1e4;
opts.globalmin = 0;
opts.showits = 1;
opts.tolabs = 1e-3;
bounds = [-10*ones(3,1),10*ones(3,1)]; bounds(1,1) = 0;

[minima, xatmin, history] = alg_LSHADE_par(Problem, opts, bounds);

J_opt = @(x) x'*[xatmin(1),xatmin(2);xatmin(2),xatmin(3)]*x;

J_vals = 0*Xs1;
for i=1:numel(Xs1)
    x_temp = [Xs1(i);Xs2(i)];
    J_vals(i) = J_opt(x_temp);
end

contour(Xs1,Xs2,J_vals)


function val = objective(alpha,Xs1,Xs2,us,f,g)
    J_loss = 0*Xs1;   
    for i=1:numel(Xs1)
        x = [Xs1(i);Xs2(i)];
        J_loss(i) = loss(alpha,x,us,f,g);
    end
    val = sum(sum(J_loss));
end

function val = loss(alpha,x,us,f,g)
    J = @(x) x'*[alpha(1),alpha(2);alpha(2),alpha(3)]*x;
    Js = zeros(length(us),1);
    for i=1:length(us)
        u = us(i);
        Js(i) = g(x,u) + J(f(x,u));
    end
    J_min = min(Js);
    val = (J(x)-J_min)^2;
end

