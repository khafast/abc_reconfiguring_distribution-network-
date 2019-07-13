function indeloop=indeloop(linedata)
% Tim cac nhanh thuoc cac vong doc lap
%%nutmax
nutmax=max(max(linedata(:,2:3)));

%%Chhuyen linedata ra ma tran ke;
G=adj(linedata);

%%Tim cac vong co ban
H=cyclebasis(G);

%%Liet ke cac vong 
hang=(1:nutmax)';
cot=(0:nutmax);
for i=1:length(H)
    H{i}=[hang, H{i}];
    H{i}=[cot;H{i}];
    
    % Tim nhanh rong va xoa
    for r=2:size(H{i},1)
        S=sum(H{i}(r,2:size(H{i},2)));
        if S==0
            H{i}(r,1)=0;
        end
    end
    m=H{i}(:,1)==0;
    m(1)=0;
    H{i}(m,:)=[];
    
    %Tim nut rong va xoa
    for r=1:size(H{i},2)
        S=sum(H{i}(2:size(H{i},1),r),2);
        if S==0
            H{i}(1,r)=0;
        end
    end
    m=H{i}(1,:)==0;
    m(1)=0;
    H{i}(:,m)=[];
    
    % Tong hop lai cac vong
    vong=[];
    for p=2:size(H{i},1)-1
        for q=p:size(H{i},2)
            if H{i}(p,q)==1
               nut1=H{i}(p,1);
               nut2=H{i}(1,q);
               for r=1:size(linedata,1)
                   if (linedata(r,2)==nut1 && linedata(r,3)==nut2) ||...
                      (linedata(r,3)==nut1 && linedata(r,2)==nut2)
                       vong(1,size(vong,2)+1)=linedata(r,1);
                   end
               end
            end
        end
    end  
    loop{i}=vong;
    loopsave{i}=vong;
end

%%Kiem tra vong doc lap
% Tim vong co so nhanh nhieu nhat de tao matran chua cac nhanh
maxmang=0;
for i=1:length(loop)
    if maxmang<=numel(loop{i})
       maxmang=numel(loop{i});
    end
end

% Chuyen tu mang te bao sang ma tran de de tinh toan
mang=zeros(length(loop),maxmang);
for i=1:length(loop)
    for j=1:length(loop{i})
        mang(i,j)=loop{i}(j);
    end
end

% Xac dinh vong nao thuoc vong doc lap
nhanhlienhop=ones(size(mang,1),1);
for i=1:size(linedata,1)
    m=linedata(i,1)==mang;
    if sum(sum(m,1),2)>1
        D=sum(m,2);
        n=D~=0;
        nhanhlienhop(n)=0;
    end
end

%Ghi lai cac vong doc lap
indeloop=[];
for i=1:length(nhanhlienhop)
    if nhanhlienhop(i)==1
        indeloop=[indeloop;mang(i,:)];
    end
end
end

function adj=adj(linedata)

%%Tim nut lon nhat
nutmax=max(max(linedata(:,2:3)));

%%tao ma tran ke adj
adj=zeros(nutmax);
for i=1:size(linedata,1)
    adj(linedata(i,2),linedata(i,3))=1;
    adj(linedata(i,3),linedata(i,2))=1;
end
end

function y=cyclebasis(G,form)

% set default value of form, if necessary
if (nargin<2) || isempty(form),
  form = 'adj';
end;

% determine form of G for output
spout = issparse(G);

% ensure that G is logicals
G = (G~=0);
  
% symmetrize G
if ~isequal(G,G'),
  G = (G+G')>0;
end;


% find the spanning forest of G and the remaining edges
[F,E] = spanforest(G);

% count the number of edges in the graphs in E (including loops)
ny = sum(cellfun(@(x)sum(sum(x+x.*eye(size(x))))/2,E));
y = cell(1,ny);

% for each edge in E, add it to a tree in F and remove the leaves
k=1;
for i=1:numel(F),
  thisE = E{i};
  [ei,ej] = find(thisE,1,'first');
  while ~isempty(ei),
    thisE(ei,ej)=0;
    thisE(ej,ei)=0;
    thisF = F{i};
    thisF(ei,ej) = 1;
    thisF(ej,ei) = 1;
    y{k} = removeleaves(thisF);
    k = k+1;
    [ei,ej] = find(thisE,1,'first');
  end; % while ~isempty(ei),
end; % for i=1:numel(F),

if isequal(form,'path'),
  % convert all fundamental cycles to path form
  for k=1:numel(y),
    y{k} = adj2path(y{k});
  end;
elseif spout,
  for k=1:numel(y),
    y{k} = sparse(y{k});
  end;
end;

end % main function cyclebasis(...)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function H=removeleaves(G)
% removes all leaves of a graph

H = G+G.*eye(size(G)); % count loops twice
i = find(sum(H)==1); % all vertices that are on a single edge
while ~isempty(i),
  H(i,:) = 0;
  H(:,i) = 0;
  i = find(sum(H)==1);
end;

H = (H~=0);

end % helper function removeleaves(...)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function L=adj2path(G)
% converts the adjacency matrix of a cycle to a path
% (warning: no error checking done to ensure G is a single cycle!)
if all(G(:)==0),
  L = [];
else
  L = zeros(1,sum(sum(G+G.*eye(size(G))))/2); % counts number of vertices
  if any(~ismember(sum(G+G.*eye(size(G))),[0,2])),
    error('G cannot be a cycle because degrees not all equal 0 or 2');
  end;
  [i,j] = find(G,1,'first');
  n = size(G,2);
  L(1)=j;
  i = 0;
  for k=2:numel(L),
    % find the next vertex adjacent to j that does not equal previous
    nextj = find(G(j,:)&((1:n)~=i),1,'first');
    i = j;
    j = nextj;
    L(k) = j;
  end;
end; % if all(G(:)==0), ... else ...

end % helper function adj2path(...)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [F,E]=spanforest(G)
% determines the spanning forest of G (since may need more than one tree)
% and also the leftover edges.  F is a cell array of adjacency matrices of
% spanning trees, one per disjoint component of G.  E is a cell array of
% adjacency matrices of the complement of the spanning tree wrt the
% corresponding component of G.

F = {};
E = {};

if ~isempty(G),
  spanned = zeros(1,size(G,2)); % vertices which have been spanned

  thisF = zeros(size(G)); % current F
  thisE = zeros(size(G)); % current E
  thisv = 1; % vertices of the spanning tree eligible to expand upon
  spanned(thisv)=1;

  while ~isempty(thisv),
    nextv = [];
    for i=thisv,
      % find nodes to extend the spanning tree
      testleaf = find(G(i,:));
      for j=testleaf,
        if (spanned(j)==1),
          % (i,j) will make tree a loop, so add it to E if it's not in F
          if thisF(i,j)==0,
            thisE(i,j)=1;
            thisE(j,i)=1;
          end;
        else
          % add (i,j) to spanning tree and add j to leaves to test next
          thisF(i,j)=1;
          thisF(j,i)=1;
          spanned(j)=1;
          nextv(end+1)=j;
        end;
      end;
    end;
    thisv = nextv; % update the list of nodes to test next
    if isempty(thisv),
      % no new nodes to test: have a component to add to F & E
      % add it even if it was empty (could have had an isolated self-loop)
      F{end+1} = thisF;
      E{end+1} = thisE;
      thisF = zeros(size(G));
      thisE = zeros(size(G));
      thisv = find(~spanned,1,'first'); % start off a new component
      spanned(thisv)=1;
    end;
  end; % while ~isempty(thisv),
end; % if ~isempty(G),

end % helper function spanforest(...)



