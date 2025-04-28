clear;clc;clf;

T = 10;
tmesh = linspace(0,T,101);
solinit = bvpinit(tmesh,@guess);
sol = bvp4c(@odefun,@bcfcn,solinit);
subplot(2,1,1)
plot(sol.y(1,:),sol.y(2,:),'k-o');
grid on
subplot(2,1,2)
plot(sol.x,-0.5*sol.y(4,:),'k-o');
grid on

function dydt = odefun(t,y)
dydt(1,1) = y(2);
dydt(2,1) = -0.5*y(4);
dydt(3,1) = -2*y(1);
dydt(4,1) = -2*y(2)-y(3);
end

function res = bcfcn(xa,xb)
%xa - left initial condition (t=0)
%xb - right initial condition (t=T)
res = [xa(1)+2
       xa(2)-10
       xb(3)-2*xb(1)
       xb(4)-2*xb(2)];
end

function g = guess(t)
g = [1;1;1;1];
end