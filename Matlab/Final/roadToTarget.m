%plot turning radius
angleToTarget = atand((KITTStartX-Px(1))/(KITTStartY-Py(1)))+90-rad2deg(KITTStartOrientation);
r = 70.05;
e = 0.0001;

%negative = left
if (angleToTarget > 0)
    steeringDirection = -1;
    if (angleToTarget > 180)
        steeringDirection = -steeringDirection;
    end
elseif (angleToTarget < 0)
    steeringDirection = 1;
    if (angleToTarget < -180)
        steeringDirection = -steeringDirection;
    end
else
    steeringDirection = 0;
end

L=0;
n=1;
tic
while(1)
    xTurn(n) = steeringDirection*r*cos(-steeringDirection*e*(n-1)+KITTStartOrientation+pi)+KITTStartX +steeringDirection*r*cos(KITTStartOrientation);
    yTurn(n) = steeringDirection*r*sin(-steeringDirection*e*(n-1)+KITTStartOrientation+pi)+KITTStartY +steeringDirection*r*sin(KITTStartOrientation);
    if (n>1)
        KITTdeltaX = (xTurn(n)-xTurn(n-1));
        KITTdeltaY = (yTurn(n)-yTurn(n-1));
        KITTtangent = KITTdeltaY/KITTdeltaX;
        L = L + sqrt(KITTdeltaX^2 + KITTdeltaY^2);
        toTargetX = (xTarget-xTurn(n));
        toTargetY = (yTarget-yTurn(n));
        targetTangent = toTargetY / toTargetX;
        if (abs(targetTangent - KITTtangent)<e*20) && (abs((xTurn(n)-xTarget))<abs(xTurn(n-1)-xTarget))
            break
        end
    end
    n = n+1;
    if (toc > 10)
        break
    end
end

lineToTargetx = linspace(xTurn(end), xTarget, 1000);
lineToTargety = linspace(yTurn(end), yTarget, 1000);

plot(xTurn, yTurn)
plot(lineToTargetx, lineToTargety)
