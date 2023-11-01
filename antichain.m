function op = antichain(n,k)
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
plot(0:length(sizes)-1,sizes,'-o','MarkerSize',2)
% plot(0:length(sizes)-1,max(sizes)-sizes,'-o','MarkerSize',2)

title(strcat('n = ',num2str(n),', k = ',num2str(k)));
ylabel('size of maximal antichains');
xlabel('number of k-sets')

%% output
op.marg = marg;
op.size = reshapemaximals(sizes,marg);
op.marg_lin = M;
op.size_lin = sizes;

end
