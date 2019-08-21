function G = ballmapper(X,epsilon)
%BALLMAPPER Ball mapper.
%   G = BALLMAPPER(X,epsilon) returns a ball mapper graph G.
%
%   Inputs:
%     X         - Point cloud (each row constitutes a point).
%     epsilon   - Radius parameter.
%
%   Output:
%     G         - Ball mapper graph.
%
%   Example:
%     load fisheriris
%     G = ballmapper(meas,0.5);
%     plot(G)
%
%   See also COLORBALLMAPPER.

%   References:
%     [1] P. Dlotko, "Ball mapper: a shape summary for topological data
%         analysis," arXiv:1901.07410v1 [math.AT].

%   Copyright 2019 Tak-Shing Chan

% Precompute Euclidean distances
d = squareform(pdist(X));

% Create initially empty cover vector B
B = cell(size(X,1),1);

while 1
    % Pick a first point p in X that is not covered
    p = find(cellfun('isempty',B),1);
    if isempty(p)
        break
    end

    % For every point x in B(p,epsilon) cap X, add p to B{x}
    for x = 1:size(X,1)
        if d(x,p)<epsilon
            B{x} = [B{x} p];
        end
    end
end

% V = cover elements in B, E = empty set
V = unique([B{:}]);
E = false(size(X,1));

% For every point p in X
for p = 1:size(X,1)
    % For every pair of cover elements c1 neq c2 in B{p}, E = E cup {c1,c2}
    for c1 = 1:length(B{p})-1
        for c2 = c1+1:length(B{p})
            E(B{p}(c1),B{p}(c2)) = 1;
        end
    end
end
G = graph(E(V,V),arrayfun(@num2str,V,'UniformOutput',0),'upper');
