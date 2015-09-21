classdef CarBattery < handle
    %The CarBattery object class is used to define properties of the
    %batteries on the vehicle being simulated in 808s and Springrates
    %   CarBattery is defined by its name and capacity measured in kWh.
    
    properties
        Capacity        %Battery capacity (kWh)
        Name = '';      %Battery name
    end
    
    methods
        function B = CarBattery(Capacity)
            B.Capacity = Capacity;  % Define CatBattery property capacity
        end
        
    end
    
end

