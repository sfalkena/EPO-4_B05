load('audiodata_B5.mat');           %Load reference data
ref = RXXr(3,:,5);                  
ref = ref(2195:18196);

Audio_Settings;                     %Set parameters and turn on audio beacon

for i=1:19
    EPO4_audio_record('B5_1', 15000,7500,2500,'ebeb9a61',48e3,5,1,3);   %Records and saves recording in audiodata_B5_1
    [x_cor,y_cor] = Execute_TDOA;
    delete audiodata_B5_1.mat                                           %Deletes file to prevent multiple files with same name
    pause(5);
end