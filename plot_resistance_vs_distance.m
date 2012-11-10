close all

all_files = {'2012-11-04_210036','2012-11-05_000525','2012-11-05_001625','2012-11-05_002724','2012-11-06_20-44-48'};
all_chemical_positions = {[6.834999847225845 2.642499940935522], [35.42 -6.82], [35.42 -6.82], [35.42 -6.82], [18.08 -14.11]};

use_measurement_offset = true;

all_distances = [];
all_resistances = [];
all_angles = [];
all_colors = [];
summary_distances = [];
summary_mus = [];
summary_stds = [];
summary_colors = [];
summary_c = [];

for f_i = 1:length(all_files)
    f = ['Estimator_Logs/' all_files{f_i} '.log'];
    [time,robot_position,robot_pose,sensor_measurements,c_vals] = reformat_raw_log_file(f);
    
    measurement_offset = use_measurement_offset*sensor_measurements(1);
    these_angles = [];
    for j = 1:length(time)
        tmp = robot_position(j,1:2) - all_chemical_positions{f_i};
        angle = atan2(tmp(2), tmp(1));
        q = qGetRotQuaternion(angle, [0, 0, 1]);
        q_diff = qMul(qConj(q), robot_pose(j,:)');
        these_angles = [these_angles; abs(q2angle(q_diff))];
    end
    these_angles = repmat(these_angles, 1, size(sensor_measurements,2));
    all_angles = [all_angles; these_angles(:)];
    
    tmp = repmat(sqrt(sum(bsxfun(@minus, robot_position(:,1:2), all_chemical_positions{f_i}).^2, 2)), 1, size(sensor_measurements,2));
    all_distances = [all_distances; tmp(:)];
    norm_resistances = bsxfun(@minus, sensor_measurements, sensor_measurements(1,:));
    %all_resistances = [all_resistances; norm_resistances(:)];
    all_resistances = [all_resistances; sensor_measurements(:)-measurement_offset];
    all_colors = [all_colors; repmat(f_i, length(tmp(:)), 1)];
    
    for j = 1:length(time)
        summary_distances = [summary_distances; sqrt(sum(bsxfun(@minus, robot_position(j,1:2), all_chemical_positions{f_i}).^2, 2))];
        %valid_data = norm_resistances(j,:) < 1e5;
        %summary_mus = [summary_mus; mean(norm_resistances(j,valid_data))];
        %summary_stds = [summary_stds; std(norm_resistances(j,valid_data))];
        valid_data = sensor_measurements(j,:) < 1e5;
        summary_mus = [summary_mus; mean(sensor_measurements(j,valid_data)-measurement_offset)];
        summary_stds = [summary_stds; std(sensor_measurements(j,valid_data)-measurement_offset)];
        if use_measurement_offset
            summary_c = [summary_c; c_vals(j)-c_vals(1)];
        else
            summary_c = [summary_c; c_vals(j)];
        end
    end
end

colors = 'bgrcmyk';

if 1
    load TEST_DATA_11_3_12.mat
    measurement_offset = use_measurement_offset*mean(sensor2(1:30));
    all_distances = [all_distances; sqrt((xpos-xpos(end)).^2+(ypos-ypos(end)).^2)];
    all_resistances = [all_resistances; sensor2-measurement_offset];
    all_colors = [all_colors; repmat(max(all_colors)+1, length(sensor2), 1)];
    all_angles = [all_angles; zeros(length(sensor2), 1)];
end

f1 = figure;
plot(all_distances, all_resistances, '.')
hold on
xlim([0 10])
if use_measurement_offset
    ylim([-4.5e4 1e4])
else
    ylim([-3e4 2e4])
end
xlabel('distance')
ylabel('resistance reading')
for i = 1:length(all_distances)
    plot(all_distances(i), all_resistances(i), ['.' colors(all_colors(i))])
end
%load TEST_DATA_11_3_12.mat
%%plot(sqrt((xpos-xpos(end)-mean(xpos(1:30))).^2+(ypos-ypos(end)-mean(ypos(1:30))).^2), sensor2, ['.' colors(max(all_colors)+1)])
%plot(sqrt((xpos-xpos(end)).^2+(ypos-ypos(end)).^2), sensor2, ['.' colors(max(all_colors)+1)])

if 0
    figure
    scatter(all_distances, all_resistances, 15, all_angles)
    xlim([0 10])
    ylim([1.5e4 6.5e4])
    xlabel('distance')
    ylabel('resistance reading')
end

f2 = figure;
errorbar(summary_distances, summary_mus, summary_stds, '.')
xlim([0 10])
if use_measurement_offset
    ylim([-4.5e4 1e4])
else
    ylim([-3e4 2e4])
end
xlabel('distance')
ylabel('resistance reading')

f3 = figure;
plot(summary_distances, summary_c, '.')
hold on
%k = -17; v = 5; q = 6.2;
k = -10.75; v = 1; q = .75;
measurement_mu = q * exp(-summary_distances.^2 ./ v^2) + k;
plot(summary_distances, measurement_mu, '.r')
xlim([0 10])
%ylim([2e4 7e4])
xlabel('distance')
ylabel('resistance reading')

% f1 = figure;
% plot([-1 7], [1e4 7e4], '.')
% hold on
% ylim([2e4 6e4])
% xlim([0 6])
% f2 = figure;
% plot([-1 7], [1e4 7e4], '.')
% hold on
% ylim([2e4 6e4])
% xlim([0 6])
% 
% for f_i = 1:length(all_files)
%     f = ['Estimator_Logs/' all_files{f_i} '.log'];
%     [time,robot_position,robot_pose,sensor_measurements] = reformat_raw_log_file(f);
%     tmp = repmat(sqrt(sum(bsxfun(@minus, robot_position(:,1:2), all_chemical_positions{f_i}).^2, 2)), 1, size(sensor_measurements,2));
%     
%     figure(f1)
%     plot(tmp(:), sensor_measurements(:), '.')
%     
%     figure(f2)
%     for j = 1:length(time)
%         summary_distances = [summary_distances; sqrt(sum(bsxfun(@minus, robot_position(j,1:2), all_chemical_positions{f_i}).^2, 2))];
%         valid_data = sensor_measurements(j,:) < 1e5;
%         errorbar(sqrt(sum(bsxfun(@minus, robot_position(j,1:2), all_chemical_positions{f_i}).^2, 2)), ...
%             mean(sensor_measurements(j,valid_data)), std(sensor_measurements(j,valid_data)), '.')
%     end
% end
% 
% 







































