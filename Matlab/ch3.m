function [ hfil ] = ch3(y,x)
%Ch3 algorithm based on EET11 labs
Ny = length(y);
Nx = length(x);
Y = fft(y);
X = fft([x zeros(1,Ny-Nx)]);                 %zero padding
H = Y./X;
eps = 0.01*max(abs(X));                      %threshold (to prevent division by 0) = 0.01

indices = find(abs(X)<eps);
H(indices) = 0;
hfil = ifft(H);
end