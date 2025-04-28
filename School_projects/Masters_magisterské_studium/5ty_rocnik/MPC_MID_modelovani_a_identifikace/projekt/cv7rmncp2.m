function TH = cv7rmncp2 (U,Y,Yivm,P0,th0)
th = th0;       % inicializace vektoru neznamych parametru                                  
P = P0;         % inicializace kovarincni matice
TH = zeros(2,length(U)); TH(:,1) = th0; % priprava vystupni matice parametru
for k = 2:length(U)                             
    phi = [-Y(k-1), U(k-1)]';       % vypocet phi pro aktualni krok
   if k > 15    % inicializace klasickou MNC, 5-8 nasobek neznamych parametru
       dz = [-Yivm(k-1), U(k-1)]';   % vypocet vektoru zpozdenich pozorovani pro aktualni krok
       K = P*dz / (1 + phi'*P*dz);  % vypocet korekce
   else     
       K = P*phi / (1 + phi'*P*phi);% vypocet korekce       
   end
    P = P - K*phi'*P;                            % aktualizace kovarincni matice
    e = Y(k) - phi'*th;                          % vypocet odchylky
    th = th + K * e;                             % vypocet odhadu parametru v aktualnim koroce
    TH(:,k) = th;                                
end
end