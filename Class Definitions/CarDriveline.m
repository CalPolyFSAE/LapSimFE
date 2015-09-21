classdef CarDriveline < handle
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        GearRatio
        Efficiency
        J
        Name = '';
    end
    
    methods
        function D = CarDriveline(GearRatio,Efficiency,J)
            D.GearRatio = GearRatio;
            D.Efficiency = Efficiency;
            D.J = J;
        end
        
        function [MotorRPM,Efficiency] = DriveTransfer(D,RoadSpeed,TireRadius)
            Efficiency = D.Efficiency;
            MotorRPM = RoadSpeed/TireRadius*D.GearRatio;
        end
            
    end
    
end

