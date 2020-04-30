function WTC = solveget_WTC (OSelectW,CoolingMethod,m_W, c, g, P_w)

% IEC 60076-7:2005 p.69

if strcmp('y',OSelectW) == 1
    
    WTC = ((m_W * c * g) / (60 * P_w * 1000));
    
end


% IEC 60076-7:2005 p.105

if strcmp('n',OSelectW) == 1
    
    if strcmp('ONAN',CoolingMethod) == 1
        
        WTC = 4; % default power should be 10%
        
    elseif  strcmp('ONAF',CoolingMethod) == 1
        
        WTC = 7;
        
    elseif strcmp('OFAN',CoolingMethod) == 1 || strcmp('OFAF',CoolingMethod) == 1
        
        WTC = 7;
        
    elseif strcmp('ODAN',CoolingMethod) == 1 || strcmp('ODAF',CoolingMethod) == 1
        
        WTC = 7;
        
    end
    
end

thestring1 = sprintf('Winding Time Constant = %0.1f',WTC);
disp(thestring1);

end