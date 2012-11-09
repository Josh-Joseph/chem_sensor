function particles = visualize_particle_filtering

fname = 'Estimator_Logs/2012-11-04_210036.log'; chemical_position = [6.834999847225845 2.642499940935522];
%fname = 'Estimator_Logs/2012-11-05_000525.log'; chemical_position = [35.42 -6.82];
%fname = 'Estimator_Logs/2012-11-05_001625.log'; chemical_position = [35.42 -6.82];
%fname = 'Estimator_Logs/2012-11-05_002724.log'; chemical_position = [35.42 -6.82];
%fname = 'Estimator_Logs/2012-11-06_20-44-48.log'; chemical_position = [18.08 -14.11];

% Read in Estimator Log
[time,pos,posquat,mu,sigma,trace,C,newData,mean_resistance] = Estimator2Mat(fname);

x_bounds = [.9*min([chemical_position(1); pos(:,1)]) 1.1*max([chemical_position(1); pos(:,1)])]; y_bounds = [1.1*min([chemical_position(2); pos(:,2)]) .9*max([chemical_position(2); pos(:,2)])];

% particle filter initialization
n = 50; x = linspace(x_bounds(1), x_bounds(2), n); y = linspace(y_bounds(1), y_bounds(2), n);
[X, Y] = meshgrid(x, y);
particles = [X(:) Y(:) ones(n^2, 1)/n^2];

% kalman filter initialization
mu_est = [15 -15]; cov_est = diag([10 10]);

for t = 2:size(time)
    % robot, look at the world
    robot_position = pos(t,1:2);
    robot_measurement = C(t);
    
    % draw robot position
    clf;
    draw_robot(pos(1:t,1:2), chemical_position);
    xlim(x_bounds);
    ylim(y_bounds);
    
    % apply the particle filter and draw the belief
    particles = particle_filter(robot_position, robot_measurement, particles);
    
    % apply the kalman filter and draw the belief
    %[mu_est, cov_est] = kalman_filter(robot_position, robot_measurement, mu_est, cov_est);
    
    pause;
end

function draw_robot(past_positions, chemical_position)
plot(past_positions(:,1), past_positions(:,2), 'k', 'LineWidth', 1)
hold on
plot(past_positions(end,1), past_positions(end,2), 'kx', 'MarkerSize', 14)
plot(chemical_position(1), chemical_position(2), 'kd', 'MarkerSize', 14)

function [mu_est, cov_est] = kalman_filter(robot_position, robot_measurement, mu_est, cov_est)
% predict step
particles = kalman_predict(mu_est, cov_est);

% update step

% draw the robot's belief about the chemical source
draw_particle_belief(particles);

function [mu_est, cov_est] = kalman_predict(mu_est, cov_est)
% not using this yet
process_std = 0;

function particles = particle_filter(robot_position, robot_measurement, particles)
% propogate particles
particles = propogate_particles(particles);

% weight measurement by observation
distances = sqrt(sum(bsxfun(@minus, particles(:,1:2), robot_position).^2, 2));
particles(:,3) = prob_C_given_distance(robot_measurement, distances) .* particles(:,3);

% re-normalize particle weights
particles(:,3) = particles(:,3) / sum(particles(:,3));

% draw the robot's belief about the chemical source
draw_particle_belief(particles);

function particles = propogate_particles(particles)
% not using this yet
process_std = 0;

function p = prob_C_given_distance(c, distance)
measurement_std = 10;
k = -17; v = 5; q = 6.2;
measurement_mu = q * exp(-distance / v^2) + k;
p = normpdf(c, measurement_mu, measurement_std);

function draw_particle_belief(particles)
scatter(particles(:,1), particles(:,2), 10, particles(:,3))
hold on



