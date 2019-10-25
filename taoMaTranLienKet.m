function matranVuong = taoMaTranKeDeDanhDauKetNoiGiuaCacNutTrongLinedata(linedata)
global logLevel
import logging.*
logger = Logger.getLogger('Chuongtrinhchinh');
logger.setLevel(logLevel);

logger.finer(['tao ra ma tran ke (ma tran vuong) ' size(linedata, 1) 'x' size(linedata, 1)]);

%%Tim nut lon nhat
nutLonNhat = max(max(linedata(:,2:3)));

%%tao ma tran ke adj
matranVuong = zeros(nutLonNhat);
for i = 1:size(linedata,1)
    nutDau = linedata(i, 2);
    nutCuoi = linedata(i, 3);
    
    matranVuong(nutDau, nutCuoi) = linedata(i, 4);
    matranVuong(nutCuoi, nutDau) = linedata(i, 4);
end
end