function TH = cv7rmncp0 (U,Y,P0,th0)
th = th0;       % inicializace vektoru neznamich parametru                                  
P = P0;         % inicializace kovarincni matice
TH = zeros(2,length(U)); TH(:,1) = th0; % priprava vystupni matice parametru
for k = 2:length(U)                             
    phi = [-Y(k-1), U(k-1)]';   % vypocet phi pro aktualni krok
    e = Y(k) - phi'*th;                          % vypocet odchylky
    K = P*phi / (1 + phi'*P*phi);                % vypocet korekce
    P = P - K*phi'*P;                            % aktualizace kovarincni matice
    th = th + K * e;                             % vypocet odhadu parametru v aktualnim koroce
    TH(:,k) = th;                                
end
end