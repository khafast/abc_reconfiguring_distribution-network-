function [slosstong,powerout]=Sloss(a,Udm,powerdata,dscat,linedata)
%a la nhanh cat;
%linedata da duoc loai bo vong da tinh va loc tia
%Tim duong di tu a den nut 3 gan nhat
%rutgonnhanhtia
linedataindeloop=[];
for i=1:length(dscat)
    n=dscat(i)==linedata(:,1);
    linedataindeloop=[linedataindeloop;linedata(n,:)];
end
%nut=nutpower(linedataindeloop,linedata);
m=linedata(:,1)==a;
nut1=linedata(m,2);
nut2=linedata(m,3);
linedata(m,:)=[];
run1=runstop(linedata,nut1);
run2=runstop(linedata,nut2);
powerout=powerdata;
%Tinh cong suat tren nut thu 1
sloss1=0;
if numel(run1)>=2
    for i=1:length(run1)-1
        power=powerout; 
        [sloss,powerout]=Slossab(run1(i),run1(i+1),Udm,power,linedata);
        sloss1=sloss1+sloss;                
    end
end
%Tinh cong suat tren nut thu 2 
sloss2=0;
if numel(run2)>=2
    for i=1:length(run2)-1
        power=powerout; 
        [sloss,powerout]=Slossab(run2(i),run2(i+1),Udm,power,linedata);
        sloss2=sloss2+sloss;
    end
end
slosstong=sloss1+sloss2;
end


