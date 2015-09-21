function [ Track ] = OvalTrack( )
%FSAEWest2011 constructs a track based on the 2011 FSAE West competition
%track.
%   The defined track matches the race line data generated by the operator
%   of www.fsaesim.com.

% Defines section data, one straight section folloed by several curved
% sections.

SectionMatrix = [ %This is in meters
        243.84,0;
        563.04,-179.22;
        243.84,0;
        563.04,-179.22;
    ];

SectionMatrix = round(SectionMatrix * 39.3701); %Convert to integer inches


N = length(SectionMatrix(:,1));

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


end

