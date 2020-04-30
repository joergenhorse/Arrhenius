function OE = get_OE (CoolingMethod)

    % x Values IEC 354 p.33
    
    if strcmp('ONAN',CoolingMethod) == 1
        
        OE = 0.8;
        
    elseif  strcmp('ONAF',CoolingMethod) == 1
        
        OE = 0.8;
        
    elseif strcmp('OFAN',CoolingMethod) == 1 || strcmp('OFAF',CoolingMethod) == 1
        
        OE = 1;
        
    elseif strcmp('ODAN',CoolingMethod) == 1 || strcmp('ODAF',CoolingMethod) == 1
        
        OE = 1;
        
    end
    
 
    thestring1 = sprintf('Oil Exponent = %0.1f',OE);
    disp(thestring1);
    
end
