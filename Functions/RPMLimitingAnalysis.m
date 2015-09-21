function [ RawResults,PointResults ] = RPMLimitingAnalysis( Car,Track )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

PointResults = [];
RawResults = [];

GearRatios = (2:0.5:6);

S1 = length(GearRatios);

RPMCutOffs = (3500:-500:1500);

S2 = length(RPMCutOffs);

RawResults = zeros(S1*2,8,S2);

EnduranceLength = 866142;

EnduranceLaps = EnduranceLength/Track.Length;

h = waitbar(0,'0%','Name','Calculating Round 1...',...
            'CreateCancelBtn',...
            'setappdata(gcbf,''canceling'',1)');
setappdata(h,'canceling',0)

TF = 1;

for i = 1:S1
    
    GR = GearRatios(i)
    Car.Driveline.GearRatio = GR;
    
    Tele = Simulate(Car,Track);
    
    TimeAutoX = sum(cell2mat(Tele.Results(1)));
    Time75 = cell2mat(Tele.Results(4));
    MaxG = Car.Tire.MaxLateralAcceleration;
    TimeSkid = 2*pi*sqrt(9.1/(9.81*MaxG));
    
    MotorCurve = Car.Motor.OutputCurve;
    
    for j = 1:S2
        
        if getappdata(h,'canceling')
            delete(h)
            return
        end
    
        RPM = RPMCutOffs(j)
        
        Car.Motor.OutputCurve(RPM+2:end,:) = [];
        
        [Energy, EndTime, TF ] = EnduranceSimulation(Car,Track,EnduranceLength,TF);

        RawResults(i,:,j) = [TimeAutoX,Time75,TimeSkid,EndTime,Energy,TF,RPM,GR];

        if TF > 1;
            TF = 1;
        elseif TF <= 0;
            TF = 1;
        end
        
        waitbar(((i-1)/S1+j/(100*S2)),h,sprintf('%4.2f%%',((i-1)/S1+j/(100*S2))*100))
        
    end
    
    Car.Motor.OutputCurve = MotorCurve;
    
    waitbar(((i)/S1+j/(100*S2)),h,sprintf('%4.2f%%',((i)/S1+j/(100*S2))*100))
    
end

delete(h)

Car.Weight = Car.Weight - 38;
Car.Battery.Capacity = 4.73;

h = waitbar(0,'0%','Name','Calculating Round 2...',...
            'CreateCancelBtn',...
            'setappdata(gcbf,''canceling'',1)');
setappdata(h,'canceling',0)

TF = 1;

for i = S1+1:S1*2
    
    GR = GearRatios(i-S1);
    Car.Driveline.GearRatio = GR;
    
    Tele = Simulate(Car,Track);
    
    TimeAutoX = sum(cell2mat(Tele.Results(1)));
    Time75 = cell2mat(Tele.Results(4));
    MaxG = Car.Tire.MaxLateralAcceleration;
    TimeSkid = 2*pi*sqrt(9.1/(9.81*MaxG));
    
    MotorCurve = Car.Motor.OutputCurve;
    
    for j = 1:S2
        
        if getappdata(h,'canceling')
            delete(h)
            return
        end
        
        RPM = RPMCutOffs(j);
        
        Car.Motor.OutputCurve(RPM+2:end,:) = [];
    
        [Energy, EndTime, TF ] = EnduranceSimulation(Car,Track,EnduranceLength,TF);
   
        RawResults(i,:,j) = [TimeAutoX,Time75,TimeSkid,EndTime,Energy,TF,RPM,GR];
    
        if TF > 1;
            TF = 1;
        elseif TF <= 0;
            TF = 1;
        end
        
        waitbar(((i-S1-1)/S1+j/(100*S2)),h,sprintf('%4.2f%%',((i-S1-1)/S1+j/(100*S2))*100))
        
    end
    
    Car.Motor.OutputCurve = MotorCurve;
    
    waitbar(((i-S1)/S1+j/(100*S2)),h,sprintf('%4.2f%%',((i-S1)/S1+j/(100*S2))*100))
    
end

delete(h)


LapTime = RawResults(:,4)/EnduranceLaps;
LapEnergy = RawResults(:,5)/EnduranceLaps;

EFArray = (min(LapTime)./LapTime).*(min(LapEnergy)./LapEnergy).^2;

PointResults = zeros(S1*2,6);

MinTimes = [77.664,3.506,4.901,1367.38,1367.38/EnduranceLaps];

for i = 1:S1*2
    
    for j = 1:S2
    
        PointResults(i,:,j) = PointCalculator([min(RawResults(:,1:4)),min(LapTime)],min(LapEnergy),min(EFArray),[RawResults(i,1:4),LapTime(i)],LapEnergy(i));
        %PointResults(i,:,j) = PointCalculator(MinTimes,0.216,0.22,[RawResults(i,1:4),LapTime(i)],LapEnergy(i));
        
    end

end

% scatter3(GearRatios,RPMCutoffs,PointResults(1:S1,end,:),'ro')
% hold on
% scatter3(GearRatios,RPMCutoffs,PointResults(S1+1:2*S1,end,:),'bo')
% grid on

end


