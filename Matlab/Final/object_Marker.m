%Gives coördinates of object closer or equal to a distance of
%'distance_bound'
%Function needs the current x and y coordinates of the car, the distance
%sensor values and the car_orientation
%Returns the x and y coordinate of the object (returns only a single
%coordinate!)


function [object,x_object,y_object] = object_Marker(x_car,y_car,r_sensor_l, r_sensor_r,car_orientation)
sensor_min = min(r_sensor_l, r_sensor_r)
%difference between measurement left and right sensor
diff_sensor = r_sensor_l - r_sensor_r

%distance of middle between sensors to one of the sensors
radius_compensation = 0.175;

%left sensor location is perpendicular to the forward location
angle_compensation_l = mod(car_orientation + 0.5 * pi, 2*pi);
x_compensation_l = radius_compensation * cos(angle_compensation_l);
y_compensation_l = radius_compensation * sin(angle_compensation_l);

angle_compensation_r = mod(car_orientation - 0.5 * pi, 2* pi);
x_compensation_r = radius_compensation * cos(angle_compensation_r);
y_compensation_r = radius_compensation * sin(angle_compensation_r);

R = sqrt(radius_compensation^2 + sensor_min^2)
%distance_bound can be dependent of the distance to destination in the
%future
distance_bound = 1; %arbitrary value for testing
if sensor_min < distance_bound
    object = 1

        %left sensor gives 10cm higher than right sensor
    if diff_sensor > 0.10
        
        x_object = x_car + sensor_min * cos(car_orientation) + x_compensation_r
        y_object = x_car + sensor_min * sin(car_orientation) + y_compensation_r
    elseif diff_sensor < -0.10
        x_object = x_car + sensor_min * cos(car_orientation) + x_compensation_l
        y_object = x_car + sensor_min * sin(car_orientation) + y_compensation_l
    else diff_sensor = 0
        x_object = x_car + sensor_min * cos(car_orientation)
        y_object = x_car + sensor_min * sin(car_orientation)
    end
    
    else
        if abs(diff_sensor) > (0.1*R)
    %no object
    object = 0
    x_object = -1;
    y_object = -1;
        else
            object = 1;
        x_object = x_car + sensor_min * cos(car_orientation)
        y_object = x_car + sensor_min * sin(car_orientation)
        diff_sensor
        R
end
end
end
