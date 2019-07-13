function linedata=loctia(linedata)
A=1;
if isempty(linedata)==1
    A=0;
end
while A==1
     %Tim nut chi chua 1 nhanh
     G=adj(linedata);
     D=sum(G,1);
     nut1=find(D==1);
     if isempty(nut1)
        break
     end
     nut1=nut1(randperm(numel(nut1),1));
    nutrun=runstop(linedata,nut1);
    for b=1:length(nutrun)-1
        for k=1:size(linedata,1)
            if (linedata(k,2)==nutrun(b) && linedata(k,3)==nutrun(b+1))||...
               (linedata(k,3)==nutrun(b) && linedata(k,2)==nutrun(b+1))
                linedata(k,:)=0;
            end
        end
     m=linedata(:,1)==0;
     linedata(m,:)=[];
     end
     if isempty(linedata)
        break
     end
end 
end

