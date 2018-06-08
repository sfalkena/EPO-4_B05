%%%%%%%%%%%%%%%%%%
Fs = 48000;                         %Sampling frequency [Hz]
v = 34300;                          %Speed of sounds in air [cm/s]

load('audiodata_B5_1.mat');         %Load reference data
a = RXXr(6,:,:);                    %Measurement at location a (for testing)
b = RXXr(7,:,:);                    %Measurement at location b (for testing)
c = RXXr(8,:,:);                    %Measurement at location c (for testing)
m = RXXr(9,:,:);                    %Measurement at location m (for testing)

load('audiodata_B5_2.mat');         %Load reference data
y_ref = RXXr(2,:,5);                %Select recording at mic2 as reference

%get_rec();                         %Record the audio signal and store it in RXXr 

yr1 = m(:,:,1);                  %Recording at mic1                     
yr2 = m(:,:,2);                  %Recording at mic2
yr3 = m(:,:,3);                  %Recording at mic3
yr4 = m(:,:,4);                  %Recording at mic4
yr5 = m(:,:,5);                  %Recording at mic5 (not used)

%Real distance from mics
d1s = Calculate_TDOA(yr1,y_ref);     %Relative distance from mic1
d2s = Calculate_TDOA(yr2,y_ref);     %Relative distance from mic2
d3s = Calculate_TDOA(yr3,y_ref);     %Relative distance from mic3
d4s = Calculate_TDOA(yr4,y_ref);     %Relative distance from mic4
d5s = Calculate_TDOA(yr5,y_ref);     %Relative distance from mic5



%Relative distances
r12 = (d1s-d2s)/Fs *v;
r13 = (d1s-d3s)/Fs *v;
r14 = (d1s-d4s)/Fs *v;
r15 = (d1s-d5s)/Fs *v;
r23 = (d2s-d3s)/Fs *v;
r24 = (d2s-d4s)/Fs *v;
r25 = (d2s-d5s)/Fs *v;
r34 = (d3s-d4s)/Fs *v;
r35 = (d3s-d5s)/Fs *v;
r45 = (d4s-d5s)/Fs *v;


[x_cor,y_cor,z_cor] = localization(r12,r13,r14,r15,r23,r24,r25,r34,r35,r45)  %Retrieve xyz coordinates of the car
