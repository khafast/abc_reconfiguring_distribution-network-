function [linedataDaRutGon, matranCatDaRutGon, danhSachCacNhanhDaBiThayThe] = cutmatrix(linedatamultiloop, linedata)

% Xac dinh ma tran cat tren luoi thuc
matranCatTrenLuoiThuc = multicutlist(linedatamultiloop);
matranCatDaRutGon = matranCatTrenLuoiThuc;

%Rut gon vong kep
[linedataDaRutGon, danhSachCacNhanhDaBiThayThe] = rutgon(linedatamultiloop, linedata);
for vitriNhanh = 1:length(danhSachCacNhanhDaBiThayThe)
    nhanhBiThayThe = danhSachCacNhanhDaBiThayThe{vitriNhanh};
    
    if isempty(nhanhBiThayThe) == 0
       m = nhanhBiThayThe(1) == matranCatDaRutGon(:, 1);
       matranCatDaRutGon(m, 1) = vitriNhanh;
       for j = 2:length(nhanhBiThayThe)
           n = nhanhBiThayThe(j) == matranCatDaRutGon(:,1);
           matranCatDaRutGon(n, :) = [];
       end
    end
end
end