function export_linedata_for_diagram_tab_view(linedata, powerdata, nutnguon, linedatafinal, dienApSauSutAp)
    SIZE_ROW = 1;
    SOLID_CONNECTOR = ' --- ';
    DOTTED_CONNECTOR = ' -.- ';
    FROM_INDEX = 2;
    TO_INDEX = 3;
    R_INDEX = 4;
    X_INDEX = 5;
    DEFAULT_NAME = 'n';
    global POWER_NODE
    POWER_NODE = nutnguon;
    
    global OPEN_BRACKET
    global CLOSE_BRACKET
    OPEN_BRACKET = '((';
    CLOSE_BRACKET = '))';
    
    global HIEN_THI_DIEN_AP_SAU_SUT_AP
    global HIEN_THI_CONG_SUAT_TINH_TOAN
    HIEN_THI_DIEN_AP_SAU_SUT_AP = true
    HIEN_THI_CONG_SUAT_TINH_TOAN = false
    HIEN_THI_LINE_DATA = true

    STYLE = 'style ';
    FORMAT_OF_NUT_NGUON = ' fill:#FF0,stroke:#333,stroke-width:3px';

    lineCount = size(linedata, SIZE_ROW);
    nutNguonCount = size(nutnguon, SIZE_ROW);

    %Ve do thi co ban
    diagramContent = ['graph TD %%%% created: ', datestr(datetime)];
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
       fromNodeDetail = getNodeDetailInfo(from, powerdata, dienApSauSutAp);
       toNode = [DEFAULT_NAME, num2str(to)];
       toNodeDetail = getNodeDetailInfo(to, powerdata, dienApSauSutAp);
       
       
       line = [selectedLineStyle, '|"'];
       if(HIEN_THI_LINE_DATA)

           line = [line, 'R=' num2str(R), ';'];
           %line = [line, '<br/>', 'X=' num2str(X), ';'];
       else
           line = [line, ' '];
       end
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
    
    

    fileID = fopen('_xem_ket_qua_su_dung_DiagramTab_GoogleChromeExtension.txt','w');
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

function detailInfo = getNodeDetailInfo(nutId, powerdata, dienApSauSutAp)
global OPEN_BRACKET
global CLOSE_BRACKET
global HIEN_THI_DIEN_AP_SAU_SUT_AP
global HIEN_THI_CONG_SUAT_TINH_TOAN

detailInfo = [OPEN_BRACKET, '"'];
detailInfo = [detailInfo, num2str(nutId)];

if HIEN_THI_DIEN_AP_SAU_SUT_AP
    detailInfo = [detailInfo, '<br/>', num2str(tinhDienApSauSutApTaiNut(dienApSauSutAp, nutId)), ' kV'];
end
if HIEN_THI_CONG_SUAT_TINH_TOAN
    detailInfo = [detailInfo, '<br/>', num2str(getPowerOfNode(powerdata, nutId)), ' kW'];
end

detailInfo = [detailInfo, '"', CLOSE_BRACKET];
end

function volt = tinhDienApSauSutApTaiNut(dienApSauSutAp, nutId)
    if kiemTraCoPhaiNutNguon(nutId)
        volt = evalin('base', 'Udm');
    else
        m = nutId == dienApSauSutAp(:, 1);
        volt = dienApSauSutAp(m, 2);
        volt = round(volt, 2);
    end
end

function laNutNguon = kiemTraCoPhaiNutNguon(nodeId)
    global POWER_NODE;
    laNutNguon = false;
    
    for index = 1:numel(POWER_NODE)
       if nodeId == POWER_NODE(index)
           laNutNguon = true;
           break;
       end
    end
end
