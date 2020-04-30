function k21 = get_k21(CoolingMethod)

    % IEC 60076-7:2005 p.105
    
    if strcmp('ONAN',CoolingMethod) == 1
        
        k21 = 1; % default power should be 2%
        
    elseif  strcmp('ONAF',CoolingMethod) == 1
        
        k21 = 2;
        
    elseif strcmp('OFAN',CoolingMethod) == 1 || strcmp('OFAF',CoolingMethod) == 1
        
        k21 = 1.3;
        
    elseif strcmp('ODAN',CoolingMethod) == 1 || strcmp('ODAF',CoolingMethod) == 1
        
        k21 = 1;
        
    end
    
 
    thestring1 = sprintf('k21 Factor = %0.1f',k21);
    disp(thestring1);
    
end