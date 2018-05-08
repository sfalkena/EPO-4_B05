% Script written by Sander Delfos
%
% This script should stop at any given distanceFromWall before the wall.
% When KITT is not connected, the variable simulation can be set to value 1, this
% will give random values for the time driven and the distance measured to
% the wall to simulate the workings of the script.


run curvesSander.m

%SETTINGS:
distanceFromWall = 1;                                       % set to desired stopping distance from wall
simulation = 0;                                             % make 1 for simulation, 0 for normal operation
brakeLengthCompensation = 1;                                % compensation for braking length (positive for earlier braking)
brakeDurationDelay = 0.3;                                   % set how much less time braking (positve for less braking)
minimumBrakeLength = 1;                                     % set a minumum for brake length to avoid crashes
N=4;                                                        % increase value to get more measurements


%accelerate to full speed
if (simulation == 1)
    tic
    randomTime = 2*rand(1);
    pause(randomTime)                                       %simulate driving for random amount of seconds before 'measurement'
else
    EPOCommunications('transmit','M165');
    tic
end

% result = 0;
% while(result == 0)
%     %wait for good measurement
%     [result, d, error] = checkMeasurementSander(simulation);
% end

%
% if (error == 1)
%     fprintf('ERROR: KITT was about to crash!')
%     return
% end


brakeLength = zeros(1,N);                                   %initialize matrix for MORE SPEEDDDD
for i = 1:N                                                 %get N measurements for brakeLength
    [d_l, d_r] = checkDistance();                           %get sensor data
    measuredDistance = max(d_l, d_r)/100;                   %take max so that glitches don't matter & convert to meters
    index1 = find(t_acc>toc);                               %find index of driven distance in curve
    distanceDriven = d_acc(index1(1));                      %find distance that has been traveled already
    distanceToDrive = measuredDistance + distanceDriven - distanceFromWall;     %determine distance that needs to be traveled in total
    d_acc = d_acc - distanceDriven;                         %shift acceleration curve to compensate for initial velocity
    d_dec = d_dec + distanceToDrive;                        %shift deceleration curve
    % figure
    % hold on
    % plot(d_acc, v_acc)
    % plot(d_dec, v_dec)
    % ylim([0,3])
    % xlim([0,distanceToDrive])
    [brake_point,brake_speed] = polyxpoly(d_acc, v_acc, d_dec, v_dec); %determine the point where the car should fully brake
    % scatter(brake_point,brake_speed)                      %plot switching point
    index2 = find(v_acc>brake_speed);                       %find corresponding index for the speed when starting to brake
    %brake_time = t_acc(index2(1));                         %find corresponding index for time when starting to brake
    index3 = find(v_dec < v_acc(index2(1)));                %find index for brake point in deceleration curve
    index4 = find(v_dec < 0.01);                            %find index for when speed is zero in deceleration curve
    brake_duration = t(index4(1))-t(index3(1));             %find how long KITT needs to brake
    brakeLength(1,i) = d_dec(index4(1))-d_dec(index3(1));   %find distance from wall when KITT needs to start braking
end

brakeLength = sort(brakeLength);                            %sort the values from small to large
delete = fix(N/4);                                          
brakeLength = brakeLength(delete:end-delete);               %delete first 1/4 and last 1/4 part from vector to remove possible outliers
brakeLength = mean(brakeLength);                            %take average
brakeLength = brakeLength + distanceToWall;                 %add distanceToWall

if (brakeLength < minimumBrakeLength)                       %make sure braking length is not too low (set value at beginning) to avoid crashes
    brakeLength = minimumBrakeLength;
end

brakeLength = brakeLength + brakeLengthCompensation;        %compensation in meters, set at beginning of script

currentDistance = 5;                                        %initialize to high enough value
while(currentDistance/100 > brakeLength)                    %wait for right moment to brake....
    [d_l,d_r]=checkDistance();
    currentDistance = max(d_l,d_r);
end
brake(brake_duration,simulation);                           %BRAKE NOW PLZ

% delay = 1;
% brakeTimer1 = timer;
% brakeTimer1.ExecutionMode = 'singleShot'; %fires the timer callback only once
% brakeTimer1.StartDelay = round(brake_time,3)-delay; %fires timer callback after this delay
% brakeTimer1.TimerFcn = @(~,~)brake(brake_duration,simulation); %define timer callback function as function brake with no input arguments
% start(brakeTimer1);


function brake(brake_duration,simulation)
brakeTimer2 = timer;                                        %timer initialiseren
brakeTimer2.ExecutionMode = 'singleShot';                   %fires the timer callback only once
brakeTimer2.StartDelay = round(brake_duration,3)-brakeDurationDelay;       %fires timer callback after this delay
if (simulation == 1)
    brakeTimer2.TimerFcn = @(~,~)checkMeasurementSander(1); %just do something random when simulation is active so that matlab quits whining about not having a callback function blablabla
else
    brakeTimer2.TimerFcn = @(~,~)EPOCommunications('transmit','M150'); %define timer callback function as setting motorspeed 150
end
start(brakeTimer2)
if (simulation == 1)
    pause(1)
else
    EPOCommunications('transmit','M135');
end

[d_l,d_r]=checkDistance();
currentDistance = max(d_l,d_r);
fprintf('We stopped at %.1f cm from the wall \n', currentDistance*100)
end

