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
