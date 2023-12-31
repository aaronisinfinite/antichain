% edit the last line for different n,k
% optionall specify data range to view
% syntax (matlab/octave): antichain_volume(n,k)
%                         antichain_volume(n,k,[xmin xmax ymin ymax])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function op = antichain_volume(n,k,varargin)
% get the volumes of antichains from the k and k-1 level of n
% each m-set contributes m to the volume
% nargin = 0;
%% defaults
if nargin == 0
    n = 12;
    k = 7;
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
titl = strjoin({...
    'antichain volume for n = ',num2str(n),...
    ', k = ',num2str(k)});
title(titl)
legend("(k-1)*t_k^'-1",'location','north')
xlabel('number of k-sets in antichain')
ylabel('volume of antichain')

% display range specified
if nargin == 3
lims = varargin{1};
axis(lims)
end

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

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
antichain_volume(12,7);
