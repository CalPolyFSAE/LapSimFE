function [ Results ] = GearRatioSweep(Car,Track)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

GearRatios = (2:0.1:5);

S = length(GearRatios);

Results = zeros(S,4);

for i = 1:S
    
    GR = GearRatios(i)
    Car.Driveline.GearRatio = GR;
    
    Tele = Simulate(Car,Track,'Off',0.988,6);
    
    Time = cell2mat(Tele.Results(1));
    Time = sum(Time);

    AccTime = cell2mat(Tele.Results(4));
    
    Energy = cell2mat(Tele.Results(7));
    
    Results(i,:) = [GR,Time,AccTime,Energy];
    
    disp('=====================================================================')
end

disp('=====================================================================')
disp('=====================================================================')
disp('=====================================================================')

end

