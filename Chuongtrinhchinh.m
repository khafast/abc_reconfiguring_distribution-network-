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

%%Chuan bi logger cho chuong trinh chinh
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

load('du_lieu_NK_538_nut.mat');

%load('du_lieu_16_nut.mat');

%Du lieu 33 nut
%load('du_lieu_33_nut.mat');

%Du lieu 27 nut
%load('linedata.mat');  load('powerdata.mat');load('nutnguon.mat');
%Du lieu moi
%load('linetest.mat');  load('powertest.mat'); load('nutnguontest.mat');linedata=linetest; powerdata=powertest; nutnguon=nutnguontest;

%Du lieu luoi sa dec
%load('sdlinedata.mat');load('sdpowerdata.mat');load('sdnutnguon.mat');linedata=sdlinedata; powerdata=sdpowerdata; nutnguon=sdnutnguon;

figure('Name', 'Luoi dien truoc khi chay chuong trinh'); 
plot(taoDoiTuongGraph(linedata), 'Layout', 'force'); view(0, 90);

%Chuyen doi cac nguon ve nut 1
if any(nutnguon ~= 1)
    [linedata, powerdata] = chuyenNutNguonVeNutMotDeDonGianHoaBaiToan(linedata, powerdata, nutnguon);
end
[linedata, powerdata] = xoaCacNutKhongTonTaiTrongLinedata(linedata, powerdata);


% Chay thuat toan bay ong nhanh tao
[cutlist] = ABCmain(Udm, linedata, powerdata);

logger.info('Phan tich du lieu thu duoc (Start)')
logger.info(['Danh sach cac nhanh cat: ' num2str(cutlist)]);
logger.info('{');
lineDataAfterRun = linedata;
for i = 1:length(cutlist)
    m = cutlist(i) == lineDataAfterRun(:, 1);
    
    % for plot
    tmpLineData = lineDataAfterRun(m,:);
    nutDau = num2str(tmpLineData(2));
    nutCuoi = num2str(tmpLineData(3));
    logger.info(['loai bo linedata: ' num2str(lineDataAfterRun(m, :))]);
    % end for plot
    
    lineDataAfterRun(m, :) = [];
    
    % plot
    %figure('Name', ['(' num2str(i) ') Hinh sau khi cat giua #' nutDau ' va #' nutCuoi]); 
    %plot(graph(adj(lineDataAfterRun)));
end
logger.info('}');

baoCaoTienDo(lineDataAfterRun, powerdata);
[~, powerDataAfterRun] = tinhPowerDataChoCacNhanhHinhTia(Udm, lineDataAfterRun, powerdata);
logger.info('tinh xong powerDataAfterABC');

dienap = tinhSutApChoTatCaNutSauKhiBoQuaDanhSachCacNhanhCat(Udm, cutlist, linedata, powerDataAfterRun);
Vmin = min(dienap(:, 2));
m = Vmin == dienap(:, 2);
nutVmin = dienap(m, 1);

Ptotalload = sum(powerdata,1);
Ptotalload = Ptotalload(2);
m = powerdata(:, 1) == 1;
Ptotal = powerDataAfterRun(m, 4);
Ploss = Ptotal + powerDataAfterRun(m,2) - Ptotalload;
DeltaP = Ploss/Ptotal*100;

logger.info('Phan tich du lieu thu duoc (Success)')

%xuat ra thong so
cutlist = sort(cutlist, 2, 'descend');
logger.info('========');
logger.info(['Danh sach cac nhanh cat: ' chuyenSoThanhChu(cutlist)]);
logger.info('{');
linedatafinal = linedata; % for view on diaram tab view data

for vitriCat = 1:numel(cutlist)
    linedataTaiViTriCat = linedata(cutlist(vitriCat), :);
    linedatafinal(cutlist(vitriCat), :) = [];
    logger.info(['cat nhanh ' num2str(linedataTaiViTriCat(1)) ' (n' chuyenSoThanhChu(linedataTaiViTriCat(2)) ' -> n' chuyenSoThanhChu(linedataTaiViTriCat(3)) ')']);
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

veHinhSoSanhLineDataBeforeAndAfterRun(linedata, lineDataAfterRun, cutlist);

export_linedata_for_diagram_tab_view(linedata, powerdata, nutnguon, linedatafinal)
logger.info('(SUCCESS)')

logManager.resetAll();
fclose all;
%logManager.printLoggers();



