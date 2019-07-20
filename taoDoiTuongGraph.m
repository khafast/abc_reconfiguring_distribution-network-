function G = taoDoiTuongGraph(lineData)
maTranKe = taoMaTranKeDeDanhDauKetNoiGiuaCacNutTrongLinedata(lineData);
G = graph(maTranKe);
end

