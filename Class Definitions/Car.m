classdef Car < handle
    %Car class object is one of two main objects that is used in 808s and
    %Springrates vehicle simulation
    %   Car class object holds properties for the car that is used in the
    %   simulation to determine performance.  Car object also containts
    %   methods for generating look up tables that are used for the
    %   simulation.  Values from the look up tables are used to generate
    %   acceleration and deceleration curves that the simulation pieces
    %   together to determine lap time and other subsequent information
    
    properties
        Brakes                % Brake class object
        Driveline             % Driveline class object
        Motor                 % Motor class object
        Chassis               % Chassis class object
        Battery               % Battery class object
        Suspension            % Suspension class object
        Tire                  % Tire class object
        DragCoefficient       % Aero drag coefficient for the car
        FrontCrossSection     % Aerodynamic cross section (in^2)
        Weight                % Total weight of car (lbf)
        CG                    % Three coordinate CG location (in), 
                              % X: From front axle back
                              % Y: From center plane of car
                              % Z: From the ground up                                                 
        SprungMass            % Sprung weight of car (lbf)
        UnsprungMass          % Two item vector for front and rear unsprung
                              % weight of car (lbf)
        Keq                   % Equivelent weight multiplier for car due to
                              % rotational inertia (unitless)
        TF = 1;               % Motor torque multiplier for endurane races
        Regen = 0;            % Regenerative braking factor for endrance races
        RPMLimit              % Motor rpm limit for endurance races
        Name = '';            % Name given to car
    end
    
    methods
        function C = Car(Brakes,Driveline,Motor,Chassis,Battery,Suspension,Tire,UnsprungMass,SprungMass,CG,DragC,XArea)
            % Assign class properties
            C.Brakes = Brakes;
            C.Driveline = Driveline;
            C.Motor = Motor;
            C.RPMLimit = Motor.OutputCurve(end,1);
            C.Chassis = Chassis;
            C.Battery = Battery;
            C.Suspension = Suspension;
            C.Tire = Tire;
            C.DragCoefficient = DragC;
            C.FrontCrossSection = XArea;
            
            C.UnsprungMass = UnsprungMass;
            C.SprungMass = SprungMass;
            
            C.Weight = sum(C.UnsprungMass) + C.SprungMass;
            C.CG = CG;
            
            % Determine rotational inertia multiplier
            I = Tire.J + Brakes.J + Driveline.J; % Determine total rotational I
            R = Tire.Radius;                     % Get tire radius  
            M = C.Weight/32.174;                 % Get mass in slugs
                                       
            C.Keq = (I/(R^2*M)) + 1;             % Assumes all rotating
                                                 % parts of non negligible
                                                 % inertia turn at same
                                                 % speed as wheels

        end      
            
        function [ LookUpTable ] = StraightAccTableGenerator( CarObject )
            % Method StraightAccTableGenerator creates a lookup table for
            % acceleration curves on straight sections of track.  The
            % lookup table contains values for velocity, drag, axle rpm,
            % motor rpm, motor torque, motor efficiency, power consumption,
            % longitudinal Gs, lateral Gs, and whether the vehicle is at
            % its tractive limit or not.  These values are given for each
            % motor rpm in the motor object's motor curve.
            
            % Return value units:
            % Velocity: in/s
            % Drag: lbf
            % Axle RPM: rev/min
            % Motor RPM: rev/min
            % Motor Torque: in lbf
            % Motor Efficiency: Scaled to 1
            % Power Consumption: in lbf/s
            % Longitudinal Gs: Gs
            % Lateral Gs: Gs
            % Traction Limit: Boolean
            
            
            NMotors = CarObject.Motor.NMotors; % Number of motors on the vehicle

            RHO = 0.002329; %Air density, slugs/ft^3

            RollingR = CarObject.Weight*CarObject.Tire.RollingResistance; % Rolling Resistance force for car configuration

            % Pull Motor RPM values from motor torque curve
            MotorRPM = CarObject.Motor.OutputCurve(:,1);
            LimitIndex = find(MotorRPM <= CarObject.RPMLimit, 1, 'last');
            MotorRPM = MotorRPM(1:LimitIndex,1);
            % Pull Motor Torque values from motor torque curve
            MotorT   = CarObject.TF*NMotors*CarObject.Motor.OutputCurve(1:LimitIndex,2);  %in-lb
            % Pull Motor Efficiency values from motor torque curve
            MotorE   = (CarObject.Motor.OutputCurve(1:LimitIndex,3));
            % Calculate Axle RPM for each Motor RPM value
            AxleRPM  = MotorRPM/CarObject.Driveline.GearRatio;
            % Calculate Car Velocity for each Axle RPM value
            Velocity = CarObject.Tire.Radius*AxleRPM*pi/30; % in/s
            % Calculate corresponding drag for each veloicty
            Drag     = (0.5*RHO*CarObject.DragCoefficient*CarObject.FrontCrossSection.*Velocity.^2)/12^4; % lbf
            
            % Caluclate axle torque for each motor torque value
            AxleT    = MotorT*CarObject.Driveline.GearRatio*CarObject.Driveline.Efficiency; % in lbf
            % Calculate force at the wheels for each axle torque value
            WheelF   = AxleT/CarObject.Tire.Radius; % lbf
            % Calculate theoretical acceleration for each wheel force value in in/s^2
            % and Gs
            MotorA   = (WheelF - Drag - RollingR)/(CarObject.Keq*CarObject.Weight/(12*32.174)); % in/s^2
            MotorGs  = MotorA/(12*32.174);

            % Compare acceleration to possible acceleration from tires and reduce
            % accelerations to those values
            ForwardGs = MotorGs;
            I = ForwardGs > CarObject.Tire.MaxForwardAcceleration;
            ForwardGs(I) = CarObject.Tire.MaxForwardAcceleration;
            
            MotorT = (CarObject.Keq*CarObject.Weight*ForwardGs + Drag + RollingR)*CarObject.Tire.Radius/(CarObject.Driveline.GearRatio*CarObject.Driveline.Efficiency);
            
            % Calculate power consumption for each motor rpm
            Power    = ((MotorT.*MotorRPM./MotorE)*pi/30);
            
            LateralGs = zeros(length(Velocity),1);
            
            % Tractive limit is reached at all of the indexes that were
            % previously adjusted to match tire acceleration
            TractiveLimit = I;
                        %    1       2     3        4       5      6      7
            LookUpTable = [Velocity,Drag,AxleRPM,MotorRPM,MotorT,MotorE,Power,ForwardGs,LateralGs,TractiveLimit];
            
            
        end
            
        function [ LookUpTable ] = StraightDecTableGenerator(CarObject,Velocity,Drag) 
            % Method StraightDecTableGenerator creates a lookup table for
            % deceleration curves on straight sections of track.  The
            % lookup table contains values for velocity, drag, axle rpm,
            % motor rpm, motor torque, motor efficiency, power consumption,
            % longitudinal Gs, lateral Gs, and whether the vehicle is at
            % its tractive limit or not.  These values are given for each
            % velocity and drag in the two input vectors.  These are
            % generally assumed to come from the output of
            % StraightAccTableGenerator
            
            % Return value units:
            % Velocity: in/s
            % Drag: lbf
            % Axle RPM: rev/min
            % Motor RPM: rev/min
            % Motor Torque: in lbf
            % Motor Efficiency: Scaled to 1
            % Power Consumption: in lbf/s
            % Longitudinal Gs: Gs
            % Lateral Gs: Gs
            % Traction Limit: Boolean
            

            RollingR = CarObject.Weight*CarObject.Tire.RollingResistance; % Rolling Resistance force for car configuration

            % Generate wheel force values from brake torque and tire radius 
            WheelF   = ones(length(Velocity),1)*sum(CarObject.Brakes.Torque)/CarObject.Tire.Radius; % lbf
            % Calculate braking acceleration from wheel force, drag and rolling
            % resistance for each velocity value
            BrakeA   = (WheelF + Drag + RollingR)/(CarObject.Keq*CarObject.Weight/(12*32.174)); % in/s^2
            BrakeGs  = BrakeA/(12*32.174);

            % Reduce any brake acceleration values that are more than tire capability
            % to tire capability
            ForwardGs = BrakeGs;
            I = ForwardGs > abs(CarObject.Tire.MaxBrakingAcceleration);
            ForwardGs(I) = abs(CarObject.Tire.MaxBrakingAcceleration);
            
            % Recalculate wheel force based on tire capability
            WheelF = CarObject.Keq*CarObject.Weight*ForwardGs - Drag - RollingR; 
            
            % Calculate axle and motor rpms based on velocity
            AxleRPM = Velocity/(CarObject.Tire.Radius*pi/30);
            MotorRPM = AxleRPM*CarObject.Driveline.GearRatio;
            % Recalculate applied brake torque based on wheel force
            BrakeTorque = WheelF*CarObject.Tire.Radius;
            
            % Straight brake curve, therefore lateral Gs is always zero
            LateralGs = zeros(length(Velocity),1);
            
            % Tractive limit is reached at all of the indexes that were
            % previously adjusted to match tire acceleration
            TractiveLimit = I;
                        %    1       2     3        4       5           6           7
            LookUpTable = [Velocity,Drag,AxleRPM,MotorRPM,BrakeTorque,ForwardGs,LateralGs,TractiveLimit];


        end
        
        function [ LookUpTable ] = CornerAccTableGenerator( CarObject,R,Velocity,Drag,MotorE )
            % Method CornerAccTableGenerator creates a lookup table for
            % acceleration curves on curved sections of track.  The
            % lookup table contains values for velocity, drag, axle rpm,
            % motor rpm, motor torque, motor efficiency, power consumption,
            % longitudinal Gs, lateral Gs, and whether the vehicle is at
            % its tractive limit or not.  These values are given for each
            % velocity, drag, and motor efficiency, in the three input  
            % vectors. These are generally assumed to come from the output 
            % of StraightAccTableGenerator.  The input R is the curved 
            % radius in inches.
            
            % Return value units:
            % Velocity: in/s
            % Drag: lbf
            % Axle RPM: rev/min
            % Motor RPM: rev/min
            % Motor Torque: in lbf
            % Motor Efficiency: Scaled to 1
            % Power Consumption: in lbf/s
            % Longitudinal Gs: Gs
            % Lateral Gs: Gs
            % Traction Limit: Boolean
        
            NMotors = CarObject.Motor.NMotors; % Number of motors on the vehicle
            
            RollingR = CarObject.Weight*CarObject.Tire.RollingResistance; % Rolling Resistance force for car configuration
            
            % Pulls max lateral Gs available from tire
            MaxLatG = CarObject.Tire.MaxLateralAcceleration;
            
            % Finds lateral Gs for each velocity in the given array
            LateralGs = (Velocity.^2/R)/(32.174*12);
            % Find indexes where velocity lateral Gs are larger than
            % maximum available from tires
            I = LateralGs > MaxLatG;
            % Trim those velocities from the arrays
            LateralGs(I) = [];
            Velocity(I) = [];
            Drag(I) = [];
            MotorE(I) = [];
            % Find max forward Gs available from tires for each lateral G
            ForwardGs = CarObject.Tire.GGCurve(LateralGs,'Throttle');

            % Calculate wheel forces, axle torque, and motor torque based
            % on given forward Gs
            WheelF = ForwardGs*CarObject.Weight*CarObject.Keq + Drag + RollingR;
            AxleT  = WheelF*CarObject.Tire.Radius;
            MotorT = AxleT/(CarObject.Driveline.GearRatio*CarObject.Driveline.Efficiency);
            % Pull available motor torque
            MotorRPM = CarObject.Motor.OutputCurve(:,1);
            LimitIndex = find(MotorRPM <= CarObject.RPMLimit, 1, 'last');
            MotorTrueT = CarObject.Motor.OutputCurve(1:LimitIndex,2)*NMotors*CarObject.TF;
            % Eliminate motor torques that occur at velocities above
            % available lateral Gs
            MotorTrueT(I) = [];
            
            % Find calculated motor torques that are more than the motor is
            % capable of
            I = MotorT > MotorTrueT;
            % And set those values to available motor torque
            MotorT(I) = MotorTrueT(I);
            % Recalculate axle torque, wheel force and forward Gs based on adjusted
            % available torque values
            AxleT = MotorT*CarObject.Driveline.GearRatio*CarObject.Driveline.Efficiency; % in lbf
            WheelF = AxleT/CarObject.Tire.Radius; % lbf
            ForwardGs = (WheelF - Drag - RollingR)/(CarObject.Keq*CarObject.Weight);
            % calculate axle and motor rpms from given velocity array
            AxleRPM = Velocity*30/(pi*CarObject.Tire.Radius);
            MotorRPM = AxleRPM*CarObject.Driveline.GearRatio;
            % calculate power consumption based on motor torque, rpm and
            % efficiency
            Power = ((MotorT.*MotorRPM./MotorE)*pi/30);
            
            % Tractive limit is reached at all indexes not limited by motor
            % torque
            TractiveLimit = ~I;

            LookUpTable = [Velocity,Drag,AxleRPM,MotorRPM,MotorT,MotorE,Power,ForwardGs,LateralGs,TractiveLimit];
            
        end
        
        function [ LookUpTable ] = CornerDecTableGenerator( CarObject,R,Velocity,Drag )
            % Method CornerDecTableGenerator creates a lookup table for
            % deceleration curves on curved sections of track.  The
            % lookup table contains values for velocity, drag, axle rpm,
            % motor rpm, motor torque, motor efficiency, power consumption,
            % longitudinal Gs, lateral Gs, and whether the vehicle is at
            % its tractive limit or not.  These values are given for each
            % velocity and drag in the two input vectors.  
            % These are generally assumed to come from the output of
            % StraightAccTableGenerator.  The input R is the curved radius 
            % in inches.
            
            % Return value units:
            % Velocity: in/s
            % Drag: lbf
            % Axle RPM: rev/min
            % Motor RPM: rev/min
            % Motor Torque: in lbf
            % Motor Efficiency: Scaled to 1
            % Power Consumption: in lbf/s
            % Longitudinal Gs: Gs
            % Lateral Gs: Gs
            % Traction Limit: Boolean
            
            RollingR = CarObject.Weight*CarObject.Tire.RollingResistance; % Rolling Resistance force for car configuration
            
            % Pull max lateral Gs from tire model
            MaxLatA = CarObject.Tire.MaxLateralAcceleration;
            
            % Calculate lateral Gs for each velocity in given array
            LateralGs = (Velocity.^2/R)/(32.174*12);
            % Find indexes where lateral Gs at given velocity is more than
            % available from tire model
            I = LateralGs > MaxLatA;
            % and trim those indexes
            LateralGs(I) = [];
            Velocity(I) = [];
            Drag(I) = [];
            % Find maximum possible backward Gs at a given lateral G from
            % tire model
            BackGs = CarObject.Tire.GGCurve(LateralGs,'Brake');
            
            % Calculate wheel force and brake torque based on backward Gs
            WheelF = BackGs*CarObject.Weight*CarObject.Keq - Drag - RollingR;
            BrakeTorque = WheelF*CarObject.Tire.Radius;
            % Find indexes where calculated brake torque is more than
            % available from brakes
            I = find(BrakeTorque > sum(CarObject.Brakes.Torque));
            if I
                % and set brake torque to the limiting available torque
                BrakeTorque(I) = sum(CarObject.Brakes.Torque);
                % Recalculate wheel force and Gs
                WheelF = BrakeTorque/CarObject.Tire.Radius;
                BackGs = (WheelF + Drag + RollingR)/(CarObject.Keq*CarObject.Weight);
            end
            
            % Calculate axle and motor rpms based on given velocity array
            AxleRPM = Velocity/(CarObject.Tire.Radius*pi/30);
            MotorRPM = AxleRPM*CarObject.Driveline.GearRatio;
            
            % Tractive limit is reached at all indexes where braking torque
            % is less than the available braking torque
            TractiveLimit = BrakeTorque < sum(CarObject.Brakes.Torque);
            
            LookUpTable = [Velocity,Drag,AxleRPM,MotorRPM,BrakeTorque,BackGs,LateralGs,TractiveLimit];
            
        end
            
    end
    
end

