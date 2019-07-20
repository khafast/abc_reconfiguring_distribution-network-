function matrancat=multicutlist(linedatamultiloop)

%Tim danh sach cho bien cat
%Input: linedata
%       linedatamultiloop la linedata cu vvong lien hop dang xet
%Output: ma tran cac nhanh se duoc cat

linedata=linedatamultiloop;
nutmax=max(max(linedata(:,2:3)));

%%Chhuyen linedata ra ma tran ke;
G = adj(linedata);

%%Tim cac vong co ban
danhSachCacVongCoBan = timDanhSachCacVongCoBan(G);

%%Liet ke cac vong 
hang=(1:nutmax)';
cot=(0:nutmax);
for vitri = 1:length(danhSachCacVongCoBan)
    danhSachCacVongCoBan{vitri} = [hang, danhSachCacVongCoBan{vitri}];
    danhSachCacVongCoBan{vitri} = [cot;danhSachCacVongCoBan{vitri}];
    
    % Tim nhanh rong va xoa
    for r=2:size(danhSachCacVongCoBan{vitri},1)
        S=sum(danhSachCacVongCoBan{vitri}(r,2:size(danhSachCacVongCoBan{vitri},2)));
        if S==0
            danhSachCacVongCoBan{vitri}(r,1)=0;
        end
    end
    m=danhSachCacVongCoBan{vitri}(:,1)==0;
    m(1)=0;
    danhSachCacVongCoBan{vitri}(m,:)=[];
    
    %Tim nut rong va xoa
    for r=1:size(danhSachCacVongCoBan{vitri},2)
        S=sum(danhSachCacVongCoBan{vitri}(2:size(danhSachCacVongCoBan{vitri},1),r),2);
        if S==0
            danhSachCacVongCoBan{vitri}(1,r)=0;
        end
    end
    m=danhSachCacVongCoBan{vitri}(1,:)==0;
    m(1)=0;
    danhSachCacVongCoBan{vitri}(:,m)=[];
    
    % Tong hop lai cac vong
    vong=[];
    for p=2:size(danhSachCacVongCoBan{vitri},1)-1
        for q=p:size(danhSachCacVongCoBan{vitri},2)
            if danhSachCacVongCoBan{vitri}(p,q)==1
               nut1=danhSachCacVongCoBan{vitri}(p,1);
               nut2=danhSachCacVongCoBan{vitri}(1,q);
               for r=1:size(linedata,1)
                   if (linedata(r,2)==nut1 && linedata(r,3)==nut2) ||...
                      (linedata(r,3)==nut1 && linedata(r,2)==nut2)
                       vong(1,size(vong,2)+1)=linedata(r,1);
                   end
               end
            end
        end
    end  
    loop{vitri}=vong;
    loopsave{vitri}=vong;
end

%%Kiem tra vong doc lap
% Tim vong co so nhanh nhieu nhat de tao matran chua cac nhanh
maxmang=0;
for vitri=1:length(loop)
    if maxmang<=numel(loop{vitri})
       maxmang=numel(loop{vitri});
    end
end

% Chuyen tu mang te bao sang ma tran de de tinh toan
mang=zeros(length(loop),maxmang);
for vitri=1:length(loop)
    for j=1:length(loop{vitri})
        mang(vitri,j)=loop{vitri}(j);
    end
end

% Xac dinh vong nao thuoc vong doc lap
nhanhlienhop=ones(size(mang,1),1);
for vitri=1:size(mang,1)
    for j=1:size(mang,2)
        for k=vitri+1:size(mang,1)
            for p=1:size(mang,2)
                if mang(k,p)==mang(vitri,j)
                   nhanhlienhop(vitri)=0;
                   nhanhlienhop(k)=0;
                end
            end
        end
    end 
end

%Ghi lai nhanh cua cac vong lien hop
davong=[];
for vitri=1:length(nhanhlienhop)
    if nhanhlienhop(vitri)==0
        davong=[davong;mang(vitri,:)];
    end
end


sonhanh=size(linedata,1);
sovong=size(davong,1);
matrancat=zeros(sonhanh,sovong+1);
matrancat(:,1)=linedata(:,1);

for vitri=1:size(linedata,1)
    for j=1:size(davong,1)
        n=linedata(vitri,1)==davong(j,:);
        if sum(n)~=0
           matrancat(vitri,j+1)=1;
        end
    end
end
end

