function [linedata, powerdata] = tinhPowerDataChoCacNhanhHinhTia(Udm, linedata, powerdata)
global logLevel
global logger
import logging.*
logger = Logger.getLogger('Chuongtrinhchinh');
logger.setLevel(logLevel);
logger.fine('(Start)')

if isempty(linedata)==1
    return;
end

soLanRutTia=0;

while true
     soLanRutTia = soLanRutTia + 1;
     %Tim nut chi chua 1 nhanh
     danhSachNutChiCoMotLienKet = timDanhSachNutCoMotLienKetVoiNutKhac(linedata);
     danhSachNutNguon = danhSachNutChiCoMotLienKet == 1;
     if sum(danhSachNutNguon) ~= 0
        logger.info('bo qua tat ca cac nut nguon');
        danhSachNutChiCoMotLienKet(danhSachNutNguon) = [];
     end
     if isempty(danhSachNutChiCoMotLienKet)
        logger.info('khong co nut nao chi nam tren mot nhanh');
        break
     end
     %Tinh cong suat
     for i = 1:length(danhSachNutChiCoMotLienKet)
         nutHienTai = danhSachNutChiCoMotLienKet(i);
         logger.info(['rut tia ' num2str(soLanRutTia) ': lan ' num2str(i) ': nut#' num2str(nutHienTai)]);
         
         danhSachNutTrenCungMotNhanh = timDanhSachNutCungMotNhanh(linedata, nutHienTai);
         danhSachNutTrenCungMotNhanh = xoaNutNaoNamSauNutNguonBoiViNutNguonLaDiemBatDauCuaNhanh(danhSachNutTrenCungMotNhanh);
         
         for vitri = 1:length(danhSachNutTrenCungMotNhanh) - 1
             [~, powerdata] = Slossab(danhSachNutTrenCungMotNhanh(vitri), danhSachNutTrenCungMotNhanh(vitri+1), Udm, powerdata, linedata);
             linedata = xoaLinedataDaTinhPowerdata(linedata, danhSachNutTrenCungMotNhanh(vitri), danhSachNutTrenCungMotNhanh(vitri+1));
         end
         baoCaoTienDo(linedata, powerdata);
     end
     
     if isempty(linedata)
        logger.info('rut tia xong (tinh xong tat ca linedata)');
        break
     end
end 
logger.fine('(Success)')
end

function danhSachNutTrenCungMotNhanh = xoaNutNaoNamSauNutNguonBoiViNutNguonLaDiemBatDauCuaNhanh(danhSachNutTrenCungMotNhanh)
    j = danhSachNutTrenCungMotNhanh == 1;
    danhSachNutTrenCungMotNhanh(find(j) + 1:numel(danhSachNutTrenCungMotNhanh)) = [];
end

function linedata = xoaLinedataDaTinhPowerdata(linedata, nutDau, nutCuoi)
    global logger;
     %%Tim nhanh
     for vitriLineData = 1:size(linedata,1)
         if (linedata(vitriLineData,2)== nutDau && linedata(vitriLineData,3)== nutCuoi)||...
            (linedata(vitriLineData,3)== nutDau && linedata(vitriLineData,2)== nutCuoi)
            lineDataBiLoaiBo = linedata(vitriLineData,:); % for plot
            linedata(vitriLineData,:)=0;
         end
     end
     danhSachNutNguon = linedata(:,1) == 0;
     logger.info(['loai tru nhanh hinh-tia co linedata: ' num2str(lineDataBiLoaiBo)]);
     linedata(danhSachNutNguon, :) = [];
end


