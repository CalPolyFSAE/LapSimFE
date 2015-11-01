classdef CarSuspension < handle
    %UNTITLED9 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        LinearSpring
        ARB
        Weight
        EffectiveCG
        SprungMass
        UnsprungMass
        UnsprungHeight
        RollCenters
        PitchCenter
        Name = '';
    end
    
    methods
        function S = CarSuspension(SpringRate,ARBRate,SprungM,UnsprungM,UnsprungH,RC,PC,CG)
            S.LinearSpring = SpringRate;
            S.ARB = ARBRate;
            S.Weight = SprungM + sum(UnsprungM);
            S.SprungMass = SprungM;
            S.UnsprungMass = UnsprungM;
            S.UnsprungHeight = UnsprungH;
            S.RollCenters = RC;
            S.PitchCenter = PC;
            S.EffectiveCG = CG;
        end
        
    end
    
end

