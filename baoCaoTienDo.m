function baoCaoTienDo(linedata, powerdata)
% In so luong linedata va powerdata hien tai de quan sat

global logLevel;
persistent logger;

import logging.*
logger = Logger.getLogger('Chuongtrinhchinh');
logger.setLevel( logLevel );

logger.info(['linedata : ' num2str(size(linedata, 1))  ' (rows); ' 'powerdata: ' num2str(size(powerdata, 1)) ' (rows)'])
end