function [G,C] = colorballmapper(X,y,epsilon)
%COLORBALLMAPPER Color ball mapper.
%   [G,C] = COLORBALLMAPPER(X,y,epsilon) returns a ball mapper graph G with
%   vertex colors C.
%
%   Inputs:
%     X         - Point cloud (each row constitutes a point).
%     y         - Colors of points (each row contains one color).
%     epsilon   - Radius parameter.
%
%   Output:
%     G         - Ball mapper graph.
%     C         - Vertex colors.
%
%   Example:
%     load fisheriris
%     y = cellfun(@(s) strcmp(s,'versicolor')+strcmp(s,'virginica')*2,species);
%     [G,C] = colorballmapper(meas,y,0.5);
%     h = plot(G);
%     h.NodeCData = C;
%
%   See also BALLMAPPER.

%   References:
%     [1] P. Dlotko, "Ball mapper: A shape summary for topological data
%         analysis," arXiv:1901.07410v1 [math.AT].
%     [2] G. Singh, F. Memoli, and G. Carlsson, "Topological methods for
%         the analysis of high dimensional data sets and 3D object
%         recognition," in Proc. Eurographics Symp. Point-Based Graphics,
%         2007, pp. 91-100.

%   Copyright 2019 Tak-Shing Chan

if ~iscolumn(y) || size(X,1)~=size(y,1)
    error('Input dimensions must agree.')
end

% Precompute Euclidean distances
d = squareform(pdist(X));

% Create initially empty cover vector B and neighborhood vector N
B = cell(size(X,1),1);
N = B;

while 1
    % Pick a first point p in X that is not covered
    p = find(cellfun('isempty',B),1);
    if isempty(p)
        break
    end

    % For every point x in B(p,epsilon) cap X, add p to B{x} and x to N{p}
    for x = 1:size(X,1)
        if d(x,p)<epsilon
            B{x} = [B{x} p];
            N{p} = [N{p} x];
        end
    end
end

% V = cover elements in B, E = empty set
G = graph;
G = addnode(G,arrayfun(@num2str,unique([B{:}]),'UniformOutput',0));

% For every point p in X
for p = 1:size(X,1)
    % For every pair of cover elements c1 neq c2 in B{p}, E = E cup {c1,c2}
    for c1 = 1:length(B{p})-1
        for c2 = c1+1:length(B{p})
            G = addedge(G,num2str(B{p}(c1)),num2str(B{p}(c2)));
        end
    end
end
G = simplify(G);

% For every vertex v in V, compute the average color of all elements in N{v}
C = cellfun(@(v) mean(y(N{str2num(v)})),table2cell(G.Nodes));
