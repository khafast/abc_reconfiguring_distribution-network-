function [linedata,powerdata] = thugon(linedata,powerdata)
global logLevel
import logging.*
logger = Logger.getLogger('Chuongtrinhchinh');
logger.setLevel(logLevel);
logger.info('(Start)')

%Liet ke cac nut
nut=[];
for i=1:size(linedata,1)
    for j=2:3
         m=linedata(i,j)==nut;
         if sum(m)==0
            nut(length(nut)+1)=linedata(i,j);
         end
    end
end
bang=zeros(length(nut),2);
bang(:,1)=nut';
for i=1:size(bang,1)
    bang(i,2)=i+1;
end
 m=bang(:,1)==1;
 bang(m,2)=1;
%xoa nut da tinh powerdata
for i=2:size(powerdata,1)
    n=powerdata(i,1)==linedata(:,2);
    m=powerdata(i,1)==linedata(:,3);
    if sum(n)==0 && sum(m)==0
        powerdata(i,1)=0;
    end
end
k=powerdata(:,1)==0;
powerdata(k,:)=[];

for i=2:size(powerdata,1)
    k=powerdata(i,1)==bang(:,1);
    powerdata(i,1)=bang(k,2);
end

% Chuyen linedata
newlinedata=linedata;
for i=1:size(newlinedata,1)
    m=newlinedata(i,2)==bang(:,1);
    newlinedata(i,2)=bang(m,2);
    n=newlinedata(i,3)==bang(:,1);
    newlinedata(i,3)=bang(n,2);
end
linedata=newlinedata;

logger.info('(Success)')
end

