function chinhMauSacChoBieuDo(bieuDo, graph)
    bieuDo.NodeColor = [0, 0, 0]; % red=0.0->1, green=0.0->1, blue=0.0->1
    bieuDo.EdgeColor = [0, 0, 0]; % red=0.0->1, green=0.0->1, blue=0.0->1
    bieuDo.LineWidth = 5; % Chieu rong day
    bieuDo.MarkerSize = 10; % Chieu rong nut
    
    veDoRongDayKhacNhauTrenHinh = 1; % 0 or 1
    
    if (veDoRongDayKhacNhauTrenHinh)
        layout(bieuDo, 'force')
        lineWith = bieuDo.LineWidth * (1.25 - graph.Edges.Weight/max(graph.Edges.Weight));
        bieuDo.LineWidth = lineWith;
    end
end