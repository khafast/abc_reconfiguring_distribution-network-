function nutlienketngoai=nutlienketngoai(linedata,linedatamultiloop)

% Input: linedatadaloc la linedata da loai bo vong doc lap va loc tia
%        linedatavongkep la linedata chi chua 1 vong lien hop
% Output: nut nguon cua vong kep


% Tim cac nut trong vong lien hop
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

%Tim nut lien ket voi nut ngoai cac nut trong vong va do la nut nguon
nutlienketngoai=[];
 G=graph(adj(linedata));
for i=1:length(nut)
    if nut==1
       nutlienketngoai=1;
    else
        n=neighbors(G,nut(i));
        for j=1:length(n)
            m=n(j)==nut;
            if sum(m)==0
               nutlienketngoai(length(nutlienketngoai)+1)=nut(i);
            end
        end
    end
end
end

