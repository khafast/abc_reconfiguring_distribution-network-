function [linedatathay,nhanh] = rutgon(linedatamultiloop,linedata)

% Dem so nhanh lien ket nut
G=adj(linedatamultiloop);
D=sum(G,2);
nut2=find(D==2);
nhanhmax=max(linedata(:,1));
a=0;
while isempty(nut2)==0
    a=a+1;
    nhanh{nhanhmax+a}=[];
    nut=nut2(randperm(length(nut2),1));
    nut3=runstop(linedatamultiloop,nut);
    run=runstop(linedatamultiloop,nut3(length(nut3)));
    nhanhxoa=[];
    for i=1:length(run)-1
        for k=1:size(linedatamultiloop,1)
            if (linedatamultiloop(k,2)==run(i) && linedatamultiloop(k,3)==run(i+1))||...
               (linedatamultiloop(k,3)==run(i) && linedatamultiloop(k,2)==run(i+1))
                nhanhxoa(length(nhanhxoa)+1)=linedatamultiloop(k,1);
                linedatamultiloop(k,:)=0;
            end
        end
    end
    nhanh{nhanhmax+a}=nhanhxoa;
        m=linedatamultiloop(:,1)==0;
        linedatamultiloop(m,:)=[];
        nhanhthay=zeros(1,5);
        nhanhthay(1,1)=nhanhmax+a;
        nhanhthay(1,2)=run(1);
        nhanhthay(1,3)=run(length(run));
        linedatamultiloop=[linedatamultiloop;nhanhthay]; 
    
    %tinh laij so nut 2
    G=adj(linedatamultiloop);
    D=sum(G,2);
    nut2=find(D==2);
end
linedatathay=linedatamultiloop;
end

