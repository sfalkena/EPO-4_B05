try 
    run midtermStopSanderV2.m
catch error
    fprintf('error detected')
    EPOCommunications('transmit','M135')
    pause(1)
    EPOCommunications('transmit','M150')
end