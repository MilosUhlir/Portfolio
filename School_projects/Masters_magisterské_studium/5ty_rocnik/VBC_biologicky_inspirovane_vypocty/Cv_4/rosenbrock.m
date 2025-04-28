function [val] = rosenbrock(x)
global function_calls
function_calls = function_calls + 1;
a = 1; b = 5;
val = (a-x(1))^2 + b*(x(2)-x(1)^2)^2;
end

