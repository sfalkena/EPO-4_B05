load('audiodata_B5_1.mat'); 
for (i = 1:5)
    figure
    refer = RXXr(i,:,:);
    for (j = 1:5)
        ref = refer(:,:,j);
        plot(ref)
        hold on
    end
    legend('1','2','3','4','5');

end