function Sigma_h_Dec = solve_Sigma_h_Dec(s,k11,Tau_O,Sigma_a,DeltaSigma_or,R,K,x,DeltaSigma_oi,H,gr,y)

% Calculate temperature DECREASE to level corresponding to load factor of K
% Use IEC 60076-7 (Published 2005)


f3 = exp((-s)/(k11*Tau_O));

%
Sigma_h_Dec = Sigma_a + DeltaSigma_or * ((1 + R * K.^2) / (1 + R)).^x + (DeltaSigma_oi - DeltaSigma_or * ((1 + R * K.^2) / (1 + R )).^x) .* f3 + H * gr * K.^y;
