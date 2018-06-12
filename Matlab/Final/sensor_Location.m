function [x,y] = sensor_Location(Left_or_Right, x_car, y_car,r_sensor_l, r_sensor_r, car_orientation)
%Distance from beacon to ultrasonic sensors in ortogonal vectors
horizontal = 17.5;
vertical = 30;
%Angle between audio beacon and the ultrasonic sensor
teta = atan(30/17.5);
%Left sensor
if Left_or_Right == 'L'
    alpha = car_orientation + teta;
    x = x_car + horizontal * cos(alpha)
    y = y_car + vertical * sin(alpha)
%Right sensor
else Left_or_Right == 'R'
        alpha = car_orientation - teta;
    x = x_car + horizontal * cos(alpha)
    y = y_car + vertical * sin(alpha)
end

