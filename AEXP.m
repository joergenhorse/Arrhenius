function OutputTableAEXP = AEXP(Sigma_a,DeltaSigma_or,DeltaSigma_hr,Tau_W,Tau_O,x,y,k11,k21,k22,R,H,g,TIME,K)



%% INPUT



% Calculate Loading STEP duration [min]

mapLength = length(TIME);

D = zeros(1,mapLength);
D(1) = TIME(1);

for m = mapLength:-1:2

Dtmp = TIME(m) - TIME(m-1);

D(m) = Dtmp;

end



N = mapLength; % Counter

%% CORE LOOP | Calc Hot Spot and Top Oil Temperatures

Sigma_hVEC = [];
Sigma_oVEC = [];

%Initial conditions

    
DeltaSigma_oi = DeltaSigma_or; % ((1 + K(1).^2 * R)/( 1 + R )).^x * (DeltaSigma_or) + Sigma_a; % (5) This is wrong! Hope you can fix it.

%DeltaSigma_hi = k21 * K(1).^y * DeltaSigma_hr; % (3)

DeltaSigma_hi = DeltaSigma_hr; % (4)





for i = 1:N
   
    

EndSTEP = D(i)-1;
  

t = 0:1:EndSTEP; % Increased Load Factor Time [min] 
s = 0:1:EndSTEP; % Decreased Load Factor Time [min]

    if K(i) >= 1
        
        
        %Calc for Increased Load Factor
    
        Sigma_h_Inc = solve_Sigma_h_Inc(t,k11,Tau_O,k21,k22,Tau_W,Sigma_a,DeltaSigma_oi(i),DeltaSigma_or,R,K(i),x,DeltaSigma_hi(i),H,g,y);
        
        Sigma_hVEC = [Sigma_hVEC, Sigma_h_Inc];
       
        Sigma_o_Inc = solve_Sigma_o_Inc(t,Sigma_a,DeltaSigma_oi(i),DeltaSigma_or,R,K(i),x,Tau_O,k11);
                
        Sigma_oVEC = [Sigma_oVEC, Sigma_o_Inc];
        
        DeltaSigma_oi = [DeltaSigma_oi; (Sigma_oVEC(TIME(i)) - Sigma_a)]; 
        DeltaSigma_hi = [DeltaSigma_hi; Sigma_hVEC(TIME(i)) - Sigma_oVEC(TIME(i))];
        
    elseif K(i) < 1
    
        % Calc for Decreased Load Factor
    
    
        Sigma_h_Dec = solve_Sigma_h_Dec(s,k11,Tau_O,Sigma_a,DeltaSigma_or,R,K(i),x,DeltaSigma_oi(i),H,g,y);
        
        Sigma_hVEC = [Sigma_hVEC, Sigma_h_Dec];
        
        Sigma_o_Dec = solve_Sigma_o_Dec(t,Sigma_a,DeltaSigma_oi(i),DeltaSigma_or,R,K(i),x,Tau_O,k11);
                
        Sigma_oVEC = [Sigma_oVEC, Sigma_o_Dec];
 
        DeltaSigma_oi = [DeltaSigma_oi; (Sigma_oVEC(TIME(i)) - Sigma_a)]; 
        DeltaSigma_hi = [DeltaSigma_hi; Sigma_hVEC(TIME(i)) - Sigma_oVEC(TIME(i))];
    
        
    end
    
% Calculation status    

thestring1 = sprintf('#  Calculating STEP %d',i);
thestring2 = sprintf('   %d min       |   Temperature = %0.1f C', TIME(i)-D(i)+1, Sigma_hVEC(TIME(i)-D(i)+1));
thestring3 = sprintf('   %d min       |   Temperature = %0.1f C', TIME(i), Sigma_hVEC(TIME(i)));


disp(thestring1);
disp(thestring2);
disp(thestring3);
disp(' ');

end

%% Calc Loss Of Life

%RAR = solveRAR(Sigma_h_Inc, 1); % Calculate Relative Aging Rate

% Calculate Loss Of Life Factor

%LOLF = sum(RAR)./TIME(N);

% Calculate Loss Of Percentage 

%LOL = ((LOLF*TIME(N))/65000)*100;


%% OUTPUT

tst = 1:1:TIME(N);  


% 'Time [min]', 'Hot Spot [C]', 'Loss Of Life [p.u]']; 
tst = 1:1:TIME(N);  
OutputTableAEXP = [tst',Sigma_hVEC',Sigma_oVEC'];

graphmatrix = [Sigma_hVEC;Sigma_oVEC];

graph_AEXP(tst, graphmatrix);  
screen2jpeg('AEXP_Graph');

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

fullFileName = fullfile(newSubFolder, 'AEXP.mat');
save(fullFileName);
   

end                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         