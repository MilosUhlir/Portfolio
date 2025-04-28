clc; clear;

P = [3 1;
     1 4;
     5 1;
     2 2;
     4 3];
M = [4,5];%[5,3];
r= length(M);
[cost,times] = cv_06_schedule_cost(P,M)
n = 5;
X = 1:n;
K = setdiff(X, M);
temp = sum(P(M, 1));
[~, idxs] = sort(P(K,1));
S1 = 0;
for k = r+1:n
     S1 = S1 + temp + (n-k+1)*P(K(idxs(k-r)),1) + ...
          P(K(idxs(k-r)),2);

end
S1

[~,idxs] = sort(P(K,2));
C_ir = times(end,end);
temp = max(C_ir, sum(P(M,1)) + min(P(K,1)));
S2 = 0;
for k=r+1:n
     S2 = S2 + temp + (n-k+1)*P(K(idxs(k-r)),2);
end
S2

cost + max(S1,S2)