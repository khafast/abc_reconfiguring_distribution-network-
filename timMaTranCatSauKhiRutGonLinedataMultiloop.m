function [linedataDaRutGon, matranCatTrenLuoiDuocRutGon, danhSachCacNhanhDaBiThayThe] = timMaTranCatSauKhiRutGonLinedataMultiloop(linedatamultiloop, linedata)

% Xac dinh ma tran cat tren luoi thuc
matranCatTrenLuoiThuc = timMaTranCatTrenCacVongLienHop(linedatamultiloop);
matranCatTrenLuoiDuocRutGon = matranCatTrenLuoiThuc;

%Rut gon linedata vong lien hop
[linedataDaRutGon, danhSachCacNhanhDaBiThayThe] = rutgonLinedataBangCachThayTheCacNhanhTrungGian(linedatamultiloop, linedata);

%Rut gon ma tran cat (boi vi linedata da bi rut gon)
for vitriNhanh = 1:length(danhSachCacNhanhDaBiThayThe)
    nhanhBiThayThe = danhSachCacNhanhDaBiThayThe{vitriNhanh};
    
    if numel(nhanhBiThayThe) > 0
       m = nhanhBiThayThe(1) == matranCatTrenLuoiDuocRutGon(:, 1);
       matranCatTrenLuoiDuocRutGon(m, 1) = vitriNhanh;
       for vitri = 2:length(nhanhBiThayThe)
           n = nhanhBiThayThe(vitri) == matranCatTrenLuoiDuocRutGon(:, 1);
           matranCatTrenLuoiDuocRutGon(n, :) = [];
       end
    end
end
end