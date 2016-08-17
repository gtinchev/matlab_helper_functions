function [ ] = run3_results( fovision_pose_body, loam_pose_body)
%MAIN The main function for interpolating and plotting
    seconds_converter = 10^6;
    fovision_pose_body(:,1) = fovision_pose_body(:,1)/seconds_converter;
    fovis = [(fovision_pose_body(:,1) - fovision_pose_body(1,1)),fovision_pose_body(:,2:11)];
    fovis = convert_to_associatable_format(fovis);
    
    loam = [loam_pose_body(:,1) - loam_pose_body(1,1), loam_pose_body(:,2)*(-1), loam_pose_body(:,3)*(-1), loam_pose_body(:,4), loam_pose_body(:,6:8), loam_pose_body(:,5), loam_pose_body(:,9:11)];
    
    figure;
    hold on;
    plot(fovis(:,2), fovis(:,3), '.', 'Color', 'b');
    plot(loam(:,2), loam(:,3), '.', 'Color', 'g');
    title('Trajectories');
    xlabel('x');
    ylabel('y');
    legend('FOVIS', 'LOAM MS');
    
    figure;
    hold on;
    plot(fovis(:,1), fovis(:,3), '.', 'Color', 'b');
    plot(loam(:,1), loam(:,3), '.', 'Color', 'g');
    xlabel('x');
    ylabel('y');
    legend('FOVIS', 'LOAM MS');
    
    figure;
    hold on;
    plot(fovis(:,1), fovis(:,2), '.', 'Color', 'b');
    plot(loam(:,1), loam(:,2), '.', 'Color', 'g');
    xlabel('x');
    ylabel('y');
    legend('FOVIS', 'LOAM MS');
    
    fovis_interpolated = interpolate_measurements(fovis, 1);
    loam_interpolated = interpolate_measurements(loam, 1);
    
    % save to files
    spath = '/home/edbot/Documents/Husky/Results/george-square-west-2016-07-13/run3/';
    
    dlmwrite(strcat(spath,'fovis_xyzqxqyqzqw.txt'), fovis,'delimiter',' ', 'precision','%.6f');
    dlmwrite(strcat(spath,'loam_xyzqxqyqzqw.txt'), loam,'delimiter',' ', 'precision','%.6f');
        
    dlmwrite(strcat(spath,'fovis_interpolated.txt'), fovis_interpolated,'delimiter',' ', 'precision','%.6f');
    dlmwrite(strcat(spath,'loam_interpolated.txt'), loam_interpolated,'delimiter',' ', 'precision','%.6f');
    
    % call the python scripts for evaluating trajectories
    rpe = 'python /home/edbot/Documents/Husky/evaluation_tools/evaluate_rpe.py ';
    ate = 'python /home/edbot/Documents/Husky/evaluation_tools/evaluate_ate.py ';
      
    fovisIntStr = [spath 'fovis_interpolated.txt '];
    loamIntStr = [spath 'loam_interpolated.txt '];
    verb = '--verbose ';
    pl_ate = ['--plot ' spath 'comparison/ate/'];
    pl_rpe = ['--plot ' spath 'comparison/rpe/fovis_loam '];
    fixed_delta = '--fixed_delta --delta_unit s --delta 1';
    
    % rpe
    rpeStr = strcat([rpe fovisIntStr loamIntStr verb pl_rpe fixed_delta]);
    
    [status, commandOut] = system(rpeStr);
    if status==0
        dlmwrite(strcat(spath,'comparison/rpe/fovis_loam.txt'), commandOut,'delimiter','');
    end

    % plot rpy
    plot_rpy(fovision_pose_body, loam_pose_body, ' Loop 3');

end

