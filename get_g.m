function g = get_g(DeltaSigma_hr,Htemp)
        
   g = DeltaSigma_hr/Htemp; % Average winding-to-average-oil temperature gradient @ rated current [Ws/K]

        
    thestring1 = sprintf('Gradient = %0.2f',g);
    disp(thestring1);
    
end