function k11 = get_k11(CoolingMethod)

    % IEC 60076-7:2005 p.105
    
    if strcmp('ONAN',CoolingMethod) == 1
        
        k11 = 1; % default power should be 1.3%
        
    elseif  strcmp('ONAF',CoolingMethod) == 1
        
        k11 = 0.5;
        
    elseif strcmp('OFAN',CoolingMethod) == 1 || strcmp('OFAF',CoolingMethod) == 1
        
        k11 = 1;
        
    elseif strcmp('ODAN',CoolingMethod) == 1 || strcmp('ODAF',CoolingMethod) == 1
        
        k11 = 1;
        
    end
    
 
    thestring1 = sprintf('k11 Factor = %0.1f',k11);
    disp(thestring1);
    
end