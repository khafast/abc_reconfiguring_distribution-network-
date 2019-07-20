function test=test(cutlist)
test=[];
load('Udm.mat');
%Du lieu 27 nut
load('linedata.mat');  load('powerdata.mat');load('nutnguon.mat');
%nutnguon=1;

line=linedata;
for i=1:length(cutlist)
    m=cutlist(i)==line(:,1);
    line(m,:)=[];
end

[~,powerdata1] = ruttia(Udm,line,powerdata);

dienap=sutap(Udm,cutlist,line,powerdata1);
Vmin=min(dienap(:,2));
m=Vmin==dienap(:,2);
nutVmin=dienap(m,1);

Ptotalload=sum(powerdata,1);
Ptotalload=Ptotalload(2);
m=powerdata(:,1)==1;
Ptatal=powerdata1(m,4);
Ploss=Ptatal+powerdata1(m,2)-Ptotalload;
DeltaP=Ploss/Ptatal*100;
%xuat ra thong so
disp(' ');
disp(['Nhanh cat la ' num2str(cutlist)]);
disp(' ');
disp(['Ton that P = ' num2str(Ploss) ' kW']);
disp(' ');
disp(['Phan tram ton that DeltaP = ' num2str(DeltaP) ' %']);
disp(' ');
disp(['Sut ap lon nhat o nut ' num2str(nutVmin) ' = ' num2str(Udm-Vmin) 'kV']);
disp(' ');
disp(['Phan tram sut ap DeltaUmin '  num2str((1-Vmin/22)*100) '%']);

G=graph(adj(line));
plot(G);
end
