function [ output_args ] = plot_rpy( fovis, loam, loop )
%PLOT_RPY Summary of this function goes here
%   Detailed explanation goes here
    fovis(:,9:11) = rad2deg(fovis(:,9:11));
    loam(:,9:11) = rad2deg(loam(:,9:11));
    
    
    f_arr = fovis;
    f_arr(:,1) = f_arr(:,1) - f_arr(1,1);
    l_arr = loam;
    l_arr(:,1) = l_arr(:,1) - l_arr(1,1);
    
    figure;
    hold on;
    plot(f_arr(:,1), f_arr(:,9));
    plot(l_arr(:,1), l_arr(:,9), 'Color', 'r');
    title(strcat('Roll Plot', loop));
    xlabel('Time [s]');
    ylabel('Roll [deg]');
    legend('FOVIS', 'LOAM');
    axis equal;
    
    figure;
    hold on;
    plot(f_arr(:,1), f_arr(:,10));
    plot(l_arr(:,1), l_arr(:,10), 'Color', 'r');
    title(strcat('Pitch Plot', loop))
    xlabel('Time [s]');
    ylabel('Pitch [deg]');
    legend('FOVIS', 'LOAM');
    axis equal;
    
    figure;
    hold on;
    plot(f_arr(:,1), f_arr(:,11));
    plot(l_arr(:,1), l_arr(:,11), 'Color', 'r');
    title(strcat('Yaw Plot', loop));
    xlabel('Time [s]');
    ylabel('Yaw [deg]');
    legend('FOVIS', 'LOAM');
    axis equal;

end

