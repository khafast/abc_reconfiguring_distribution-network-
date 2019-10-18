function [nhanhcat, Ploss, Bestpower] = ABCmulti(Udm, linedatamultiloop, linedata, powerdata)
% Chay thuat toan bay ong nhan tao (ABC) tren cac vong lien-hop (multiple loops)

global logLevel

global CostFunction;
global bayOng;
global kickThuocBayOng;
global boDemSoLanBoQua;
global matrancat;
global nVar;
global p;
global phamViTimNgauNhien;
global linedatacatnguon;
global danhsachnut;
global nutNguon;
global nhanhthay;

global logger;

import logging.*
logger = Logger.getLogger('Chuongtrinhchinh');
logger.setLevel(logLevel);
logger.info('(Start)')

format short G;
%he so vong lap
heSoVongLap = 0.7;

%Pham vi tim ngau nhien TODO: cang chinh chi so nay de ho tro mang 33 nut
phamViTimNgauNhien = 12;

%xac dinh ma tran cat
[linedatacatnguon, matrancat, nhanhthay] = timMaTranCatSauKhiRutGonLinedataMultiloop(linedatamultiloop, linedata);

%Tim nut nguon
nutNguon = timNutNguon(linedatacatnguon, linedata);

%danh sach nut
maTranKe = taoMaTranKeDeDanhDauKetNoiGiuaCacNutTrongLinedata(linedatacatnguon);
G = maTranKe;
D = sum(G,1);
danhsachnut = find(D~=0);

% ham muc tieu
CostFunction = @(dscat) Slossmul(dscat, nutNguon, Udm, linedatamultiloop, linedata, powerdata);

% So bien moi co ong
nVar = size(matrancat, 2) - 1;

% So vong lap toi da
soVongLapToiDa = round(heSoVongLap * nVar^2);

% Tim so nhanh nhieu nhat
D = zeros(1,size(matrancat, 2)-1);
maxnhanh = 0;
for i = 1:size(matrancat, 2) - 1
    for j = 1:size(matrancat, 1)
        D(i) = D(i)+ matrancat(j, i+1);
    end
    if D(i) >= maxnhanh
        maxnhanh = D(i);
    end
end

%Kich thuoc bay ong
kickThuocBayOng = round(2*nVar);

% Kich thuoc ong giam sat
kichThuocBayOngGiamSat = kickThuocBayOng;

% Gioi han bo qua
gioiHanBoQua = 2;

%% Khoi tao

%Empty Bee Structure
empty_bee.Position = [];
empty_bee.Cost = [];

% Initialize Population Array
bayOng = repmat(empty_bee, kickThuocBayOng, 1);

% Initialize Best Solution Ever Found
BestSol.Cost.ploss = inf;
BestSol.Cost.power = 0;
BestSol.Position = inf;
Ploss = inf;
nhanhcat = [];

[bayOng, BestSol, p] = khoiTaoBayOngBanDau(bayOng, BestSol, p);

% Bo dem so lan bo qua
boDemSoLanBoQua = zeros(kickThuocBayOng, 1);

%% ABC Main Loop
for it = 1:soVongLapToiDa
    bangDanhGiaKhaNangThanhCong = trienKhaiOngLamViec(CostFunction);
    
    bayOng = trienKhaiOngGiamSat(bangDanhGiaKhaNangThanhCong, CostFunction, bayOng, kichThuocBayOngGiamSat);
    
    bayOng = trienKhaiOngTrinhSat(CostFunction, bayOng, gioiHanBoQua);
    
    % Cap nhat giai phap tot nhat ma bay ong tim duoc
    for i = 1:kickThuocBayOng
        if real(bayOng(i).Cost.ploss) <= real(BestSol.Cost.ploss)
            BestSol = bayOng(i);
        end
    end
    
    %% Store Best Cost Ever Found
    if  real(BestSol.Cost.ploss) < Ploss
        Ploss = real(BestSol.Cost.ploss);
        Bestpower = BestSol.Cost.power;
        nhanhcat = BestSol.Position;
        
        %Xuat trang thai chay
        logger.fine(['Chay vong lap tren vong kep lan  ' num2str(it)]);
        logger.info(['No.' num2str(it) ' (Success): Ploss = ' num2str(Ploss) ' kW' '; nhanhcat = ' num2str(nhanhcat) '; (giai phap duoc chon)'])
    else
        logger.info(['No.' num2str(it) ' (Fail): Ploss = ' num2str(Ploss) ' kW' '; nhanhcat = ' num2str(BestSol.Position) ';'])
    end
    
