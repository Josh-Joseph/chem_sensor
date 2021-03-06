function data_analysis

close all

bloodhound_directory_location = '/home/josh/Dropbox/Bloodhound/';

for run = 6
    run_directory = [bloodhound_directory_location 'autonomous-runs_11-12/' num2str(run) '/'];
    [time,robot_position,robot_pose,sensor_measurements,c_vals] = reformat_raw_log_file([run_directory 'estimator.log']);
    switch run
        case 1
            chemical_location = [10.85 -14.4];
            k = -10.8534; q = 0.3748; v = 1.085; measurement_std = .09043;
        case 2
            chemical_location = [-7.23 -14.64];
            k = -10.772533609157081; q = 0.3748; v = 1.085; measurement_std = .09043;
        case 3
            chemical_location = [-3.3 -3.2];
            k = -10.690862495372969; q = 0.3748; v = 1.085; measurement_std = .09043;
        case 4
            chemical_location = [8.05 0.87];
            k = -10.772533609157081; q = 0.3748; v = 1.085; measurement_std = .09043;
        case 5
            chemical_location = [-2.7 -1.3];
            k = -10.690862495372969; q = 0.3748; v = 1.085; measurement_std = .09043;
        case 6
            chemical_location = [-2.4 -1.3];
            chemical_location = [-2 -3.75];
            k = -10.656964357927036; q = 0.3748; v = 1.085; measurement_std = .09043;
            % to correct for that 15th strange data row
            time = time([1:14 16:end]);
            robot_position = robot_position([1:14 16:end],:);
            robot_pose = robot_pose([1:14 16:end],:);
            sensor_measurements = sensor_measurements([1:14 16:end],:);
            c_vals = c_vals([1:14 16:end]);
    end
    
    dist = sqrt(sum(bsxfun(@minus, robot_position(:,1:2), chemical_location).^2, 2));
    
    if 1
        C = c_vals - k;
        f = @(pars) mean((C- (pars(2).*exp(-dist.^2 ./ pars(1).^2)) ).^2);
        options = optimset('MaxIter', 1e20);
        par_est = fminsearch(f, [5 6.2], options);
        v = par_est(1)
        q = par_est(2)
        sqrd_err = f(par_est);
        measurement_std = sqrt(sqrd_err)
    end
    
    f1 = figure;
    subplot(2,1,1)
    for t = 1:length(time)
        plot(dist(t)*ones(1, size(sensor_measurements,2)), sensor_measurements(t,:), '.')
        hold on
    end
    xlim([0 9])
    ylim([1e4 5e4])
    xlabel('distance')
    ylabel('resistance')
    title(['autonomous-runs_11-12/' num2str(run) '/'])
    
    subplot(2,1,2)
    d = linspace(0, max(dist), 100);
    measurement_mu = q * exp(-d.^2 ./ v^2) + k;
    plot(d, measurement_mu, 'm')
    hold on
    plot(d, measurement_mu-measurement_std, '--m')
    plot(d, measurement_mu+measurement_std, 'm--')
    
    plot(dist, c_vals, 'o', 'MarkerSize', 6)
    xlim([0 9])
    ylim([-11 -9])
    xlabel('distance')
    ylabel('C')
    title(['autonomous-runs_11-12/' num2str(run) '/'])
end

    function [time,robot_position,robot_pose,sensor_measurements,c_vals] = reformat_raw_log_file(f)
        raw_data = dlmread(f, '\t', 1, 0);
        time = raw_data(:,1);
        robot_position = raw_data(:,2:4);
        robot_pose = raw_data(:,5:8);
        sensor_measurements = raw_data(:,13:end);
        sensor_measurements(:,any(sensor_measurements == 0,1)) = [];
        c_vals = raw_data(:,12);
    end
end
