function dienap=sutap(Udm,cutlist,linedata,powerdataout)
global logLevel
import logging.*
logger = Logger.getLogger('Chuongtrinhchinh');
logger.setLevel(logLevel);
logger.finer('(Start)')

powerdata=powerdataout;
%cat nhanh cat khoi luoi dien
for i=1:length(cutlist)
    m=cutlist(i)==linedata(:,1);
    linedata(m,:)=[];
end
dienap=zeros(size(powerdata,1),2);
dienap(:,1)=powerdata(:,1);

%Tim duong di
G=graph(adj(linedata));
run=bfsearch(G,1);
m=dienap(:,1)==1;
dienap(m,2)=Udm;
for i=2:length(run)
    %%Tim nhanh
    nutchay=rmin(linedata,1,run(i));
    for k=1:size(linedata,1)
        if (linedata(k,2)==nutchay(1) && linedata(k,3)==nutchay(2))||...
           (linedata(k,3)==nutchay(1) && linedata(k,2)==nutchay(2))
            R=linedata(k,4);
            X=linedata(k,5);
        end
    end
    %Tim nut truoc
    m=nutchay(1)==powerdata(:,1);
    P=powerdata(m,2)+powerdata(m,4);
    Q=powerdata(m,3)+powerdata(m,5);
   
    %Tinh do sut ap
    m=nutchay(2)==dienap(:,1);
    Udau=dienap(m,2);
    DeltaU=(P*R+Q*X)/Udm;
    Ucuoi=Udau-DeltaU/1000;
    n=nutchay(1)==dienap(:,1);
    dienap(n,2)=Ucuoi;
end
logger.finer('(Success)')
end
