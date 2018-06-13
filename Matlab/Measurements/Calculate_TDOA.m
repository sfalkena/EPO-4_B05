%%%%%%%%%%%%%%%%%
function [ Npeak ] = Calculate_TDOA(y2,y1)
Fs = 48000;                     %Sampling frequency
v = 34300;                      %Speed of sound in air [cm/s]

h = ch3(y2,y1);                 %Find channel response
hnew = h(1:4999);               %Remove later peaks
[~,Npeak] = max(hnew);          %Find location peak [samples]
end
