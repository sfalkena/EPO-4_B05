%Script of EPO-4, projectgroup B-05
%Sander Delfos, Sumeet Sharma, Sieger Falkena, Ivor Bas, Emiel van Veldhuijzen
%June 2018

%File to setup the audio settings of computer and initialize asio drivers
setpref('dsp','portaudioHostApi',3);
pause(2)
pa_wavrecord(1,1,20*8000) ;

