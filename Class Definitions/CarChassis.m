classdef CarChassis < handle
    %UNTITLED7 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ChassisWeight
        ChassisCG
        DriverWeight
        DriverCG
        TotalWeight
        EffectiveCG
        Length
        Track
        Name = '';
    end
    
    methods
        function C = CarChassis(CWeight,CCG,DWeight,DCG,Track,Length)
            C.ChassisWeight = CWeight;
            C.ChassisCG = CCG;
            C.DriverWeight = DWeight;
            C.DriverCG = DCG;
            C.Track = Track;
            C.Length = Length;
            
            C.TotalWeight = CWeight + DWeight;
            C.EffectiveCG = (CWeight.*CCG + DWeight.*DCG)/C.TotalWeight;
        end
            
            
    end
    
end

