classdef CarSuspension < handle
    %UNTITLED9 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        LinearSpring
        ARB
        UnsprungHeight
        RollCenters
        PitchCenter
        Name = '';
    end
    
    methods
        function S = CarSuspension(SpringRate,ARBRate,UnsprungH,RC,PC)
            S.LinearSpring = SpringRate;
            S.ARB = ARBRate;
            S.UnsprungHeight = UnsprungH;
            S.RollCenters = RC;
            S.PitchCenter = PC;
        end
        
    end
    
end

