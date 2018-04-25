count = 0;
EPOCommunications('transmit','M165');
aantal_metingen=0;
while (count < 1)
    d=zeros(1,2);
    [d(1), d(2)] = checkDistance()
    minimum = min(d);
    if(minimum < 200)
        count = count+1;
    else
        count = 0;
    end
    aantal_metingen = aantal_metingen + 1;
end

EPOCommunications('transmit','M135');
pause(0.5)
EPOCommunications('transmit','M150');
pause(1)
EPOCommunications('transmit','M135');
pause(2)
EPOCommunications('transmit','M150');