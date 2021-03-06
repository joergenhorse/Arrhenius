function ARRHENIUS_StandAlone

%%% ARRHENIUS - Transformer Temperature Based Overloading
%% Introduction to ARRHENIUS
% _Created by Christo Holtshausen_


%%
% ARRHENIUS is name given to the overloading program.

%% Initialize

delete('LongFile.txt');
diary('LongFile.txt');

diary on

close all;
clear;
clc;

disp('__________________________________');
disp(' ');
disp('ARRHENIUS Build 1.0 ______________');
disp('__________________________________');
disp(' ');

% Prompt models to run

disp(' Enable [y/ENTER] | Disable [n]');
disp(' ');

mod1 = input('RUN Transient Loading ? y/n : ','s');
if isempty(mod1)
    mod1 = 'y';
    disp('> |ADIF Selected|');
    shwgrph = input('Plot while calculating? y/n : ','s');
    if strcmp('y',shwgrph) == 1
        showgraph = 1;
        disp('> |Plot Enabled|')
    elseif strcmp('n',shwgrph) == 1
        showgraph = 0;
        disp('> |Plot Disabled|')
    else
        showgraph = 1;
        disp('> |Plot Enabled|')
    end
elseif strcmp('n',mod1) == 1
    disp('> |ADIF Disabled|');
else
    mod1 = 'y';
    disp('> |ADIF Selected|');
    shwgrph = input('Show ADIF graph? y/n : ','s');
    if strcmp('y',shwgrph) == 1
        showgraph = 1;
        disp('> |Plot Enabled|')
    elseif strcmp('n',shwgrph) == 1
        showgraph = 0;
        disp('> |Plot Disabled|')
    else
        showgraph = 0;
        disp('> |Plot Disabled|')
    end
end

% Prompt thermal characteristics

disp(' ');

reply1 = input('Use design specific thermal characteristics? y/n : ', 's');
if isempty(reply1)
    reply1 = 'y';
    disp('> |Design Characteristics Selected|');
elseif strcmp('n',reply1) == 1
    reply1 = 'n';
    disp('> |Defaults Selected|');
else
    reply1 = 'y';
    disp('> |Design Characteristics Selected');
end

% Prompt loading conditions

disp(' ');

prl = str2double(input('Preceding load? 0-1 p.u : ','s'));
if isnan(prl)
    PrecedingLoad = 1; %Preceding load 0-1 pu. of tested load case
    disp('> |1 p.u default|');
elseif 0 >= prl <= 1
    PrecedingLoad = prl; %Preceding load 0-1 pu. of tested load case
    
    thestring_PL = sprintf('Preceding Load = %0.2f p.u',PrecedingLoad);
    disp(thestring_PL)
else
    PrecedingLoad = 1; %Preceding load 0-1 pu. of tested load case
    disp('> |1 p.u default|');
end

%---------------------------

enl = str2double(input('End load? 0-1 p.u : ','s'));
if isnan(enl)
    EndLoad = 1.2; %End load 0-1 pu. of tested load case
    disp('> |1.2 p.u default|');
elseif 0 >= enl <= 1
    EndLoad = enl; %End load 0-1 pu. of tested load case
    
    thestring_EL = sprintf('End Load = %0.2f p.u',EndLoad);
    disp(thestring_EL)
else
    EndLoad = 1.2; %End load 0-1 pu. of tested load case
    disp('> |1.2 p.u default|');
end

%---------------------------

disp(' ');

fcl = str2double(input('Forced cooling loss? 0-1 p.u : ','s'));
if isnan(fcl)
    ForcedCoolingLoss = 0; %Loss of forced cooling 0-1 pu.
    disp('> |0 p.u default|');
elseif 0 >= fcl <= 1
    ForcedCoolingLoss = fcl; %Loss of forced cooling 0-1 pu.
    
    thestring_FCL = sprintf('Forced cooling loss = %0.2f p.u',ForcedCoolingLoss);
    disp(thestring_FCL)
else
    ForcedCoolingLoss = 0; %Loss of forced cooling 0-1 pu.
    disp('> |0 p.u default|');
end

% Prompt End-time

disp(' ');

set = input('Set End-time? y/n : ','s');
if isempty(set)
    settime = false;
    endtime = 0;
    disp('> |Set End-time Disabled|');
elseif strcmp('n',set) == 1
    settime = false;
    endtime = 0;
    disp('> |Set End-time Disabled|');
