function [linedata, powerdata] = xoaCacNutKhongTonTaiTrongLinedata(linedata, powerdata)
global logLevel
import logging.*
logger = Logger.getLogger('Chuongtrinhchinh');
logger.setLevel(logLevel);
logger.finer('(Start)')

format short G;
danhSachNutKhongTonTaiTrongLinedata = [];

G = taoDoiTuongGraph(linedata);
tong = dfsearch(G,1);
for j = 1:size(powerdata,1)
    n = powerdata(j,1) == tong;
    if sum(n) == 0
        danhSachNutKhongTonTaiTrongLinedata(length(danhSachNutKhongTonTaiTrongLinedata)+1) = powerdata(j,1);
    end
end

for i = 1:length(danhSachNutKhongTonTaiTrongLinedata)
    n = linedata(:,2) == danhSachNutKhongTonTaiTrongLinedata(i);
    linedata(n,:) = [];
    
    m = linedata(:,3) == danhSachNutKhongTonTaiTrongLinedata(i);
    linedata(m,:) = [];
    
    k = powerdata(:,1) == danhSachNutKhongTonTaiTrongLinedata(i);
    powerdata(k,:) = [];
    
    logger.info(['xoa nut roi (nut doc lap) #' num2str(danhSachNutKhongTonTaiTrongLinedata(i))])
end

logger.finer('(Success)')
end

