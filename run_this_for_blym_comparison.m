% edit last line for different n,k
% optionally specify data range to view
% syntax (matlab/octave): blym_comp(n,k)
%                         blym_comp(n,k,[xmin,xmax,ymin,ymax])


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
function op = antichain_size(n,k,varargin)
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

% display range specified
if nargin == 3
lims = varargin{1};
axis(lims)
end

title(strcat('n = ',num2str(n),', k = ',num2str(k)));
ylabel('size of maximal antichains');
xlabel('number of k-sets')

%% output
op.marg = marg;
op.size = reshapemaximals(sizes,marg);
op.marg_lin = M;
op.size_lin = sizes;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function op = antichain_volume(n,k)
% get the volumes of antichains from the k and k-1 level of n
% each m-set contributes m to the volume
% nargin = 0;
%% defaults
if nargin == 0
    n = 5;
    k = 3;
end

nCk0 = nchoosek(n,k);
nCk1 = nchoosek(n,k-1);

%% get marginal volumes from marginal sizes
M = getmarginals(k,n-k); % returns choose(n-1,d-1)x(k+1) array
marg = []; % linear container for marginals
for i = 1:size(M,1)
    marg = [marg,M(i,:)]; %#ok<AGROW> 
end
marg = marg(~isnan(marg)); % remove NaNs

marg_vol = (k-1)*marg-1;
vol = nan(nCk0+1,1);
vol(1) = nCk1*(k-1);

for i = 1:length(marg)
    vol(i+1) = vol(i) - marg_vol(i);
end

%% plot
plt = plot(0:(length(marg)),vol);

% display range specified
if nargin == 3
lims = varargin{1};
axis(lims)
end

titl = strjoin({...
    'antichain volume for n = ',num2str(n),...
    ', k = ',num2str(k)});
title(titl)
legend("(k-1)*t_k^'-1",'location','north')
xlabel('number of k-sets in antichain')
ylabel('volume of antichain')


v_i = nCk1*(k-1);
v_m = min(vol);
v_f = nCk0*k;
x_m = find(vol==v_m,1);

% number of (k-1)-sets in min volume
num_lil = (v_m-(x_m-1)*k)/(k-1);

str = {...
    ['init volume = ',num2str(v_i)],...
    ['min volume = ',num2str(v_m),' = ',...
    num2str(x_m-1),'*k + ',num2str(num_lil),'*(k-1)'],...
    ['fin volume = ',num2str(v_f)],...
    ['gap = ',num2str(v_f-v_m)] };
text(0.25,0.7,str,'units','normalized')        

%% output
op.vol = vol;
op.marg = marg;
op.ax = gca;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function blym_comp(n,k,varargin)
% compare blym to size and volume

nCk0 = nchoosek(n,k);
nCk1 = nchoosek(n,k-1);

% get sizes and volumes
acs = antichain_size(n,k);
sizes = acs.size_lin;
acv = antichain_volume(n,k);
vols = acv.vol';

% normalize the sizes and volumes by their respective max
sn = sizes/max(sizes);
vn = vols/max(vols);

% numbers of k- and (k-1)-sets in antichains
numk = 0:nCk0;
numk1 = sizes - numk;

% portions of k- and (k-1)-sets in antichains
p0 = numk/nCk0;
p1 = numk1/nCk1;
p = p0 + p1;

% plot
clf, hold on
plot(p,'ko')
plot(sn,'r+')
plot(vn,'bx')

% display range specified
if nargin == 3
lims = varargin{1};
axis(lims)
end

legend({'blym','size (norm)','vol (norm)'},'Location','north')
title(strcat('blym and normalized size,volume for n = ',num2str(n),', k = ',num2str(k)));

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

blym_comp(12,7);
