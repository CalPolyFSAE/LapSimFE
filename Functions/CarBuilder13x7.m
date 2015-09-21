function [ C ] = CarBuilder13x7( )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Brake Parameters

Torque = [8258.77 2742.6]; % Front Back (in lbf)
J = 0.967; % slugs in^2

Brakes = CarBrakes(Torque,J);

% Battery Parameters

Capacity = 6.3; % kWh

Battery = CarBattery(Capacity);

% Chassis Parameters

TrackWidth = [ 48 48 ]; % Front Back (in)
WheelBase = 64; % in

Chassis = CarChassis(TrackWidth,WheelBase);

% Driveline Parameters

GearRatio = 3.5; 
Efficiency = 0.9; 
J = 20; % slug in^2

Driveline = CarDriveline(GearRatio,Efficiency,J);

% Motor Parameters

RPMS = (0:1:3500)';
T = ones(3001,1)*1637.39; % in lbf
T = [T;(((3001:1:3500)'-3000)/(3500-3000))*(0-1637.39)+1637.39];
E = ones(length(RPMS),1)*0.95; 
OutputCurve = [RPMS,T,E];
NMotors = 1;
Drive = 'RWD';
Motor = CarMotor(OutputCurve,NMotors,Drive);

% Suspension Parameters

SpringRate = [ 200 250 ]; % Front Rear (lbf/in)
ARBRate = [ 0 0 ]; % Front Rear (in lbf/rad)
UnsprungH = [ 10.5 10.5 ]; % Front Back (in)
RollCenter = [ -0.88 0.53 ]; % Front Back (in)
PitchCenter = [ 0 33.28 ]; % Height Distance from back (in)

Suspension = CarSuspension(SpringRate,ARBRate,UnsprungH,RollCenter,PitchCenter);

% Tire Parameters

K = 900; % lbf/in
R = 10.5; % in
RollingResistance = 0.03;
J = 120.628; % slugs in^2
TireModel = @Hoosier13x7;

Tire = CarTire(TireModel,K,R,RollingResistance,J);

% Car Parameters

Drag = 0.6; 
CrossArea = 2015; % in^2
CG = [ 33.28 0 10.7]; % x y z (in) 
UnsprungMass = [ 60 60 ]; % slugs
SprungMass = 513; % lbf

C = Car(Brakes,Driveline,Motor,Chassis,Battery,Suspension,Tire,UnsprungMass,SprungMass,CG,Drag,CrossArea);

end






