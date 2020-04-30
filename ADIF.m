function Output_ADIF = ADIF(Sigma_a,DeltaSigma_or,DeltaSigma_hr,Tau_W,Tau_O,x,y,k11,k21,k22,R,Sigma_o_max,Sigma_h_max,PrecedingLoad,EndLoad,showgraph,settime,endtime,Thermset)



%% Input

S_ai = Sigma_a;

Ki = PrecedingLoad;
Ko = EndLoad;

D = 1;
t = 1;

H_Limit = Sigma_h_max;
O_Limit = Sigma_o_max;

%% Core Loop | Calculate Hot Spot and Top Oil Temperatures

Sigma_h_sendVEC = [];
Sigma_o_sendVEC = [];
TIME = [];
KVEC = [];
LOL_sendVEC = [];
ExternalLoopCount = 1;

for K = Ki:0.05:Ko

    [n,hsreached_flag,toreached_flag,converge_flag,Sigma_h_send,Sigma_o_send,LOL_send,TIMEVEC_send] = ADIF_Core(Ki,R,x,DeltaSigma_or,S_ai, k21,y, DeltaSigma_hr,K,D,t,k11,Tau_O,k22,Tau_W,H_Limit,O_Limit,showgraph,settime,endtime,Thermset);
    
    if hsreached_flag
        
        thestringa1 = sprintf('# Calculating STEP %0.0f',ExternalLoopCount);
        thestringa = sprintf('  Hot-spot Limit Reached at K = %0.2f after %0.0f min / %0.2f hrs',K,n-1,(n-1)/60);
        thestringb = sprintf('  Top-oil = %0.2f C | Hot-spot = %0.2f C',Sigma_o_send, Sigma_h_send);
        thestringc = sprintf('  Loss of life = %0.3f days',LOL_send);
        
        disp(' ');
        disp(thestringa1);
        disp(' ');
        disp(thestringa);
        disp(thestringb);
        disp(thestringc);
        disp(' ');
        
        Sigma_h_sendVEC = [Sigma_h_sendVEC;Sigma_h_send]; %#ok<AGROW>
        Sigma_o_sendVEC = [Sigma_o_sendVEC;Sigma_o_send]; %#ok<AGROW>
        TIME = [TIME;TIMEVEC_send]; %#ok<AGROW>
        LOL_sendVEC = [LOL_sendVEC;LOL_send];  %#ok<AGROW>
        
    end
    
    if toreached_flag
        
        thestringd1 = sprintf('# Calculating STEP %0.0f',ExternalLoopCount);        
        thestringd = sprintf('  Top-oil Limit Reached at K = %0.2f after %0.0f min / %0.2f hrs',K,n-1,(n-1)/60);
        thestringe = sprintf('  Top-oil = %0.2f C | Hot-spot = %0.2f C',Sigma_o_send, Sigma_h_send);
        thestringf = sprintf('  Loss of life = %0.3f days',LOL_send);
        disp(' ');
        disp(thestringd1);
        disp(' ');
        disp(thestringd);
        disp(thestringe);
        disp(thestringf);
        disp(' ');
        
        Sigma_h_sendVEC = [Sigma_h_sendVEC;Sigma_h_send]; %#ok<AGROW>
        Sigma_o_sendVEC = [Sigma_o_sendVEC;Sigma_o_send]; %#ok<AGROW>
        TIME = [TIME;TIMEVEC_send]; %#ok<AGROW>
        LOL_sendVEC = [LOL_sendVEC;LOL_send]; %#ok<AGROW>
        
    end
    
    if converge_flag
        
        thestringg1 = sprintf('# Calculating STEP %0.0f',ExternalLoopCount);        
        thestringg = sprintf('  Continuous Loading Achieved at K = %0.2f after %0.0f min / %0.2f hrs',K,n-1,(n-1)/60);
        thestringh = sprintf('  Top-oil = %0.2f C | Hot-spot = %0.2f C',Sigma_o_send, Sigma_h_send);
        thestringi = sprintf('  Loss of life = %0.3f days',LOL_send);
        disp(' ');
        disp(thestringg1);
        disp(' ');
        disp(thestringg);
        disp(thestringh);
        disp(thestringi);
        disp(' ');
        
        Sigma_h_sendVEC = [Sigma_h_sendVEC;Sigma_h_send]; %#ok<AGROW>
        Sigma_o_sendVEC = [Sigma_o_sendVEC;Sigma_o_send]; %#ok<AGROW>
        TIME = [TIME;TIMEVEC_send]; %#ok<AGROW>
        LOL_sendVEC = [LOL_sendVEC;LOL_send]; %#ok<AGROW>
        
    end
    
        KVEC = [KVEC;K]; %#ok<AGROW>
        ExternalLoopCount = ExternalLoopCount+1;
end   
    
%% Plot

    if showgraph
        
        figure(1)
        
        subplot(2,1,1)
        plot(TIME,Sigma_o_sendVEC,':b','LineWidth',1);

        
        hold on;
        
        subplot(2,1,1)
        plot(TIME,Sigma_h_sendVEC,':r','LineWidth',1);

        subplot(2,1,2)
        plot(TIME,LOL_sendVEC,':k','LineWidth',1);
                           
    end

%% Output

Output_ADIF = [TIME,Sigma_h_sendVEC,Sigma_o_sendVEC,KVEC];
    
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

fullFileName = fullfile(newSubFolder, 'ADIF.mat');
save(fullFileName);

end  
    

