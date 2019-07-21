function nut = layNgauNhienMotNut(danhSachNut)
% lay ngau nhien 1 nut tu linedata duoc truyen vao
    nut = danhSachNut(randperm(numel(danhSachNut), 1));
end