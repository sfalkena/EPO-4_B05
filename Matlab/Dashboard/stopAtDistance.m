function stopAtDistance(stop_distance)
global d_l d_r
checkSensors();
count = 0;
EPOCommunications('transmit','M165');
meting = 0;
while (count < 1)
    d=zeros(1,2);
    checkSensors();
    minimum = min(d_l, d_r);
    if(minimum < stop_distance)
        count = count+1;
    else
        count = 0;
    end
    meting = meting + 1;
end

EPOCommunications('transmit','M135');
checkSensors();
pause(0.5)

EPOCommunications('transmit','M150');
checkSensors();
pause(1)

EPOCommunications('transmit','M135');
checkSensors();
pause(2)

EPOCommunications('transmit','M150');
checkSensors();
end