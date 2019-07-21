function G = taoDoiTuongGraph(lineData)
maTranKe = taoMaTranKeDeDanhDauKetNoiGiuaCacNutTrongLinedata(lineData);
G = graph(maTranKe);
for i = 1:size(lineData, 1)
    G.Edges.Weight(i) = lineData(i, 4);
end
end

