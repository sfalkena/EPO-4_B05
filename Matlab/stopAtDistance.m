global d_l_log d_r_log stop_distance

EPOCommunications('transmit','M165');

%Intitialize all variables
d=zeros(1,2);
d = [d_l_log(end), d_r_log(end)];
maximum=max(d(1),d(2));
Speed=diff(d_l_log(end))/diff(t(end)); %speed: 0-5.56 m/s
brake_distance = stop_distance;

while(maximum > brake_distance)
    d = [d_l_log(end), d_r_log(end)];
    maximum=max(d(1),d(2));
    if(length(d_l_log) < 3)
        Speed = diff(d_l_log(end))/diff(t(end));
    else
        %take mean of derivative of the last 3 elements
        Speed = mean(diff(d_l_log(end-3:end)))/mean(diff(t(end-3:end)));
    end
    brake_distance = (stop_distance - Speed*5);
end

%braking according to speed
EPOCommunications('transmit','M135');
pause(Speed/4);
EPOCommunications('transmit','M150');