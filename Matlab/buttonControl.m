%% directioncontrol: checks for keypress and sends commands
% Based on code by: Bas Verdoes (A1) - 23/04/2018
function buttonControl()

    dutyCycleDirection = 150;
    dutyCycleMotor     = 150;

    currentButton = 1;
    while(currentButton ~= 27) % Pressing escape stops the loop
        % Get keypress value
        pause(0.05)
        k = waitforbuttonpress;
        currentButton = double(get(gcf,'CurrentCharacter'));
        assignin('base','currentButton',currentButton)

        % Commands for each keypress
        switch currentButton
            case 32 % spacebar: PANIC button
                dutyCycleMotor = 150;
                dutyCycleDirection = 150;
        end

        % Send Commands
        commandDirection = ['D',int2str(dutyCycleDirection)];
        EPOCommunications('transmit',commandDirection);

        commandMotor = ['M',int2str(dutyCycleMotor)];
        EPOCommunications('transmit',commandMotor);

        % Print Commands in commandline
        disp(['D: ',num2str(dutyCycleDirection),'M: ',num2str(dutyCycleMotor)])
    end
    
end