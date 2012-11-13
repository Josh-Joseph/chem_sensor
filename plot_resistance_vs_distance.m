close all

all_files = {'2012-11-04_210036','2012-11-05_000525','2012-11-05_001625','2012-11-05_002724','2012-11-06_20-44-48','estimator_run1_2012_11_11','estimator_run2_2012_11_11','estimator_run1_2012_11_12','estimator_run2_2012_11_12','estimator_run3_2012_11_12','estimator_run4_2012_11_12','estimator_run5_2012_11_12'};
all_chemical_positions = {[6.834999847225845 2.642499940935522], [35.42 -6.82], [35.42 -6.82], [35.42 -6.82], [18.08 -14.11], [4.1000 -6.7000], [4.9100 -2.4600], [8.58 0.42], [3.94, -0.10], [10.85 -14.4], [10.85 -14.4], [-7.23 -14.64]};

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
summary_variance = [];

color_i = 1;
if 1
    load TEST_DATA_11_3_12.mat
    measurement_offset = use_measurement_offset*max(sensor2(:));
    all_distances = [all_distances; sqrt((xpos-xpos(end)).^2+(ypos-ypos(end)).^2)];
    all_resistances = [all_resistances; sensor2-measurement_offset];
    all_colors = [all_colors; repmat(color_i, length(sensor2), 1)];
    all_angles = [all_angles; zeros(length(sensor2), 1)];
    color_i = color_i + 1;
end
if 1
    load data1.mat
    measurement_offset = use_measurement_offset*max(sensor2(:));
    all_distances = [all_distances; sqrt((xpos-trueSource(1)).^2+(ypos-trueSource(2)).^2)];
    all_resistances = [all_resistances; sensor2-measurement_offset];
    all_colors = [all_colors; repmat(color_i, length(sensor2), 1)];
    all_angles = [all_angles; zeros(length(sensor2), 1)];
    color_i = color_i + 1;
end
if 1
    load data2.mat
    measurement_offset = use_measurement_offset*max(sensor2(:));
    all_distances = [all_distances; sqrt((xpos-trueSource(1)).^2+(ypos-trueSource(2)).^2)];
    all_resistances = [all_resistances; sensor2-measurement_offset];
    all_colors = [all_colors; repmat(color_i, length(sensor2), 1)];
    all_angles = [all_angles; zeros(length(sensor2), 1)];
    color_i = color_i + 1;
end

for f_i = 1:length(all_files)
    
    f = ['Estimator_Logs/' all_files{f_i} '.log'];
    [time,robot_position,robot_pose,sensor_measurements,c_vals] = reformat_raw_log_file(f);
    
    measurement_offset = use_measurement_offset*max(sensor_measurements(:));
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
    all_colors = [all_colors; repmat(color_i, length(tmp(:)), 1)];
    color_i = color_i + 1;
    
    for j = 1:length(time)
        summary_distances = [summary_distances; sqrt(sum(bsxfun(@minus, robot_position(j,1:2), all_chemical_positions{f_i}).^2, 2))];
        %valid_data = norm_resistances(j,:) < 1e5;
        %summary_mus = [summary_mus; mean(norm_resistances(j,valid_data))];
        %summary_stds = [summary_stds; std(norm_resistances(j,valid_data))];
        valid_data = sensor_measurements(j,:) < 1e5;
        summary_mus = [summary_mus; mean(sensor_measurements(j,valid_data)-measurement_offset)];
        summary_stds = [summary_stds; std(sensor_measurements(j,valid_data))];
        if use_measurement_offset
            summary_c = [summary_c; c_vals(j)-mean(c_vals(1))];
        else
            summary_c = [summary_c; c_vals(j)];
        end
    end
end

%colors = 'bgrcmykbgrcmyk';
%symbols = 'oooooooxxxxxxx';
colors = 'bbbbbbbbbbcmyk';
symbols = '..........xxxx';

