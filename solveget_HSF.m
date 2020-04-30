function HSF = solveget_HSF (CoolingMethod)

    % IEC 60076-7:2005 p.105
    
    if strcmp('ONAN',CoolingMethod) == 1
        
        HSF = 1.3;
        
    elseif  strcmp('ONAF',CoolingMethod) == 1
        
        HSF = 1.3;
        
    elseif strcmp('OFAN',CoolingMethod) == 1 || strcmp('OFAF',CoolingMethod) == 1
        
        HSF = 1.3;
        
    elseif strcmp('ODAN',CoolingMethod) == 1 || strcmp('ODAF',CoolingMethod) == 1
        
        HSF = 1.3;
        
    end
    
 
    thestring1 = sprintf('Hot-spot Factor = %0.1f',HSF);
    disp(thestring1);
    
end