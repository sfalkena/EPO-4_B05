% Function written by Sander Delfos
%
% This function will check whether the distance sensors have a good
% reading. This is done by checking a few conditions: 
%
% 1. Do either of the sensors have a really low reading
% 2. Is there a significant difference between both sensors
% 3. Is the distance to the wall so high that there might not be 
% intersection between acceleration and deceleration curve
%
% If any of these conditions is met, the reading is set as not reliable.
% If there are 3 consecutive reliable readings, the function gives back
% result = 1, otherwise result = 0.
%
% If simulation mode is enabled from main script, this function will give
% back a random 'reliable' distance.

function [result, d] = checkMeasurementSander(simulation)
result = 0;
if (simulation == 1)
    result = 3;
    d = 3*rand(1);
else
    for i = 1:3
        [d_l, d_r] = checkDistance();
        if (min(d_l,d_r)<50)
            result = 0;
        elseif (abs(d_l - d_r)>50)
            result = 0;
        elseif (min(d_l,d_r)>400)
            result = 0;
        else
            result = result + 1;
        end
    end
    d = min(d_l,d_r);
end


if (result == 3)
    result = 1;
else
    result = 0;
end
end
