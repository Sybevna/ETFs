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
    matchPat = '.' + wildcardPattern;
     assignin('base',['tab' erase(stocksFiles(ii).name,matchPat)],table2timetable(read_etf_data([stocksFiles(ii).folder '\' stocksFiles(ii).name])))
     stocksNames{ii} = ['tab' erase(stocksFiles(ii).name,matchPat)];
end

%% Synchronize timetables
timetableETFs = synchronize(tab0P0000M0RQ, tabCEA1, tabCNX1, tabHMCH, tabIASH, tabIFSW, tabIH2O, tabINRG, tabIUSA, tabIWQU, tabSGLN, tabXLVP);
timetableStocks = synchronize(tabAILAFcsv ,tabDSMAScsv,tabGIVNSWcsv, tabLINcsv, tabNVDAcsv, tabSIKASWcsv, tabSY1DEcsv);

timetableEtfsAndStocks = synchronize(timetableStocks,timetableETFs);
allAssets = [stocksNames etfsNames];
%% Portfolio setup
dailyReturn = tick2ret(timetableEtfsAndStocks{:,:});
p = Portfolio('AssetList',allAssets);
%p = setMinMaxNumAssets(p, ceil(numel(allAssets)/2), numel(allAssets));
p = estimateAssetMoments(p,dailyReturn);
p = setDefaultConstraints(p);
w1 = estimateMaxSharpeRatio(p);
[risk1, ret1] = estimatePortMoments(p, w1);
%% Plotting
risks = sqrt(diag(p.AssetCovar));
returns = p.AssetMean;
figure
scatter(risks,returns)
ylabel('Return')
xlabel('Risk')

figure
plotFrontier(p)
hold on
scatter(risks,returns)

scatter(risk1,ret1,'red','filled','diamond');
x = [0, risk1*2]';
y = [p.RiskFreeRate,ret1*2]';
plot(x,y,'-.')
hold off


