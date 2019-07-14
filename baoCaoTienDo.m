function baoCaoTienDo(linedata, powerdata)
global logLevel;
persistent logger;

import logging.*
logger = Logger.getLogger('Chuongtrinhchinh');
logger.setLevel( logLevel );

logger.info(['linedata : ' num2str(numel(linedata))  ' (rows); ' 'powerdata: ' num2str(numel(powerdata)) ' (rows)'])
end