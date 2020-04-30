function LR = solveget_LR (OSelectLR,PLL,PNL,CoolingMethod)

if strcmp('y',OSelectLR) == 1
    
    LR = PLL/PNL;
    
end

if strcmp('n',OSelectLR) == 1
    
    % IEC 60076-7:2005 p.105
    
    if strcmp('ONAN',CoolingMethod) == 1
        
        LR = 5;
        
    elseif  strcmp('ONAF',CoolingMethod) == 1
        
        LR = 6;
        
    elseif strcmp('OFAN',CoolingMethod) == 1 || strcmp('OFAF',CoolingMethod) == 1
        
        LR = 6;
        
    elseif strcmp('ODAN',CoolingMethod) == 1 || strcmp('ODAF',CoolingMethod) == 1
        
        LR = 6;
        
    end
    
end

    disp(' ');
    thestring1 = sprintf('Loss ratio = %0.1f',LR);
    disp(thestring1);
    
end