% Code to perform portfolio analysis on selected values
%% Housekeeping
clear
clc
close all
%% Import data ETFs + Managed fund
etfsFiles= dir('ETF_data\*.csv');
for ii=1:numel(etfsFiles)
     assignin('base',['tab' erase(etfsFiles(ii).name,'.L.csv')],table2timetable(read_etf_data([etfsFiles(ii).folder '\' etfsFiles(ii).name])))
     etfsNames{ii} = ['tab' erase(etfsFiles(ii).name,'.L.csv')]; %#ok<SAGROW> 
end


stocksFiles= dir('Stocks_data\*.csv');
for ii=1:numel(stocksFiles)
    matchPat = '.' + wildcardPattern + 'csv';
     assignin('base',['tab' erase(stocksFiles(ii).name,matchPat)],table2timetable(read_etf_data([stocksFiles(ii).folder '\' stocksFiles(ii).name])))
     stocksNames{ii} = ['tab' erase(stocksFiles(ii).name,matchPat)]; %#ok<SAGROW> 
end

%% Synchronize timetables
timetableETFs = synchronize(tab0P0000M0RQ, tabIH2O, tabCEA1, tabIUKD, tabLITG, tabISF, tabCNX1, tabHMCH, tabIASH, tabIFSW, tabINRG, tabIUSA, tabIWQU, tabSGLN, tabXLVP);
timetableStocks = synchronize(tabAILA, tabDSM, tabGIVN, tabLIN, tabNVDA, tabQBTS, tabSIKA, tabSY1);
timetableEtfsAndStocks = synchronize(timetableStocks,timetableETFs);
etfsAndStocksData = timetable2table(timetableEtfsAndStocks);
%% Portfolio setup
dailyReturn = tick2ret(timetableEtfsAndStocks);
p = Portfolio('AssetList',timetableEtfsAndStocks.Properties.VariableNames,'RiskFreeRate',0.01/252);
%p = setMinMaxNumAssets(p, ceil(numel(allAssets)/2), numel(allAssets));
p = estimateAssetMoments(p,dailyReturn,'MissingData',true);

p = setAssetMoments(p, m, C);
p = setDefaultConstraints(p);
p = setBounds(p,0.05,0.5, 'BoundType', 'Conditional');
p = setMinMaxNumAssets(p, 5, 7);  
% Get weight asset distribution
w1 = estimateMaxSharpeRatio(p);
% Get risk and return of optimal portfolio
[risk1, ret1] = estimatePortMoments(p, w1);
% Labels for plots
symbol =erase(timetableEtfsAndStocks.Properties.VariableNames','Close_tab');
%%
f = figure;
tabgp = uitabgroup(f); % Define tab group
tab1 = uitab(tabgp,'Title','Efficient Frontier Plot'); % Create tab
ax = axes('Parent', tab1);
% Extract asset moments from portfolio and store in m and cov
[m, cov] = getAssetMoments(p); 
scatter(ax,sqrt(diag(cov)), m,'oc','filled'); % Plot mean and s.d.
xlabel('Risk')
ylabel('Expected Return')
text(sqrt(diag(cov))+0.0003,m,symbol,'FontSize',7); % Label ticker names
%%
hold on;
[risk2, ret2]  = plotFrontier(p,100);
plot(risk1,ret1,'p','markers',15,'MarkerEdgeColor','k',...
                'MarkerFaceColor','y');
hold off
%%
tab2 = uitab(tabgp,'Title','Optimal Portfolio Weight'); % Create tab

% Column names and column format
columnname = {'Ticker','Weight (%)'};
columnformat = {'char','numeric'};

% Define the data as a cell array
data = table2cell(table(symbol(w1>0),w1(w1>0)*100));

% Create the uitable
uit = uitable(tab2, 'Data', data,... 
            'ColumnName', columnname,...
            'ColumnFormat', columnformat,...
            'RowName',[]);

% Set width and height
uit.Position(3) = 450; % Widght
uit.Position(4) = 350; % Height

