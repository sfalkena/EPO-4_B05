%Script of EPO-4, projectgroup B-05
%Sander Delfos, Sumeet Sharma, Sieger Falkena, Ivor Bas, Emiel van Veldhuijzen
%June 2018

%Set audio parameters
EPOCommunications('transmit','B7500');       %Set bit frequency 7.5 kHz
EPOCommunications('transmit','C0xebeb9a61')  %Set 32 bit code word
EPOCommunications('transmit','F15000');      %Set carrier frequency 15 kHz
EPOCommunications('transmit','R2500');       %Set repitition counter 2500 
EPOCommunications('transmit','A1');          %Turn on audio beacon
