function [obs, xObs, yObs] = obstacle(xKITT, yKITT, directionKITT)
angle = deg2rad(15/2);
[d_l, d_r] = checkDistance;
minSensor = min(d_l,d_r);
obs = 1;

while (minSensor < 1)
    [d_l, d_r] = checkDistance;
    minSensor = min(d_l,d_r);
end

if (abs(d_l - d_r) < 5)
    xObs = xKITT + (minSensor + 10)*cos(directionKITT);
    yObs = yKITT + (minSensor + 10)*sin(directionKITT);
elseif (d_l < d_r)
    xObs = xKITT + (minSensor + 10)*cos(directionKITT+angle);
    yObs = yKITT + (minSensor + 10)*sin(directionKITT+angle);
else
    xObs = xKITT + (minSensor + 10)*cos(directionKITT-angle);
    yObs = yKITT + (minSensor + 10)*sin(directionKITT-angle);
end

if (xObs < 20) | (xObs > 440) | (yObs < 20) | (yObs > 440) | (minSensor > 100)
    obs = 0;
end    

end
