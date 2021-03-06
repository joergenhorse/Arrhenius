function OutputTableAK24 = AK24(RatedMVA,CoolingMethod,Design_Sigma_a,MaxAmp)



%% K24

Sigma_a = [-25 -20 -10 0 10 20 30 40 50];
Delta_Sigma_h = [132 118 108 98 88 78 68 58 0];
ON = [1.33 1.30 1.22 1.15 1.08 1.00 0.92 0.82 0.77];
OF = [1.31 1.28 1.21 1.14 1.08 1.00 0.92 0.83 0.77];
OD = [1.24 1.22 1.17 1.11 1.06 1.00 0.94 0.87 0.77];

FactorTable = [Sigma_a; Delta_Sigma_h; ON; OF; OD];



% Cooling selection

if strcmp('ONAN',CoolingMethod) == 1 || strcmp('ONAF',CoolingMethod) == 1
    
    K24 = ON;
    
elseif strcmp('OFAN',CoolingMethod) == 1 || strcmp('OFAF',CoolingMethod) == 1
        
        K24 = OF;
        
elseif strcmp('ODAN',CoolingMethod) == 1 || strcmp('ODAF',CoolingMethod) == 1
            
            K24 = OD;
            
end

%% Calculations 

%(Ambient  20C)


MVA_adj = K24 .* RatedMVA;

AMP_adj = (MVA_adj./MVA_adj(end)) .* MaxAmp;


%(Ambient  30C)

temp = Design_Sigma_a + 1; %temp holder 


%% OUTPUT

Titles = char('Ambient [C]','Hot-spot [C]','K24 [p.u]','Rating [MVA]','Current [A]');


OutputTemp = [Sigma_a; Delta_Sigma_h; K24; MVA_adj; AMP_adj];
OutputTemp2 = num2str(OutputTemp);

OutputTableAK24 = horzcat(Titles,OutputTemp2);

graph_AK24(MVA_adj,Sigma_a);

screen2jpeg('AK24_Graph');

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

fullFileName = fullfile(newSubFolder, 'AK24.mat');
save(fullFileName);

end
 