end
logger.info('(Success)')
end

function [bayOng, BestSol, p] = khoiTaoBayOngBanDau(bayOng, BestSol, p)
    global CostFunction;
    %global bayOng;
    global kickThuocBayOng;
    %global boDemSoLanBoQua;
    global matrancat;
    global nVar;
    %global p;
    %global phamViTimNgauNhien;
    global linedatacatnguon;
    global danhsachnut;
    global nutNguon;
    global nhanhthay;

    % Create Initial Population
    for i = 1:kickThuocBayOng
        A = 0;
        danhSachNhanh = [];
        while A == 0
            danhSachCat = matrancat;
            for j = 1:nVar
                n = danhSachCat(:,j+1) == 1;
                nhanhcat = danhSachCat(n,1);
                nhanh = layNgauNhienMotNut(nhanhcat);
                danhSachNhanh(j) = nhanh;
                m = nhanh == danhSachCat(:,1);
                danhSachCat(m, :)=[];
            end
            %xoa nhanh tren linedata
            linedatacat=linedatacatnguon;
            for vitri = 1:length(danhSachNhanh)
                p = danhSachNhanh(vitri) == linedatacat(:,1);
                linedatacat(p, :)=[];
            end
            %Tim nut lien ket
            danhSachNutThu = danhsachnut;
            maTranKe = taoMaTranKeDeDanhDauKetNoiGiuaCacNutTrongLinedata(linedatacat);
            ketQuaCuaDepthFirstSearch = dfsearch(graph(maTranKe),nutNguon);
            for vitri = 1:length(ketQuaCuaDepthFirstSearch)
                p = ketQuaCuaDepthFirstSearch(vitri) == danhSachNutThu;
                danhSachNutThu(p) = [];
            end
            if isempty(danhSachNutThu)
                A = 1;
            end
        end
        %chuyen doi danh sach ve nhanh thuc
        nhanhcatthuc = [];
        nhanhthay1 = [];
        for r = 1:length(danhSachNhanh)
            if isempty(nhanhthay{danhSachNhanh(r)})
                nhanhcatthuc(length(nhanhcatthuc) + 1) = danhSachNhanh(r);
            else
                nhanhthay1 = layNgauNhienMotNut(nhanhthay{danhSachNhanh(r)});
                nhanhcatthuc(length(nhanhcatthuc) + 1) = nhanhthay1;
            end
        end
        
        
        bayOng(i).Position = nhanhcatthuc;
        [ploss, power] = CostFunction(bayOng(i).Position);
        bayOng(i).Cost.ploss = ploss;
        bayOng(i).Cost.power = power;
        if real(bayOng(i).Cost.ploss) <= real(BestSol.Cost.ploss)
            BestSol=bayOng(i);
        end
    end
end

