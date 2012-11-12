function [time,robot_position,robot_pose,sensor_measurements,c_vals] = reformat_raw_log_file(f)
if strcmp(f,'Estimator_Logs/estimator.log') % log from nov 11
    raw_data = dlmread(f, '\t', 1, 0);
    time = raw_data(:,1);
    robot_position = raw_data(:,2:4);
    robot_pose = raw_data(:,5:8);
    sensor_measurements = raw_data(:,13:end);
    sensor_measurements(:,any(sensor_measurements == 0,1)) = [];
    c_vals = raw_data(:,12);
else % logs prior to nov 11
    raw_data = dlmread(f, '\t', 1, 0);
    time = raw_data(2:end,1);
    robot_position = raw_data(2:end,2:4);
    robot_pose = raw_data(2:end,5:8);
    sensor_measurements = raw_data(2:end,22:end);
    sensor_measurements(:,any(sensor_measurements == 0,1)) = [];
    c_vals = raw_data(2:end,21);
end