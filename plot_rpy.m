function [] = plot_rpy( fovis, loam, loop, x_threshold,y_threshold, fix_loam )
%PLOT_RPY Summary of this function goes here
%   Detailed explanation goes here
    fovis(:,9:11) = rad2deg(fovis(:,9:11));
    loam(:,9:11) = rad2deg(loam(:,9:11));

    figure;
    hold on;
    plot(fovis(:,1), fovis(:,9));
    plot(loam(:,1), loam(:,9), 'Color', 'r');
    title(strcat('Roll Plot', loop));
    xlabel('Time [s]');
    ylabel('Roll [deg]');
    legend('FOVIS', 'LOAM');
    axis equal;
    
    figure;
    hold on;
    plot(fovis(:,1), fovis(:,10));
    plot(loam(:,1), loam(:,10), 'Color', 'r');
    title(strcat('Pitch Plot', loop))
    xlabel('Time [s]');
    ylabel('Pitch [deg]');
    legend('FOVIS', 'LOAM');
    axis equal;
    
    figure;
    hold on;
    plot(fovis(:,1), fovis(:,11));
    plot(loam(:,1), loam(:,11), 'Color', 'r');
    title(strcat('Yaw Plot', loop));
    xlabel('Time [s]');
    ylabel('Yaw [deg]');
    legend('FOVIS', 'LOAM');
    axis equal;
    
    % relative plots
    f_2 = fovis;
    l_2 = loam;
    
    l_2(:,9) = l_2(:,9) - l_2(1,9);
    f_2(:,9) = f_2(:,9) - f_2(1,9);
    
    l_2(:,10) = l_2(:,10) - l_2(1,10);
    f_2(:,10) = f_2(:,10) - f_2(1,10);
    
    % yaw
    % if it's minus sign - 
    indexes = find(fovis(:,11)<y_threshold & fovis(:,1)>x_threshold);
    
    for i=1:length(indexes)
        if f_2(indexes(i),11) > 0
            f_2(indexes(i),11) = f_2(indexes(i),11)+360;
        else
            f_2(indexes(i),11) = abs(mod(fovis(indexes(i),11),(fovis(indexes(i), 11)/abs(fovis(indexes(i), 11)))*(-1)*180))+180;
        end
    end
    
    indexes_l = find(loam(:,11)<y_threshold & loam(:,1)>x_threshold);
    
    if fix_loam
        for i=1:length(indexes_l)
            if l_2(indexes_l(i),11) > 0
                l_2(indexes_l(i),11) = l_2(indexes_l(i),11)+360;
            else
                l_2(indexes_l(i),11) = abs(mod(loam(indexes_l(i),11),(loam(indexes_l(i), 11)/abs(loam(indexes_l(i), 11)))*(-1)*180))+180;
            end
        end
    end
    
    f_2(:,11) = f_2(:,11) - f_2(2,11);
    l_2(:,11) = l_2(:,11) - l_2(2,11);
    
    figure;
    hold on;
    plot(f_2(:,1), f_2(:,11));
    plot(l_2(:,1), l_2(:,11), 'Color', 'r');
    title(strcat('Aligned Yaw Plot', loop));
    xlabel('Time [s]');
    ylabel('Yaw [deg]');
    legend('FOVIS', 'LOAM');
    axis equal;
    
    
    % find closest index
    for i=1:length(l_2)
        if i < length(l_2)-1
            
            % first value
            [~, idx] = min(abs(f_2(:,1) - l_2(i,1)));
            closest_value_in_fovis = f_2(idx,:);

            % next value
            j = i+1;
            next_value_fovis = f_2(idx+1,:);
            
            % compute the difference in roll pitch and yaw
            rel_l(1:3) = [l_2(j,9) - l_2(i,9),l_2(j,10) - l_2(i,10), l_2(j,11) - l_2(i,11)];
            % compute the difference in roll from LOAM
            rel_f(1:3) = [next_value_fovis(1,9) - closest_value_in_fovis(1,9),closest_value_in_fovis(1,10) - next_value_fovis(1,10),next_value_fovis(1,11) - closest_value_in_fovis(1,11)];
            
            
            % compute the difference between two measurements from FOVIS
            % compute the error
            % s, r, p, y
            rel_rpy(i, 1:4) = [l_2(i,1), abs(rel_l(1)-rel_f(1)),abs(rel_l(2)-rel_f(2)),abs(rel_l(3)-rel_f(3))];
        end
    end
    
    % roll
    figure;
    plot(rel_rpy(:,1), rel_rpy(:,2)); % roll
    title('Relative Roll Error');
    xlabel('Time [s]');
    ylabel('Relative Roll Error [deg]');
    axis equal;
    
    % pitch
    figure;
    plot(rel_rpy(:,1), rel_rpy(:,3));
    title('Relative Pitch Error');
    xlabel('Time [s]');
    ylabel('Relative Roll Error [deg]');
    axis equal;
    
    % yaw
    figure;
    plot(rel_rpy(:,1), rel_rpy(:,4));
    title('Relative Yaw Error');
    xlabel('Time [s]');
    ylabel('Relative Yaw Error [deg]');
    axis equal;

end

