function [ output_args ] = plot_rpy( input_pose_body, loop )
%PLOT_RPY Summary of this function goes here
%   Detailed explanation goes here
    input_pose_body(:,9:11) = rad2deg(input_pose_body(:,9:11));
    figure;
    arr = input_pose_body;
    arr(:,1) = arr(:,1) - arr(1,1);
    plot(arr(:,1), arr(:,9));
    title(strcat('Roll Plot', loop));
    xlabel('Time [s]');
    ylabel('Roll');
    
    figure;
    plot(arr(:,1), arr(:,10));
    title(strcat('Pitch Plot', loop))
    xlabel('Time [s]');
    ylabel('Pitch');
    
    figure;
    plot(arr(:,1), arr(:,11));
    title(strcat('Yaw Plot', loop));
    xlabel('Time [s]');
    ylabel('Yaw');

end

