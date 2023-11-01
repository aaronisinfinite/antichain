function op = allksets(n_or_set,varargin)
% return all k-sets in squashed order from n-set
% input should be an integer or a set of integers/symbols
% if only one argument given, returns power set in squashed order
% if two arguments given, returns only subsets of given size

if length(n_or_set) == 1 % input is an integer N and the set is 1,2,...N
    symb = 1:n_or_set;
else % input is a set of symbols
    symb = n_or_set;
end
n = length(symb); % how many symbols

P = cell(1,n+1); % container for subsets of symb
P{1} = {[]}; % empty set
for i = 1:n
  % get all length i subsets
  P{i + 1} = num2cell(nchoosek(symb, i), 2);
end
P = cat(1, P{:});

% to each set assign a sort value to force squashed order
for i = 1:2^n
    S(i) = length(P{i}) * 2^(n+1) + sum(2.^P{i});
end
[~,ind] = sort(S);
P = P(ind); % power set of {1,...,n} in squashed order

% output
if nargin == 1 % return power set of {1,...,n} in squashed orer
    op.P = P;
elseif nargin == 2 % return only k-sets of {1,...,n} in squashed order
    k = varargin{1};

    % get index of first k-set
    ind = 0;
    for i = 0:k-1
        ind = ind + nchoosek(n,i);
    end
    ind = ind+1;
    op.P = P(ind:ind+nchoosek(n,k)-1);
end

op.S = S;

end