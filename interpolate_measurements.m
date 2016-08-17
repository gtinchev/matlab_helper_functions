function [ output ] = interpolate_measurements( loam, varargin )
%INTERPOLATE_MEASUREMENTS Summary of this function goes here
%   Detailed explanation goes here

    numvarargs = length(varargin);
    if numvarargs > 1
        error('interpolate_measurements:TooManyInputs', ...
            'requires at most 1 optional inputs');
    end
    
    % set defaults for optional inputs
    optargs = {2};

    % now put these defaults into the valuesToUse cell array, 
    % and overwrite the ones specified in varargin.
    optargs(1:numvarargs) = varargin;
    
    FREQUENCY=optargs{1};
    
    NORM_THRESHOLD = 10;
    
    format long;
    
    seconds_converter = 1;
    
    interpolation_period = FREQUENCY * seconds_converter; % every 2 seconds we will get a measurement    
    
    output = [];
    
    %iterator for the index
    ii = 1;
    
    % iterate from 0, every 2  seconds( frequency) until the end of loam seconds, for 
    for i = 0:FREQUENCY:loam(end,1)/seconds_converter
        begin_index = find(loam(:,1)<((i-1)*seconds_converter),1, 'last'); % the index of the number less than the interpolation period
        a = loam(begin_index,:); % a - start of the interpolation
        % find the measurement right after the current period
        end_index = find(loam(:,1)>(i*seconds_converter),1); % the index of the first seen number bigger then the interpolation period
        b = loam(end_index,:); % b - end of the interpolation
            
        if ~isempty(a) & ~isempty(b)
            
            % check if the norm of the two measurements is very different
            if abs(norm(loam(end_index, 2:3))-norm(loam(begin_index, 2:3))) < NORM_THRESHOLD
            
                % now we have the first and the last element, time to interpolate
                % the position and slerp the orientation
                output(ii, 1) = i*seconds_converter;

                % time, how close to measurement
                t = ((i*seconds_converter) - a(1,1)) / (b(1,1)-a(1,1));

                output(ii, 2) = a(1,2)+(b(1,2) - a(1,2))*t; % retrieve the new x
                output(ii, 3) = a(1,3)+(b(1,3) - a(1,3))*t; % retrieve the new y
                output(ii, 4) = a(1,3)+(b(1,4) - a(1,4))*t; % retrieve the new z

                % orientation
                if size(a,2) > 4
                    output(ii, 5:8) = slerp(a(1,5:8)', b(1,5:8)', t);        
                else
                    output(ii, 5:8) = [0,0,0,0];
                end

                ii=ii+1;
            end
        end
    end
end

