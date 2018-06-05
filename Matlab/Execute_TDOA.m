%%%%%%%%%%%%%%%%%%
Fs = 48000;                         %Sampling frequency [Hz]
v = 34300;                          %Speed of sounds in air [cm/s]

load('audiodata_B5_1.mat');         %Load reference data
a = RXXr(6,:,:);                    %Measurement at location a (for testing)
b = RXXr(7,:,:);                    %Measurement at location b (for testing)
c = RXXr(8,:,:);                    %Measurement at location c (for testing)
m = RXXr(9,:,:);                    %Measurement at location m (for testing)
y_ref = RXXr(2,:,2);                %Select recording at mic2 as reference

%get_rec();                         %Record the audio signal and store it in RXXr 

yr1 = a(:,:,1);                  %Recording at mic1                     
yr2 = a(:,:,2);                  %Recording at mic2
yr3 = a(:,:,3);                  %Recording at mic3
yr4 = a(:,:,4);                  %Recording at mic4
yr5 = a(:,:,5);                  %Recording at mic5 (not used)

d1 = Calculate_TDOA(yr1,y_ref);     %Relative distance from mic1
d2 = Calculate_TDOA(yr2,y_ref);     %Relative distance from mic2
d3 = Calculate_TDOA(yr3,y_ref);     %Relative distance from mic3
d4 = Calculate_TDOA(yr4,y_ref);     %Relative distance from mic4

r12 = (d1-d2)/Fs *v;
r13 = (d1-d3)/Fs *v;
r14 = (d1-d4)/Fs *v;
r23 = (d2-d3)/Fs *v;
r24 = (d2-d4)/Fs *v;
r34 = (d3-d4)/Fs *v;
[x_cor,y_cor] = localization(r12,r13,r14,r23,r24,r34)  %Retrieve x and y coordinates
