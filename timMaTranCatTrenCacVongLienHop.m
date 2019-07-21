function matrancat = timMaTranCatTrenCacVongLienHop(linedataCuaCacVongLienHop)
global logLevel
import logging.*
logger = Logger.getLogger('Chuongtrinhchinh');
logger.setLevel(logLevel);
logger.info('(Start)')

%Tim danh sach cho bien cat
%Input: linedata
%       linedatamultiloop la linedata cua vong lien hop dang xet
%Output: ma tran cac nhanh se duoc cat

linedata = linedataCuaCacVongLienHop;
nutmax = max(max(linedata(:,2:3)));

%%Chuyen linedata ra ma tran ke;
maTranKe = taoMaTranKeDeDanhDauKetNoiGiuaCacNutTrongLinedata(linedata);
G = maTranKe;

%%Tim cac vong co ban
danhSachCacVongCoBan = timDanhSachCacVongCoBan(G);

%%Liet ke cac vong 
hang = (1:nutmax)';
cot = (0:nutmax);
for vitri = 1:length(danhSachCacVongCoBan)
    danhSachCacVongCoBan{vitri} = [hang, danhSachCacVongCoBan{vitri}];
    danhSachCacVongCoBan{vitri} = [cot; danhSachCacVongCoBan{vitri}];
    
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
                       vong(1, size(vong,2) + 1) = linedata(r, 1);
                   end
               end
            end
        end
    end  
    danhSachCacVong{vitri}=vong;
    %loopsave{vitri}=vong;
end
%baoCaoDuLieu('danhSachCacVong', danhSachCacVong);

%%Kiem tra vong doc lap
% Tim vong co so nhanh nhieu nhat de tao matran chua cac nhanh
maxmang=0;
for vitri=1:length(danhSachCacVong)
    if maxmang<=numel(danhSachCacVong{vitri})
       maxmang=numel(danhSachCacVong{vitri});
    end
end

% Chuyen tu mang te bao (cells) sang ma tran (array) de de tinh toan
mang=zeros(length(danhSachCacVong),maxmang);
for vitri=1:length(danhSachCacVong)
    for j=1:length(danhSachCacVong{vitri})
        mang(vitri,j)=danhSachCacVong{vitri}(j);
    end
end

% Xac dinh vong nao thuoc vong doc lap
nhanhlienhop = ones(size(mang, 1), 1);
for vitriHang = 1:size(mang, 1)
    for vitriCot = 1:size(mang, 2)
        vitriBatDauCuaHangTiepTheo = vitriHang + 1;
        for vitriHangTiepTheo = vitriBatDauCuaHangTiepTheo:size(mang, 1)
            for vitriCotTiepTheo = 1:size(mang, 2)
                if mang(vitriHangTiepTheo, vitriCotTiepTheo) == mang(vitriHang, vitriCot)
                   nhanhlienhop(vitriHang) = 0;
                   nhanhlienhop(vitriHangTiepTheo) = 0;
                end
            end
        end
    end 
end
%baoCaoDuLieu('nhanhlienhop', nhanhlienhop);

%Ghi lai nhanh cua cac vong lien hop
danhSachNhanhTrenCacVongLienHop = [];
for vitri = 1:length(nhanhlienhop)
    if nhanhlienhop(vitri) == 0
        danhSachNhanhTrenCacVongLienHop = [danhSachNhanhTrenCacVongLienHop; mang(vitri, :)];
    end
end
baoCaoDuLieu('danhSachNhanhTrenCacVongLienHop', danhSachNhanhTrenCacVongLienHop);

sonhanh = size(linedata, 1);
sovong = size(danhSachNhanhTrenCacVongLienHop, 1);
matrancat = zeros(sonhanh, sovong+1);
matrancat(:, 1) = linedata(:, 1);

for vitriLinedata = 1:size(linedata, 1)
    for j = 1:size(danhSachNhanhTrenCacVongLienHop, 1)
        n = linedata(vitriLinedata, 1) == danhSachNhanhTrenCacVongLienHop(j,:);
        if sum(n)~=0
           matrancat(vitriLinedata, j+1) = 1;
        end
    end
end

baoCaoDuLieu('matrancat', matrancat);
logger.info('(Success)')
end

