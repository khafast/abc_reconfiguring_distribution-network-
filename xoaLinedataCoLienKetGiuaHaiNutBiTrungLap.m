function linedata = xoaLinedataCoLienKetGiuaHaiNutBiTrungLap(linedata)
global logLevel
import logging.*
logger = Logger.getLogger('Chuongtrinhchinh');
logger.setLevel(logLevel);
logger.info('(Start)')

G = taoDoiTuongGraph(linedata);
danhSachLines = G.Edges;
danhSachLienKetGiuaHaiNut = danhSachLines.EndNodes;
for vitri = 1:size(linedata, 1)
    tontai = 0;
    for vitriNut = 1:size(danhSachLienKetGiuaHaiNut, 1)
        if (linedata(vitri, 2) == danhSachLienKetGiuaHaiNut(vitriNut, 1) && linedata(vitri,3) == danhSachLienKetGiuaHaiNut(vitriNut, 2))||...
           (linedata(vitri, 3) == danhSachLienKetGiuaHaiNut(vitriNut, 1) && linedata(vitri,2) == danhSachLienKetGiuaHaiNut(vitriNut, 2))
            %
            tontai = 1;
            %chuan bi cho vong lap ke
            danhSachLienKetGiuaHaiNut(vitriNut, :) = 0; 
        end
    end
    n = danhSachLienKetGiuaHaiNut(:, 1) == 0;
    danhSachLienKetGiuaHaiNut(n, :) = [];
    
    if 0 == tontai
        linedata(vitri, :) = 0;
    end
end
m = linedata(:, 1) == 0;
linedata(m,:) = [];

logger.info('(Success)')
end