function linedata=locnhanhtrung(linedata)
global logLevel
import logging.*
logger = Logger.getLogger('Chuongtrinhchinh');
logger.setLevel(logLevel);
logger.info('(Start)')

G=graph(adj(linedata));
data=G.Edges;
data=data.EndNodes;
for i=1:size(linedata,1)
    tontai=0;
    for j=1:size(data,1)
        if (linedata(i,2)==data(j,1)&&linedata(i,3)==data(j,2))||...
           (linedata(i,3)==data(j,1)&&linedata(i,2)==data(j,2))
            data(j,:)=0;
            tontai=1;
        end
    end
    n=data(:,1)==0;
    data(n,:)=[];
    if tontai==0
        linedata(i,:)=0;
    end
end
m=linedata(:,1)==0;
linedata(m,:)=[];

logger.info('(Success)')
end