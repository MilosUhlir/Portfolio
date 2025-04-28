clear, clc;

% Create grid of input values
[x1, x2] = meshgrid(-5:0.1:5);

% Evaluate the function over the grid
z = dejong5_2([x1(:), x2(:)])
% z = reshape(z, size(x1));

% Plot the surface
figure;
surf(x1, x2, z);
xlabel('x1');
ylabel('x2');
zlabel('f(x1,x2)');
title('De Jong Function No. 5');


function f = dejong5_2(x)
    f = 0.5 * ((x(1)^2 + x(2)^2)^2 - 2*x(1)^2 - 2*x(2)^2 + 1);
end