%% Giai doan Ong lam viec (Employed Bees Phase)
function P = trienKhaiOngLamViec(CostFunction)
    %global CostFunction;
    global bayOng;
    global kickThuocBayOng;
    global boDemSoLanBoQua;
    global matrancat;
    global nVar;
    global p;
    global phamViTimNgauNhien;
    global linedatacatnguon;
    global danhsachnut;
    global nutNguon;
    global nhanhthay;
    
    global logger;
    
    logger.fine(' ...');
    
    for i = 1:kickThuocBayOng
        A = 0;
        danhSachNhanh = [];
        while A == 0
            danhSachCat = matrancat;
            for j = 1:nVar
                vitriTrongDanhSach = danhSachCat(:,j+1)==1;
                nhanhcat = danhSachCat(vitriTrongDanhSach, 1);
                vitri = find(p);
                E = 1;
                while E == 1
                    if vitri == 1
                        Z = 0:phamViTimNgauNhien;
                    elseif vitri == numel(nhanhcat)
                        Z = -phamViTimNgauNhien:0;
                    else
                        Z = -phamViTimNgauNhien:phamViTimNgauNhien;
                    end
                    phi = layNgauNhienMotNut(Z);
                    if (vitri + phi) >= 1 && ...
                            (vitri + phi <= length(nhanhcat))
                        E=0;
                    end
                end
                danhSachNhanh(j) = nhanhcat(vitri + phi);
                vitriTrongDanhSach=danhSachNhanh(j) == danhSachCat(:,1);
                danhSachCat(vitriTrongDanhSach,:) = [];
            end
            %xoa nhanh tren linedata
            linedatacat = linedatacatnguon;
            for k = 1:length(danhSachNhanh)
                p = danhSachNhanh(k) == linedatacat(:,1);
                linedatacat(p,:) = [];
            end
            %Tim nut lien ket
            danhSachNutThu = danhsachnut;
            maTranKe = taoMaTranKeDeDanhDauKetNoiGiuaCacNutTrongLinedata(linedatacat);
            list = dfsearch(graph(maTranKe), nutNguon);
            for k = 1:length(list)
                p = list(k) == danhSachNutThu;
                danhSachNutThu(p) = [];
            end
            if isempty(danhSachNutThu)
                A = 1;
            end
        end
        %chuyen doi danhsach ve nhanh thuc
        nhanhcatthuc = [];
        nhanhthay1 = [];
        for r = 1:length(danhSachNhanh)
            if isempty(nhanhthay{danhSachNhanh(r)})
                nhanhcatthuc(length(nhanhcatthuc)+1) = danhSachNhanh(r);
            else
                nhanhthay1 = layNgauNhienMotNut(nhanhthay{danhSachNhanh(r)});
                nhanhcatthuc(length(nhanhcatthuc)+1) = nhanhthay1;
            end
        end
        newbee.Position = nhanhcatthuc;
        [ploss, power] = CostFunction(newbee.Position);
        newbee.Cost.ploss = ploss;
        newbee.Cost.power = power;
        % Comparision
        if real(newbee.Cost.ploss) <= real(bayOng(i).Cost.ploss)
            bayOng(i) = newbee;
        else
            boDemSoLanBoQua(i) = boDemSoLanBoQua(i) + 1;
        end
    end
    
    % Calculate Fitness Values and Selection Probabilities
    F = zeros(kickThuocBayOng,1);
    for i = 1:kickThuocBayOng
        if bayOng(i).Cost.ploss >= 0
            F(i) = 1 / (1+real(bayOng(i).Cost.ploss));
        else
            F(i) = 1 + abs(real(bayOng(i).Cost.ploss));
        end
    end
    P = F/sum(F);
end

%% Giai doan Ong giam sat (Onlooker Bees Phase )
function [bayOng] = trienKhaiOngGiamSat(P, CostFunction, bayOng, kichThuocBayOngGiamSat)
    %global CostFunction;
    %global bayOng;
    %global kickThuocBayOng;
    global boDemSoLanBoQua;
    global matrancat;
    global nVar;
    global p;
    global phamViTimNgauNhien;
    global linedatacatnguon;
    global danhsachnut;
    global nutNguon;
    global nhanhthay;
    
    global logger;
    
    logger.fine(' ...');
    
    for vitri = 1:kichThuocBayOngGiamSat
        vitriOng = RouletteWheelSelection(P);
        A = 0;
        danhSachNhanh = [];
        while A==0
            danhSachCat = matrancat;
            for j = 1:nVar
                vitri = danhSachCat(:,j+1) == 1;
                nhanhcat = danhSachCat(vitri,1);
                vitri = find(p);
                E = 1;
                while E == 1
                    if vitri == 1
                        Z = 0:phamViTimNgauNhien;
                    elseif vitri == numel(nhanhcat)
                        Z = -phamViTimNgauNhien:0;
                    else
                        Z = -phamViTimNgauNhien:phamViTimNgauNhien;
                    end
                    phi = layNgauNhienMotNut(Z);
                    if (vitri + phi) >= 1 && ...
                            (vitri + phi <= length(nhanhcat))
                        E = 0;
                    end
                end
                danhSachNhanh(j) = nhanhcat(vitri+phi);
                vitri = danhSachNhanh(j) == danhSachCat(:,1);
                danhSachCat(vitri,:) = [];
            end
            
            %xoa nhanh tren linedata
            linedatacat = linedatacatnguon;
            for k = 1:length(danhSachNhanh)
                p = danhSachNhanh(k) == linedatacat(:,1);
                linedatacat(p,:) = [];
            end
            %Tim nut lien ket
            danhSachNutThu = danhsachnut;
            maTranKe = taoMaTranKeDeDanhDauKetNoiGiuaCacNutTrongLinedata(linedatacat);
            list = dfsearch(graph(maTranKe), nutNguon);
            for k = 1:length(list)
                p = list(k) == danhSachNutThu;
                danhSachNutThu(p)=[];
            end
            %Kiem tra lai dieu kien danh sach nhanh cat la phu hop
            if isempty(danhSachNutThu)
                A = 1;
            end
        end
        
        %chuyen doi danhsach ve nhanh thuc
        nhanhcatthuc = [];
        nhanhthay1 = [];
        for r = 1:length(danhSachNhanh)
            if isempty(nhanhthay{danhSachNhanh(r)})
                nhanhcatthuc(length(nhanhcatthuc)+1) = danhSachNhanh(r);
            else
                nhanhthay1 = layNgauNhienMotNut(nhanhthay{danhSachNhanh(r)});
                nhanhcatthuc(length(nhanhcatthuc)+1) = nhanhthay1;
            end
        end
        newbee.Position = nhanhcatthuc;
        % Evaluation
        [ploss, power] = CostFunction(newbee.Position);
        newbee.Cost.ploss = ploss;
        newbee.Cost.power = power;
        
        % So sanh ket qua giua ong lam viec va ong giam sat
        if real(newbee.Cost.ploss) <= real(bayOng(vitriOng).Cost.ploss)
            bayOng(vitriOng) = newbee;
        else
            boDemSoLanBoQua(vitriOng) = boDemSoLanBoQua(vitriOng)+1;
        end
    end
