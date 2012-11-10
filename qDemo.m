function qDemo
close all

% a demo how to rotate a point around an arbitrary axis by using
% quaternions
% REMARK:
%   1) enless loop, hit CTRL+C to break
%
% VERSION: 05.03.2011

% point to be rotated
P = [ .5, 0, 0 ];

% vector around which the rotation will be performed
u = [ 0, 0, 1 ];

% for camera purpose
azimuth = 0;
hold off;
fprintf( 'Press CTRL+C to break!\n\r' );
while 1
    hold off
    for teta = 0:5:360
        % create a quaternion for rotation
        Qrot = qGetRotQuaternion( teta*pi/180, u );
        R = qGetR(Qrot);
        '-------------------'
        disp(asin(R(1,1))*180/pi)
        disp(acos(R(2,1))*180/pi)
        disp(q2angle(Qrot))
        % rotate point
        Prot = qRotatePoint( P, Qrot );
        
        % display x axis
        quiver3( 0,0,0, 1,0,0 );
        hold on;
        
        %display y axis
        quiver3( 0,0,0, 0,1,0 );
        
        % display z axis
        quiver3( 0,0,0, 0,0,1 );
        
        % display rotation vector
        quiver3( 0,0,0, u(1),u(2),u(3) );
        
        % display point
        plot3( Prot(1), Prot(2), Prot(3), 'b.' );
        
        % setup the plot
        grid on;
        axis equal;
        axis([-1  1.0 -1 1.0 -1 1.0]);
        xlabel( 'x' );
        ylabel( 'y' );
        zlabel( 'z' );
        
        % rotate the camera
        azimuth = azimuth - 1;
        view( azimuth, 20 );
        drawnow;
    end
end
    