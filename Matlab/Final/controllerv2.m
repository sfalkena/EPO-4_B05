%% Implementation of fsm: https://drive.google.com/file/d/1n7EBoggdJZXqctVqqwDk2HfOGOQZImze/view?usp=sharing
clear xKITT yKITT

%% set simulation to '1' for offline use
simulation = 1;

%% set initial values for KITT
xKITT = 100;
yKITT = 350;
directionKITT = 130;
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
Px=[150 200 400 230];
Py=[150 360 200 230];
Mx=[460 0 0 460 230];
My=[0 0 460 460 460];
scatter(Px,Py,'r','x')
scatter(Mx,My,'b')
scatter(xKITT(1),yKITT(1),'g')

%% Initialize variables used in FSM
i = 1;
k = 2;
targets = 4;
errorMargin = 10;
directionMargin = deg2rad(10);
state = 'new_target';
reverse = 0;

%% FSM
while (1)
    switch state
        
        case 'new_target' % set new target
            if (i <= targets)
                state = 'direction';
            else
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
            if (distFromTarget(k) < errorMargin)
                state = 'stop'
            elseif (xFuture > 450) | (xFuture < 0) | (yFuture > 450) | (yFuture <0)
                state = 'reverse'
            elseif (distFromTarget(k) > distFromTarget(k-1)) && (reverse == 0) && (distFromTarget(k) < 140)
                state = 'reverse'
            elseif (abs(directionError) < directionMargin)
                state  = 'straight'
            elseif (directionError < 0)
                if (abs(directionError) < pi)
                    state = 'left'
                else
                    state = 'right'
                end
            elseif (directionError > 0)
                if (abs(directionError) < pi)
                    state = 'right'
                else
                    state = 'left'
                end
            end
            reverse = 0;
            
            
        case 'location' % determine location (or fake location in sim)
            EPOCommunications('transmit','D150')
            EPOCommunications('transmit','M150')
            if (simulation == 0)
                [xKITT(k),yKITT(k)] = location();
            else
                xDeltaKITT = xKITT(end)-xKITT(end-1);
                yDeltaKITT = yKITT(end)-yKITT(end-1);
                directionKITT = atan2(yDeltaKITT,xDeltaKITT);
                xKITT(k) = xKITT(end)+20*cos(directionKITT);
                yKITT(k) = yKITT(end)+20*sin(directionKITT);
                plot(xKITT,yKITT,'k')
            end
            k=k+1;
            state = 'direction';
            
        case 'reverse'
            reverse = 1;
            EPOCommunications('transmit','D150')
            EPOCommunications('transmit','M145')
            pause(1)
            EPOCommunications('transmit','M150')
            if (simulation == 1)
                xKITT(k) = xKITT(k-1) - 50*cos(directionKITT);
                yKITT(k) = yKITT(k-1) - 50*sin(directionKITT);
            end
            state = 'location';
            
        case 'straight' % drive straight for a second
            EPOCommunications('transmit','D150')
            EPOCommunications('transmit','M158')
            pause(1)
            state = 'location';
            
        case 'left' % drive left for a second
            if (simulation == 1)
                xKITT(k) = xKITT(k-1)+ 5*cos(directionKITT+pi/10);
                yKITT(k) = yKITT(k-1)+ 5*sin(directionKITT+pi/10);
            end
            EPOCommunications('transmit','D200')
            EPOCommunications('transmit','M158')
            pause(1)
            state = 'location';
            
        case 'right' % drive right for a second
            if (simulation == 1)
                xKITT(k) = xKITT(k-1)+ 5*cos(directionKITT-pi/10);
                yKITT(k) = yKITT(k-1)+ 5*sin(directionKITT-pi/10);
            end
            EPOCommunications('transmit','D100')
            EPOCommunications('transmit','M158')
            pause(1)
            state = 'location';
            
        case 'stop' % stop and proceed to next target
            EPOCommunications('transmit','D150')
            EPOCommunications('transmit','M150')
            beep
            fprintf('Target reached')
            scatter(xKITT(end),yKITT(end),'o','k')
            i = i+1;
            state = 'new_target';
            
    end
end