end

function i = RouletteWheelSelection(P)
    
    r = rand;
    C = cumsum(P);
    i = find(r <= C,1,'first');
end

%% Giai doan Ong Trinh Sat (Scout Bee Phase)
function [bayOng] = trienKhaiOngTrinhSat(CostFunction, bayOng, gioiHanBoQua)
    %global CostFunction;
    %global bayOng;
    global kickThuocBayOng;
    global boDemSoLanBoQua; % duoc tinh toan trong 2 giai doan truoc (ong lam viec va ong trinh sat)
    global matrancat;
    global nVar;
    global p;
    %global phamViTimNgauNhien;
    global linedatacatnguon;
    global danhsachnut;
    global nutNguon;
    global nhanhthay;
    
    global logger;
    
    logger.fine('...');
    
    for i=1:kickThuocBayOng
        if boDemSoLanBoQua(i) >= gioiHanBoQua
            danhSachNutThuConPhanTu = true;
            danhSachNhanhCatConLai = [];
            while danhSachNutThuConPhanTu == true
                danhSachCat = matrancat;
                for j = 1:nVar
                    n = danhSachCat(:, j+1) == 1;
                    danhSachNhanhCat = danhSachCat(n,1);
                    
                    nhanhCat = layNgauNhienMotNut(danhSachNhanhCat);
                    danhSachNhanhCatConLai(j) = nhanhCat;
                    
                    m = nhanhCat == danhSachCat(:,1);
                    danhSachCat(m,:) = [];
                end
                
                %xoa nhanh tren linedata
                linedatacat = linedatacatnguon;
                for k = 1:length(danhSachNhanhCatConLai)
                    p = danhSachNhanhCatConLai(k) == linedatacat(:,1);
                    linedatacat(p,:)=[];
                end
                
                %Tim nut lien ket
                danhSachNutThu = danhsachnut;
                maTranKe = taoMaTranKeDeDanhDauKetNoiGiuaCacNutTrongLinedata(linedatacat);
                list = dfsearch(graph(maTranKe), nutNguon);
                for k = 1:length(list)
                    p = list(k)==danhSachNutThu;
                    danhSachNutThu(p)=[];
                end
                
                %Kiem tra dieu kien ton tai nut co lap
                if isempty(danhSachNutThu)
                    danhSachNutThuConPhanTu = false;
                end
            end
            %chuyen doi danhsach ve nhanh thuc
            nhanhcatthuc = [];
            for vitriNhanh = 1:length(danhSachNhanhCatConLai)
                if isempty(nhanhthay{danhSachNhanhCatConLai(vitriNhanh)})
                    nhanhcatthuc(length(nhanhcatthuc)+1) = danhSachNhanhCatConLai(vitriNhanh);
                else
                    nhanhthay1 = layNgauNhienMotNut(nhanhthay{danhSachNhanhCatConLai(vitriNhanh)});
                    nhanhcatthuc(length(nhanhcatthuc)+1) = nhanhthay1;
                end
            end
            bayOng(i).Position = nhanhcatthuc;
            [ploss, power] = CostFunction(bayOng(i).Position);
            bayOng(i).Cost.ploss = ploss;
            bayOng(i).Cost.power = power;
            boDemSoLanBoQua(i)=0;
        end
    end
end


