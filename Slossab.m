function [Sloss, power] = Slossab(nutDau, nutCuoi, Udm, powerdata, linedata)
global logLevel
import logging.*
logger = Logger.getLogger('Chuongtrinhchinh');
logger.setLevel(logLevel);
logger.finer(['Tinh ton that tu nut ' num2str(nutDau) ' toi nut ' num2str(nutCuoi) ' (Start)'])

%%a la nut dau, b la nut sau
power = powerdata;
vitriNutDau = powerdata(:,1) == nutDau;
vitriNutCuoi = powerdata(:,1) == nutCuoi;
Pload = powerdata(vitriNutDau, 2);
Qload = powerdata(vitriNutDau, 3);
Ptransfer = powerdata(vitriNutDau, 4);
Qtransfer = powerdata(vitriNutDau, 5);

%nut1=powerdata(nuta,1);
%nut2=powerdata(nutb,1);

%%Tim nhanh
for vitri = 1:size(linedata,1)
    if (linedata(vitri, 2) == nutCuoi && linedata(vitri,3) == nutDau)||...
       (linedata(vitri, 3) == nutCuoi && linedata(vitri,2) == nutDau)
        nhanh=linedata(vitri, 1);
        R = linedata(vitri, 4);
        X = linedata(vitri, 5);
    end
end
%%Tinh ton that
% TODO: xem lai cong thuc, tai sao dung "X^2 + X^2" ma khong dung 2*(X^2)
Ploss = (((Pload + Ptransfer)^2+(Qload + Qtransfer)^2)/Udm^2)*R/sqrt(3)/1000;
Qloss = (((Pload + Ptransfer)^2+(Qload + Qtransfer)^2)/Udm^2)*X/sqrt(3)/1000;
Sloss = Ploss + 1i * Qloss;

power(vitriNutCuoi, 4) = power(vitriNutCuoi, 4) + Pload + Ptransfer + Ploss;
power(vitriNutCuoi, 5) = power(vitriNutCuoi, 5) + Qload + Qtransfer + Qloss;
logger.finer(['Tinh ton that tu nut ' num2str(nutDau) ' toi nut ' num2str(nutCuoi) ' (Success)'])
end

