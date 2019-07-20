function linedata = loaiBoLinedataChuaHaiNutLienKe(nutA, nutB, linedata)
for k = 1:size(linedata, 1)
    nutBatDau = linedata(k, 2);
    nutKetThuc = linedata(k, 3);
    if (nutBatDau == nutA && nutKetThuc == nutB)||...
            (nutKetThuc == nutA && nutBatDau == nutB)
        linedata(k, :) = 0;
    end
end
m = linedata(:, 1) == 0;
linedata(m, :) = [];
end

