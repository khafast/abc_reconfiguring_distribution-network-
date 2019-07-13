function [linedata,powerdata]=ruttia(Udm,linedata,powerdata)
global logLevel
import logging.*
logger = Logger.getLogger('Chuongtrinhchinh');
logger.setLevel(logLevel);
logger.fine('(Start)')

if isempty(linedata)==1
    return;
end

soLanRutTia=0;

while true
     soLanRutTia=soLanRutTia+1;
     %Tim nut chi chua 1 nhanh
     G=adj(linedata);
     soLuongLienKetCuaTatCaNut = sum(G,1);
     danhSachNutChiNamTrenMotNhanh = find(soLuongLienKetCuaTatCaNut == 1);
     danhSachNutNguon = danhSachNutChiNamTrenMotNhanh == 1;
     if sum(danhSachNutNguon)~=0
        logger.info('bo qua tat ca cac nut nguon');
        danhSachNutChiNamTrenMotNhanh(danhSachNutNguon)=[];
     end
     if isempty(danhSachNutChiNamTrenMotNhanh)
        logger.info('khong co nut nao chi nam tren mot nhanh');
        break
     end
     %Tinh cong suat
     for i=1:length(danhSachNutChiNamTrenMotNhanh)
         nutHienTai = danhSachNutChiNamTrenMotNhanh(i);
         logger.info(['rut tia ' num2str(soLanRutTia) ': lan ' num2str(i) ': nut#' num2str(nutHienTai)]);
         nutrun=runstop(linedata, nutHienTai);
         j=nutrun==1;
         nutrun(find(j)+1:numel(nutrun))=[];
         for vitriNutRun=1:length(nutrun)-1
             [~,powerdata]=Slossab(nutrun(vitriNutRun),nutrun(vitriNutRun+1),...
             Udm,powerdata,linedata);
             %%Tim nhanh
             for vitriLineData=1:size(linedata,1)
                 if (linedata(vitriLineData,2)==nutrun(vitriNutRun) && linedata(vitriLineData,3)==nutrun(vitriNutRun+1))||...
                    (linedata(vitriLineData,3)==nutrun(vitriNutRun) && linedata(vitriLineData,2)==nutrun(vitriNutRun+1))
                    lineDataBiLoaiBo = linedata(vitriLineData,:); % for plot
                    linedata(vitriLineData,:)=0;
                 end
             end
             danhSachNutNguon=linedata(:,1)==0;
             logger.info(['loai tru nhanh hinh-tia co linedata: ' num2str(lineDataBiLoaiBo)]);
             linedata(danhSachNutNguon,:)=[];
         end
     end
     if isempty(linedata)
        logger.info('rut trich xong du lieu (tinh xong tat ca linedata)');
        break
     end
end 
logger.fine('(Success)')
end

