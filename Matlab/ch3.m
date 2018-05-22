function [ hfil ] = ch3(y,x)
eps = 0.001;                      %threshold
Ny = length(y);
Nx = length(x);
Y = fft(y);
X = fft([x zeros(1,Ny-Nx)]);   %zero padding
H = Y./X;
hfil = ifft(H);
figure
plot(hfil);

%G = zeros(Ny,1);
%G(abs(X)>eps)=1;                %implement threshold
%Hfil=H.*G;
%hfil= ifft(Hfil);               %inverse transformation
end