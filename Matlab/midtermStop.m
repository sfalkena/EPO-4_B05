% Script of EPO-4, projectgroup B-05
% Sander Delfos, Sumeet Sharma, Sieger Falkena, Ivor Bas, Emiel van Veldhuijzen
% May 2018

% This script should stop at any given distanceFromWall before the wall.
% When KITT is not connected, the variable simulation can be set to value 1, this
% will simulate getting values from the sensors. 




%VARIABLE SETTINGS:

% Set distance from wall to stop
distanceFromWall = 0.4;                                    

% Set simulation 1 (on) / 0 (off) 
simulation = 1;                                            

% Set minimum distance from wall that KITT needs to start braking (to avoid
% crashing in case of false measurements)
minimumBrakeLength = 1;                                    

% Set amount of measurements (default = 4)
N=4;                                           

% Set value from transmission delay used in simulation mode
transmitDelay = 0.25;                                      

% Set compensation (in meters) for sensor delay
distanceCompensation = 0.3;            

%END OF SETTINGS



% Run curves function to get plots
run curves.m

if (simulation == 1)
    % Simulate giving a command
    pause(transmitDelay)
    % Start stopwatch
    tic
else
    % Start accelerating at full speed
    EPOCommunications('transmit','M165');
    % Start stopwatch
    tic
end

% Initialize matrices for later use
brakeDistance = zeros(1,N);
brakeVelocity = zeros(1,N);                                                   

% Start measurements, repeat N times
for i = 1:N                                                                
    if (simulation == 0)
        % Get sensor data
        [d_l, d_r] = checkDistance();                                       
    else
        % Simulate getting sensor data (use data from curves fuction
        % instead of measurements)
        t = toc;
        index_t = find(accTimeCurve > t, 1);
        d_l = 300 - accDistanceCurve(index_t)*100;
        d_r = 300 - accDistanceCurve(index_t)*100;
    end
    
    % Calculations
    % Take max (no glitches), convert to meters, add in compensation
    measuredDistance = max(d_l, d_r)/100 - distanceCompensation;
    
    % Find index of driven time in curve
    index1 = find(accTimeCurve>toc);                                               
    
    % Link driven time to driven distance
    distanceDriven = accDistanceCurve(index1(1));                                     
    
    % Determine distance that needs to be driven from current position
    distanceToDrive = measuredDistance - distanceFromWall;
    
    % Shift acceleration curve for driven distance
    accDistanceCurveShifted = accDistanceCurve - distanceDriven;                                   
    
    % Shift brake curve for distance that needs to be driven
    brakeDistaneCurveShifted = brakeDistanceCurve + distanceToDrive; 
    
    % Determine distance and velocity when KITT needs to start braking
    [brakeDistance(1,i),brakeVelocity(1,i)] = polyxpoly(accDistanceCurveShifted, accVelocityCurve, brakeDistaneCurveShifted, brakeVelocityCurve);
    
    % Make plots when simulation is active
    if (simulation == 1)
        if ~mod(i-1, 4)                                                     
            figure() ;
        end
        subplot(2, 2, mod(i-1, 4)+1) ;
        plot(accDistanceCurveShifted, accVelocityCurve)
        hold on
        plot(brakeDistaneCurveShifted, brakeVelocityCurve)
        scatter(brakeDistance(1,i), brakeVelocity(1,i))
        ylim([0,3])
        xlim([0,distanceToDrive+1])
        title(['Measurement ' num2str(i) ' @ ' num2str(measuredDistance) 'm from wall']);
        xlabel('Distance [m]')
        ylabel('Velocity [m/s]')
        legend('Acceleration','Braking','Brake point')
    end
    
end

% Take average for N measured/calculated braking points
brakeVelocity = mean(brakeVelocity);                                           

% Find index of braking velocity in acceleration curve
index2 = find(accVelocityCurve>brakeVelocity ,1);                                   

% Link braking velocity to point in time in curves, compensate for time
% driven with toc
brakeTime = accTimeCurve(index2(1))-toc;                                    

% Find index of braking velocity in brake curve
index3 = find(brakeVelocityCurve < accVelocityCurve(index2),1);                                 

% Find index of zero velocity in brake curve
index4 = find(brakeVelocityCurve < 0.01 ,1);                                        

% Find how long KITT needs to brake
brakeDuration = brakeTimeCurve(index4)-brakeTimeCurve(index3);                        

% Compensate for delays
brakeDurationDelay = 0.09*brakeVelocity*brakeVelocity;

% Set timer to let KITT start braking
brakeTimer1 = timer;
brakeTimer1.ExecutionMode = 'singleShot'; 
brakeTimer1.StartDelay = round(brakeTime,3);
brakeTimer1.TimerFcn = @(~,~)brake(brakeDuration,simulation, brakeDurationDelay, transmitDelay);
start(brakeTimer1);

% Function to start when KITT needs to start braking
function brake(brakeDuration, simulation, brakeDurationDelay, transmitDelay)
    % Set timer to let KITT brake for certain amount of time
    brakeTimer2 = timer;                                                        
    brakeTimer2.ExecutionMode = 'singleShot';                                   
    brakeTimer2.StartDelay = round(brakeDuration,3)-round(brakeDurationDelay,3);
    
    
    if (simulation == 1)
        % Simulate giving a command and set callback to empty function
        pause(transmitDelay)
        brakeTimer2.TimerFcn = @(~,~)sim;                
    else
        % Set callback to stop braking command
        brakeTimer2.TimerFcn = @(~,~)EPOCommunications('transmit','M150');   
    end
    
    start(brakeTimer2)
    
    if (simulation == 1)
        % Simulate giving a command 
        pause(transmitDelay)
    else
        % Start braking
        EPOCommunications('transmit','M135');
    end    
end

function sim()
    %empty function for sim
end

