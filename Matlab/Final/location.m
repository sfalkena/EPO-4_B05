function [x,y,lowestError] = location(r12,r13,r14,r23,r24,r34, r15, r25, r35, r45)
z = 24; %asume constant
error = 1000*ones(461); % init matrix
%% check for all x an y values (1cm resolution)
for x = 1:461
    for y = 1:461
              m = [460 0 24; 0 0 24; 0 460 24; 460 460 24; 230 460 54]';     % (known) locations of the mics

        d = zeros(1,5);
        for i = 1:5
            d(i) = sqrt((x-m(1,i))^2 + (y-m(2,i))^2 + (z-m(3,i))^2);
        end
        %calculate r values for current coordinate
        R12 = d(1)-d(2);
        R13 = d(1)-d(3);
        R14 = d(1)-d(4);
        R15 = d(1)-d(5);
        R23 = d(2)-d(3);
        R24 = d(2)-d(4);
        R25 = d(2)-d(5);
        R34 = d(3)-d(4);
        R35 = d(3)-d(5);
        R45 = d(4)-d(5);
        %calculate difference between measured and calculated r value
        error(x,y) = abs(r12-R12);
        error(x,y) = error(x,y) + abs(r13-R13);
        error(x,y) = error(x,y) + abs(r14-R14);
        error(x,y) = error(x,y) + abs(r23-R23);
        error(x,y) = error(x,y) + abs(r24-R24);
        error(x,y) = error(x,y) + abs(r34-R34);
        error(x,y) = error(x,y) + abs(r35-R35);
        error(x,y) = error(x,y) + abs(r45-R45);
        error(x,y) = error(x,y) + abs(r25-R25);
        error(x,y) = error(x,y) + abs(r15-R15);
    end
end
%% Determine lowest error
lowestError = min(min(error)) %double min because its a matrix, not a vector
[x,y] = find(error == lowestError,1); %find the coordinates for the lowest error

end