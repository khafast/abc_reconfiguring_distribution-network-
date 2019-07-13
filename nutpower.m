function nutnguon=nutpower(linedatamultiloop,linedata)

%nut trong vong kep
vong=linedatamultiloop;
nut=0; %danh sach chua nut
for i=1:size(vong,1)
    nut1=vong(i,2); %Nut
    nut2=vong(i,3); %Nut
    
    % Tim nut1 trong nut va kiem tra nut1 co ton tai hay chua
    m=nut1==nut;
    if sum(m)==0 
        nut(length(nut)+1)=nut1;
    end
    
    % Tim nut2 trong nut va kiem tra nut2 co ton tai hay chua
    n=nut2==nut;
    if sum(n)==0
        nut(length(nut)+1)=nut2; 
    end
end
nut(1)=[]; %Xoa nut 0
nutnguon=[];
for i=1:length(nut)
    if nut(i)==1
       nutnguon=1;
    end
end

if isempty(nutnguon)
   k=randperm(length(nut),1);
   nutthu=nut(k);
   nutchay=rmin(linedata,nutthu,1);
   K=0;
   i=0;
   while K==0
         i=i+1;
         m=nutchay(i)==nut;
         if sum(m)~=0
            nutnguon=nutchay(i);
            K=1;
         end
    end
end
end

