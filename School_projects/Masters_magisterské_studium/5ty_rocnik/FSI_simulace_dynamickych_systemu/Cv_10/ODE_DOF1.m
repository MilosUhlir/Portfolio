function x_dot = ODE_DOF1(m,b,k,x, F0, omega, t)
% Funkce obsahující diferenciální rovnice pro 1DOF
% Vrací polohu a rychlost

x_dot(1) = x(2);
x_dot(2) = 1/m*(-b*x(2) - k*x(1) + F0*sin(omega*t));
x_dot = x_dot';


end


% 
% function x_dot = ODE_DOF1(m,b,k,x)
% % Funkce obsahující diferenciální rovnice pro 1DOF
% % Vrací polohu a rychlost
% 
% x_dot(1) = x(2);
% x_dot(2) = 1/m*(-b*x(2) - k*x(1));
% x_dot = x_dot';
% 
% end