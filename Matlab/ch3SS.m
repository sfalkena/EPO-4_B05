function[h,X]=ch3SS(x,y)
Ny = length(y); 
Nx = length(x); 
L = Ny - Nx + 1;
Y = fft(y);
X = fft([x; zeros((Ny - Nx),1)]); % zero padding to length Ny
ii = find(abs(X) > 0.05);
H = Y ./ X; % frequency domain deconvolution
G = zeros(1,Ny);
G(ii) = 1;
g=ifft(G);
H = G.*H;
h = ifft(H);
%h = h(1:L);
end
% truncate h to length L
% make the sequence real if necessary