function matrancat=multicutlist(linedatamultiloop)

%Tim danh sach cho bien cat
%Input: linedata
%       linedatamultiloop la linedata cu vvong lien hop dang xet
%Output: ma tran cac nhanh se duoc cat

linedata=linedatamultiloop;
nutmax=max(max(linedata(:,2:3)));

%%Chhuyen linedata ra ma tran ke;
G=adj(linedata);

%%Tim cac vong co ban
H=cyclebasis(G);

%%Liet ke cac vong 
hang=(1:nutmax)';
cot=(0:nutmax);
for i=1:length(H)
    H{i}=[hang, H{i}];
    H{i}=[cot;H{i}];
    
    % Tim nhanh rong va xoa
    for r=2:size(H{i},1)
        S=sum(H{i}(r,2:size(H{i},2)));
        if S==0
            H{i}(r,1)=0;
        end
    end
    m=H{i}(:,1)==0;
    m(1)=0;
    H{i}(m,:)=[];
    
    %Tim nut rong va xoa
    for r=1:size(H{i},2)
        S=sum(H{i}(2:size(H{i},1),r),2);
        if S==0
            H{i}(1,r)=0;
        end
    end
    m=H{i}(1,:)==0;
    m(1)=0;
    H{i}(:,m)=[];
    
    % Tong hop lai cac vong
    vong=[];
    for p=2:size(H{i},1)-1
        for q=p:size(H{i},2)
            if H{i}(p,q)==1
               nut1=H{i}(p,1);
               nut2=H{i}(1,q);
               for r=1:size(linedata,1)
                   if (linedata(r,2)==nut1 && linedata(r,3)==nut2) ||...
                      (linedata(r,3)==nut1 && linedata(r,2)==nut2)
                       vong(1,size(vong,2)+1)=linedata(r,1);
                   end
               end
            end
        end
    end  
    loop{i}=vong;
    loopsave{i}=vong;
end

%%Kiem tra vong doc lap
% Tim vong co so nhanh nhieu nhat de tao matran chua cac nhanh
maxmang=0;
for i=1:length(loop)
    if maxmang<=numel(loop{i})
       maxmang=numel(loop{i});
    end
end

% Chuyen tu mang te bao sang ma tran de de tinh toan
mang=zeros(length(loop),maxmang);
for i=1:length(loop)
    for j=1:length(loop{i})
        mang(i,j)=loop{i}(j);
    end
end

% Xac dinh vong nao thuoc vong doc lap
nhanhlienhop=ones(size(mang,1),1);
for i=1:size(mang,1)
    for j=1:size(mang,2)
        for k=i+1:size(mang,1)
            for p=1:size(mang,2)
                if mang(k,p)==mang(i,j)
                   nhanhlienhop(i)=0;
                   nhanhlienhop(k)=0;
                end
            end
        end
    end 
end

%Ghi lai nhanh cua cac vong lien hop
davong=[];
for i=1:length(nhanhlienhop)
    if nhanhlienhop(i)==0
        davong=[davong;mang(i,:)];
    end
end


sonhanh=size(linedata,1);
sovong=size(davong,1);
matrancat=zeros(sonhanh,sovong+1);
matrancat(:,1)=linedata(:,1);

for i=1:size(linedata,1)
    for j=1:size(davong,1)
        n=linedata(i,1)==davong(j,:);
        if sum(n)~=0
           matrancat(i,j+1)=1;
        end
    end
end
end

