%Script of EPO-4, projectgroup B-05
%Sander Delfos, Sumeet Sharma, Sieger Falkena, Ivor Bas, Emiel van Veldhuijzen
%June 2018

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