function [linedataDaRutGon, matran, danhSachCacNhanhDaBiThayThe] = cutmatrix(linedatamultiloop, linedata)

% Xac dinh ma tran cat tren luoi thuc
matran = multicutlist(linedatamultiloop);
%Rut gon vong kep
[linedataDaRutGon, danhSachCacNhanhDaBiThayThe] = rutgon(linedatamultiloop, linedata);
for i = 1:length(danhSachCacNhanhDaBiThayThe)
    if isempty(danhSachCacNhanhDaBiThayThe{i}) == 0
       m = danhSachCacNhanhDaBiThayThe{i}(1) == matran(:,1);
       matran(m,1) = i;
       for j = 2:length(danhSachCacNhanhDaBiThayThe{i})
           n = danhSachCacNhanhDaBiThayThe{i}(j) == matran(:,1);
           matran(n,:) = [];
       end
    end
end
end