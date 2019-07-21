function [linedata, powerdata] = chuyenNutNguonVeNutMotDeDonGianHoaBaiToan(linedata, powerdata)
% Chuyen nut nguon ve nut 1 de don gian hoa bai toan
    global logLevel
    import logging.*
    logger = Logger.getLogger('Chuongtrinhchinh');
    logger.setLevel(logLevel);
    
    logger.info('(start)')
    nutmax = max(max(linedata(:, 2:3)));
    
    m = linedata(:,2) == 1;
    linedata(m,2) = nutmax+1;
    
    m = linedata(:,3) == 1;
    linedata(m,3) = nutmax + 1;
    
    m = powerdata(:,1) == 1;
    powerdata(m,1) = nutmax + 1;
    
    for vitriNutNguon = 1:length(nutnguon)
        vitriTrongLinedataMaNutBatDauLaNutNguon = nutnguon(vitriNutNguon) == linedata(:,2);
        linedata(vitriTrongLinedataMaNutBatDauLaNutNguon, 2) = 1;
        
        vitriTrongLinedataMaNutKetThucLaNutNguon = nutnguon(vitriNutNguon) == linedata(:,3);
        linedata(vitriTrongLinedataMaNutKetThucLaNutNguon, 3) = 1;
        
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

