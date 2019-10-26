function veHinhSoSanhLineDataBeforeAndAfterRun(linedata, cutlist) 
    lineDataAfterRun = linedata;
    
    for index = 1:numel(cutlist)
       nhanh =  cutlist(index);
       lineDataAfterRun(nhanh, :) = [];
    end
    
    G = taoDoiTuongGraph(lineDataAfterRun);
    figure('Name', 'Luoi dien sau khi tinh toan'); plot(G);

    edgeLabel = cell(1, size(G.Edges, 1));
    for i = 1:numel(edgeLabel)
        edgeLabel{i} = '';
    end

    for vitriCat = 1:numel(cutlist)
        lineHienTai = linedata(cutlist(vitriCat), :);
        G = G.addedge(lineHienTai(2), lineHienTai(3), 11111);
    end
%     
%     figure('Name', 'So sanh truoc va sau khi tinh toan');
%     plotHandler = plot(G, 'Layout', 'force'); view(0, 90); %view(-180, 0)
%     plotHandler.EdgeLabelMode = 'auto';
% 
%     for i = 1:numel(plotHandler.NodeLabel)
%         plotHandler.NodeLabel{i} = ['n' plotHandler.NodeLabel{i} ''];
%     end
end