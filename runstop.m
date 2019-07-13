function dsnut=runstop(linedata, nutdau)
global logLevel
import logging.*
logger = Logger.getLogger('Chuongtrinhchinh');
logger.setLevel(logLevel);
logger.finer(['Tim cac ket noi tu nut ' num2str(nutdau) ' (Start)'])


G=graph(adj(linedata));
D=sum(adj(linedata),2);
nut=nutdau;
thung=[]; %Thung chua nut
thung(length(thung)+1)=nut;
A=1;
while A==1
    nutke=neighbors(G,nut);
    %xoa nut da di qua
    for i=1:length(thung)
        m=thung(i)==nutke;
        nutke(m)=[];
    end
    nutke(m)=[];
    %Tim duong di den nut khac 2 uu tien qua nut 2
    nut2=[];
    for i=1:length(nutke)
        if D(nutke(i))==2
           nut2(length(nut2)+1)=nutke(i);
        end
    end
    
    if isempty(nut2)==0
        nut=nut2(randperm(length(nut2),1));
        thung(length(thung)+1)=nut;
    else
        nut=nutke(randperm(length(nutke),1));
        thung(length(thung)+1)=nut;
        A=0;
    end
end
dsnut=thung;  

logger.finer(['Tim cac ket noi tu nut ' num2str(nutdau) ', danh sach nut la: ' num2str(dsnut) ' (Success)'])
end

