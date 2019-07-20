function linedata = xoaCacNhanhHinhTiaTrongLinedata(linedata)
% loai bo tat ca cac nhanh hinh tia

global logLevel
import logging.*
logger = Logger.getLogger('Chuongtrinhchinh');
logger.setLevel(logLevel);

logger.info('loc bo tat ca cac nhanh hinh tia');

while numel(linedata) > 0
    %Tim nut chi chua 1 nhanh
    maTranKe = taoMaTranKeDeDanhDauKetNoiGiuaCacNutTrongLinedata(linedata);
    G = maTranKe;
    D = sum(G, 1);
    danhSachNutChiCoKetNoiVoiMotNutKhac = find(D == 1);
    if isempty(danhSachNutChiCoKetNoiVoiMotNutKhac)
        break
    end
    
    nutChiChuaMotNhanh = layNgauNhienMotNut(danhSachNutChiCoKetNoiVoiMotNutKhac);
    danhSachCacNutCungNhanh = timDanhSachNutCungMotNhanh(linedata, nutChiChuaMotNhanh);
    
    for b = 1:length(danhSachCacNutCungNhanh) - 1
        nutA = danhSachCacNutCungNhanh(b);
        nutB = danhSachCacNutCungNhanh(b + 1);
        linedata = xoaCacLinedataChuaHaiNutLienKe(nutA, nutB, linedata);
    end
    
    if isempty(linedata)
        break
    end
end
end

