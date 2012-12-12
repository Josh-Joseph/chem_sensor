function visualize_filtering_clojure

close all


%fname = 'Estimator_Logs/2012-11-04_210036.log'; chemical_position = [6.834999847225845 2.642499940935522];
%fname = 'Estimator_Logs/2012-11-05_000525.log'; chemical_position = [35.42 -6.82];
%fname = 'Estimator_Logs/2012-11-05_001625.log'; chemical_position = [35.42 -6.82];
%fname = 'Estimator_Logs/2012-11-05_002724.log'; chemical_position = [35.42 -6.82];
%fname = 'Estimator_Logs/2012-11-06_20-44-48.log'; chemical_position = [18.08 -14.11];
fname = 'estimator.log'; fname_particles = 'particles.log';chemical_position = [18.08 -14.11];
fname = 'estimator.log'; fname_particles = 'particles.log';chemical_position = [14.04 -10];
fname = 'estimator.log'; fname_particles = 'particles.log';chemical_position = [10.85 -14.4];

dirname = '/home/josh/Dropbox/Bloodhound/autonomous-runs_11-12/6/';
fname = [dirname 'estimator.log']; fname_particles = [dirname 'particles.log']; chemical_position = [-2.7 -1.3];

% Read in Estimator Log
[time,pos,posquat,mu,C,newData] = Estimator2Mat(fname);

% Read in Particle Filter Log
particleLog_Mat = dlmread(fname_particles);


[i j] = find(pos>1e20);
time(i) = [];
pos(i,:) = [];
posquat(i,:) = [];
mu(i,:) = [];
C(i) = [];
newData(i,:) = [];
particleLog_Mat(i,:) = [];


x_bounds = [.9*min([chemical_position(1); pos(:,1)]) 1.1*max([chemical_position(1); pos(:,1)])]; 
y_bounds = [1.1*min([chemical_position(2); pos(:,2)]) .9*max([chemical_position(2); pos(:,2)])];

for t = 1:size(time)
    % draw robot position
    clf;
    draw_robot(pos(1:t,1:2), chemical_position);
    %xlim(x_bounds);
    %ylim(y_bounds);
    
    % apply the particle filter and draw the belief
    particles = [particleLog_Mat(:,1), particleLog_Mat(:,2),particleLog_Mat(:,t+2)];
    
    % draw particles
    draw_particle_belief(particles);
    
    pause;
end

function draw_robot(past_positions, chemical_position)
plot(past_positions(:,1), past_positions(:,2), 'k', 'LineWidth', 2)
hold on
plot(past_positions(end,1), past_positions(end,2), 'kx', 'MarkerSize', 18)
plot(chemical_position(1), chemical_position(2), 'k*', 'MarkerSize', 18)

function draw_particle_belief(particles)
%scatter(particles(:,1), particles(:,2), 10, particles(:,3))

%n = sqrt(length(particles));
%contour(reshape(particles(:,1),n,n), reshape(particles(:,2),n,n), reshape(particles(:,3),n,n));
%colorbar

w_sorted = sort(particles(:,3),'descend');
top_w = w_sorted(find(cumsum(w_sorted) < 1/4, 1, 'last'));
bottom_w = w_sorted(find(cumsum(w_sorted) < 1/2, 1, 'last'));
top_inds = particles(:,3) >= top_w;
plot(particles(top_inds,1), particles(top_inds,2), '.r', 'MarkerSize', 5)
mid_inds = top_w > particles(:,3) >= bottom_w;
plot(particles(mid_inds,1), particles(mid_inds,2), '.y', 'MarkerSize', 5)
bottom_inds = particles(:,3) < bottom_w;
plot(particles(bottom_inds,1), particles(bottom_inds,2), '.b', 'MarkerSize', 5)
highest_ind = find(particles(:,3)==w_sorted(1));
plot(particles(highest_ind,1),particles(highest_ind,2),'.g','MarkerSize',5);
title('top 1/4 probability mass is red, next 1/4 is yellow, bottom 1/2 is blue, HIGHEST is green')
 