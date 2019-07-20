function nutnguon = timNutNguon(linedatamultiloop, linedata)

NUT_NGUON = 1;

%nut trong vong kep
banSauCuaLinedataMultiLoop = linedatamultiloop;

danhSachNut = timDanhSachNutTrongLinedata(banSauCuaLinedataMultiLoop);

danhSachNut(1) = []; %Xoa nut 0
nutnguon = [];
for vitri = 1:length(danhSachNut)
    if danhSachNut(vitri) == NUT_NGUON
       nutnguon = NUT_NGUON;
    end
end

if isempty(nutnguon) % khong tim duoc nut nguon (1)
   nutthu = layNgauNhienMotNut(danhSachNut);
   danhSachNutGiuaHaiNut = timDuongDiNganNhatGiuaHaiNut(linedata, nutthu, NUT_NGUON);
   K = 0;
   vitri = 0;
   while K == 0
         vitri = vitri + 1;
         m = danhSachNutGiuaHaiNut(vitri) == danhSachNut;
         if sum(m) ~= 0
            % nut nay khong nam giua 2 nut -> nut nay la nut nguon
            nutnguon = danhSachNutGiuaHaiNut(vitri);
            K = 1;
         end
    end
end
end

