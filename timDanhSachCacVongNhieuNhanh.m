function multiloop = timDanhSachCacVongNhieuNhanh(linedata)
global logLevel
import logging.*
logger = Logger.getLogger('Chuongtrinhchinh');
logger.setLevel(logLevel);
logger.info('(Start)')

% Tim cac nhanh thuoc cac vong doc lap
multiloop=[];
%Input linedata
%output mang te bao gom cac linedata da vong


%%nutmax
nutmax=max(max(linedata(:,2:3)));

%%Chhuyen linedata ra ma tran ke;
G = adj(linedata);

%%Tim cac vong co ban
danhSachCacVongCoBan = timDanhSachCacVongCoBan(G);

%%Liet ke cac vong 
hang=(1:nutmax)';
cot=(0:nutmax);
loop=[];
for i=1:length(danhSachCacVongCoBan)
    danhSachCacVongCoBan{i}=[hang, danhSachCacVongCoBan{i}];
    danhSachCacVongCoBan{i}=[cot;danhSachCacVongCoBan{i}];
    
    % Tim nhanh rong va xoa
    for r=2:size(danhSachCacVongCoBan{i},1)
        S=sum(danhSachCacVongCoBan{i}(r,2:size(danhSachCacVongCoBan{i},2)));
        if S==0
            danhSachCacVongCoBan{i}(r,1)=0;
        end
    end
    m=danhSachCacVongCoBan{i}(:,1)==0;
    m(1)=0;
    danhSachCacVongCoBan{i}(m,:)=[];
    
    %Tim nut rong va xoa
    for r=1:size(danhSachCacVongCoBan{i},2)
        S=sum(danhSachCacVongCoBan{i}(2:size(danhSachCacVongCoBan{i},1),r),2);
        if S==0
            danhSachCacVongCoBan{i}(1,r)=0;
        end
    end
    m=danhSachCacVongCoBan{i}(1,:)==0;
    m(1)=0;
    danhSachCacVongCoBan{i}(:,m)=[];
    
    % Tong hop lai cac vong
    vong=[];
    for p=2:size(danhSachCacVongCoBan{i},1)-1
        for q=p:size(danhSachCacVongCoBan{i},2)
            if danhSachCacVongCoBan{i}(p,q)==1
               nut1=danhSachCacVongCoBan{i}(p,1);
               nut2=danhSachCacVongCoBan{i}(1,q);
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
for i=1:size(linedata,1)
    m=linedata(i,1)==mang;
    if sum(sum(m,1),2)>1
        D=sum(m,2);
        n=D~=0;
        nhanhlienhop(n)=0;
    end
end

%Ghi lai cac vong doc lap
indeloop=[];
for i=1:length(nhanhlienhop)
    if nhanhlienhop(i)==1
        indeloop=[indeloop;mang(i,:)];
    end
end
for i=1:size(indeloop,2)
    for j=1:size(indeloop,1)
        m=indeloop(j,i)==linedata(:,1);
        linedata(m,:)=[];
    end
end
linedata=loctia(linedata);
if isempty(linedata)==0
%Ghi lai nhanh cua cac vong lien hop
davong=[];
for i=1:length(nhanhlienhop)
    if nhanhlienhop(i)==0
        davong=[davong;mang(i,:)];
    end
end
%Chuyen ve linedata davong
linedatadavong=linedata;

for i=1:size(linedata,1)
    m=linedata(i,1)==davong;
    if m==0
        linedatadavong(i,:)=0;
    end
end

% Xoa hang rong trenlinedata davong
n=linedatadavong(:,1)==0;
linedatadavong(n,:)=[];
%------------------------------------------------------------------
%%Phan loai vong lien hop
%Chuyen linedata ve graph
Ga=graph(adj(linedatadavong));

%tach cac da vong
linedatadavongthu=linedatadavong;
i=1;
vonglienhop{i}=[];
while size(linedatadavongthu,1)>0
     
      nhanh=randperm(size(linedatadavongthu,1),1);
      nut=linedatadavongthu(nhanh,2);
      dsnut=dfsearch(Ga,nut);
      %Chuyen tu danhsach sang linedata
      for j=1:size(linedatadavongthu,1)
          n=linedatadavongthu(j,2)==dsnut;
          m=linedatadavongthu(j,3)==dsnut;
          if sum(n)~=0 || sum(m)~=0
              vonglienhop{i}=[vonglienhop{i};linedatadavongthu(j,:)];
              linedatadavongthu(j,:)=0;
          end
      end
      %Xoa nut da thuoc vong
      m=linedatadavongthu(:,1)==0;
      linedatadavongthu(m,:)=[];
      
       %Tang thu tu vong
       i=i+1;
end
%Ghi lai vong lienhop
multiloop=vonglienhop;
end

logger.info('(Success)')
end

function adj=adj(linedata)

%%Tim nut lon nhat
nutmax=max(max(linedata(:,2:3)));

%%tao ma tran ke adj
adj=zeros(nutmax);
for c=1:size(linedata,1)
    adj(linedata(c,2),linedata(c,3))=1;
    adj(linedata(c,3),linedata(c,2))=1;
end
end