function [linedata,powerdata] = thugonBangCachXoaPowerdataDuThuaVaDoiTenNut(linedata,powerdata)
global logLevel
import logging.*
logger = Logger.getLogger('Chuongtrinhchinh');
logger.setLevel(logLevel);
logger.info('(Start)')

%Liet ke cac nut
danhSachNut = [];
for i=1:size(linedata,1)
    for j=2:3
         m=linedata(i,j)==danhSachNut;
         if sum(m)==0
            danhSachNut(length(danhSachNut)+1)=linedata(i,j);
         end
    end
end
bang = zeros(length(danhSachNut), 2);
bang(:, 1)=danhSachNut';
for i=1:size(bang,1)
    bang(i,2)=i+1;
end
 m=bang(:,1)==1;
 bang(m,2)=1;
%xoa nut da tinh powerdata
for i=2:size(powerdata,1)
    n=powerdata(i,1)==linedata(:,2);
    m=powerdata(i,1)==linedata(:,3);
    if sum(n)==0 && sum(m)==0
        powerdata(i,1)=0;
    end
end
k=powerdata(:,1)==0;
powerdata(k,:)=[];

for i=2:size(powerdata,1)
    k=powerdata(i,1)==bang(:,1);
    powerdata(i,1)=bang(k,2); % TODO: bug (original line)
    %powerdata(i,1) = bang(k, 1); % TODO: bug (modified, because the first column is node index, cannot be replaced)
end

% Chuyen linedata
newlinedata=linedata;
for i=1:size(newlinedata,1)
    m=newlinedata(i,2)==bang(:,1);
    newlinedata(i,2)=bang(m,2); % TODO: bug (original line)
    
    n=newlinedata(i,3)==bang(:,1);
    newlinedata(i,3)=bang(n,2); % TODO: bug (original line)
end
linedata=newlinedata;

logger.info('(Success)')
end

