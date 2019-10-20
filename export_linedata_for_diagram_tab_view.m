function export_linedata_for_diagram_tab_view(linedata, powerdata, nutnguon, linedatafinal)
    SIZE_ROW = 1;
    SOLID_CONNECTOR = ' --- ';
    DOTTED_CONNECTOR = ' -.- ';
    FROM_INDEX = 2;
    TO_INDEX = 3;
    R_INDEX = 4;
    X_INDEX = 5;
    DEFAULT_NAME = 'n';
    OPEN_BRACKET = '((';
    CLOSE_BRACKET = '))';

    STYLE = 'style ';
    FORMAT_OF_NUT_NGUON = ' fill:#FF0,stroke:#333,stroke-width:3px';

    lineCount = size(linedata, SIZE_ROW);
    nutNguonCount = size(nutnguon, SIZE_ROW);

    %Ve do thi co ban
    diagramContent = 'graph TD';
    for index = 1:lineCount
       from = linedata(index, FROM_INDEX);
       to = linedata(index, TO_INDEX);
       R = linedata(index, R_INDEX);
       X = linedata(index, X_INDEX);
       
       if(isRemovedInFinalLineData(linedatafinal, from, to))
           selectedLineStyle = DOTTED_CONNECTOR;
       else
           selectedLineStyle = SOLID_CONNECTOR;
       end

       fromNode = [DEFAULT_NAME, num2str(from)];
       fromNodeDetail = [OPEN_BRACKET, '"', fromNode, '<br/>', num2str(getPowerOfNode(powerdata, from)), 'kW', '"', CLOSE_BRACKET];
       toNode = [DEFAULT_NAME, num2str(to)];
       toNodeDetail = [OPEN_BRACKET, '"', toNode, '<br/>', num2str(getPowerOfNode(powerdata, to)), 'kW', '"', CLOSE_BRACKET];
       
       line = [selectedLineStyle, '|"'];
       line = [line, 'R=' num2str(R), ';'];
       %line = [line, '<br/>', 'X=' num2str(X), ';'];
       line = [line, '"|'];
       
       newConnector = [fromNode, fromNodeDetail, line, toNode, toNodeDetail];

       diagramContent = [diagramContent, char(10), newConnector];
    end

    %Style cho cac nut nguon
    for index = 1:nutNguonCount
        nguon = nutnguon(index);
        nutNguon = [DEFAULT_NAME, num2str(nguon)];

        diagramContent = [diagramContent, char(10), STYLE, nutNguon, FORMAT_OF_NUT_NGUON ];
    end
    
    

    fileID = fopen('_digram_tab_view_data.txt','w');
    fprintf(fileID, diagramContent);
    fclose(fileID);
end

function isRemoved = isRemovedInFinalLineData(linedata, fromNode, toNode)
    isRemoved = true;
    for index= 1:size(linedata, 1)
        if (linedata(index, 2) == fromNode) && (linedata(index, 3) == toNode)
            isRemoved = false;
            break;
        end
    end
    
    return;
end

function power = getPowerOfNode(powerdata, nodeId) 
for index = 1:size(powerdata, 1)
    if(powerdata(index, 1) == nodeId)
       power =  powerdata(index, 2);
       break
    end
end
end
