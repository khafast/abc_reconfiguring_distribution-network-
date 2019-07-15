function [Sloss,power] = Slossab(a, b, Udm, powerdata, linedata)
global logLevel
import logging.*
logger = Logger.getLogger('Chuongtrinhchinh');
logger.setLevel(logLevel);
logger.finer(['Tinh ton that tu nut ' num2str(a) ' toi nut ' num2str(b) ' (Start)'])

%%a la nut dau, b la nut sau
power=powerdata;
nuta=powerdata(:,1)==a;
nutb=powerdata(:,1)==b;
A=powerdata(nuta,2);
B=powerdata(nuta,3);
C=powerdata(nuta,4);
D=powerdata(nuta,5);
nut1=powerdata(nuta,1);
nut2=powerdata(nutb,1);

%%Tim nhanh
for k=1:size(linedata,1)
    if (linedata(k,2)==b && linedata(k,3)==a)||...
       (linedata(k,3)==b && linedata(k,2)==a)
        nhanh=linedata(k,1);
        E=linedata(k,4);
        F=linedata(k,5);
    end
end
%%Tinh ton that
Ploss=(((A+C)^2+(B+D)^2)/Udm^2)*E/sqrt(3)/1000;
Qloss=(((A+C)^2+(B+D)^2)/Udm^2)*F/sqrt(3)/1000;
Sloss=Ploss+1i*Qloss;
power(nutb,4)=power(nutb,4)+A+C+Ploss;
power(nutb,5)=power(nutb,5)+B+D+Qloss;
logger.finer(['Tinh ton that tu nut ' num2str(a) ' toi nut ' num2str(b) ' (Success)'])
end

