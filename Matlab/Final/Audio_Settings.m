%Set audio parameters
%comport = '\\.\COM5';
%EPOCommunications('open',comport)           %Open comport
EPOCommunications('transmit','B7500');      %Set bit frequency 7.5 kHz
EPOCommunications('transmit','C0xebeb9a61')  %Set 32 bit code word
EPOCommunications('transmit','F15000');     %Set carrier frequency 15 kHz
EPOCommunications('transmit','R2500');        %Set repitition counter 750 Hz
EPOCommunications('transmit','A1');         %Turn on audio beacon