elseif strcmp('y',set) == 1
    disp('> |Set End-time Enabled|');
    endtimetemp = str2double(input('Run up to? [min] : ','s'));
    if isnan(endtimetemp)
        settime = false;
        endtime = 0;
        disp('> |Set End-time Disabled|');
    elseif isnumeric(endtimetemp)
        settime = true;
        endtime = endtimetemp;
        thestring_ET = sprintf('End Time = %0.0f min',endtimetemp);
        disp(thestring_ET)
    else
        settime = false;
        endtime = 0;
        disp('> |Set End-time Disabled|');
    end
else
    settime = false;
    endtime = 0;
    disp('> |Set End-time Disabled|');
end

% Prompt Thermal Paper Type

disp(' ');

input_TS = input('Use thermally upgraded paper ? y/n : ','s');
if isempty(input_TS)
    Thermset = 1;
    disp('> |Thermally Upgraded Paper Selected|');
elseif strcmp('n',input_TS) == 1
    Thermset = 2;
    disp('> |Non-thermally Upgraded Paper Selected|');
else
    Thermset = 1;
    disp('> |Thermally Upgraded Paper Selected|');
end

% Start Timer

tic;

%% INPUT

PLL = 3.253; % Total Load losses [kW]
PNL = 0.819; % No-load losses [kW]
PSC = 1.90; % Self Cooling Capacity of Tank [kW]
PW = 3.041;% Total winding losses (I2R + Winding Eddies)

CoolingMethod = 'ONAN'; %Cooling Method

Sigma_a = 80; % Ambient Temperature [C]

DeltaSigma_wr = 55; % Actual Hottest Winding Rise @ rated load [K] (i.e hottest hot-spot rise) (if not available - guaranteed value)
DeltaSigma_o_mean = 40; % Actual Mean Oil Temperature Rise @ rated load [K] (if not available - guaranteed value)
DeltaSigma_or = 50; % Actual Top Oil Temperatnure Rise @ rated load [K] (if not available - guaranteed value)

m_A = 940; % Core and coil assembly mass [kg]
m_T = 780; % Tank and fittings mass [kg]
m_O = 780; % Oil mass [kg]
m_W = 120; % Copper mass [kg]

c = 890; % Specific heat [Ws/kg.K]

Sigma_o_max = 140; % Maximum allowed top oil temperature [C]
Sigma_h_max = 140; % Maximum allowed hot spot temperature [C]

%% Thermal Functions

P = solve_CL(PLL,PNL,PSC,ForcedCoolingLoss); % Losses for cooling equipment [kW]
P_w = solve_WL(PW); % Winding losses [kW]

%----
Htemp = solveget_HSF(CoolingMethod);
DeltaSigma_hr = get_DeltaSigma_hr(DeltaSigma_wr,DeltaSigma_or) ; % ?check? Hot-spot to top-oil (in tank) gradient @ rated load [K] |(Hg  = HSF x g)

g = get_g(DeltaSigma_hr,Htemp); % ?check? Average winding-to-average-oil temperature gradient @ rated current [Ws/K]

%----

OSelectLR = reply1;
R = solveget_LR(OSelectLR,PLL,PNL,CoolingMethod); % Ratio of Load to No-Load losses @ rated current

OSelectW = reply1;
Tau_W = solveget_WTC(OSelectW,CoolingMethod,m_W, c, g, P_w) ; % Winding Time Constant [Min]

OSelectO = reply1;
Tau_O = solveget_OTC(OSelectO,CoolingMethod, m_A, m_T, m_O, DeltaSigma_o_mean, P); % Average Oil Time Constant [Min]

x = get_OE(CoolingMethod); % Oil Temperature Exponent
y = get_WE(CoolingMethod);  % Winding Temperature Exponent

k11 = get_k11(CoolingMethod); % K11 Thermal Constants
k21 = get_k21(CoolingMethod); % K21 Thermal Constants
k22 = get_k22(CoolingMethod); % K22 Thermal Constants

%% Call ADIF    Differential Model

if strcmp('y',mod1) == 1
    
    disp(' ');
    disp('>> START Transient Cyclic Loading (ADIF)')
    disp(' ');
    
    Output_ADIF = ADIF(Sigma_a,DeltaSigma_or,DeltaSigma_hr,Tau_W,Tau_O,x,y,k11,k21,k22,R,Sigma_o_max,Sigma_h_max,PrecedingLoad,EndLoad,showgraph,settime,endtime,Thermset); %#ok<NASGU>
    
    disp(' ');
    disp('>> Transient Cyclic Loading COMPLETE');
    disp(' ');
    
elseif strcmp('n',mod0) == 1
    
    disp(' ');
    disp('#  DISABLED Transient Cyclic Loading (ADIF)')
    disp(' ');
    
end


%% OUTPUT


%% SAVE Workspace

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

fullFileName = fullfile(newSubFolder, 'ARRHENIUS.mat');
save(fullFileName);

%% Terminate
toc;

diary off;

