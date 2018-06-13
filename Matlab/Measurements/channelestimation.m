% Code written by:
% - Sander Delfos : 4317262
% - Sieger Falkena: 4293681
clear all
load('audiodata_B5_1.mat'); 
load('ref.mat')
Fs=44100;
freq_y = fftshift(fft(RXXr(6,:,1)));
freq_x = fftshift(fft(ref));
N=length(freq_x);
Omega = pi*[-1: 2/N : 1-1/N];
F=(Omega*Fs)/(2*pi);
t=linspace(0,(N/Fs),N);
t=transpose(t);

N_1=length(freq_y);
Omega_1 = pi*[-1: 2/N_1 : 1-1/N_1];
F_1=(Omega_1*Fs)/(2*pi);
t_1=linspace(0,(N_1/Fs),N_1);
t_1=transpose(t_1);
h1=ch3(ref,RXXr(6,:,1));
h2=ch3(ref,RXXr(6,:,2));

figure
hold on
plot(t_1,h1)
plot(t_1,h2)
title('Channels')
xlabel('Time(s)')
ylabel('Amplitude')

[Tijd, Afstand]=TDOA(h1,h2)
