function[h]=ch2(x,y)
Ny = length(y); 
Nx = length(x); 
x = x(:);
y = y(:);
L = Ny - Nx + 1;
xr = flipud(x); % reverse the sequence x (assuming a col vector)
h = filter(xr,1,y); % matched filtering
alpha = x'*x; % estimate scale
h = h/alpha; % scale down
end