%Gives coördinates of object closer or equal to a distance of
%'distance_bound'
%Function needs the current x and y coordinates of the car, the distance
%sensor values and the car_orientation
%Returns the x and y coordinate of the object (returns only a single
%coordinate!)

function [x_object,y_object] = object_Marker(x_car,y_car,x_sensor_l, x_sensor_r,car_orientation)
sensor_min = min(x_sensor_l, x_sensor_r);
%distance_bound can be dependent of the distance to destination in the
%future
distance_bound = 10; 
if sensor_min < distance_bound
        %quadrant 1
    if car_orientation <= 90
        x_object = x_car + sensor_min * cos(car_orientation)
        y_object = x_car + sensor_min * sin(car_orientation)
        
        %quadrant 2
    elseif (car_orientation > 90) && (car_orientation <= 180)
        x_object = x_car - sensor_min * cos(car_orientation)
        y_object = x_car + sensor_min * sin(car_orientation)
        
        %quadrant 3
    elseif (car_orientation > 180) && (car_orientation <= 270)
        x_object = x_car - sensor_min * cos(car_orientation)
        y_object = x_car - sensor_min * sin(car_orientation)
        
        %quadrant 4
    elseif (car_orientation > 270) && (car_orientation <= 360)
        x_object = x_car + sensor_min * cos(car_orientation)
        y_object = x_car - sensor_min * sin(car_orientation)
        
    end
    else
    %default value for when no object is close enough
x_object = -1;
y_object = -1;
end
        
end
