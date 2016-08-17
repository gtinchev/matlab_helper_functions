function [ ] = run1_results( fovision_pose_body, loam_pose_body, gps_enu)
%MAIN The main function for interpolating and plotting
    fovis = [fovision_pose_body(:,1) - fovision_pose_body(1,1),fovision_pose_body(:,2:11)];
    fovis = convert_to_associatable_format(fovis);
    
    loam = [loam_pose_body(:,1) - loam_pose_body(1,1),loam_pose_body(:,2:4), loam_pose_body(:,6:8), loam_pose_body(:,5), loam_pose_body(:,9:11)];
    gps = [gps_enu(:,1) - gps_enu(1,1), gps_enu(:,2)-gps_enu(1,2), gps_enu(:,3)-gps_enu(1,3), gps_enu(:,2:8)];
    
%     figure;
%     hold on;
%     plot(fovis(:,2), fovis(:,3), '.', 'Color', 'b');
%     plot(gps(:,2), gps(:,3), '.', 'Color', 'r');
%     plot(loam(:,2), loam(:,3), '.', 'Color', 'g');
%     title('Trajectories');
%     xlabel('South');
%     ylabel('West');
%     legend('FOVIS', 'GPS', 'LOAM MS');
%     
%     figure;
%     hold on;
%     plot(fovis(:,1), fovis(:,3), '.', 'Color', 'b');
%     plot(gps(:,1), gps(:,3), '.', 'Color', 'r');
%     plot(loam(:,1), loam(:,3), '.', 'Color', 'g');
%     title('Time against West');
%     xlabel('Time [s]');
%     ylabel('West');
%     
%     figure;
%     hold on;
%     plot(fovis(:,1), fovis(:,2), '.', 'Color', 'b');
%     plot(gps(:,1), gps(:,2), '.', 'Color', 'r');
%     plot(loam(:,1), loam(:,2), '.', 'Color', 'g');
%     title('Time against South');
%     xlabel('Time [s]');
%     ylabel('South');
    
    % filter gps
    [filtered_gps_run1_151, filtered_gps_run1_201, filtered_gps_run1_251] = filter_gps_data(gps, 0, 0, 1);
    
    figure;
    hold on;
    plot(fovis(:,2), fovis(:,3), '.', 'Color', 'b');
    plot(filtered_gps_run1_151(:,2), filtered_gps_run1_151(:,3), '.', 'Color', 'r');
    plot(loam(:,2), loam(:,3), '.', 'Color', 'g');
    title('Trajectories with filtered GPS');
    xlabel('South');
    ylabel('West');
    legend('FOVIS', 'GPS', 'LOAM MS');
    
    figure;
    hold on;
    plot(fovis(:,1), fovis(:,3), '.', 'Color', 'b');
    plot(filtered_gps_run1_151(:,1), filtered_gps_run1_151(:,3), '.', 'Color', 'r');
    plot(loam(:,1), loam(:,3), '.', 'Color', 'g');
    title('Time against West with filtered GPS');
    xlabel('Time [s]');
    ylabel('West');
    
    figure;
    hold on;
    plot(fovis(:,1), fovis(:,2), '.', 'Color', 'b');
    plot(filtered_gps_run1_151(:,1), filtered_gps_run1_151(:,2), '.', 'Color', 'r');
    plot(loam(:,1), loam(:,2), '.', 'Color', 'g');
    title('Time against South with filtered GPS');
    xlabel('Time [s]');
    ylabel('South');
    
    % interpolate
    gps_interpolated_151 = interpolate_measurements(filtered_gps_run1_151, 1);
    gps_interpolated_201 = interpolate_measurements(filtered_gps_run1_201, 1);
    gps_interpolated_251 = interpolate_measurements(filtered_gps_run1_251, 1);
    
    fovis_interpolated = interpolate_measurements(fovis, 1);
    loam_interpolated = interpolate_measurements(loam, 1);
    
    % save to files
    spath = '/home/edbot/Documents/Husky/Results/george-square-west-2016-07-13/run1/';
    
    dlmwrite(strcat(spath,'fovis_xyzqxqyqzqw.txt'), fovis,'delimiter',' ', 'precision','%.6f');
    dlmwrite(strcat(spath,'loam_xyzqxqyqzqw.txt'), loam,'delimiter',' ', 'precision','%.6f');
    
    dlmwrite(strcat(spath,'gps_interpolated_151.txt'), gps_interpolated_151,'delimiter',' ', 'precision','%.6f');
    dlmwrite(strcat(spath,'gps_interpolated_201.txt'), gps_interpolated_201,'delimiter',' ', 'precision','%.6f');
    dlmwrite(strcat(spath,'gps_interpolated_251.txt'), gps_interpolated_251,'delimiter',' ', 'precision','%.6f');
    
    dlmwrite(strcat(spath,'fovis_interpolated.txt'), fovis_interpolated,'delimiter',' ', 'precision','%.6f');
    dlmwrite(strcat(spath,'loam_interpolated.txt'), loam_interpolated,'delimiter',' ', 'precision','%.6f');
    
    % call the python scripts for evaluating trajectories
    rpe = 'python /home/edbot/Documents/Husky/evaluation_tools/evaluate_rpe.py ';
    ate = 'python /home/edbot/Documents/Husky/evaluation_tools/evaluate_ate.py ';
    gpsInt151Str = [spath 'gps_interpolated_151.txt '];
    gpsInt201Str = [spath 'gps_interpolated_201.txt '];
    gpsInt251Str = [spath 'gps_interpolated_251.txt '];
    
    fovisIntStr = [spath 'fovis_interpolated.txt '];
    loamIntStr = [spath 'loam_interpolated.txt '];
    verb = '--verbose ';
    pl_ate = ['--plot ' spath 'comparison/ate/'];
    pl_rpe = ['--plot ' spath 'comparison/rpe/fovis_loam '];
    fixed_delta = '--fixed_delta --delta_unit s --delta 1';
    
    % ATE
    
    % loam_151
    ateStr = strcat([ate gpsInt151Str loamIntStr verb pl_ate 'loam_151.eps']);
    [status, commandOut] = system(ateStr);
    if status==0
        dlmwrite(strcat(spath,'comparison/ate/loam_151.txt'), commandOut,'delimiter','');
    end
    
    % loam_201
    ateStr = strcat([ate gpsInt201Str loamIntStr verb pl_ate 'loam_201.eps']);
    [status, commandOut] = system(ateStr);
    if status==0
        dlmwrite(strcat(spath,'comparison/ate/loam_201.txt'), commandOut,'delimiter','');
    end
    
    % loam_251
    ateStr = strcat([ate gpsInt251Str loamIntStr verb pl_ate 'loam_251.eps']);
    [status, commandOut] = system(ateStr);
    if status==0
        dlmwrite(strcat(spath,'comparison/ate/loam_251.txt'), commandOut,'delimiter','');
    end
    
    % fovis_151
    ateStr = strcat([ate gpsInt151Str fovisIntStr verb pl_ate 'fovis_151.eps']);
    [status, commandOut] = system(ateStr);
    if status==0
        dlmwrite(strcat(spath,'comparison/ate/fovis_151.txt'), commandOut,'delimiter','');
    end
    
    % fovis_201
    ateStr = strcat([ate gpsInt201Str fovisIntStr verb pl_ate 'fovis_201.eps']);
    [status, commandOut] = system(ateStr);
    if status==0
        dlmwrite(strcat(spath,'comparison/ate/fovis_201.txt'), commandOut,'delimiter','');
    end
    
    % fovis_251
    ateStr = strcat([ate gpsInt251Str fovisIntStr verb pl_ate 'fovis_251.eps']);
    [status, commandOut] = system(ateStr);
    if status==0
        dlmwrite(strcat(spath,'comparison/ate/fovis_251.txt'), commandOut,'delimiter','');
    end
    
    % rpe
    rpeStr = strcat([rpe fovisIntStr loamIntStr verb pl_rpe fixed_delta]);
    
    [status, commandOut] = system(rpeStr);
    if status==0
        dlmwrite(strcat(spath,'comparison/rpe/fovis_loam.txt'), commandOut,'delimiter','');
    end

    % plot rpy
    plot_rpy(fovision_pose_body, loam_pose_body, ' Loop 1');

end

