function [RAR] = solve_RAR(HSTemp, ThermSet)

% Calculate Relative Aging Rate based on Hot Spot Temperature
% Use IEC 60076-7 (Published 2005)


%
 if ThermSet == 1
    
        %Relative Aging Rate for Thermally Upgraded Paper
  
        RAR = exp(((15000)/(110+273))-((15000)./(HSTemp + 273)));

        
    elseif ThermSet == 2 
    
        %Relative Aging Rate for Non-Thermally Upgraded Paper
    
    
       RAR = 2.^((HSTemp-98)/6);
        
 end 
end