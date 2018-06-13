Audio_Settings;                     %Set parameters and turn on audio beacon
i=0;
for i=1:6
    RXXr = EPO4_audio_record('B5_audio', 15000,7500,2500,'ebeb9a61',48e3,5,1,3);   %Records and saves recording in audiodata_B5_1
    [x_cor(i),y_cor(i)] = Testfile(RXXr)                                          %Deletes file to prevent multiple files with same name
    
end