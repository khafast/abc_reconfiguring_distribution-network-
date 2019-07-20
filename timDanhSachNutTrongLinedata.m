function danhSachNut = timDanhSachNutTrongLinedata(linedata)
danhSachNut = 0; %danh sach chua nut
COT_2 = 2;
COT_3 = 3;

for vitriLineData = 1:size(linedata,1)
    for vitriCot = COT_2 : COT_3
         m = linedata(vitriLineData, vitriCot) == danhSachNut;
         if sum(m) == 0
            danhSachNut(length(danhSachNut)+1) = linedata(vitriLineData, vitriCot);
         end
    end
end
end

