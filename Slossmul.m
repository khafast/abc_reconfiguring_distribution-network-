function [slosstong, powerdataout] = Slossmul(dscat, nguon, Udm, linedatamultiloop, linedata, powerdata)
slosstong = 0;
%Input dscat: danh sach cac nhanh se cat
%      Udm la dien ap dinh muc
%      linedata
%      Powerdata
%Output nhanhcat:danhsach cac nhanh cat toi uu
%      sloss ton that khi cat cac nhanh
banSauCuaLinedataMultiloop = linedatamultiloop;
%xac dinh nut mot
for i = 1:length(dscat)
    vitriLinedata = dscat(i) == banSauCuaLinedataMultiloop(:, 1);
    banSauCuaLinedataMultiloop(vitriLinedata, :) = [];
end

A = 1;
while A == 1
    %Tim nut chi chua 1 nhanh
    G = adj(banSauCuaLinedataMultiloop);
    D = sum(G, 1);
    nutCuoiTrenNhanhHinhTia = find(D == 1);
    vitriNut = nutCuoiTrenNhanhHinhTia == 1;
    if  sum(vitriNut) ~= 0
        nutCuoiTrenNhanhHinhTia(vitriNut) = [];
    end
    
    vitriNut = nutCuoiTrenNhanhHinhTia == nguon;
    if  sum(vitriNut) ~= 0
        nutCuoiTrenNhanhHinhTia(vitriNut) = [];
    end
    
    %Tinh cong suat
    if numel(nutCuoiTrenNhanhHinhTia) > 0
        %Tim duong di
        for i = 1:length(nutCuoiTrenNhanhHinhTia)
            nutrun = timDuongDiNganNhatGiuaHaiNut(banSauCuaLinedataMultiloop, nguon, nutCuoiTrenNhanhHinhTia(i));
            
            danhSachNutTrenCungMotNhanh = runstop(banSauCuaLinedataMultiloop, nutCuoiTrenNhanhHinhTia(i));
            nutCuoiCungTrongDanhSach = danhSachNutTrenCungMotNhanh(numel(danhSachNutTrenCungMotNhanh));
            m = nutCuoiCungTrongDanhSach == nutrun;
            if sum(m) ~= 0
                vitriNut = find(nutCuoiCungTrongDanhSach == nutrun);
                nutrun(vitriNut + 1:length(nutrun)) = [];
            end
            
            %tinh cong suat
            for vitriNut = 1:length(nutrun)-1
                nutA = nutrun(vitriNut);
                nutB = nutrun(vitriNut + 1);
                
                [sloss1, powerdata] = Slossab(nutA, nutB, Udm, powerdata, linedata);
                slosstong = slosstong + sloss1;
                
                banSauCuaLinedataMultiloop = loaiBoLinedataChuaHaiNutLienKe(nutA, nutB, banSauCuaLinedataMultiloop);
            end
        end
    else
        A = 0;
    end
    if isempty(banSauCuaLinedataMultiloop)
        break
    end
end
powerdataout = powerdata;
end
