function WE = get_WE (CoolingMethod)

   % y Values IEC 354 p.33
    
    if strcmp('ONAN',CoolingMethod) == 1
        
        WE = 1.6; % default power should be 1.3%
        
    elseif  strcmp('ONAF',CoolingMethod) == 1
        
        WE = 1.3;
        
    elseif strcmp('OFAN',CoolingMethod) == 1 || strcmp('OFAF',CoolingMethod) == 1
        
        WE = 1.6;
        
    elseif strcmp('ODAN',CoolingMethod) == 1 || strcmp('ODAF',CoolingMethod) == 1
        
        WE = 2.0;
        
    end
    
    
    thestring1 = sprintf('Winding Exponent = %0.1f',WE);
    disp(thestring1);

end 