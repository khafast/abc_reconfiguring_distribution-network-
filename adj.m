function adj=adj(linedata)
global logLevel
import logging.*
logger = Logger.getLogger('Chuongtrinhchinh');
logger.setLevel(logLevel);

logger.finer('Danh dau len ma tran vuong cac nut co ket noi voi nhau');

%%Tim nut lon nhat
nutmax=max(max(linedata(:,2:3)));

%%tao ma tran ke adj
adj=zeros(nutmax);
for i=1:size(linedata,1)
    nutDau = linedata(i,2);
    nutCuoi = linedata(i,3);
    
    adj(nutDau, nutCuoi)=1;
    adj(nutCuoi, nutDau)=1;
end
end