function angle = q2angle(q)

R = qGetR(q);

angle_s = asin(R(1,1))*180/pi;
angle_c = acos(R(2,1))*180/pi;

if angle_s >= 0 && angle_c <= 90
    angle = 90 - angle_s;
elseif angle_s < 0 && angle_c <= 90
    angle = 90 + angle_c;
elseif angle_s < 0 && angle_c > 90
    angle = angle_s - 90;
elseif angle_s >= 0 && angle_c > 90
    angle = angle_s - 90;
end