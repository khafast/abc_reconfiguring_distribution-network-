function [linedata, powerdata, danhsachLineDataChuaNutNguon] = chuyenNutNguonVeNutMotDeDonGianHoaBaiToan(linedata, powerdata, nutnguon)
% Chuyen nut nguon ve nut 1 de don gian hoa bai toan
    global logLevel
    import logging.*
    logger = Logger.getLogger('Chuongtrinhchinh');
    logger.setLevel(logLevel);
    
    logger.info('(start)')
    
%     nutmax = max(max(linedata(:, 2:3)));
%     
%     NUT_1 = 1;
%     NUT_CUOI_CUNG_CONG_MOT = nutmax + 1;
%     
%     m = linedata(:, 2) == NUT_1;
%     linedata(m, 2) = NUT_CUOI_CUNG_CONG_MOT;
%     
%     m = linedata(:, 3) == NUT_1;
%     linedata(m, 3) = NUT_CUOI_CUNG_CONG_MOT;
%     
% %     m = powerdata(:, 1) == NUT_1;
% %     powerdata(m, 1) = NUT_CUOI_CUNG_CONG_MOT;
%     
%     lineCount = size(linedata, 1);
%     linedata = [linedata; lineCount + 1, NUT_1, NUT_CUOI_CUNG_CONG_MOT, 0, 0];
%     
%     powerdata = [powerdata; NUT_CUOI_CUNG_CONG_MOT, 0, 0, 0, 0];

    danhsachLineDataChuaNutNguon = [];
    for vitriNutNguon = 1:length(nutnguon)
        
        column = 2;
        [linedata, danhsachLineDataChuaNutNguon] = thayTheNutNguonBangNutMot(linedata, danhsachLineDataChuaNutNguon, nutnguon(vitriNutNguon), column);
        
        column = 3;
        [linedata, danhsachLineDataChuaNutNguon] = thayTheNutNguonBangNutMot(linedata, danhsachLineDataChuaNutNguon, nutnguon(vitriNutNguon), column);
        
        vitriNutNguonTrongPowerdata = nutnguon(vitriNutNguon) == powerdata(:,1);
        powerdata(vitriNutNguonTrongPowerdata, 1) = 1;
    end
    m = powerdata(:,1)==1;
    power = powerdata(m,:);
    powerdata(m, :) = [];
    D = sum(power,1);
    D(1) = 1;
    powerdata = [D; powerdata];  
    logger.info('(success)')
end

function [linedata, danhsachLineDataChuaNutNguon] = thayTheNutNguonBangNutMot(linedata, danhsachLineDataChuaNutNguon, nutNguonHienTai, column)
    vitriTrongLinedata = [];
    
    for index = 1:size(linedata, 1)
        if nutNguonHienTai == linedata(index, column)
           vitriTrongLinedata = [vitriTrongLinedata, index];
           break
        end
    end
    
    if any(vitriTrongLinedata)
        for index = 1:size(vitriTrongLinedata)
            danhsachLineDataChuaNutNguon = [danhsachLineDataChuaNutNguon; vitriTrongLinedata(index), column, linedata(vitriTrongLinedata, column)];
        end
    end
    linedata(vitriTrongLinedata, column) = 1;
end