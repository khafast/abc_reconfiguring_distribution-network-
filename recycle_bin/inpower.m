function [ powerdata ] = inpower( linedata,powerdata)
nutmax=max(max(linedata(:,2:3)));
powerdataout=zeros(nutmax,4);
n=1:nutmax;
powerdataout=[n',powerdataout];

for i=1:size(powerdata,1)
    n=powerdata(i,1)==powerdataout(:,1);
    powerdataout(n,2)=powerdata(i,2);
    powerdataout(n,3)=powerdata(i,3);
    

end
powerdata=powerdataout;

