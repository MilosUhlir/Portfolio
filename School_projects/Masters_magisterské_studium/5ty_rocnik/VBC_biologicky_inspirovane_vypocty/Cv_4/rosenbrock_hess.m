function [val] = rosenbrock_hess(x)
a = 1; b = 5;
val = [2+2*b*((-2*x(1))^2 -2*(x(2)-x(1)^2)), -4*b*x(1);
            -4*b*x(1), 2*b]/2;
end

