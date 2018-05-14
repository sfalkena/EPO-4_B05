% Script written by Sander Delfos / Sieger Falkena
%
% This script should stop at any given distanceFromWall before the wall.
% When KITT is not connected, the variable simulation can be set to value 1, this
% will give random values for the time driven and the distance measured to
% the wall to simulate the workings of the script.


run curvesSander.m
sim = 'vijfde_meting_19.0v.mat';                            %file to simulate with

%SETTINGS:
distanceFromWall = 0.5;                                       % set to desired stopping distance from wall
simulation = 1;                                             % make 1 for simulation, 0 for normal operation
brakeLengthCompensation = 1;                                % compensation for braking length (positive for earlier braking)
brakeDurationDelay = 0.3;                                   % set how much less time braking (positve for less braking)
minimumBrakeLength = 1;                                     % set a minumum for brake length to avoid crashes
N=6;                                                        % increase value to get more measurements
transmitDelay = 0.25;                                       % simulate delay caused by transmitting driving command


%accelerate to full speed
if (simulation == 1)
    tic
    pause(transmitDelay)
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

brake_point = zeros(1,N);
brake_speed = zeros(1,N);                                                   %initialize matrix for MORE SPEEDDDD
for i = 1:N                                                                 %get N measurements for brakeLength
    if (simulation == 0)
        [d_l, d_r] = checkDistance();                                       %get sensor data
    else
        %         d_l = load( sim , 'd_l_log'); d_l = d_l.d_l_log;                    %extract data from simulated file
        %         d_r = load( sim , 'd_r_log'); d_r = d_r.d_r_log;
        %         t = load( sim , 't'); t = t.t;
        %         t(1) = 0;                                                           %fist value is allways wrong
        %         command_index = 20;              %HARD CODED, still need to find a way to automatically find the command point.
        %         t = t - t(command_index);                                           %shift time vector to moment that car starts to drive
        %         t_toc = zeros(N);
        %         t_toc(i) = toc;                                                     %store toc for debugging
        %         index_t = find(t>t_toc(i),1);                                       %extract simulated sensor values
        %         d_l = d_l(index_t);
        %         d_r = d_r(index_t);
        t = toc;
        index_t = find(t_acc > t, 1);
        d_l = 300 - d_acc(index_t)*100;
        d_r = 300 - d_acc(index_t)*100;
    end
    measuredDistance = max(d_l, d_r)/100;                                   %take max so that glitches don't matter & convert to meters
    index1 = find(t_acc>toc);                                               %find index of driven distance in curve
    distanceDriven = d_acc(index1(1));                                      %find distance that has been traveled already
    distanceToDrive = measuredDistance - distanceFromWall;                  %determine distance that needs to be traveled in total
    d_acc_shift = d_acc - distanceDriven;                                   %shift acceleration curve to compensate for initial velocity
    d_dec_shift = d_dec + distanceToDrive;                                  %shift deceleration curve
    if (simulation == 1)
        if ~mod(i-1, 4)                                                     %automatically plot intersection curves in different subplots
            figure() ;
        end
        subplot(2, 2, mod(i-1, 4)+1) ;
        plot(d_acc_shift, v_acc)
        hold on
        plot(d_dec_shift, v_dec)
        ylim([0,3])
        xlim([0,distanceToDrive+1])
        title(['N = ' num2str(i) ', DistanceToDrive = ' num2str(distanceToDrive)]);
    end
    [brake_point(1,i),brake_speed(1,i)] = polyxpoly(d_acc_shift, v_acc, d_dec_shift, v_dec); %determine the point where the car should fully brake
    % scatter(brake_point,brake_speed)                                      %plot switching point
    
end
brake_speed
brake_speed = sort(brake_speed);                                            %sort the values from small to large
delete = fix(N/4);
brake_speed = brake_speed(delete:end-delete);                               %delete first 1/4 and last 1/4 part from vector to remove possible outliers
brake_speed = mean(brake_speed);                                            %take average

index2 = find(v_acc>brake_speed ,1);                                    %find corresponding index for the speed when starting to brake
brake_time = t_acc(index2(1));                                         %find corresponding index for time when starting to brake
index3 = find(v_dec < v_acc(index2),1);                                 %find index for brake point in deceleration curve
index4 = find(v_dec < 0.01 ,1);                                         %find index for when speed is zero in deceleration curve
brake_duration = t_dec(index4)-t_dec(index3);                           %find how long KITT needs to brake
% brakeLength(1,i) = d_dec_shift(index4)-d_dec_shift(index3);             %find distance from wall when KITT needs to start braking



% if (brakeLength < minimumBrakeLength)                                       %make sure braking length is not too low (set value at beginning) to avoid crashes
%     brakeLength = minimumBrakeLength;
% end
%
% brakeLength = brakeLength + brakeLengthCompensation;                        %compensation in meters, set at beginning of script
%
% currentDistance = 5;                                                        %initialize to high enough value
% while(currentDistance/100 > brakeLength)                                    %wait for right moment to brake....
%     oldDistance = currentDistance;
%     [d_l,d_r]=checkDistance();
%     currentDistance = max(d_l,d_r);
%     difference = currentDistance - oldDistance;
%     if ((currentDistance + 0.5*difference)/100 > brakeLength)
%         break
%     end
% end
% brake(brake_duration,simulation, brakeDurationDelay, transmitDelay);        %BRAKE NOW PLZ

delay = 0.5;
brakeTimer1 = timer;
brakeTimer1.ExecutionMode = 'singleShot'; %fires the timer callback only once
brakeTimer1.StartDelay = round(brake_time,3)-delay; %fires timer callback after this delay
brakeTimer1.TimerFcn = @(~,~)brake(brake_duration,simulation); %define timer callback function as function brake with no input arguments
start(brakeTimer1);


function brake(brake_duration, simulation, brakeDurationDelay, transmitDelay)
    brakeTimer2 = timer;                                                        %timer initialiseren
    brakeTimer2.ExecutionMode = 'singleShot';                                   %fires the timer callback only once
    brakeTimer2.StartDelay = round(brake_duration,3)-brakeDurationDelay;        %fires timer callback after this delay
    if (simulation == 1)
        brakeTimer2.TimerFcn = @(~,~)checkMeasurementSander(1);                 %just do something random when simulation is active so that matlab quits whining about not having a callback function blablabla
    else
        brakeTimer2.TimerFcn = @(~,~)EPOCommunications('transmit','M150');      %define timer callback function as setting motorspeed 150
    end
    start(brakeTimer2)
    if (simulation == 1)
        pause(transmitDelay)
    else
        EPOCommunications('transmit','M135');
    end
    
    if (simulation == 0)
        [d_l,d_r]=checkDistance();
        currentDistance = max(d_l,d_r);
        fprintf('We stopped at %.1f cm from the wall \n', currentDistance*100)
    else
    end
    
end

