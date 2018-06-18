function [obs, xObs, yObs] = obstacle(xKITT, yKITT, directionKITT)
angle = deg2rad(15/2);
[d_l, d_r] = checkDistance;
minSensor = min(d_l,d_r);
if (minSensor > 100)
    obs = 0;
elseif (abs(d_l - d_r) < 20)
    obs = 1;
    xObs = xKITT + (minSensor + 10)*cos(directionKITT);
    yObs = yKITT + (minSensor + 10)*sin(directionKITT);
elseif (d_l < d_r)
    obs = 1;
    xObs = xKITT + (minSensor + 10)*cos(directionKITT+angle);
    yObs = yKITT + (minSensor + 10)*sin(directionKITT+angle);
else
    obs = 1;
    xObs = xKITT + (minSensor + 10)*cos(directionKITT-angle);
    yObs = yKITT + (minSensor + 10)*sin(directionKITT-angle);
end
end
