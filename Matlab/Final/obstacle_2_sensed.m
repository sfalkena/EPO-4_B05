function [x,y] = obstacle_2_sensed(L_lower_R, x_car,y_car,r_sensor_l, r_sensor_r,car_orientation)
        if r_sensor_l < r_sensor_r
            x = x_car + r_sensor_l * cos(car_orientation);
            y = y_car + r_sensor_l * sin(car_orientation);
        else
            x = x_car + r_sensor_r * cos(car_orientation);
            y = y_car + r_sensor_r * sin(car_orientation);

        end
end

