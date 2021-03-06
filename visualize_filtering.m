function visualize_filtering

use_particle_filter = true;

%fname = 'Estimator_Logs/2012-11-04_210036.log'; chemical_position = [6.834999847225845 2.642499940935522];
%fname = 'Estimator_Logs/2012-11-05_000525.log'; chemical_position = [35.42 -6.82];
%fname = 'Estimator_Logs/2012-11-05_001625.log'; chemical_position = [35.42 -6.82];
%fname = 'Estimator_Logs/2012-11-05_002724.log'; chemical_position = [35.42 -6.82];
fname = 'Estimator_Logs/2012-11-06_20-44-48.log'; chemical_position = [18.08 -14.11];
% Read in Estimator Log
[time,pos,~,~,~,~,C,~] = Estimator2Mat_old(fname);

fname = 'Estimator_Logs/estimator_run1_2012_11_11.log'; chemical_position = [4.1000 -6.7000];
%fname = 'Estimator_Logs/estimator_run2_2012_11_11.log'; chemical_position = [4.9100 -2.4600];
%fname = 'Estimator_Logs/estimator_run1_2012_11_12.log'; chemical_position = [8.58 0.42];
%fname = 'Estimator_Logs/estimator_run2_2012_11_12.log'; chemical_position = [3.94, -0.10];
dirname = '/home/josh/Dropbox/Bloodhound/autonomous-runs_11-12/6/';
fname = [dirname 'estimator.log']; fname_particles = [dirname 'particles.log']; chemical_position = [-2.7 -1.3];
[time,pos,~,~,C,~] = Estimator2Mat(fname);
% to correct for that 15th strange data row
time = time([1:14 16:end]);
pos = pos([1:14 16:end],:);
C = C([1:14 16:end]);

close all

process_std = 0;
measurement_std = 0.3830;
%k = -17; v = 5; q = 6.2;
k = -10.8534; v = 1.1386; q = .383;


x_bounds = [min([chemical_position(1); pos(:,1)])-5 max([chemical_position(1); pos(:,1)])+5];
y_bounds = [min([chemical_position(2); pos(:,2)])-5 max([chemical_position(2); pos(:,2)])+5];

% particle filter initialization
n = 75; x = linspace(x_bounds(1), x_bounds(2), n)'; y = linspace(y_bounds(1), y_bounds(2), n)';
[X, Y] = meshgrid(x, y);
particles = [X(:) Y(:) ones(n^2, 1)/n^2];

% kalman filter initialization
%mu_est = [pos(1,1); pos(1,2)]; 
mu_est = chemical_position'; 
cov_est = diag([10 10]);

for t = 2:size(time)
    % robot, look at the world
    robot_position = pos(t,1:2);
    robot_measurement = C(t);
    %robot_measurement = ideal_measurement(robot_position, chemical_position);
    
    % draw robot position
    clf;
    draw_robot(pos(1:t,1:2), chemical_position);
    xlim(x_bounds);
    ylim(y_bounds);
    
    if use_particle_filter % apply the particle filter and draw the belief
        particles = particle_filter(robot_position, robot_measurement, particles);
    else % apply the kalman filter and draw the belief
        [mu_est, cov_est] = kalman_filter(robot_position, robot_measurement, mu_est, cov_est);
    end
    
    pause;
end

    function draw_robot(past_positions, chemical_position)
        plot(past_positions(:,1), past_positions(:,2), 'k', 'LineWidth', 2)
        hold on
        plot(past_positions(end,1), past_positions(end,2), 'kx', 'MarkerSize', 14)
        plot(chemical_position(1), chemical_position(2), 'kd', 'MarkerSize', 14)
    end

    function [mu_est, cov_est] = kalman_filter(robot_position, robot_measurement, mu_est, cov_est)
        % predict step
        [mu_est, cov_est] = kalman_predict(mu_est, cov_est);
        
        % update step
        [mu_est, cov_est] = kalman_update(mu_est, cov_est, robot_position, robot_measurement)
        
        % draw the robot's belief about the chemical source
        draw_gaussian_belief(mu_est, cov_est);
    end

    function [mu_est, cov_est] = kalman_predict(mu_est, cov_est)
        % not using this yet
        process_std;
    end

    function [mu_est, cov_est] = kalman_update(mu_est, cov_est, robot_position, robot_measurement)
        H = compute_jacobian(robot_position, mu_est');
        innovation = robot_measurement - ideal_measurement(robot_position, mu_est');
        S = H * cov_est * H' + measurement_std^2;
        K = cov_est * H' * (1/S);
        mu_est = mu_est + K * innovation;
        cov_est = (eye(2) - K * H) * cov_est;
    end

    function H = compute_jacobian(robot_position, chemical_position)
        distances = sqrt(sum(bsxfun(@minus, chemical_position, robot_position).^2, 2));
        dGdx = q .* exp(-distances.^2 ./ v^2) .* (-distances.^2 ./ v^2);
        H = [dGdx dGdx];
    end

    function draw_gaussian_belief(mu_est, cov_est)
        p = mvnpdf([X(:) Y(:)], mu_est', cov_est);
        contour(X, Y, reshape(p,n,n))
    end

    function particles = particle_filter(robot_position, robot_measurement, particles)
        % propogate particles
        particles = propogate_particles(particles);
        
        % weight measurement by observation
        particles(:,3) = prob_C_given_distance(robot_measurement, robot_position, particles) .* particles(:,3);
        
        % re-normalize particle weights
        particles(:,3) = particles(:,3) ./ sum(particles(:,3));
        
        % draw the robot's belief about the chemical source
        draw_particle_belief(particles);
    end

    function particles = propogate_particles(particles)
        % not using this yet
        process_std;
    end

    function measurement_mu = ideal_measurement(robot_position, chemical_position)
        distances = sqrt(sum(bsxfun(@minus, chemical_position, robot_position).^2, 2));
        measurement_mu = q .* exp(-distances.^2 ./ v^2) + k;
    end

    function p = prob_C_given_distance(c, robot_position, particles)
        measurement_mu = ideal_measurement(robot_position, particles(:,1:2));
        p = normpdf(c, measurement_mu, measurement_std);
    end

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
        title('top 1/4 probability mass is red, next 1/4 is yellow, bottom 1/2 is blue')
    end

end

