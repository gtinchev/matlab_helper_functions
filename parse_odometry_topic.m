function [ pose_arr ] = parse_odometry_topic( input_file )
%parse_odometry_topic Given a file of the odometry topic, parses the
%position in (x,y,z) and orientation in quaternions (x,y,z,w)
%   TODO: Detailed explanation goes here
    
    % increase the decimal point
    format long
    
    % read the text
    text = fileread(input_file);
    
    % split into sequences
    seq = strsplit(text,'---');
    
    % define the position (x,y,z) and orienatation in quat (x,y,z,w)
    pose_arr = zeros(size(seq,2)-1, 7);
    % disregard the last sequence
    for i=1:size(seq,2)-1
        [rem, pose_str] = strsplit(seq{i}, 'pose');
        [pose, rem2] = strsplit(rem{3}, 'covariance');
        % pose now looks like so:
        %:      position:        x: 0.0405009053648       y: -0.0167003273964       z: 0.00216210098006     orientation:        x: 0.147895129587       y: -0.68759950882       z: 0.695003643483       w: 0.149344841427   
        all_values_arr = strsplit(pose{1}, '      ');
        for k=2:size(all_values_arr,2)
            pose_arr(i,k-1) = sscanf(all_values_arr{1,k}, '%*s %f');
        end
    end
    

end

