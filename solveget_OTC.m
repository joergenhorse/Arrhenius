function OTC = solveget_OTC (OSelectO,CoolingMethod, m_A, m_T, m_O, DeltaSigma_o_mean, P)

% IEC 60076-7:2005 p.69

if strcmp('y',OSelectO) == 1
    
    %ON
    if strcmp('ONAN',CoolingMethod) == 1 || strcmp('ONAF',CoolingMethod) == 1
        
        C = 0.132 * m_A + 0.0882 * m_T + 0.400 * m_O;
        
        %OD/OF
    elseif strcmp('OFAN',CoolingMethod) == 1 || strcmp('OFAF',CoolingMethod) == 1 || strcmp('ODAN',CoolingMethod) == 1 || strcmp('ODAF',CoolingMethod) == 1
        
        C = 0.132 * (m_A + m_T) + 0.400 * m_O;
        
    end
    
  
    OTC = (C * DeltaSigma_o_mean * 60) / (P * 1000);
end    
% IEC 60076-7:2005 p.105
  
if strcmp('n',OSelectO) == 1
    
    if strcmp('ONAN',CoolingMethod) == 1
        
        OTC = 180; % % default power should be 210 
        
    elseif  strcmp('ONAF',CoolingMethod) == 1
        
        OTC = 150;
        
    elseif strcmp('OFAN',CoolingMethod) == 1 || strcmp('OFAF',CoolingMethod) == 1
        
        OTC = 90;
        
    elseif strcmp('ODAN',CoolingMethod) == 1 || strcmp('ODAF',CoolingMethod) == 1
        
        OTC = 90;
        
    end
    
end

thestring1 = sprintf('Oil Time Constant = %0.1f', OTC);
disp(thestring1);

end
