function [ Track ] = FSAELincoln2013( )
%FSAEWest2011 constructs a track based on the 2011 FSAE West competition
%track.
%   The defined track matches the race line data generated by the operator
%   of www.fsaesim.com.

% Defines section data, one straight section folloed by several curved
% sections.

SectionMatrix = [2,-21.7000000000000;1,-30.7000000000000;1,-97.8000000000000;1,42;1,55.7000000000000;1,85.9000000000000;1,223.500000000000;1,126.900000000000;1,101.100000000000;1,147.400000000000;1,190.600000000000;1,421.400000000000;1,-102.400000000000;1,-76.8000000000000;1,-83.7000000000000;1,-126.700000000000;1,-44.3000000000000;1,-38.8000000000000;2,-31.5000000000000;1,-20.6000000000000;1,-17.2000000000000;1,-15.3000000000000;2,-14.6000000000000;1,-13.2000000000000;1,-18;1,-24.3000000000000;1,-84.2000000000000;2,61.1000000000000;1,27.9000000000000;1,20.6000000000000;1,18.1000000000000;2,18.2000000000000;1,17.5000000000000;2,19.4000000000000;1,25.9000000000000;1,58.8000000000000;2,-99.3000000000000;1,-34;2,-22.9000000000000;1,-23.1000000000000;1,-32.1000000000000;2,-27.9000000000000;1,-17.1000000000000;1,-17.7000000000000;1,-22.7000000000000;1,-16.7000000000000;1,-15.3000000000000;1,-14.1000000000000;2,-13.6000000000000;1,-12;1,-11.7000000000000;1,-11.9000000000000;1,-12.1000000000000;1,-10.7000000000000;1,-10.7000000000000;1,-10.4000000000000;2,-13.4000000000000;1,-16.5000000000000;1,-25.3000000000000;1,-157.800000000000;2,-1417.70000000000;1,95.4000000000000;1,31.2000000000000;2,22.4000000000000;1,13.6000000000000;1,11.5000000000000;2,12.6000000000000;1,13;1,20.4000000000000;1,29.3000000000000;2,174;1,464.200000000000;1,75.7000000000000;2,189.300000000000;1,-60.7000000000000;1,-41.7000000000000;2,-26.2000000000000;1,-15.5000000000000;1,-13.2000000000000;1,-11.5000000000000;1,-12.7000000000000;1,-27.3000000000000;1,-145.700000000000;1,17.3000000000000;2,10.2000000000000;1,9.10000000000000;1,8;1,9.20000000000000;1,9.70000000000000;1,10.9000000000000;1,45.2000000000000;1,-38.6000000000000;1,-14.7000000000000;1,-12.5000000000000;1,-11.1000000000000;2,-9.90000000000000;1,-10.5000000000000;1,-11.7000000000000;1,-12.3000000000000;1,-32.5000000000000;1,59.4000000000000;2,33;1,15;1,14.1000000000000;1,13.2000000000000;1,13.4000000000000;2,13.2000000000000;1,14.4000000000000;1,15.6000000000000;1,69.3000000000000;2,-29.3000000000000;1,-13.4000000000000;1,-12.1000000000000;2,-13.2000000000000;1,-13.7000000000000;1,-14.4000000000000;2,-14.2000000000000;1,-14.7000000000000;2,-17.5000000000000;1,-20.5000000000000;1,-20.6000000000000;2,-18.7000000000000;1,-17.9000000000000;2,-21.6000000000000;1,-32;2,-64.8000000000000;1,517.300000000000;1,64.3000000000000;1,23.3000000000000;2,15.3000000000000;1,13.2000000000000;1,11.5000000000000;1,12;2,14.7000000000000;1,16;1,14.7000000000000;1,22.4000000000000;2,19.5000000000000;1,18.1000000000000;2,20.6000000000000;1,18.3000000000000;2,17.9000000000000;1,19.3000000000000;1,18.8000000000000;2,17.6000000000000;1,17;2,18.1000000000000;2,21.8000000000000;1,24.8000000000000;2,27.8000000000000;1,39;2,40.4000000000000;2,48.9000000000000;1,50.9000000000000;2,83.7000000000000;1,250.800000000000;2,-812.700000000000;1,199.900000000000;2,56.4000000000000;1,28;1,17.4000000000000;1,15;2,13.7000000000000;1,12.3000000000000;1,13.8000000000000;1,19.3000000000000;1,14;1,13.2000000000000;1,11.5000000000000;1,11.1000000000000;1,10.3000000000000;1,10.9000000000000;1,11.2000000000000;1,11.2000000000000;1,11.1000000000000;1,8.90000000000000;2,8.10000000000000;1,9.60000000000000;1,9;1,8.90000000000000;1,9.20000000000000;1,8.90000000000000;1,8.40000000000000;1,9.30000000000000;1,10.2000000000000;1,12.2000000000000;1,24.5000000000000;2,-311;1,-19;1,-12.3000000000000;1,-9.10000000000000;1,-7.60000000000000;1,-5.20000000000000;1,-5.50000000000000;1,-5.30000000000000;1,-5.50000000000000;1,-6.40000000000000;1,-5.60000000000000;1,-6.60000000000000;1,-7.20000000000000;1,-11.8000000000000;1,-7.40000000000000;1,-6.60000000000000;1,-6.10000000000000;1,-6.30000000000000;1,-7;1,-9.40000000000000;1,-10.7000000000000;1,-14.2000000000000;1,-27;1,-344.900000000000;1,28.3000000000000;1,15.6000000000000;1,12.6000000000000;1,10;1,8.10000000000000;1,6.80000000000000;1,6.30000000000000;1,7.50000000000000;1,7.30000000000000;1,7.60000000000000;1,7;1,7;1,7.20000000000000;1,7.90000000000000;1,8.60000000000000;1,9.20000000000000;1,11.6000000000000;1,15.9000000000000;1,14.4000000000000;2,20.2000000000000;1,64.8000000000000;1,94.9000000000000;2,118.800000000000;1,128.100000000000;2,1042.80000000000;1,-296.300000000000;2,-120.400000000000;1,-70.5000000000000;2,-46.5000000000000;1,-46.7000000000000;2,-39.1000000000000;1,-28.3000000000000;1,-15.4000000000000;1,-11.8000000000000;2,-10.4000000000000;1,-9.30000000000000;1,-10;1,-10.6000000000000;1,-10.4000000000000;1,-8.60000000000000;1,-8;1,-8.60000000000000;1,-7.80000000000000;1,-10.2000000000000;1,-10.6000000000000;1,-12.8000000000000;2,-18.2000000000000;1,-17.2000000000000;1,-17.4000000000000;2,-24.7000000000000;1,-51.9000000000000;1,-191.400000000000;2,403.900000000000;1,188.900000000000;2,59.6000000000000;2,36;1,30.4000000000000;2,32.3000000000000;2,29.6000000000000;1,31.3000000000000;2,28.3000000000000;2,24.3000000000000;1,26.2000000000000;2,22.1000000000000;2,23.1000000000000;1,21.1000000000000;2,22;2,20.4000000000000;1,19.8000000000000;2,19.4000000000000;2,19.1000000000000;1,19.4000000000000;2,21;2,32.6000000000000;1,59.9000000000000;2,-765;2,-83.3000000000000;1,-51.6000000000000;2,-38.3000000000000;2,-30;1,-37.8000000000000;2,-40.7000000000000;1,-37.6000000000000;1,-76.7000000000000;2,28;1,12.1000000000000;1,11;1,9.40000000000000;1,11.4000000000000;2,27.6000000000000;1,79.5000000000000;1,-93.1000000000000;2,-22.6000000000000;1,-16.6000000000000;1,-12.6000000000000;1,-10;1,-9.70000000000000;2,-10.2000000000000;1,-10.9000000000000;1,-29.6000000000000;1,78.9000000000000;1,12.9000000000000;1,8.60000000000000;1,8.50000000000000;1,8.30000000000000;1,9.50000000000000;2,11.2000000000000;1,24;1,-353;1,-24.6000000000000;1,-13.4000000000000;2,-11.9000000000000;1,-12.2000000000000;1,-10;1,-11;2,-15.1000000000000;1,-18.9000000000000;1,-26.2000000000000;1,-118.800000000000;2,152.200000000000;1,61.4000000000000;1,29.6000000000000;1,20.7000000000000;2,15.8000000000000;1,13.5000000000000;1,12.5000000000000;1,11.6000000000000;1,15.8000000000000;1,12.3000000000000;1,11.7000000000000;1,10.9000000000000;1,9;1,9;1,8.60000000000000;1,7.80000000000000;1,7;1,7.20000000000000;1,8;1,8.50000000000000;1,9.40000000000000;1,10.3000000000000;1,11.8000000000000;1,12.9000000000000;1,16;1,16.1000000000000;2,23.9000000000000;1,27.7000000000000;2,31.9000000000000;1,30.5000000000000;1,31.1000000000000;2,47.2000000000000;1,38.7000000000000;2,46.4000000000000;2,61.1000000000000;1,95.3000000000000;2,96.3000000000000;2,87;1,52.5000000000000;1,30.8000000000000;2,27.7000000000000;1,39.1000000000000;1,33.6000000000000;2,24.3000000000000;1,20.6000000000000;1,21.6000000000000;1,13.8000000000000;1,12.8000000000000;1,10.4000000000000;1,8.10000000000000;1,7.40000000000000;1,6.50000000000000;1,7.90000000000000;1,9;1,11.9000000000000;1,63.5000000000000;1,-17.1000000000000;1,-11.5000000000000;1,-8.20000000000000;1,-7.10000000000000;1,-6.90000000000000;1,-6.40000000000000;1,-6.50000000000000;1,-7.20000000000000;1,-6.60000000000000;1,-7;1,-7;1,-14.1000000000000;1,-15.1000000000000;1,-13.5000000000000;2,-13.1000000000000;1,-15;1,-15.4000000000000;1,-15.2000000000000;2,-24.9000000000000;1,-31.8000000000000;2,-45.5000000000000;1,-48;2,-66.4000000000000;1,-86.8000000000000;2,-151.600000000000;1,-160.500000000000;2,-136.700000000000;2,-750.500000000000;1,381.600000000000;2,487.800000000000;2,560.900000000000;1,0;2,842.600000000000;2,587.900000000000;2,936.400000000000;2,363.800000000000;1,296.600000000000;2,898.500000000000;2,0;2,0;2,532.900000000000;3,357.300000000000;2,686.500000000000;2,486.700000000000;2,770.900000000000;2,887.300000000000;2,1022.40000000000;3,910.900000000000;2,1215.10000000000;2,0;2,-596;2,-441.200000000000;2,-545.500000000000;2,-192.800000000000;2,-340.900000000000;2,896.100000000000;1,-704.900000000000;2,133.300000000000;1,151.500000000000;1,0;2,-24.2000000000000;1,-12.4000000000000;1,-10.6000000000000;1,-9.20000000000000;1,-8;1,-7.40000000000000;1,-6;1,-8.50000000000000;1,-13.8000000000000;1,-13.8000000000000;1,-13.6000000000000;1,-13.3000000000000;2,-13.5000000000000;1,-15.4000000000000;1,-12.8000000000000;1,-12.5000000000000;1,-11.3000000000000;2,-10.7000000000000;1,-14.7000000000000;1,-11.9000000000000;2,-14.7000000000000;1,-14.7000000000000;1,-15.5000000000000;2,-16;1,-14.4000000000000;2,-16.1000000000000;1,-17;1,-21;2,-23;2,-19.6000000000000;1,-21.2000000000000;2,-24.7000000000000;1,-29.6000000000000;2,-34.3000000000000;2,-58.5000000000000;2,-328.600000000000;1,-130.100000000000;2,-151.600000000000;2,-226.600000000000;2,0;1,-254.200000000000;2,-102.200000000000;2,-85.2000000000000;2,-88.7000000000000;1,-127.800000000000;2,-238.100000000000;1,523.400000000000;2,520.600000000000;1,92.3000000000000;1,32.6000000000000;1,29.8000000000000;1,23.5000000000000;1,20.8000000000000;1,13.5000000000000;1,11.2000000000000;1,10.1000000000000;2,9;1,8.80000000000000;1,8.30000000000000;1,8.20000000000000;1,7.30000000000000;1,7.50000000000000;1,7.20000000000000;1,7;1,9;1,12;1,22.7000000000000;1,17.2000000000000;1,19.5000000000000;2,31.2000000000000;1,36.4000000000000;1,30.8000000000000;2,31.6000000000000;1,31.2000000000000;2,33.1000000000000;1,44.7000000000000;2,44.7000000000000;1,39.1000000000000;2,38.9000000000000;2,43.3000000000000;1,50.9000000000000;2,44.4000000000000;2,39.6000000000000;2,32.3000000000000;1,41.4000000000000;2,26.9000000000000;1,22.7000000000000;2,23;2,35.5000000000000;1,26.4000000000000;2,24.7000000000000;1,23;2,23.8000000000000;1,21.4000000000000;2,18.9000000000000;2,21.7000000000000;1,25.8000000000000;2,51.2000000000000;2,96.6000000000000;1,133.500000000000;2,235.200000000000;2,-1534.40000000000;1,515.300000000000;2,158.400000000000;1,117.800000000000;2,83.5000000000000;1,93;1,-58.9000000000000;2,-26.3000000000000;1,-17.2000000000000;1,-13.1000000000000;1,-11.6000000000000;2,-13.5000000000000;1,-12.8000000000000;1,-12.4000000000000;2,-14.8000000000000;1,-20.1000000000000;2,-87.2000000000000;1,140.500000000000;1,22.4000000000000;2,13.7000000000000;1,13.3000000000000;1,12.7000000000000;2,12.2000000000000;1,13.6000000000000;1,18.4000000000000;2,91.5000000000000;1,-57.9000000000000;2,-22.1000000000000;1,-14.6000000000000;2,-14.2000000000000;1,-14.5000000000000;1,-14.2000000000000;2,-14.4000000000000;1,-12.8000000000000;2,-15.9000000000000;1,-18.9000000000000;1,-28.3000000000000;2,167.600000000000;1,34.6000000000000;2,24.4000000000000;1,20.3000000000000;2,20.6000000000000;1,20.5000000000000;2,20.1000000000000;2,22.6000000000000;1,23.4000000000000;2,44.6000000000000;2,65.9000000000000;1,93.2000000000000;2,980.900000000000;2,0;2,-1060.10000000000;1,0];

SectionMatrix = round(SectionMatrix * 39.3701); %Convert to integer inches


N = length(SectionMatrix);

% Builds array of TrackSection objects
for i=1:N
    if SectionMatrix(i,2)
        Length = SectionMatrix(i,1);
        Radius = SectionMatrix(i,2);
        TS = TrackSection(Length,Radius,i);
        TSArray(i) = TS;
    else
        Length = SectionMatrix(i,1);
        TS = TrackSection(Length,0,i);
        TSArray(i) = TS;
    end
end

Tmin75 = 3.506;
TminAutoX = 77.664;
TminSkid = 4.901;
TminEnd = 1367.38;
TminEndLap = 85.46;
Emin = 0.216;
EFmin = 0.22;


% Calls TestTrack Constructor
Track = TestTrack(TSArray,[Tmin75,TminAutoX,TminSkid,TminEnd,TminEndLap,Emin,EFmin],'FSAE Lincoln 2012');
