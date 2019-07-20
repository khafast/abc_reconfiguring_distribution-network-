function danhSachNutThoaDieuKien = timDanhSachNutCoLienKetVoiNutKhac(linedata, soLuongLienKet)
    ONE_ROW_MODE = 1;
    %Tim nut chi chua 1 nhanh
    maTranKe = taoMaTranKeDeDanhDauKetNoiGiuaCacNutTrongLinedata(linedata);
    danhSachSoLuongLienKet = sum(maTranKe, ONE_ROW_MODE);
    danhSachNutThoaDieuKien = find(danhSachSoLuongLienKet == soLuongLienKet);
end

