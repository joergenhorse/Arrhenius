function P = solve_CL(PLL,PNL,PSC,ForcedCoolingLoss)

% Total losses to be removed by cooling equipment [kW];

Ptemp = PLL + PNL - PSC; 
P = Ptemp + Ptemp*(ForcedCoolingLoss);

thestring1 = sprintf('Cooling Losses = %0.2f kW',P);
disp(' ');
disp(thestring1);

end