% f1 = figure;
% %plot(all_distances, all_resistances, '.')
% for i = 1:length(all_distances)
%     plot(all_distances(i), all_resistances(i), [colors(all_colors(i)) symbols(all_colors(i))], 'MarkerSize', 14)
%     hold on
% end
% xlim([0 10])
% if use_measurement_offset
%     ylim([-4.5e4 1e4])
% else
%     ylim([1.5e4 6.5e4])
% end
% xlabel('distance')
% ylabel('resistance reading')
% 
% if 0
%     figure
%     scatter(all_distances, all_resistances, 15, all_angles)
%     xlim([0 10])
%     ylim([1.5e4 6.5e4])
%     xlabel('distance')
%     ylabel('resistance reading')
% end
% 
% f2 = figure;
% errorbar(summary_distances, summary_mus, summary_stds, '.')
% xlim([0 10])
% if use_measurement_offset
%     ylim([-4.5e4 1e4])
% else
%     ylim([1.5e4 6.5e4])
% end
% xlabel('distance')
% ylabel('resistance reading')
% 
% f4 = figure;
% plot(summary_distances, summary_stds,'.')
% xlabel('distance')
% ylabel('std')
% 
% f5 = figure;
% plot(summary_distances, summary_mus,'.')
% xlabel('distance')
% ylabel('std')


offset = 0;
f3 = figure;

all_dists = [];
all_Cs = [];
load LongTrial_1_data.mat
C = C-mean(C(1));
dist = sqrt(sum(bsxfun(@minus, pos(:,1:2), trueSource).^2, 2));
plot(dist, C+offset, 'or')
all_dists = [all_dists; dist];
all_Cs = [all_Cs; C];
hold on

load LongTrial_2_data.mat
C = C-mean(C(1));
dist = sqrt(sum(bsxfun(@minus, pos(:,1:2), trueSource).^2, 2));
plot(dist, C+offset, 'ob')
hold on

load LongTrial_3_data.mat
C = C-mean(C(1));
dist = sqrt(sum(bsxfun(@minus, pos(:,1:2), trueSource).^2, 2));
plot(dist, C+offset, 'oc')
all_dists = [all_dists; dist];
all_Cs = [all_Cs; C];
hold on

load LongTrial_4_data.mat
C = C-mean(C(1));
dist = sqrt(sum(bsxfun(@minus, pos(:,1:2), trueSource).^2, 2));
plot(dist, C+offset, 'og', 'MarkerSize', 16)
all_dists = [all_dists; dist];
all_Cs = [all_Cs; C];
hold on

load LongTrial_5_data.mat
C = C-mean(C(1));
dist = sqrt(sum(bsxfun(@minus, pos(:,1:2), trueSource).^2, 2));
plot(dist, C+offset, '^m')
all_dists = [all_dists; dist];
all_Cs = [all_Cs; C];
hold on

load LongTrial_6_data.mat
C = C-mean(C(1));
dist = sqrt(sum(bsxfun(@minus, pos(:,1:2), trueSource).^2, 2));
plot(dist, C+offset, '^y', 'MarkerSize', 16)
all_dists = [all_dists; dist];
all_Cs = [all_Cs; C];
hold on

load LongTrial_7_data.mat
C = C-mean(C(1));
dist = sqrt(sum(bsxfun(@minus, pos(:,1:2), trueSource).^2, 2));
plot(dist, C+offset, '^k', 'MarkerSize', 16)
all_dists = [all_dists; dist];
all_Cs = [all_Cs; C];
hold on

dist = all_dists;
C = all_Cs;
%dist = summary_distances;
%C = summary_c;

%f = @(pars) mean((C- (pars(3).*exp(-dist.^2 ./ pars(2).^2)+pars(1)) ).^2);
%options = optimset('MaxIter', 1e20);
%par_est = fminsearch(f, [-17 5 6.2], options);
%k = par_est(1);
%v = par_est(2);
%q = par_est(3);

f = @(pars) mean((C- (pars(2).*exp(-dist.^2 ./ pars(1).^2)) ).^2);
options = optimset('MaxIter', 1e20);
par_est = fminsearch(f, [5 6.2], options);
v = par_est(1);
q = par_est(2);

sqrd_err = f(par_est);
measurement_std = sqrt(sqrd_err);

summary_distances = [summary_distances; all_dists];
summary_c = [summary_c; all_Cs];

v = 1.085;
q = 0.3748;
measurement_std = .09043;

%plot(summary_distances, summary_c+offset, '.k')
hold on
%k = -17; v = 5; q = 6.2;
%q = 1/(sig_hat*sqrt(2*pi)); v = sqrt(2) * sig_hat;
measurement_mu = q * exp(-summary_distances.^2 ./ v^2);
%measurement_mu = normpdf(summary_distances, mu_hat, sig_hat) + k;
plot(summary_distances, measurement_mu+offset, 'dm')
plot(summary_distances, measurement_mu+offset-measurement_std, 'dm')
plot(summary_distances, measurement_mu+offset+measurement_std, 'dm')
xlim([0 10])
%ylim([2e4 7e4])
xlabel('distance')
ylabel('C')


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







































