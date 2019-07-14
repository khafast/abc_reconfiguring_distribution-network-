function [cutlist,Ploss,DeltaP,linedata,powerdata]=ABCmain(Udm,linedata,powerdata)
global logLevel
import logging.*
logger = Logger.getLogger('Chuongtrinhchinh');
logger.setLevel( logLevel );
logger.info('(Start)')

format short G;
%Khoi tao
cutlist=[];
powerdatanguon = powerdata;

%-------------------------------------------------------------------------
%------------Chuyen doi linedata voi cac nut nguon thanh nut 1------------

%Tim nhanh chi lien ket voi nut nguon
nhanhlienketnguon=[];
for i=1:size(linedata,1)
    if linedata(i,2)==1 && linedata(i,3)==1
        targetLine = linedata(i,1);
        logger.info(['Tim duoc nhanh lien ket nut nguon: ' num2str(targetLine)])
        nhanhlienketnguon(length(nhanhlienketnguon)+1) = targetLine;
        linedata(i,1)=0;
    end
end
n=linedata(:,1)==0;
linedata(n,:)=[];
cutlist=[cutlist,nhanhlienketnguon];
%----------Loc cac nhanh tia khoi luoi-------------------------------------
logger.info('Loc cac nhanh tia ra khoi luoi (Start)')
[linedata, powerdata] = ruttia(Udm, linedata, powerdata);
linedata = locnhanhtrung(linedata);

[linedata, powerdata] = ruttia(Udm, linedata, powerdata);
[linedata, powerdata] = thugon(linedata, powerdata);

[linedata, powerdata] = ruttia(Udm, linedata, powerdata);
linedata = locnhanhtrung(linedata);
logger.info('Loc cac nhanh tia ra khoi luoi (Success)')
%------------------------------MAIN----------------------------------------

%----------Tim vong doc lap------------------------------------------------

VongDL = indeloop(linedata);

%----------Tim vong kep------------------------------------------------- ---

VongKep = multiloop(linedata);


%chay vong lap
linedatarong = isempty(linedata);
while linedatarong == 0
    
    %Quet cac vong doc lap
    i = 0;
    while numel(VongDL) > 0 %dieu kien quet vong doc lap
        %Quet cac vong doc lap
        i = i+1;
        linedataindeloop = [];
        %Tim so nut co lien ket ngoai
        for j = 1:size(VongDL,2)
            n = VongDL(i, j) == linedata(:,1);
            linedataindeloop = [linedataindeloop;linedata(n,:)];
        end
        nutlkn=nutlienketngoai(linedata,linedataindeloop);
        %Neu chi co 1 nut co lien ket ngoai thi do la nut nguon
        % va cho chay ABC v cap nhat linedata powerdata
        if numel(nutlkn) < 2
            [nhanhcat] = ABCin(VongDL(i,:), Udm, linedata, powerdata);
            cutlist = [cutlist,nhanhcat];
            %Loc tia va tinh cong suat
            q = nhanhcat == linedata(:,1);
            linedata(q,:) = [];
            [ linedata, powerdata ] = ruttia(Udm,linedata,powerdata);
            for k = 1:numel(VongDL(i,:))
                m = VongDL(i,k) == linedata(:,1);
                linedata(m,1) = 0;
            end
            VongDL(i,:) = [];
            p = linedata(:,1) == 0;
            linedata(p,:) = [];
            i = 0;
            % Loc tia va tinh cong suat
            % L?c c�c nh�nh l� h�nh tia v� t�nh c�ng su?t truy?n v� c�ng su?t t?n th?t v? n�t    ngu?n th? c?p (n�t r? nh�nh)
            %logger.info('rut tia linedata va tinh lai cong suat truyen va cong suat ton that')
            [ linedata, powerdata ] = ruttia(Udm,linedata,powerdata);
        end
    end
    
    %Quet tren cac vong kep
    i = 0;
    while numel(VongKep) > 0
        i = i+1;
        linedatamultiloop = VongKep{i};
        nutlkn = nutlienketngoai(linedata,linedatamultiloop);
        if numel(nutlkn)<2
            [nhanhcat] = ABCmulti(Udm,linedatamultiloop,linedata,powerdata);
            cutlist = [cutlist,nhanhcat];
            %Tinh cong suat
            for j = 1:numel(nhanhcat)
                m = nhanhcat(j) == linedata(:,1);
                linedata(m,:) = [];
            end
            [ linedata,powerdata ] = ruttia(Udm,linedata,powerdata);
            for j = 1:size(linedatamultiloop,1)
                n=linedatamultiloop(j,1) == linedata(:,1);
                linedata(n,1) = 0;
            end
            m=linedata(:,1) == 0;
            linedata(m,:) = [];
            VongKep(i) = [];
            i=0;
        end
        % Tinh cong suat
        % L?c c�c nh�nh l� h�nh tia v� t�nh c�ng su?t truy?n v� c�ng su?t t?n th?t v? n�t ngu?n th? c?p (n�t r? nh�nh)
        %logger.info('rut tia linedata va tinh lai cong suat truyen va cong suat ton that')
        [ linedata, powerdata] = ruttia(Udm,linedata,powerdata);
    end
    %Kiem tra lai so phan ti linedata
    linedatarong = isempty(linedata);
end
%Tinh Ton that
Ptatalload = sum(powerdatanguon,1);
Ptatalload = Ptatalload(3);
m = powerdata(:,1)==1;
Ptatal = powerdata(m,5);
Ploss = Ptatal-Ptatalload;
DeltaP = Ploss/Ptatal*100;

logger.info('(Success)')
end