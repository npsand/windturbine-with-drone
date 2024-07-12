blades = {"B1", "B2", "B3"};
points_per_blade = 10;

results = table([], [], [], [], [], 'VariableNames', {'Name', 'Time', 'x', 'y', 'z'});

for blade_number = 1:length(blades)
    blade = blades{blade_number};
    
    blade_data = eval(['out.pos_' num2str(blade) '.signals.values']);
    
    for time_entry = 1:(simT + 1)
        all_blade_points_per_one_time = blade_data(:,:,time_entry);
        
        point = 1;
        point_index = 1;
        while point <= (points_per_blade * 3)
            point_name = [blade '_T' num2str(point_index)];
            
            x_point = all_blade_points_per_one_time(point);
            y_point = all_blade_points_per_one_time(point + 1);
            z_point = all_blade_points_per_one_time(point + 2);
            
            new_row = {char(point_name), time_entry, x_point, y_point, z_point};
            results = [results; new_row];
            
            point = point + 3;
            point_index = point_index + 1;
        end
    end
end

results = sortrows(results, 'Time');

disp(results);
