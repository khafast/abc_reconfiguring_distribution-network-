function [linedata, powerdata]=xoanutroi(linedata,powerdata)
global logLevel
import logging.*
logger = Logger.getLogger('Chuongtrinhchinh');
logger.setLevel(logLevel);
logger.finer('(Start)')

format short G;
nutroi=[];
G=graph(adj(linedata));
tong=dfsearch(G,1);
for j=1:size(powerdata,1)
    n=powerdata(j,1)==tong;
    if sum(n)==0
        nutroi(length(nutroi)+1)=powerdata(j,1);
    end
end

for i=1:length(nutroi)
    n=linedata(:,2)==nutroi(i);
    linedata(n,:)=[];
    m=linedata(:,3)==nutroi(i);
    linedata(m,:)=[];
    k=powerdata(:,1)==nutroi(i);
    powerdata(k,:)=[];
end

logger.finer('(Success)')
end

