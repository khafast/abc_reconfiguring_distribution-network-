function danhsachcat=danhsachcat(linedata)

%%Tim khu vuc cat hinh tia 

%%Rut gon luoi dien
[luoi,nhanhthay]=rutgon(matranke(linedata));

%%Loc tia luoi da rut gon
locluoirutgon=loctia(luoi);

%%Tim nhanh cat phu hop tren luoi da rut gon va loc tia
DSC=[]; %%Tao danh sach nhanh cat phu hop
luoithu=locluoirutgon;
for i=1:2^(size(locluoirutgon,1)-1)
    Bin=dec2bin(i);
    Binstr=num2str(Bin);
    
    
    for j=1:length(Binstr)
        
        %%Cat nhanh theo thu tu
        if str2num(Binstr(j))==0
           luoithu(j+1,2:size(luoithu,2))=0;
        end
        
      %%Kiem tra lai dieu khien hinh tia va lien ket den nguon
      
        %%Dieu kien hinh tia
        loctialuoithu=loctia(luoithu);
        loctialuoithu(1,:)=[];
        
        %%Dieu kien tat ca cac nut lien ket nut nguon
        n=dfsearch(graph(creatgraph(mat2line(luoithu))));
        n=n'; %%Chuyen co thanh hang
        
        %%Tim nut khong lien ket voi nut nguon
        dk=0;
        for k=1:size(luoithu,2)-1
            m=luoithu(1,k+1)==n;
            if m==0
               dk=1;
               break
            end
        end
    end
end
        
        %%Tong hop lai dieu kien
        if loctialuoithu == [] &&...
           dk==0
           DSC(length(DSC)+1)=i;
        end
        
        %%Thay the nhanh rut gon bang nhanh that
        danhsachcat=[];
        for i=1:length(DSC)
            Bin=dec2bin(i);
            Binstr=num2str(Bin);  
            catthu=[];
            for j=1:length(Binstr)
                if Binstr(j)==0
                   catthu(length(catthu)+1)=locluoirutgon(j+1);
                   danhsachcat=[danhsachcat; catthu];
                end
            end
        end
end

