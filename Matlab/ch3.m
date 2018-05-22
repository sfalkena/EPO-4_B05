function [ hfil ] = ch3(y,x)
eps = 5;                      %threshold
Ny = length(y);
Nx = length(x);
Y = fft(y);
X = fft([x zeros(1,Ny-Nx)]);   %zero padding
H = Y./X;

indices = find(abs(H)<eps);
figure
plot(abs(H));
H(indices) = 0;
hfil = ifft(H);
figure
plot(hfil);

%G = zeros(Ny,1);
%G(abs(X)>eps)=1;                %implement threshold
%Hfil=H.*G;
%hfil= ifft(Hfil);               %inverse transformation
end