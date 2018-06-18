%% Implementation of fsm: https://drive.google.com/file/d/1n7EBoggdJZXqctVqqwDk2HfOGOQZImze/view?usp=sharing
clear xKITT yKITT distFromTarget

%% set simulation to '1' for offline use
simulation = 1;

%% set initial values for KITT
xKITT = 230;
yKITT = 0;
directionKITT = 90;
directionKITT = deg2rad(directionKITT); %convert to radians

%% Plot the playground with microphones, targets and starting position of
%KITT

figure
hold on
xlim([-10 470])
ylim([-10 470])
title('Map')
xlabel('x coördinate')
ylabel('y coördinate')
% Old targets:
% Px=[150 260 370 230];
% Py=[150 360 200 230];
% New targets:
Px=[346 105 385 230];
Py=[0   333 248 230];
Mx=[460 0 0 460 230];
My=[0 0 460 460 460];
scatter(Px,Py,'r','x')
scatter(Mx,My,'b')
scatter(xKITT(1),yKITT(1),'g')

%% Initialize variables used in FSM
i = 1;
k = 2;
targets = 4;
errorMargin = 20;
directionMargin = deg2rad(20);
state = 'new_target';
reverse = 0;
obs = 0;
distFromTarget = 999;

%% FSM
while (1)
    switch state
        
        case 'new_target' % set new target
            if (i <= targets)
                state = 'direction';
            else
                fprintf('All targets reached, stopping now \n')
                EPOCommunications('transmit','A0');         %Turn off audio beacon               
                break
            end
            xTarget = Px(i);
            yTarget = Py(i);
            
        case 'direction' % determine the current direction of KITT and decide whether to go left, right or straight
            if (length(xKITT)>1)
                xDeltaKITT = xKITT(end)-xKITT(end-1);
                yDeltaKITT = yKITT(end)-yKITT(end-1);
                directionKITT = atan2(yDeltaKITT,xDeltaKITT);
                if (reverse == 1)
                    directionKITT = directionKITT + pi;
                end
            end
            xDeltaTarget = xTarget-xKITT(end);
            yDeltaTarget = yTarget-yKITT(end);
            directionTarget = atan2(yDeltaTarget,xDeltaTarget);
            directionError = mod(directionKITT - directionTarget,2*pi);
            distFromTarget(k) = sqrt((xKITT(end)-xTarget)^2+(yKITT(end)-yTarget)^2);
            xFuture = xKITT(end)+50*cos(directionKITT);
            yFuture = yKITT(end)+50*sin(directionKITT);
            if (distFromTarget(k) < 25)
                driveTime = 0.5;
            else
                driveTime = sqrt(distFromTarget(k)/100);
            end
            if (distFromTarget(k) < errorMargin)
                state = 'stop'
            elseif ((xFuture > 460) | (xFuture < 0) | (yFuture > 460) | (yFuture <0)) && ((abs(directionError) > pi/4) && (abs(directionError) < 7*pi/4))
                state = 'reverse'
            elseif (obs == 1)
                if (directionObstacle == 0)
                    directionToMid = directionKITT - atan2((230-yKITT(end)),(230-xKITT(end)));
                    directionToMid = wrapToPi(directionToMid);
                    if (directionToMid > 0)
                        state = 'right'
                    elseif (directionToMid < 0)
                        state = 'left'
                    else
                        state = 'straight'
                    end
                elseif (directionObstacle > 0)
                    state = 'left'
                elseif (directionObstacle < 0)
                    state = 'right'
                end
            elseif (distFromTarget(k) > distFromTarget(k-1)) && (reverse == 0) && (distFromTarget(k) < 70)
                state = 'reverse'
            elseif (abs(directionError) < directionMargin)
                state  = 'straight'
            elseif (directionError < 0)
                if (abs(directionError) < pi)
                    if (abs(directionError) < pi/4)
                        state = 'left'
                    else
                        state = 'sharp_left'
                    end
                else
                    if (directionError < 7*pi/4)
                        state = 'right'
                    else
                        state = 'sharp_right'
                    end
                end
            elseif (directionError > 0)
                if (abs(directionError) < pi)
                    if (abs(directionError) < pi/4)
                        state = 'right'
                    else
                        state = 'sharp_right'
                    end
                else
                    if (directionError > 7*pi/4)
                        state = 'left'
                    else
                        state = 'sharp_left'
                    end
                end
            end
            reverse = 0;
            
            
        case 'location' % determine location (or fake location in sim)
            EPOCommunications('transmit','M150')
            obs = 0;
            if (simulation == 0)
                run Audio_Settings.m
                lowestError = 99999;
                margin = 100;
                a = 1;
                while (lowestError > margin) %keep recording untill good reading
                    RXXr = EPO4_audio_record('B5_audio', 15000,7500,2500,'ebeb9a61',48e3,5,1,3);
                    [xMeasure(a),yMeasure(a),lowestError(a)] = Testfile(RXXr);
                    margin = margin*2;
                    a = a + 1;
                end
                a = find(min(lowestError),1);
                xKITT(k) = xMeasure(a);
                yKITT(k) = yMeasure(a);
            else
                xDeltaKITT = xKITT(end)-xKITT(end-1);
                yDeltaKITT = yKITT(end)-yKITT(end-1);
                directionKITT = atan2(yDeltaKITT,xDeltaKITT);
                xKITT(k) = xKITT(end)+20*cos(directionKITT);
                yKITT(k) = yKITT(end)+20*sin(directionKITT);
            end
            if (simulation == 0)
                [obs, xObs, yObs] = obstacle(xKITT(end), yKITT(end), directionKITT);
                if (obs == 1)
                    scatter(xObs, yObs, '*')
                    directionObstacle = directionKITT - atan2((yObs-yKITT(end)),(xObs-xKITT(end)));
                    directionObstacle = wrapToPi(directionObstacle);                    
                end
            else
                xObs = 300;
                yObs = 50;
                directionObstacle = directionKITT - atan2((yObs-yKITT(end)),(xObs-xKITT(end)));
                directionObstacle = wrapToPi(directionObstacle); 
                if (abs(directionObstacle) < pi/2) & (sqrt((xKITT(end)-xObs)^2+(yKITT(end)-yObs)^2) < 100)
                    obs = 1;
                    scatter(xObs, yObs, '*')
                end
            end
            plot(xKITT,yKITT,'k')
            k=k+1;
            EPOCommunications('transmit','D150')
            state = 'direction';
            
        case 'reverse'
            reverse = 1;
            EPOCommunications('transmit','D150')
            EPOCommunications('transmit','M142')
            pause(2.5)
            EPOCommunications('transmit','M150')
            if (simulation == 1)
                xKITT(k) = xKITT(k-1) - 50*cos(directionKITT);
                yKITT(k) = yKITT(k-1) - 50*sin(directionKITT);
            end
            state = 'location';
            
        case 'straight' % drive straight for a second
            EPOCommunications('transmit','D150')
            EPOCommunications('transmit','M159')
            pause(driveTime)
            if (simulation == 1)
                xKITT(k) = xKITT(k-1) + 2*driveTime*cos(directionKITT);
                yKITT(k) = yKITT(k-1) + 2*driveTime*sin(directionKITT);
            end
            state = 'location';
            
        case 'left' % drive left for a second
            if (simulation == 1)
                xKITT(k) = xKITT(k-1)+ 5*cos(directionKITT+pi/10);
                yKITT(k) = yKITT(k-1)+ 5*sin(directionKITT+pi/10);
            end
            EPOCommunications('transmit','D200')
            EPOCommunications('transmit','M156') %to make wheels turn if not turned
            pause(0.5)
            EPOCommunications('transmit','M159')
            pause(0.7)
            state = 'location';
            
        case 'sharp_left' % drive left for a second
            if (simulation == 1)
                xKITT(k) = xKITT(k-1)+ 20*cos(directionKITT+pi/5);
                yKITT(k) = yKITT(k-1)+ 20*sin(directionKITT+pi/5);
            end
            EPOCommunications('transmit','D200')
            EPOCommunications('transmit','M156') %to make wheels turn if not turned
            pause(0.5)
            EPOCommunications('transmit','M159')
            pause(2)
            state = 'location';
            
        case 'right' % drive right for a second
            if (simulation == 1)
                xKITT(k) = xKITT(k-1)+ 5*cos(directionKITT-pi/10);
                yKITT(k) = yKITT(k-1)+ 5*sin(directionKITT-pi/10);
            end
            EPOCommunications('transmit','D100')
            EPOCommunications('transmit','M156') %to make wheels turn if not turned
            pause(0.5)
            EPOCommunications('transmit','M159')
            pause(0.7)
            state = 'location';
            
        case 'sharp_right' % drive right for a second
            if (simulation == 1)
                xKITT(k) = xKITT(k-1)+ 20*cos(directionKITT-pi/5);
                yKITT(k) = yKITT(k-1)+ 20*sin(directionKITT-pi/5);
            end
            EPOCommunications('transmit','D100')
            EPOCommunications('transmit','M156') %to make wheels turn if not turned
            pause(0.5)
            EPOCommunications('transmit','M159')
            pause(2)
            state = 'location';
            
        case 'stop' % stop and proceed to next target
            EPOCommunications('transmit','D150')
            EPOCommunications('transmit','M150')
            EPOCommunications('transmit','A0');         %Turn off audio beacon
            beep
            scatter(xKITT(end),yKITT(end),'o','k')
            i = i+1;
            state = 'new_target';
            fprintf('Target reached, press any button to proceed to next target \n')
            pause
            fprintf('Proceeding to next target \n')
            EPOCommunications('transmit','A1');         %Turn on audio beacon
    end
end

