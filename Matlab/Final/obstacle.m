%Script of EPO-4, projectgroup B-05
%Sander Delfos, Sumeet Sharma, Sieger Falkena, Ivor Bas, Emiel van Veldhuijzen
%June 2018

function [obs, xObs, yObs] = obstacle(xKITT, yKITT, directionKITT)
angle = deg2rad(15/2);
[d_l, d_r] = checkDistance                                      %get sensor values
minSensor = min(d_l,d_r);
obs = 1;

if (abs(d_l - d_r) < 5)                                         %obstacle is right in front of car
    xObs = xKITT + (minSensor + 10)*cos(directionKITT);
    yObs = yKITT + (minSensor + 10)*sin(directionKITT);
elseif (d_l < d_r)                                              %obstacle is to the left of the car
    xObs = xKITT + (minSensor + 10)*cos(directionKITT+angle);
    yObs = yKITT + (minSensor + 10)*sin(directionKITT+angle);
else                                                            %obstacle is to the right of the car
    xObs = xKITT + (minSensor + 10)*cos(directionKITT-angle);
    yObs = yKITT + (minSensor + 10)*sin(directionKITT-angle);
end

%If obstacle is outside the field, it is not treated as an obstacle
if (xObs < 20) | (xObs > 440) | (yObs < 20) | (yObs > 440) | (minSensor > 60) | (minSensor == 0)
    obs = 0;
end    

end
 