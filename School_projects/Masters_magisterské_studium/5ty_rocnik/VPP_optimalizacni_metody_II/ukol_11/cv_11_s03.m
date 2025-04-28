clear;clc;close all;

dt = 0.1;
nr_disc = 101;
lb1 = -10; ub1 = 10;
xs1 = linspace(lb1,ub1,nr_disc);
lb2 = -10; ub2 = 10;
xs2 = linspace(lb2,ub2,nr_disc);
%g = @(x) 1-(norm([x(1) x(2)])< 1e-6);
g = @(x,u) (x'*x + u'*u)*dt;

xs = zeros(nr_disc^2,2);cntr = 0;
for i = 1:nr_disc
    for ii = 1:nr_disc
        cntr = cntr + 1;
        xs(cntr,:) = [xs1(i),xs2(ii)];
    end
end
[Xs1,Xs2] = meshgrid(xs1,xs2);
J_old = 0*Xs1; U = 0*Xs1;
figure(1)
for iter = 1:100
    iter
    % disp(iter);
    J_new = J_old;
    for i=1:numel(J_old)
        % i
        x1_cur = Xs1(i);
        x2_cur = Xs2(i);
        Js = 0*xs2; us = Js;
        for ii=1:nr_disc
            % ii
            x2_new = xs2(ii);
            u = (x2_new-x2_cur)/dt;
            us(ii) = u;
            x1_new = x1_cur + dt*x2_cur;
            if x1_new < lb1 || x1_new > ub1
                Js(ii) = Inf;
            else
                [~,id1] = min(abs(x1_new-xs1));
                p1 = g([x1_cur;x2_cur],u);
                p2 = J_old(id1,ii);
                Js(ii) = g([x1_cur;x2_cur],u) + J_old(id1,ii);
            end
        end
        [minval,minpos] = min(Js);
        J_new(i) = minval;
        U(i) = us(minpos);
    end
    max(abs(J_old(J_new < Inf)-J_new(J_new < Inf)));
    J_old = J_new;    
%     subplot(2,1,1)
    contour(Xs1,Xs2,J_new,30)
    axis equal
    grid on;
%     subplot(2,1,2)
    % figure(4)
    % surf(Xs1,Xs2,U)
    % zlim([-20,20])
    axis equal
    drawnow;
end

figure(4)
surf(Xs1,Xs2,U)
zlim([-20,20])

n = 500;
x1_0 = -2; x2_0 = 10;
xs_traj = zeros(2,n+1);
xs_traj(:,1) = [x1_0;x2_0];
us_traj = zeros(1,n);
for i=1:n
    [~,id1] = min(abs(xs_traj(1,i)-xs1));
    [~,id2] = min(abs(xs_traj(2,i)-xs2));
    us_traj(i) = U(id1,id2);
    xs_traj(1,i+1) = xs_traj(1,i) + dt*xs_traj(2,i);
    xs_traj(2,i+1) = xs_traj(2,i) + dt*us_traj(i);
end

figure(2)
plot(xs_traj(1,:),xs_traj(2,:))


J_true = 0*Xs1;
for i=1:numel(Xs1)
    x_temp = [Xs1(i);Xs2(i)];
    J_true(i) = x_temp'*[sqrt(3), 1;1 sqrt(3)]*x_temp;
end
figure(3)
contour(Xs1,Xs2,J_true)
axis equal
