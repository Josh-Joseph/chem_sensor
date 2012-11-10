load TEST_DATA_11_3_12

inverted_data = 1./sensor2;
normalized_data = inverted_data - min(inverted_data);
log_data = log(normalized_data);




figure;plot3(xpos,ypos,log_data)
grid on
hold on
plot3(xpos(length(xpos))*ones(1,801),ypos(length(ypos))*ones(1,801),[-18:.01:-10],'r')

figure;
hold on;
for i = 1:length(log_data)
    if log_data(i) > -11
        color = 'r';
    elseif log_data(i) > -12
            color = 'm';
    elseif log_data(i) > -13
        color = 'y';
    elseif log_data(i) > -14
        color = 'g';
    elseif log_data(i) > -15
        color = 'c';          
    elseif log_data(i) > -16
        color = 'b';                              
    else
        color = 'k';   
    end
    plot3(xpos(i),ypos(i),log_data(i),'*','Color',color);
    
end
grid on;
