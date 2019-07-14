% Chuong trinh tim diem mo mach vong toi uu tren luoi dien phan phoi
% bang thuat toan bay ong nhan tao
%--------------------------------------------------------------------------

%Input: Udm la dien ap dinh muc luoi dien phan phoi (kW)
%       nutnguon la danh sach cac nut phat cong suat khi dua vao chuong
%       trinh se quy dinh la nut 1

%       Linedata la thong so duong day
% Nhanh       Nut dau      Nut cuoi       R            X
%   1            1             2          3            4

%       Powerdata la thong so cong suat phu tai
% Nut          P load       Qload        P tranfer    Qtranfer
% 1             0             0         tinh toan    tinh toan
%--------------------------------------------------------------------------

%Output Ploss la cong suat ton that tren duong day
%       Nhanhcat la danh sach cac nhanh phai cat de luoi dien hinh tia va
%       ton that cong  suat tren luoi dien la nho nhat
%--------------------------------------------------------------------------

% clear workspace
clc;
clear;
feature('DefaultCharacterSet','UTF-8');

import logging.*
global logLevel
%logLevel = Level.FINER; 
logLevel = Level.INFO;
% get the global LogManager
logManager = LogManager.getLogManager();

% add a file handler to the root logger
fileHandler = FileHandler('./_bao_cao_toan_bo_chuong_trinh.log');
fileHandler.setLevel( Level.ALL );
rootLogger = logManager.getLogger('');
rootLogger.addHandler( fileHandler );
logger = Logger.getLogger('Chuongtrinhchinh');
logger.setLevel(logLevel);
logger.info('(START)')

%-----------------------Main-----------------------------------------------
load('Udm.mat');
%Du lieu 27 nut
load('linedata.mat');  load('powerdata.mat');load('nutnguon.mat');
%Du lieu moi
%load('linetest.mat');  load('powertest.mat'); load('nutnguontest.mat');linedata=linetest; powerdata=powertest; nutnguon=nutnguontest;

%Du lieu luoi sa dec
%load('sdlinedata.mat');load('sdpowerdata.mat');load('sdnutnguon.mat');linedata=sdlinedata; powerdata=sdpowerdata; nutnguon=sdnutnguon;

figure('Name', 'Luoi dien truoc khi chay chuong trinh'); 
plot(graph(adj(linedata)));

%Chuyen doi cac nguon ve nut 1
if nutnguon ~= 1
    logger.info('Chuyen doi cac nguon ve nut 1 (start)')
    nutmax = max(max(linedata(:,2:3)));
    
    m = linedata(:,2) == 1;
    linedata(m,2) = nutmax+1;
    
    m = linedata(:,3) == 1;
    linedata(m,3) = nutmax + 1;
    
    m = powerdata(:,1) == 1;
    powerdata(m,1) = nutmax + 1;
    
    for vitriNutNguon = 1:length(nutnguon)
        vitriTrongLinedataMaNutBatDauLaNutNguon = nutnguon(vitriNutNguon) == linedata(:,2);
        linedata(vitriTrongLinedataMaNutBatDauLaNutNguon, 2) = 1;
        
        vitriTrongLinedataMaNutKetThucLaNutNguon = nutnguon(vitriNutNguon) == linedata(:,3);
        linedata(vitriTrongLinedataMaNutKetThucLaNutNguon, 3) = 1;
        
        vitriNutNguonTrongPowerdata = nutnguon(vitriNutNguon) == powerdata(:,1);
        powerdata(vitriNutNguonTrongPowerdata, 1) = 1;
    end
    m = powerdata(:,1)==1;
    power = powerdata(m,:);
    powerdata(m,:) = [];
    D = sum(power,1);
    D(1) = 1;
    powerdata = [D;powerdata];  
    logger.info('Chuyen doi cac nguon ve nut 1 (success)')
end
[linedata, powerdata] = xoanutroi(linedata, powerdata);


% Chay thuat toan bay ong nhanh tao
[cutlist] = ABCmain(Udm, linedata, powerdata);

logger.info('Phan tich du lieu thu duoc (Start)')
logger.info(['Danh sach cac nhanh cat: ' num2str(cutlist)]);
logger.info('{');
lineDataAfterRun = linedata;
for i=1:length(cutlist)
    m = cutlist(i) == lineDataAfterRun(:,1);
    
    % for plot
    tmpLineData = lineDataAfterRun(m,:);
    nutDau = num2str(tmpLineData(2));
    nutCuoi = num2str(tmpLineData(3));
    logger.info(['loai bo linedata: ' num2str(lineDataAfterRun(m,:))]);
    % end for plot
    
    lineDataAfterRun(m,:)=[];
    
    % plot
    figure('Name', ['(' num2str(i) ') Hinh sau khi cat giua #' nutDau ' va #' nutCuoi]); 
    plot(graph(adj(lineDataAfterRun)));
end
logger.info('}');

baoCaoTienDo(lineDataAfterRun, powerdata);
[~, powerDataAfterRun] = ruttia(Udm, lineDataAfterRun, powerdata);
logger.info('tinh xong powerDataAfterABC');

dienap = sutap(Udm, cutlist, linedata, powerDataAfterRun);
Vmin = min(dienap(:,2));
m = Vmin == dienap(:,2);
nutVmin = dienap(m,1);

Ptotalload = sum(powerdata,1);
Ptotalload = Ptotalload(2);
m = powerdata(:,1)==1;
Ptotal = powerDataAfterRun(m,4);
Ploss = Ptotal + powerDataAfterRun(m,2) - Ptotalload;
DeltaP = Ploss/Ptotal*100;

logger.info('Phan tich du lieu thu duoc (Success)')

%xuat ra thong so
logger.info('========');
logger.info(['Danh sach cac nhanh cat: ' chuyenSoThanhChu(cutlist)]);
logger.info('{');
for vitriCat = 1:numel(cutlist)
    linedataTaiViTriCat = linedata(cutlist(vitriCat), :);
    logger.info(['cat giua nut #' chuyenSoThanhChu(linedataTaiViTriCat(2)) ' va nut #' chuyenSoThanhChu(linedataTaiViTriCat(3))]);
end
logger.info('}');
logger.info('========');
logger.info(['Tong tai (Ptotalload) = ' chuyenSoThanhChu(Ptotalload) ' kW']);
logger.info(['Tong cong suat (Ptotal) = ' chuyenSoThanhChu(Ptotal) ' kW']);
logger.info(['Ton that cong suat (Ploss) = ' chuyenSoThanhChu(Ploss) ' kW']);
logger.info(['Phan tram ton that cong suat (DeltaP) = ' chuyenSoThanhChu(DeltaP) '%%']);
logger.info(['Sut ap lon nhat o nut #' chuyenSoThanhChu(nutVmin') ' = ' chuyenSoThanhChu(Udm-Vmin) ' kV']);
logger.info(['Phan tram sut ap DeltaUmin = '  chuyenSoThanhChu((1-Vmin/22)*100) '%%']);
logger.info('========');

G = graph(adj(lineDataAfterRun));
figure('Name', 'Luoi dien sau khi tinh toan'); plot(G);

logger.info('(SUCCESS)')

logManager.resetAll();
fclose all;
%logManager.printLoggers();

function chu = chuyenSoThanhChu(so)
    doPhanGiaiSoThapPhan = 3;
    chu = num2str(so, doPhanGiaiSoThapPhan);
end
