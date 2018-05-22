function [ x_estimated ] = Calculate_TDOA(y2,y1)
Fs = 48000;                     %sampling frequency
v = 34300;                      %speed of sound in air [m/s]
t = [0:1/Fs:(14400-1)/Fs];      %time axis

h = ch3(y2,y1);                 %find channel response
%[~,Npeak] = max(h);             %find location peak [samples]
[ pks, locs ] = findpeaks(h);
Npeak = locs(1);
tpeak = Npeak/Fs;               %find location peak [seconds]
x_estimated = tpeak*v;          %find distance between mics [m]
end
