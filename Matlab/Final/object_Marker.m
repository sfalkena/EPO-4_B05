%Gives coördinates of object closer or equal to a distance of
%'distance_bound'
%Function needs the current x and y coordinates of the car, the distance
%sensor values and the car_orientation
%Returns the x and y coordinate of the object (returns only a single
%coordinate!)

function [object,x_object,y_object] = object_Marker(x_car,y_car,x_sensor_l, x_sensor_r,car_orientation)
sensor_min = min(x_sensor_l, x_sensor_r);
%distance_bound can be dependent of the distance to destination in the
%future
distance_bound = 10; %arbitrary value for testing
if sensor_min < distance_bound
    object = 1;
        x_object = x_car + sensor_min * cos(car_orientation)
        y_object = x_car + sensor_min * sin(car_orientation)

    else
    %no object
    object = 0;
    %default value for when no object is close enough
x_object = -1;
y_object = -1;
end
end
