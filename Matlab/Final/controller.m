%Implementation of fsm: https://drive.google.com/open?id=1hF1ciyzaJeoJ0LMB2N4dyqVVWJgN8bHU
clear xTurn yTurn
KITTStartX = 300;
KITTStartY = 300;
KITTStartOrientation = 90;
KITTStartOrientation = deg2rad(KITTStartOrientation);

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
scatter(KITTStartX,KITTStartY,'g')

i = 1;
targets = 4;
errorMargin = 1;
state = 'new_target';
while (1)
    switch state
        
        case 'new_target'
            xTarget = Px(i);
            yTarget = Py(i);
            run roadToTarget
            if (i <= targets)
                state = 'start';
            else
                break
            end
            
            
        case 'start'
            if (steeringDirection == 1)
                EPOCommunications('transmit','D100')
            elseif (steeringDirection == -1)
                EPOCommunications('transmit','D200')
            end
            EPOCommunications('transmit','M158')
            pause(1)
            state = 'turning';
            
        case 'turning'
            EPOCommunications('transmit','M157')
            state = 'location_turn';
            
        case 'location_turn'
            [xKITT(k),yKITT(k)] = location();
            k=k+1;
            distFromTurn = sqrt((xKITT(end)-xTurn(end))^2+(yKITT(end)-yTurn(end))^2);
            if (distFromTurn < errorMargin)
                state = 'straight';
            else
                state = 'turning';
            end
            
        case 'straight'
            EPOCommunications('transmit','D150')
            EPOCommunications('transmit','M158')
            pause(1)
            state = 'location';
            
        case 'location'
            EPOCommunications('transmit','D150')
            EPOCommunications('transmit','M150')
            [xKITT(k),yKITT(k)] = location();
            k=k+1;
            xDeltaKITT = xKITT(end)-xKITT(end-1);
            yDeltaKITT = yKITT(end)-yKITT(end-1);
            directionKITT = atand(yDeltaKITT/xDeltaKITT);
            xDeltaTarget = xKITT(end)-xTarget;
            yDeltaTarget = yKITT(end)-yTarget;
            directionTarget = atand(yDeltaTarget/xDeltaTarget);
            directionError = directionKITT - directionTarget;
            distFromTarget = sqrt((xKITT(end)-xTarget)^2+(yKITT(end)-yTarget)^2);
            if (distFromTarget < errorMargin)
                state = 'stop';
            elseif (abs(directionError) < errorMargin)
                state  = 'straight';
            elseif (directionError > 0)
                state = 'left';
            else
                state = 'right';
            end
            
        case 'left'
            EPOCommunications('transmit','D200')
            EPOCommunications('transmit','M158')
            pause(1)
            state = 'location';
            
        case 'right'
            EPOCommunications('transmit','D100')
            EPOCommunications('transmit','M158')
            pause(1)
            state = 'location';
            
        case 'stop'
            EPOCommunications('transmit','D150')
            EPOCommunications('transmit','M150')
            i = i+1;
            state = new_target;
            
    end
end

