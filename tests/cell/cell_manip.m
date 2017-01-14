a = struct();
a.car = 'ferrari';
a.house = 'mansion';

b = struct();
b.car = 'tesla';
b.house = 'condo';

c = {a b}

% Attempt to convert cell array of struct to list of struct (which matlab calles
% a struct array)

% Pre-allocate 
d = repmat(c{1}, length(c), 1)
for n = 1:length(c)
    d(n) = c{n};
end

d