function Sigma_h_Inc = solve_Sigma_h_Inc(t,k11,Tau_O,k21,k22,Tau_W,Sigma_a,DeltaSigma_oi,DeltaSigma_or,R,K,x,DeltaSigma_hi,H,gr,y)

% Calculate temperature increase to level corresponding to load factor of K
% Use IEC 60076-7 (Published 2005)

% first f3 factor might be -1* or 1* depending ons starting K   | ToDo


f1 = 1*(1 - exp((-t)/(k11 * Tau_O))); 


f2 = 1*k21 * (1 - exp((-t)/(k22 * Tau_W))) - (k21 - 1) * (1 - exp((-t)/(Tau_O/k22))); 



%
Sigma_h_Inc = Sigma_a + DeltaSigma_oi + ( DeltaSigma_or * ((1 + R * K.^2)/(1 + R)).^x - DeltaSigma_oi )* f1 + DeltaSigma_hi + (H*gr*K.^y - DeltaSigma_hi) * f2; 