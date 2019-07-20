function [linedatathay, danhSachCacNhanhDaBiThayThe] = rutgonLinedataBangCachThayTheCacNhanhTrungGian(linedatamultiloop, linedata)

% Dem so nhanh lien ket nut
danhSachNutCoHaiLienKet = timDanhSachNutCoHaiLienKetVoiNutKhac(linedatamultiloop);

nhanhmax = max(linedata(:, 1));

vitriNhanhThayThe = 0;
while isempty(danhSachNutCoHaiLienKet) == 0
    vitriNhanhThayThe = vitriNhanhThayThe + 1;
    danhSachCacNhanhDaBiThayThe{nhanhmax + vitriNhanhThayThe} = [];
    
    nutNgauNhienTrongDanhSach = layNgauNhienMotNut(danhSachNutCoHaiLienKet);
    danhSachCacNutLanCanCapMot = runstop(linedatamultiloop, nutNgauNhienTrongDanhSach);
    danhSachCacNutLanCanCapHai = runstop(linedatamultiloop, danhSachCacNutLanCanCapMot(length(danhSachCacNutLanCanCapMot)));
    nhanhxoa = [];
    for i = 1:length(danhSachCacNutLanCanCapHai) - 1
        for k = 1:size(linedatamultiloop, 1)
            if (linedatamultiloop(k,2) == danhSachCacNutLanCanCapHai(i) && linedatamultiloop(k, 3) == danhSachCacNutLanCanCapHai(i + 1)) ||...
                    (linedatamultiloop(k, 3) == danhSachCacNutLanCanCapHai(i) && linedatamultiloop(k, 2) == danhSachCacNutLanCanCapHai(i + 1))
                nhanhxoa(length(nhanhxoa) + 1) = linedatamultiloop(k, 1);
                linedatamultiloop(k, :) = 0;
            end
        end
    end
    danhSachCacNhanhDaBiThayThe{nhanhmax + vitriNhanhThayThe} = nhanhxoa;
    
    m = linedatamultiloop(:, 1) == 0;
    linedatamultiloop(m, :) = [];
    
    nhanhThayThe = zeros(1, 5);
    nhanhThayThe(1, 1) = nhanhmax + vitriNhanhThayThe;
    nhanhThayThe(1, 2) = danhSachCacNutLanCanCapHai(1);
    nhanhThayThe(1, 3) = danhSachCacNutLanCanCapHai(length(danhSachCacNutLanCanCapHai));
    linedatamultiloop = [linedatamultiloop; nhanhThayThe];
    
    %tinh laij so nut 2
    danhSachNutCoHaiLienKet = timDanhSachNutCoHaiLienKetVoiNutKhac(linedatamultiloop);
end
linedatathay = linedatamultiloop;
end

