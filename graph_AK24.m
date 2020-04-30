function graph_AK24(X1, Y1)
%CREATEFIGURE(X1,Y1)
%  X1:  vector of x data
%  Y1:  vector of y data

%  Auto-generated by MATLAB on 19-Jun-2012 16:50:04

% Create figure
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1,'YMinorTick','on','YGrid','on',...
    'XMinorTick','on',...
    'FontWeight','bold');
hold(axes1,'all');

% Create plot
plot(X1,Y1,'Marker','o','LineWidth',2,...
    'Color',[0.87058824300766 0.490196079015732 0],...
    'DisplayName','Overloading');

% Create xlabel
xlabel('Rated Power [MVA]','FontWeight','bold');

% Create ylabel
ylabel('Ambient Temperature [C]','FontWeight','bold');

% Create title
title('Continuous Loading - Normal','FontWeight','bold','FontSize',12);
