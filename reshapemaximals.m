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
