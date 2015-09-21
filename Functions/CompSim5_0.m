function [ ScoreTotal, ScoreEnd ] = CompSim5_0(tf, rpmlimit, gr)
dx = 6;
StopV = 1;
Track = track;
EnduranceTrack = FSAELincoln2013;
Car = Hoosier13x7
Car.Driveline.GearRatio = gr;
Tele = Simulate(Car,Track,'Off',StopV,dx);
TimeAutoX = Tele.Results{1};
Time75 = Tele.Results{4};
MaxG = Car.Tire.MaxLateralAcceleration;
TimeSkid = 2*pi*sqrt(9.1/(9.81*MaxG));
Car.TF = tf;
Car.RPMLimit = rpmlimit;
Car.Regen = 0;

Laps = 28;

Tele = Simulate(Car,EnduranceTrack,'Off',StopV,dx);
FirstLapIndex = find(Tele.LapData(:,1) >= Track.Length, 1, 'first');
FirstLapP = Tele.LapData(1:FirstLapIndex,8)*0.000112985;
FirstLapT = Tele.LapData(1:FirstLapIndex,11);
FirstLapE = sum(FirstLapP.*FirstLapT)/3600;
FirstLapT = sum(FirstLapT);

SecondLapP = Tele.LapData(FirstLapIndex+dx:end,8)*0.000112985;
SecondLapT = Tele.LapData(FirstLapIndex+dx:end,11);
SecondLapE = sum(SecondLapP.*SecondLapT)/3600;
SecondLapT = sum(FirstLapT);

EnergyEnd = FirstLapE + SecondLapE*(Laps-1);
RemainingEnergy = Car.Battery.Capacity - EnergyEnd;
LapEnergy = EnergyEnd/Laps;
TimeEnd = FirstLapT + SecondLapT*(Laps-1);
LapTime = TimeEnd/Laps;

Times = [Time75,TimeAutoX,TimeSkid,TimeEnd,LapTime];
TopTimes = Track.Scores(1:5);
TopEnergy = Track.Scores(6);
TopEF = Track.Scores(7);
Scores = PointCalculator(TopTimes,TopEnergy,TopEF,Times,LapEnergy);
Score75 = Scores(1);
ScoreAutoX = Scores(2);
ScoreSkid = Scores(3);
if RemainingEnergy >= 0
    ScoreEnd = Scores(4);
else
    ScoreEnd = 0;
end
ScoreEF = Scores(5);
ScoreTotal = Score75 + ScoreAutoX + ScoreSkid + ScoreEF;


Car.TF = 1;
Car.RPMLimit = Car.Motor.OutputCurve(end,1);
Car.Regen = 0;

end