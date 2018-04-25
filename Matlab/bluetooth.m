%status = EPOCommunications('close'); % close connection
%comport = '\\.\COM4';
%result = EPOCommunications('open',comport); % open connection
%status = EPOCommunications('transmit','S'); % request status string



currentButton = 1;

while(currentButton ~= 27) % Pressing escape stops the loop

        EPOCommunications('transmit','D150'); % direction command
        EPOCommunications('transmit','M160'); % motor speed command
        status = EPOCommunications('transmit','S') % request status string
        k = waitforbuttonpress;
        currentButton = double(get(gcf,'CurrentCharacter'));
end

EPOCommunications('transmit','M150'); % motor speed command

EPOCommunications('transmit', 'A0'); % switch off audio beacon
%EPOCommunications('transmit', 'A1'); % switch on audio beacon
EPOCommunications('transmit', 'B5000'); % set the bit frequency
EPOCommunications('transmit', 'F15000'); % set the carrier frequency
EPOCommunications('transmit', 'R2500'); % set the repetition count
EPOCommunications('transmit', 'C0xaa55aa55'); % set the audio code

