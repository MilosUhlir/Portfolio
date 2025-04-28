clc;
clear;

%% variable init

x1_0 = -2;  % initial position
x2_0 = 10;  % initial valocity

% diskretizace
dt = 0.2;
discret = 100;
lb = -10;
ub = 10;
xs1 = linspace(lb,ub,discret);
xs2 = linspace(lb,ub,discret);

g = @(x1, x2, u) (x1^2 + x2^2 + u^2) * dt;


%% VALUE ITERATION

xs = zeros(discret^2,2);cntr = 0;
for i = 1:discret
    for ii = 1:discret
        cntr = cntr + 1;
        xs(cntr,:) = [xs1(i),xs2(ii)];
    end
end
[Xs1,Xs2] = meshgrid(xs1,xs2);
J_old = 0*Xs1; U = 0*Xs1;

for iter = 1:100
    iter
    J_new = J_old;
    for i=1:numel(J_old)
        x1_cur = Xs1(i);
        x2_cur = Xs2(i);
        Js = 0*xs2; 
        us = Js;
        for ii=1:discret
            x2_new = xs2(ii);
            u = (x2_new-x2_cur)/dt;
            us(ii) = u;
            x1_new = x1_cur + dt*x2_cur;
            if x1_new < lb || x1_new > ub
                Js(ii) = Inf;
            else
                [~,id1] = min(abs(x1_new-xs1));
                p1 = g(x1_cur,x2_cur,u);
                p2 = J_old(id1,ii);
                Js(ii) = p1 + p2;
            end
        end
        [minval,minpos] = min(Js);
        J_new(i) = minval;
        U(i) = us(minpos);
    end
    max(abs(J_old(J_new < Inf)-J_new(J_new < Inf)));
    J_old = J_new;    

    figure(3)
    surf(Xs1,Xs2,U)
    xlabel('position (x1)')
    ylabel('velocity (x2)')
    zlabel('acceleration (u)')
    drawnow;

end

%% trajectory extraction / simulation
n = 100000;
trajectory_xs = zeros(2,n+1);
trajectory_xs(:,1) = [x1_0;x2_0];
trajectory_us = zeros(1,n+1);
for i=1:n
    [x1_min,id1] = min(abs(trajectory_xs(1,i)-xs1));
    [x2_min,id2] = min(abs(trajectory_xs(2,i)-xs2));
    trajectory_us(i) = U(id1,id2);
    trajectory_xs(1,i+1) = trajectory_xs(1,i) + dt*trajectory_xs(2,i);
    trajectory_xs(2,i+1) = trajectory_xs(2,i) + dt*trajectory_us(i);
end


x = trajectory_xs(1,:);
v = trajectory_xs(2,:);
a = trajectory_us;
t = linspace(0,n,length(a));

figure(1)
subplot(2,1,1)
plot(x,v)
xlabel('position (x1)')
ylabel('velocity (x2)')
subplot(2,1,2)
plot(t,x, t,v, t,a)
legend('position (x1)', 'velocity (x2)', 'acceleration (u)')
xlabel('time')
% ylabel('acceleration (u)')

figure(2)
plot3(x,v,a)
grid on; grid minor
xlabel('position (x1)')
ylabel('velocity (x2)')
zlabel('acceleration (u)')

figure(3)
surf(Xs1,Xs2,U)
xlabel('position (x1)')
ylabel('velocity (x2)')
zlabel('acceleration (u)')