function [  ] = main(  )
%
% Hello, I am trying to find all "possible" paths between two nodes, 
% in an n*n matrix, where n is the number of nodes. 

% Basically, 
% I have this matrix (n*n) which defines a connection between nodes if its value is non zero (the value represents the weight of the edge) , and there isn't a connection if the value is zero. 
% The restriction of making a path "possible": 
% 1) the nodes have to be connected. 
% 2) in each path, a node must not be visited more than once. 
% 3) in each path, an edge must not be visited more than once. 
% 4) the number of hops in the path must be less or equal to (n-1)
% Finally I would store all the possible paths in another matrix(num of possible path *n) where it would have its row representing the paths, and if path has number of hops less than (n-1) the rest of the row would be zeros

    A= [
           0         0         0   52.6751   57.8655   96.4418         0   94.5074   90.5029  104.3699
           0         0   49.8587         0   85.2586   84.3756         0   59.4121         0         0
           0   49.8587         0         0   90.3530  119.4477         0   50.8899         0         0
     52.6751         0         0         0   97.6427  104.8545         0         0  117.1408   54.3737
     57.8655   85.2586   90.3530   97.6427         0   64.1560         0   39.7898         0         0
     96.4418   84.3756  119.4477  104.8545   64.1560         0         0   83.9832         0         0
           0         0         0         0         0         0         0         0  108.7307         0
     94.5074   59.4121   50.8899         0   39.7898   83.9832         0         0         0         0
     90.5029         0         0  117.1408         0         0  108.7307         0         0         0
    104.3699         0         0   54.3737         0         0         0         0         0         0
    ];

    g = digraph(A);
    n = numnodes(g);
    D = distances(g, 'Method', 'unweighted');
    hasPath = isfinite(D);
    [src, tgt] = find(hasPath);
    Paths = zeros(length(src), n);
    for i=1:length(src)
        p = shortestpath(g, src(i), tgt(i), 'Method', 'unweighted');
        Paths(i, 1:length(p)) = p;
    end

end

