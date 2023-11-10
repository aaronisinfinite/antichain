% edit last line for different n,k
% optionally specify data range to view
% syntax (matlab/octave): antichain(n,k)
%                         antichain(n,k,[xmin,xmax,ymin,ymax])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function op = getmarginals(k,d)
% get the marginal changes in size of maximal antichain
% as a result of increasing number of symbols

if d<1
    warning('d < 1')
    return
end

if d == 1
    op = k-1 - (0:k);
else
    % choose(k+d-1,d-1) is num rows for T(k,d)
    op = nan(nchoosek(k+d-1,d-1) , k+1);
    for i=0:k
        temp = getmarginals(k-i,d-1); % recursive call
        row = find(isnan(op(:,1)),1); % first empty row
        sz = size(temp); % how much of op being written
        op(row:row+sz(1)-1,1:sz(2)) = temp;
    end
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function op = reshapemaximals(sizes,marg)
% reshape sizes to right-aligned format of marg, building from bottom up

szm = size(marg);
op = nan(szm); % initialize container
j2 = length(sizes); % initial slice end index
for i = szm(1):-1:1
    j1 = find(~isnan(marg(i,:)),1,'last'); % slice start index
    op(i,1:j1) = sizes(j2-j1+1:j2); % row by row
    j2 = j2-j1; % update slice end index;
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function op = antichain(n,k,varargin)
% plot size of maximal antichain on n symbols as function of # of k-sets

%% default
if nargin == 0
    n = 20;
    k = 11;
end

%% get the marginal changes
d = n-k; % dimension
marg = getmarginals(k,d); % returns choose(n-1,d-1)x(k+1) array

%% get the maximal sizes
M = []; % linear container for marginals
% list all marginals in a single row
for i = 1:size(marg,1)
    M = [M,marg(i,:)]; %#ok<AGROW> 
end
M = M(~isnan(M)); % remove NaNs
sizes = nan(1,length(M)+1); % container for maximal sizes
sizes(1) = nchoosek(n,k-1); % s0

% compute each size
for i = 1:length(M)
    sizes(i+1) = sizes(i) - M(i);
end

%% plot
plot(0:length(sizes)-1,sizes)%,'.','MarkerSize',2)
% plot(0:length(sizes)-1,max(sizes)-sizes,'-o','MarkerSize',2)

% display range specified
if nargin == 3
lims = varargin{1};
axis(lims)
end

title(strcat('antichain size for n = ',num2str(n),', k = ',num2str(k)));
ylabel('size of maximal antichains');
xlabel('number of k-sets')

%% output
op.marg = marg;
op.size = reshapemaximals(sizes,marg);
op.marg_lin = M;
op.size_lin = sizes;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

antichain(16,9);
