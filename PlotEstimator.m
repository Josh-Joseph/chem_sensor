fname = 'Estimator_Logs/2012-11-04_210036.log';
fname = 'Estimator_Logs/2012-11-05_000525.log';
fname = 'Estimator_Logs/2012-11-05_001625.log';
fname = 'Estimator_Logs/2012-11-05_002724.log';
fname = 'Estimator_Logs/2012-11-05_20-22-00.log';
%fname = 'Estimator_Logs/2012-11-06_20-44-48.log';

% %fname = '/Users/mvdl/Dropbox/Bloodhound (1)/estimator-reruns/2012-11-06_20-44-48/0.00001_100_estimator.log';
% fname = '/Users/mvdl/Dropbox/Bloodhound (1)/estimator-reruns/2012-11-06_20-44-48/100_.00001_estimator.log'
% %fname = '/Users/mvdl/Dropbox/Bloodhound (1)/estimator-reruns/2012-11-06_20-44-48/0.00001_10000_estimator.log';
% %fname = '/Users/mvdl/Dropbox/Bloodhound (1)/estimator-reruns/2012-11-06_20-44-48/0.00001_1_estimator.log';
% fname = '/Users/mvdl/Dropbox/Bloodhound (1)/estimator-reruns/2012-11-06_20-44-48/10_50_estimator.log'
% fname = '/Users/mvdl/Dropbox/Bloodhound (1)/estimator-reruns/2012-11-06_20-44-48/10_50_reverse_estimator.log'
% fname = '/Users/mvdl/Dropbox/Bloodhound (1)/estimator-reruns/2012-11-06_20-44-48/10_50_good_readings_estimator.log'
% fname = '/Users/mvdl/Dropbox/Bloodhound (1)/estimator-reruns/2012-11-06_20-44-48/1_50_good_readings_estimator.log'
% fname = '/Users/mvdl/Dropbox/Bloodhound (1)/estimator-reruns/2012-11-06_20-44-48/1_50_good_readings_estimator_new_mean.log'
% fname = '/Users/mvdl/Dropbox/Bloodhound (1)/estimator-reruns/2012-11-06_20-44-48/1_5__estimator_new_mean.log'
% fname = '/Users/mvdl/Dropbox/Bloodhound (1)/estimator-reruns/2012-11-06_20-44-48/0.001_0.001_estimator_new_mean.log'
% fname = '/Users/mvdl/Dropbox/Bloodhound (1)/estimator-reruns/2012-11-06_20-44-48/0_0.1_estimator_mid_mean.log'
% fname = '/Users/mvdl/Dropbox/Bloodhound (1)/estimator-reruns/2012-11-06_20-44-48/0_10_estimator_mid_mean.log'
% fname = '/Users/mvdl/Dropbox/Bloodhound (1)/estimator-reruns/2012-11-06_20-44-48/0_100_estimator_5e4.log'
% fname = '/Users/mvdl/Dropbox/Bloodhound (1)/estimator-reruns/2012-11-06_20-44-48/0_50_estimator_5e4_true_mean.log'
% fname = '/Users/mvdl/Dropbox/Bloodhound (1)/estimator-reruns/2012-11-06_20-44-48/0_50_estimator_5e4_good_readings.log'
% fname = '/Users/mvdl/Dropbox/Bloodhound (1)/simulations/estimator.log'



close all

% Read in Estimator Log
[time,pos,posquat,mu,sigma,trace,C,newData] = Estimator2Mat(fname);

% Source Location
% sourceTrue = [6.834999847225845   2.642499940935522];
% sourceTrue = [35.42 -6.82];
% sourceTrue = [-19.74 16.6];
sourceTrue = [18.08 -14.11];

% % Plot covariance trace
% figure;
% plot(trace);
% xlabel('Reading Number');
% ylabel('Estimator Covariance Trace');
% title('Estimator Covariance');
% 
% 

% Plot estimate location
figure;
hold on;
plot(mu(:,1),mu(:,2),'*c');

for(k = 1:length(mu))
    ang = 0;
    if mu(k,1) < mu(k,2)
        ang = pi/2;
    end
        
   [ex,ey] = calculateEllipse(mu(k,1),mu(k,2),sigma(k,1),sigma(k,5),ang,100);
   plot(ex,ey); 
   
   if k == length(mu)
         plot(ex,ey,'r');
   end
   
   if k == 1
       plot(ex,ey,'g')
   end
   
end



plot(mu(length(mu),1),mu(length(mu),2),'*m');
plot(mu(1,1),mu(1,2),'*g');
plot(sourceTrue(1),sourceTrue(2),'*r');
plot(mu(:,1),mu(:,2));
% Plot Robot Path
plot(pos(:,1),pos(:,2),'y');
plot(pos(:,1),pos(:,2),'*k');
plot(pos(length(pos),1),pos(length(pos),2),'*m');
plot(pos(1,1),pos(1,2),'*g');
plot(sourceTrue(1),sourceTrue(2),'*r');
legend('Robot Path','Sensor Reading Location','Robot End','Robot Start','True Source Location');
xlabel('x position [m]');
ylabel('y postion [m]');
title('Robot Path');
xlim([-5 45]);
ylim([-20 30]);

% 
% 
% legend('Estimate Mean Location','Final Estimate','Initial Estimate','True Source Location');
xlabel('x position [m]');
ylabel('y postion [m]');
title('Estimator Mean Locations');
xlim([-5 45]);
ylim([-20 30]);
% 
% %%% Plot Raw Reading Box Plots
rawReadings = newData(:,22:length(newData));
dist = zeros(length(pos),1);
for i = 1:length(pos)
   dist(i) = sqrt((pos(i,1) - sourceTrue(1))^2 + (pos(i,2) - sourceTrue(2))^2);
   
end
distReading = [dist';rawReadings'];
% % % distReading = sortrows(distReading',1)';
distReading(distReading==0) = NaN;
% figure;boxplot(distReading(2:length(distReading(:,1)),:),distReading(1,:));
% title('Resistance vs Distance from Source');
% xlabel('Distance from Source [m]');
% ylabel('Resistance');
figure;boxplot(distReading(2:length(distReading(:,1)),:));
title('Resistance vs Reading Number');
xlabel('Reading Number');
ylabel('Resistance');



%Plot C values
figure;plot(C);
title('C value vs Reading number');
xlabel('Reading Number');
ylabel('C value');
distC = [dist C];
distC = sortrows(distC,1);
% figure;plot(distC(:,1),distC(:,2));
% title('C value vs Distance');
% xlabel('Distance from Source [m]');
% ylabel('C value');
% 

% % Plot Robot Path
% figure;plot(pos(:,1),pos(:,2));
% hold on;
% plot(pos(:,1),pos(:,2),'*c');
% plot(pos(length(pos),1),pos(length(pos),2),'*m');
% plot(pos(1,1),pos(1,2),'*g');
% plot(sourceTrue(1),sourceTrue(2),'*r');
% legend('Robot Path','Sensor Reading Location','Robot End','Robot Start','True Source Location');
% xlabel('x position [m]');
% ylabel('y postion [m]');
% title('Robot Path');
% xlim([-5 45]);
% ylim([-20 30]);
% 
% % 
% % 
