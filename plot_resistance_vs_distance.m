%close all

all_files = {'2012-11-04_210036','2012-11-05_000525','2012-11-05_001625','2012-11-05_002724','2012-11-06_20-44-48'};
all_chemical_positions = {[6.834999847225845 2.642499940935522], [35.42 -6.82], [35.42 -6.82], [35.42 -6.82], [18.08 -14.11]};

distances = [];
resistances = [];

for f_i = 1:length(all_files)
    [time,pos,posquat,mu,sigma,trace,C,newData,mean_resistance] = Estimator2Mat(['Estimator_Logs/' all_files{f_i} '.log']);
    distances = [distances; sqrt(sum(bsxfun(@minus, pos(2:end,1:2), all_chemical_positions{f_i}).^2, 2))];
    resistances = [resistances; mean_resistance(2:end)];
end

figure
plot(distances, resistances, '.')