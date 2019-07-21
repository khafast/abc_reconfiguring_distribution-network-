function danhSachNutLienKetNgoai = timDanhSachNutCoLienKetVoiCacNutNgoaiVongLienHopHienTai(linedata, linedatamultiloop)
% Input: linedatadaloc la linedata da loai bo vong doc lap va loc tia
%        linedatavongkep la linedata chi chua 1 vong lien hop
% Output: nut nguon cua vong kep


% Tim cac nut trong vong lien hop
vongLienHop = linedatamultiloop;
danhSachNutTrongVongLienHopHienTai = timDanhSachNutTrongLinedata(vongLienHop); %danh sach chua nut
danhSachNutTrongVongLienHopHienTai(1) = []; %Xoa nut 0

%Tim nut lien ket voi nut ngoai cac nut trong vong va do la nut nguon
danhSachNutLienKetNgoai = [];

G = taoDoiTuongGraph(linedata);
for vitri = 1:length(danhSachNutTrongVongLienHopHienTai)
    if danhSachNutTrongVongLienHopHienTai == 1
       danhSachNutLienKetNgoai=1;
    else
        danhSachCacNutLanCan = neighbors(G, danhSachNutTrongVongLienHopHienTai(vitri));
        for vitriNutLanCan = 1:length(danhSachCacNutLanCan)
            m = danhSachCacNutLanCan(vitriNutLanCan) == danhSachNutTrongVongLienHopHienTai;
            if sum(m) == 0
               danhSachNutLienKetNgoai(length(danhSachNutLienKetNgoai) + 1) = danhSachNutTrongVongLienHopHienTai(vitri);
            end
        end
    end
end
end

