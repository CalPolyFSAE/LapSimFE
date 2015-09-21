classdef CarBrakes < handle
    %UNTITLED6 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Torque
        J
        Name = '';
    end
    
    methods
        function B = CarBrakes(Torque,J)
            B.Torque = Torque;
            B.J = J;
        end
        
        function Force = Brake(B,TireRadius)
            Force = B.Torque/TireRadius;
        end
    end
    
end

