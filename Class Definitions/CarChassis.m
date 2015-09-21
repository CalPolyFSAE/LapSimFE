classdef CarChassis < handle
    %UNTITLED7 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Length
        Track
        Name = '';
    end
    
    methods
        function C = CarChassis(Track,Length)
            C.Track = Track;
            C.Length = Length;
        end
            
            
    end
    
end

