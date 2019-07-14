function baoCaoTienDo(linedata, powerdata)
global logLevel;
persistent logger;

import logging.*
logger = Logger.getLogger('Chuongtrinhchinh');
logger.setLevel( logLevel );

logger.info(['so luong linedata : ' num2str(numel(linedata))  ' (don vi)'])
logger.info(['so luong powerdata: ' num2str(numel(powerdata)) ' (don vi)'])
end