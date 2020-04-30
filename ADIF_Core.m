function [n,hsreached_flag,toreached_flag,converge_flag,Sigma_h_send,Sigma_o_send,LOL_send,TIMEVEC_send] = ADIF_Core(Ki,R,x,DeltaSigma_or,S_ai, k21,y, DeltaSigma_hr,K,D,t,k11,Tau_O,k22,Tau_W,H_Limit,O_Limit,showgraph,settime,endtime,Thermset)


%Initial conditions

Sigma_oVEC = ((1 + Ki.^2 * R)/( 1 + R )).^x * (DeltaSigma_or) + S_ai; % (5)
DeltaSigma_h1VEC = k21 * Ki.^y * DeltaSigma_hr; % (3)
DeltaSigma_h2VEC = (k21 - 1) * Ki.^y * DeltaSigma_hr; % (4)


Sigma_a = S_ai;


DeltaSigma_hVEC = [];
Sigma_hVEC = [];

LOL_MinVEC = [];
LOL_DayVEC = [];
LOL_Min_CumVEC = [];
LOL_Day_CumVEC = [];

STEPVEC = 1;
TIMEVEC = 1;


n = 1;
flag = true;

while flag
    
    Sigma_oi = Sigma_oVEC(n);
    DeltaSigma_h1i = DeltaSigma_h1VEC(n);
    DeltaSigma_h2i = DeltaSigma_h2VEC(n);
 
    
    %Difference calcs
    
    Sigma_o = (Sigma_oi + (D*t/(k11*Tau_O)) * ( ((1 + K.^2 .* R)/( 1 + R )).^x * (DeltaSigma_or) - (Sigma_oi - Sigma_a) ))/D; % (5)
    Sigma_oVEC = [Sigma_oVEC; Sigma_o];  %#ok<AGROW>
    
    DeltaSigma_h2 = (DeltaSigma_h2i + ((k22*D*t)/Tau_O) * ((k21 - 1) * DeltaSigma_hr .* K.^y - DeltaSigma_h2i))/D; % (4)
    DeltaSigma_h2VEC = [DeltaSigma_h2VEC; DeltaSigma_h2];  %#ok<AGROW>
    
    DeltaSigma_h1 = (DeltaSigma_h1i + (D*t/(k22*Tau_W)) * (k21 * DeltaSigma_hr * K.^y - DeltaSigma_h1i))/D; % (3)
    DeltaSigma_h1VEC = [DeltaSigma_h1VEC; DeltaSigma_h1];  %#ok<AGROW>
    
    DeltaSigma_h = DeltaSigma_h1 - DeltaSigma_h2; %(2)
    DeltaSigma_hVEC = [DeltaSigma_hVEC; DeltaSigma_h];  %#ok<AGROW>
    
    Sigma_h = Sigma_o + DeltaSigma_h; % (1)
    Sigma_hVEC = [Sigma_hVEC; Sigma_h];  %#ok<AGROW>
    
    %Populate Vectors
    
    STEPVEC_ADD = STEPVEC(n)+1;
    STEPVEC = [STEPVEC; STEPVEC_ADD]; %#ok<AGROW>
    
    TIMEVEC_ADD = TIMEVEC(n)+1;
    TIMEVEC = [TIMEVEC; TIMEVEC_ADD];  %#ok<AGROW>
    
    %Display calculations
    
    %thestring1 = sprintf('#  Hot-spot = %0.1f C',Sigma_h);
    %thestring2 = sprintf('       Time = %0.0f min',n);
    
    %disp(' ');
    %disp(thestring1);
    %disp(thestring2);
    %disp(' ');
    
    %-----------------------------------------------------------
    
    % Calc Loss Of Life

    RAR = solveRAR(Sigma_h, Thermset); % Calculate Relative Aging Rate
    
    LOL_Min = RAR*n; % [Min]
    LOL_MinVEC = [LOL_MinVEC; LOL_Min];  %#ok<AGROW>
    
    LOL_Day = LOL_Min/1440; % [Day]
    LOL_DayVEC = [LOL_DayVEC; LOL_Day]; %#ok<AGROW>
    
    %Check if Hot-spot limit has been reached
    %--------------------------------------------------------
    
    if settime == false && Sigma_o >= O_Limit
        
        flag = false;
        
        hsreached_flag = false;
        toreached_flag = true;
        converge_flag = false;
        
        Sigma_h_send = Sigma_h; 
        Sigma_o_send = Sigma_o;
        TIMEVEC_send = TIMEVEC(n);
        
        LOL_Min_Cum = (LOL_MinVEC);
        LOL_Min_CumVEC = [LOL_Min_CumVEC;LOL_Min_Cum]; %#ok<AGROW>
        
        LOL_Day_Cum = (LOL_DayVEC);
        LOL_Day_CumVEC = [LOL_Day_CumVEC;LOL_Day_Cum]; %#ok<AGROW>
        
        LOL_send = LOL_Day_CumVEC(end);
        
    %Check if Top-oil limit has been reached
        
    elseif settime == false && Sigma_h >= H_Limit
        
        flag = false;
        
        hsreached_flag = true;
        toreached_flag = false;
        converge_flag = false;
        
        Sigma_h_send = Sigma_h; 
        Sigma_o_send = Sigma_o;
        TIMEVEC_send = TIMEVEC(n);
        
        LOL_Min_Cum = (LOL_MinVEC);
        LOL_Min_CumVEC = [LOL_Min_CumVEC;LOL_Min_Cum]; %#ok<AGROW>
        
        LOL_Day_Cum = (LOL_DayVEC);
        LOL_Day_CumVEC = [LOL_Day_CumVEC;LOL_Day_Cum]; %#ok<AGROW>
        
        LOL_send = LOL_Day_CumVEC(end);
        
    %Check every 2nd vector for convergence
       
    elseif rem(n,2)==0  % Divide remaining
        
        if settime == false && (Sigma_oVEC(n)-Sigma_oVEC(n-1)) <= 0.016 && (Sigma_oVEC(n)-Sigma_oVEC(n-1)) >= -0.016
            
            flag = false;
            
            hsreached_flag = false;
            toreached_flag = false;
            converge_flag = true;
            
            Sigma_h_send = Sigma_h; 
            Sigma_o_send = Sigma_o;
            TIMEVEC_send = TIMEVEC(n);
            
            LOL_Min_Cum = (LOL_MinVEC);
            LOL_Min_CumVEC = [LOL_Min_CumVEC;LOL_Min_Cum]; %#ok<AGROW>
            
            LOL_Day_Cum = (LOL_DayVEC);
            LOL_Day_CumVEC = [LOL_Day_CumVEC;LOL_Day_Cum]; %#ok<AGROW>
            
            LOL_send = LOL_Day_CumVEC(end);
        end
    %--------------------------
         if settime == true 
            if n == endtime
            flag = false;
            
            hsreached_flag = false;
            toreached_flag = false;
            converge_flag = true;
            
            Sigma_h_send = Sigma_h; 
            Sigma_o_send = Sigma_o;
            TIMEVEC_send = TIMEVEC(n);
            
            LOL_Min_Cum = (LOL_MinVEC);
            LOL_Min_CumVEC = [LOL_Min_CumVEC;LOL_Min_Cum]; %#ok<AGROW>
            
            LOL_Day_Cum = (LOL_DayVEC);
            LOL_Day_CumVEC = [LOL_Day_CumVEC;LOL_Day_Cum]; %#ok<AGROW>
            
            LOL_send = LOL_Day_CumVEC(end);
            
            end
            
        end
        
    %--------------------------
    end
    
    
    
    n = n+1;
    
