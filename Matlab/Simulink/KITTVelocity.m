figure;
plot(velocityOutput.time, velocityOutput.signals.values);
title('Velocity of KITT')
xlabel('Time [s]')
ylabel('Velocity [m/s]')

index = find(velocityOutput.signals.values>16);
IntersectionTime = velocityOutput.time(index(1))