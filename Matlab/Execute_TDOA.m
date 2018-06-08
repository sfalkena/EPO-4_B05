%%%%%%%%%%%%%%%%%%
Fs = 48000;                         %Sampling frequency [Hz]
load('audiodata_B5_1.mat');         %Load reference data
a=6; b=7; c=8; m=9;                  %different measurements from B5_1
load 'ref.mat';                     %Load reference data

%create axes for plots
freq_y = fftshift(fft(RXXr(:,:,1)));
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

l=a; %choose measurement point
%calculate impulse responses
h1=ch2(ref,RXXr(l,:,1)).^2;
h2=ch2(ref,RXXr(l,:,2)).^2;
h3=ch2(ref,RXXr(l,:,3)).^2;
h4=ch2(ref,RXXr(l,:,4)).^2;
h5=ch2(ref,RXXr(l,:,5)).^2;

% figure
% hold on
% plot(t_1,h1)
% plot(t_1,h2)
% title('Channels')
% xlabel('Time(s)')
% ylabel('Amplitude')

r12 = Calculate_TDOA(h1,h2);        %Relative distance from mic1
r13 = Calculate_TDOA(h1,h3);
r14 = Calculate_TDOA(h1,h4);
r15 = Calculate_TDOA(h1,h5);
r23 = Calculate_TDOA(h2,h3);
r24 = Calculate_TDOA(h2,h4);
r25 = Calculate_TDOA(h2,h5);
r34 = Calculate_TDOA(h3,h4);
r35 = Calculate_TDOA(h3,h5);
r45 = Calculate_TDOA(h4,h5);

[x_cor,y_cor,z_cor] = localization(r12,r13,r14,r15,r23,r24,r25,r34,r35,r45)  %Retrieve x and y coordinates
