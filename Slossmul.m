function [slosstong,powerdataout]=Slossmul(dscat,nguon,Udm,linedatamultiloop,linedata,powerdata)
slosstong=0;
%Input dscat: danh sach cac nhanh se cat
%      Udm la dien ap dinh muc
%      linedata 
%      Powerdata
%Output nhanhcat:danhsach cac nhanh cat toi uu
%      sloss ton that khi cat cac nhanh
line=linedatamultiloop;
%xac dinh nut mot
for i=1:length(dscat)
    m=dscat(i)==line(:,1);
    line(m,:)=[];
end

A=1;
while A==1
    %Tim nut chi chua 1 nhanh
     G=adj(line);
     D=sum(G,1);
     nut1=find(D==1);
      m=nut1==1;
      if  sum(m)~=0
          nut1(m)=[];
      end
      n=nut1==nguon;
      if  sum(n)~=0
          nut1(n)=[];
      end
      %Tinh cong suat
      if isempty(nut1)==0
          %Tim duong di
          for i=1:length(nut1)
              nutrun=rmin(line,nguon,nut1(i));
              nut3=runstop(line,nut1(i));
              nut3=nut3(numel(nut3));
              m=nut3==nutrun;
              if sum(m)~=0
                 x=find(nut3==nutrun);
                 nutrun(x+1:length(nutrun))=[];
              end
              %tinh cong suat
              for b=1:length(nutrun)-1
                  [sloss1,powerdata]=Slossab(nutrun(b),nutrun(b+1),Udm,powerdata,linedata);
                   slosstong = slosstong + sloss1;
                   %%Tim nhanh
                   for k=1:size(line,1)
                       if (line(k,2)==nutrun(b) && line(k,3)==nutrun(b+1))||...
                          (line(k,3)==nutrun(b) && line(k,2)==nutrun(b+1))
                           line(k,:)=0;
                       end
                   end
                   %xoa nhanh da tinh
                   m=line(:,1)==0;
                   line(m,:)=[];
              end
          end
      else
          A=0;
      end
      if isempty(line)
          break
      end
end
powerdataout=powerdata;
end
    



