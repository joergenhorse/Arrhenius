function Sigma_o_Dec = solve_Sigma_o_Dec(t,Sigma_a,DeltaSigma_oi,DeltaSigma_or,R,K,x,Tau_O,k11)


% Use IEC 60076-7 (Published 2005)


Sigma_o_Dec = Sigma_a + DeltaSigma_oi + ( DeltaSigma_or * ((1 + R * K.^2)/(1 + R)).^x - DeltaSigma_oi )* (1 - exp(-t/(k11*Tau_O)));

end
