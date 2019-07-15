function [linedatacat, matran, nhanh] = cutmatrix(linedatamultiloop, linedata)

% Xac dinh ma tran cat tren luoi thuc
matran = multicutlist(linedatamultiloop);
%Rut gon vong kep
[linedatacat, nhanh] = rutgon(linedatamultiloop, linedata);
for i = 1:length(nhanh)
    if isempty(nhanh{i}) == 0
       m = nhanh{i}(1) == matran(:,1);
       matran(m,1) = i;
       for j = 2:length(nhanh{i})
           n = nhanh{i}(j) == matran(:,1);
           matran(n,:) = [];
       end
    end
end
end