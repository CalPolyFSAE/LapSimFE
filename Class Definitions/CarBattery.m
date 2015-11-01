classdef CarBattery < handle
    %UNTITLED8 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Capacity
        Weight
        EffectiveCG
        Name = '';
    end
    
    methods
        function B = CarBattery(Capacity,Weight,CG)
            B.Capacity = Capacity;
            B.Weight = Weight;
            B.EffectiveCG = CG;
        end
        
    end
    
end

