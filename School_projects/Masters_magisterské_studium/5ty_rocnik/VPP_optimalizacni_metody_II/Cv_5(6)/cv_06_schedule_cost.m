function [cost,times] = cv_06_schedule_cost(P,M)
r = length(M);
M1_s = zeros(1,r); M1_f = zeros(1,r);
for i=2:r
   M1_f(i-1) = M1_s(i-1) + P(M(i-1),1);
   M1_s(i) = M1_f(i-1);
end
M1_f(r) = M1_s(r) + P(M(r),1);

M2_s = zeros(1,r); M2_f = zeros(1,r);
M2_s(1) = M1_f(1);
for i=2:r
   M2_f(i-1) = M2_s(i-1) + P(M(i-1),2);
   M2_s(i) = max(M2_f(i-1),M1_f(i));
end
M2_f(r) = M2_s(r) + P(M(r),2);
times = [M1_s;M1_f;M2_s;M2_f];

cost = sum(M2_f);
end