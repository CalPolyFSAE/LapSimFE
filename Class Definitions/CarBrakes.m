classdef CarBrakes < handle
    %UNTITLED6 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Torque
        Weight
        SprungMass
        UnsprungMass
        J
        EffectiveCG
        Name = '';
    end
    
    methods
        function B = CarBrakes(Torque,SprungMass,UnsprungMass,CG,J)
            B.Torque = Torque;
            B.SprungMass = SprungMass;
            B.UnsprungMass = UnsprungMass;
            B.Weight = SprungMass + sum(UnsprungMass);
            B.EffectiveCG = CG;
            B.J = J;
        end
        
        function Force = Brake(B,TireRadius)
            Force = B.Torque/TireRadius;
        end
    end
    
end

