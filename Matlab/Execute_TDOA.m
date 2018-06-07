%%%%%%%%%%%%%%%%%%
Fs = 48000;                         %Sampling frequency [Hz]
load('audiodata_B5_1.mat');         %Load reference data
a=6; b=7; c=8; m=9;                  %different measurements from B5_1
load 'ref.mat';                     %Load reference data

%create axes for plots
freq_y = fftshift(fft(RXXr(t,:,1)));
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

t=a; %choose measurement point
%calculate impulse responses
h1=ch3(ref,RXXr(t,:,1));
h2=ch3(ref,RXXr(t,:,2));
h3=ch3(ref,RXXr(t,:,3));
h4=ch3(ref,RXXr(t,:,4));
h5=ch3(ref,RXXr(t,:,5));

% figure
% hold on
% plot(t_1,h1)
% plot(t_1,h2)
% title('Channels')
% xlabel('Time(s)')
% ylabel('Amplitude')

r12 = TDOA(h1,h2,'r12');        %Relative distance from mic1
r13 = TDOA(h1,h3,'r13');
r14 = TDOA(h1,h4,'r14');
r23 = TDOA(h2,h3,'r23');
r24 = TDOA(h2,h4,'r24');
r34 = TDOA(h3,h4,'r34');

[x_cor,y_cor] = localization(r12,r13,r14,r23,r24,r34)  %Retrieve x and y coordinates
