function [ roll, pitch, yaw ] = quat2rpy( q, solution_number)
%QUAT2RPY Summary of this function goes here
%   Detailed explanation goes here
    % x - 1
    % y - 2
    % z - 3
    % w - 4
    
    TFSIMD_2_PI = 6.283185307179586232;
    TFSIMD_PI   = TFSIMD_2_PI *(0.5);

    d = q(1) * q(1) + q(2) * q(2) + q(3) * q(3) + q(4) * q(4);
    
    
    if(d ~= 0.0)
       s = 2.0 /d;xs = q(1)*s;ys = q(2) * s;zs = q(3) * s;
       wx = q(4) * xs;  wy = q(4) * ys;  wz = q(4) * zs;
       xx = q(1) * xs;  xy = q(1) * ys;  xz = q(1) * zs;
       yy = q(2) * ys;  yz = q(2) * zs;  zz = q(3) * zs;

    end
    R = [
        1.0 - (yy + zz), xy - wz, xz + wy
        xy + wz, 1.0 - (xx + zz), yz - wx
        xz - wy, yz + wx, 1.0 - (xx + yy)
        ];
    
    euler_out = zeros(1,3); % roll, pitch, yaw
    euler_out_2 = zeros(1,3); % roll, pitch, yaw
%     Check that pitch is not at a singularity
    if abs(R(3,1)) >= 1
        euler_out(3) = 0;
        euler_out_2(3) = 0;
        % From difference of angles formula
        
        if(R(3,1) < 0) % gimbal locked down
            delta = atan2(R(1,2),R(1,3));
            euler_out(2) = TFSIMD_PI / 2;
            euler_out_2(2) = TFSIMD_PI / 2.0;
            euler_out(1) = delta;
            euler_out_2(1) = delta;
        else % gimbal locked up
            delta = atan2(-R(1,2),-R(1,3));
            euler_out(2) = -TFSIMD_PI / 2.0;
            euler_out_2(2) = -TFSIMD_PI / 2.0;
            euler_out(1) = delta;
            euler_out_2(1) = delta;
        end
    else
        euler_out(2) = - asin(R(3,1));
        euler_out_2(2) = TFSIMD_PI - euler_out(2);

        euler_out(1) = atan2(R(3,2)/cos(euler_out(2)), R(3,3)/cos(euler_out(2)));
        euler_out_2(1) = atan2(R(3,2)/cos(euler_out_2(2)), R(3,3)/cos(euler_out_2(2)));
        
        euler_out(3) = atan2(R(2,1) / cos(euler_out(2)), R(1,1)/cos(euler_out(2)));
        euler_out_2(3) = atan2(R(2,1) / cos(euler_out_2(2)), R(1,1)/cos(euler_out_2(2)));
    end
    
    if (solution_number == 1)
        yaw = euler_out(3); 
        pitch = euler_out(2);
        roll = euler_out(1);
    else
        yaw = euler_out_2(3); 
        pitch = euler_out_2(2);
        roll = euler_out_2(1);
    end
end

