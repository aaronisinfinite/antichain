%% change the very last line for different n,k
%% syntax: antichain_volume(n,k)

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
plot(0:(length(marg)),vol), hold off
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
% op.vol = vol2;
% op.marg = A.marg;
% op.marg_vol = -reshapemaximals(marg_vol2,A.marg);
end
