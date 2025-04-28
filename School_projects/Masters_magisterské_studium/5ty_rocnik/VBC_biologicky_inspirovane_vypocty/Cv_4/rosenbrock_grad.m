function [val] = rosenbrock_grad(x)
global gradient_calls
gradient_calls = gradient_calls + 1;

a = 1; b = 5;
val = [-2*(a-x(1))+2*b*(x(2)-x(1)^2)*(-2*x(1)); 2*b*(x(2)-x(1)^2)];

end

