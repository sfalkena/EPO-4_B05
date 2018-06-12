function [x,y] = obstacle_1_sensed(L_lower_R, x_car,y_car,r_sensor_l, r_sensor_r,car_orientation)

[sensor_location_l_x, sensor_location_l_y] = sensor_Location('L', x_car,y_car,r_sensor_l, r_sensor_r,car_orientation)
[sensor_location_r_x, sensor_location_r_y] = sensor_Location('R', x_car,y_car,r_sensor_l, r_sensor_r,car_orientation)

        if(L_lower_R)
            x_max = sensor_location_l_x + r_sensor_l * cos(car_orientation + pi/12);
            y_max = sensor_location_l_y + r_sensor_l * sin(car_orientation+ pi/12);
            x_min = sensor_location_r_x + r_sensor_r * cos(car_orientation + pi/12);
            y_min = sensor_location_r_y + r_sensor_r * sin(car_orientation+ pi/12);
            angle_max = atan(y_max / x_max);
            angle_min = atan(y_min / x_min);
            angle_center = (angle_max + angle_min) / 2;
            x = x_car + r_sensor_l * angle_center;
            y = y_car + r_sensor_l * angle_center;
        else
            x_max = sensor_location_l_x + r_sensor_l * cos(car_orientation - pi/12);
            y_max = sensor_location_l_y + r_sensor_l * sin(car_orientation - pi/12);
            x_min = sensor_location_r_x + r_sensor_r * cos(car_orientation - pi/12);
            y_min = sensor_location_r_y + r_sensor_r * sin(car_orientation - pi/12);
            angle_max = atan(y_max / x_max);
            angle_min = atan(y_min / x_min);
            angle_center = (angle_max + angle_min) / 2;
            x = x_car + r_sensor_l * angle_center;
            y = y_car + r_sensor_l * angle_center;
            
        end
end

