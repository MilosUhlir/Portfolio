function [TH, LBD] = rmnc3(U,Y,P0,th0,lbd0)
    N = length(U);
    th = th0;
    TH = zeros(height(th0),N);
    TH(:,1) = th0;
    TH(:,2) = th0;
    P = P0;
    LBD = lbd0;
    for k = 3:N
        if abs(U(k-1)-U(k)) > 0.5
            LBD(end+1) = lbd0;
        else
            LBD(end+1) = 0.99*LBD(end,1)+(1-0.99);
        end
        phi = [-Y(k-1);
               -Y(k-2);
               U(k-1);
               U(k-2)];
        e = Y(k) - phi' * TH(:,k-1);
        K = (P*phi)/(LBD(end)*1+phi'*P*phi);
        P = (1/LBD(end))*(P-K*phi'*P);
        th = th + K*e;
        
        TH(:,k) = th;
    end
end