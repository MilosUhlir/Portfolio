clear;clc;clf
dt = 0.5; N = 50; gamma = 0.2; 
lambda = 0.005;
sigma = 1*diag([0.005,0.002,0.005,0.001,0]);
x0 = [2;0;2;0;9.8];
A = [1 dt 0 0 0;
     0 1-dt*gamma 0 0 0;
     0 0 1 dt 0;
     0 0 0 1-dt*gamma -dt;
     0 0 0 0 1];
B = [0,0;dt,0;0,0;0,dt;0,0];
Q_k = (1-lambda)*eye(5);Q_k(2,2) = 0; Q_k(4,4) = 0; 
Q_N = (1-lambda)*eye(5);Q_N(2,2) = 0; Q_N(4,4) = 0; 
R = 0.01*lambda*eye(2);

x_traj = zeros(5,N+1);
x_traj(:,1) = x0;
for i=2:N+1
    x_traj(1,i) = x0(1) + (i-1)*dt;
    x_traj(3,i) = x0(3) + sin((i-1)*dt);
end

P = Q_N;
Q = Q_k;
L = zeros(2,5,N+1);
L_v = zeros(2,5,N+1);
K = zeros(5,5,N+1);
v = zeros(5,1,N+1);
K(:,:,N+1) = P; v(:,:,N+1) = P*x_traj(:,N+1);
for k=N:-1:1
    L(:,:,k) = -inv(B'*K(:,:,k+1)*B+R)*B'*K(:,:,k+1)*A;
    K(:,:,k) = A'*K(:,:,k+1)*(A+B*L(:,:,k))+Q;
    v(:,:,k) = (A+B*L(:,:,k))'*v(:,:,k+1)+Q*x_traj(:,k);
    L_v(:,:,k) = inv(B'*K(:,:,k+1)*B+R)*B';
end


%% simulace
xs = zeros(5,N+1) ; xs(:,1) = x0;
us = zeros(2,N);
for k=1:N
    us(:,k) = L(:,:,k)*xs(:,k) + L_v(:,:,k)*v(:,:,k+1);
    xs(:,k+1) = A*xs(:,k) + B*us(:,k) + ...
        mvnrnd(zeros(5,1),sigma)';
end


subplot(2,1,1)
hold on;
plot(x_traj(1,:),x_traj(3,:),'k-x')
plot(xs(1,:),xs(3,:),'b-x')
axis equal; grid on;
subplot(2,1,2)
hold on;
plot(us(1,:));plot(us(2,:));grid on;