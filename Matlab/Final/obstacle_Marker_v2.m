function [object_nearby, x, y] = object_Marker(x_car,y_car,r_sensor_l, r_sensor_r,car_orientation)
%Only obstacles within 1 meter are dealt with
detection_bound = 100;
n = 0;
left_sensed = (r_sensor_l < detection_bound)
right_sensed = (r_sensor_r < detection_bound)
number_sensed = left_sensed + right_sensed
L_lower_R = (r_sensor_l <= r_sensor_r);
switch number_sensed
    case 0
        object_nearby = 0;
        x = -1;
        y = -1;
    case 1
        object_nearby = 1;
       [x,y] = obstacle_1_sensed(L_lower_R, x_car,y_car,r_sensor_l, r_sensor_r,car_orientation)
    case 2
        object_nearby = 1;
       [x,y] = obstacle_2_sensed(L_lower_R, x_car,y_car,r_sensor_l, r_sensor_r,car_orientation)
        
end
        
end