end

% Correct data, Remove 1st row (= initial conditions)

Sigma_h_adj = [Sigma_hVEC(1);Sigma_hVEC];
Sigma_o_adj = Sigma_oVEC(1:end,1);

LOL_MinVEC_adj = [0;LOL_MinVEC]; %#ok<NASGU>
LOL_Min_CumVEC_adj = [0;LOL_Min_CumVEC]; %#ok<NASGU>

LOL_DayVEC_adj = [0;LOL_DayVEC]; %#ok<NASGU>
LOL_Day_CumVEC_adj = [0;LOL_Day_CumVEC];


if showgraph
    
    hFig = figure(1);
    set(hFig, 'Position', [1200 50 600 900])



    subplot(2,1,1)
    plot(TIMEVEC,Sigma_h_adj,'-r','LineWidth',0.5);
    title('|Short Time Loading|')
    xlabel('Time [min]');
    ylabel('Top Oil/Hot-Spot Temperature [C]');
    
    hold on;
    
   
    subplot(2,1,1)
    plot(TIMEVEC,Sigma_o_adj);
    title('|Short Time Loading|')
    xlabel('Time [min]');
    ylabel('Top Oil/Hot-Spot Temperature [C]');
    
    %hold on;
   
    %subplot(3,2,6)
    %plot(TIMEVEC,LOL_Min_CumVEC_adj,'-k','LineWidth',1);
    %xlabel('Time [min]');
    %ylabel('Loss Of Life [min]');
    
    hold on;

    subplot(2,1,2)
    plot(TIMEVEC,LOL_Day_CumVEC_adj,'-k','LineWidth',1);
    xlabel('Time [min]');
    ylabel('Loss Of Life [days]');
    
    hold on;

  
end

%% Save Workspace

% First, get the name of the folder you're using.
yourFolder = pwd;
[~, deepestFolder] = fileparts(yourFolder);
% Next, create a name for a subfolder within that.
% For example 'D:\photos\Info\DATA-Info'
newSubFolder = sprintf('%s/OUTPUT-%s', yourFolder, deepestFolder);
% Finally, create the folder if it doesn't exist already.
if ~exist(newSubFolder, 'dir')
  mkdir(newSubFolder);
end

fullFileName = fullfile(newSubFolder, 'ADIF_Core.mat');
save(fullFileName);

end