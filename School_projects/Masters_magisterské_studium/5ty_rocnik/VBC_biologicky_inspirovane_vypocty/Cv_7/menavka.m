clear
clc
clf
hold on


% nelder mead
% tested on rosenbrock function

x = linspace(-2,2, 300);
y = linspace(-1,3, 300);
z = zeros(length(x), length(y));
S = [-1, 0, 0;    % [x0, y0, CF0]
      0, 0, 0;    % [x1, y1, CF1]
     -1, 1, 0];   % [x2, y2, CF2]

% RB plot
for r = 1:length(x)
    for s = 1:length(y)
        z(r,s) = RBeval([x(s), y(r)]);
    end
end
RBplot(x,y,z);
plot([S(:,1); S([2,3,1],1)],...
     [S(:,2); S([2,3,1],2)],...
     'r', 'LineWidth', 0.5)

xlabel('x_1')
ylabel('x_2')

for iter = 1:100

    % clf
    % RBplot(x,y,z);
    % hold on
    plot([S(:,1); S([2,3,1],1)],...
     [S(:,2); S([2,3,1],2)],...
     'r', 'LineWidth', 0.5)
    % pause(0.5)

    for i = 1:size(S,1)
        S(i,3) = RBeval(S(i,:));
    end
    S = sortrows(S,3);
    C = getCentroid(S(1:2,:));
    R = getReflection(S,C);
    R(3) = RBeval(R);
    if R(3) < S(2,3) && R(3) >= S(1,3)
        S(3,:) = R;
        disp('reflection')
        continue
    end

    if R(3) < S(1,3)
        E = getExpansion(S,C);
        E(3) = RBeval(E);
        if E(3) < R(3)
            S(3,:) = E;
            disp('Expansion')
            continue
        else
            S(3,:) = R;
            disp('reflection 2')
            continue
        end
    end

    K = getContraction(S, C);
    K(3) = RBeval(K);
    if K(3) < S(3,3)
        S(3,:) = K;
        disp('Contraction')
        continue
    end

    S = shrink(S);
    disp('shrink')

end

plot(S(1,1), S(2,1), 'r*', 'LineWidth',3)




%% Pomocné Funkce

function z = RBeval(x)
    z = (1-x(1))^2 + 100*(x(2) - x(1)^2)^2;
end

function RBplot(x,y,z)
    contour(x,y,z,[0.05,2,10,75,333,1666],'Color',[0,0,0],'LineWidth',1.5)
end


function c = getCentroid(S)
    c = (S(1,:) + S(2,:))/2;
end

function r = getReflection(S,C)
    o = C - S(3,:);
    r = C + o;
end

function e = getExpansion(S,C)
    o = 2*(C - S(3,:));
    e = C + o;
end

function k = getContraction(S,C)
    o = 1/2*(C - S(3,:));
    k = C + o;
end

function s = shrink(s)
    for i = 2:size(s,1)
        s(i,1) = s(1,1) + 0.5*(s(i,1) - s(1,1));
        s(i,2) = s(1,2) + 0.5*(s(i,2) - s(1,2));
    end
end