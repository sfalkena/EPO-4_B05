function [x_cor,y_cor] = Execute_TDOA()

load('audiodata_B5.mat');               %Load reference data
ref = RXXr(3,:,5);                  
ref = ref(2195:18196);

load('audiodata_B5_audio.mat');         %Load recording data

%Calculate impulse responses
h1=ch2(ref,RXXr(:,:,1)).^2;
h2=ch2(ref,RXXr(:,:,2)).^2;
h3=ch2(ref,RXXr(:,:,3)).^2;
h4=ch2(ref,RXXr(:,:,4)).^2;
h5=ch2(ref,RXXr(:,:,5)).^2;

r12 = TDOA(h1,h2,'r12');            %Relative distance from mic1
r13 = TDOA(h1,h3,'r13');
r14 = TDOA(h1,h4,'r14');
r15 = TDOA(h1,h5,'r15');
r23 = TDOA(h2,h3,'r23');
r24 = TDOA(h2,h4,'r24');
r34 = TDOA(h3,h4,'r34');
r25 = TDOA(h2,h5,'r25');
r35 = TDOA(h3,h5,'r35');
r45 = TDOA(h4,h5,'r45');

[x_cor,y_cor] = localisation5mic(r12,r13,r14,r15,r23,r24,r25,r34,r35,r45);  %Retrieve x and y coordinates
end