function [ Track ] = FSAEWest2011( )
%FSAEWest2011 constructs a track based on the 2011 FSAE West competition
%track.
%   The defined track matches the race line data generated by the operator
%   of www.fsaesim.com.

% Defines section data, one straight section folloed by several curved
% sections.

SectionMatrix = [580,0; % Section 1
    435,973; 370,515; 690,566; 1270,993;
    185,0;  % Section 2
    570,701;
    177,0; % Section 3
    450,1070; 460,941; 640,561;
    2320,0; % Section 4
    675,605; 675,605; 230,407; 230,407; 230,407; 230,407; 230,185;
    2031,0; % Section 5
    510,629; 510,1159; 510,1159; 400,871;
    300,0; % Section 6
    1260,1608; 800,1129; 350,776; 
    620,0; % Section 7
    575,1456;
    310,0; % Section 8
    620,1570;
    1110,0; % Section 9
    460,442; 460,441;
    158,0; % Section 10
    450,445; 450,382;
    148,0; % Section 11
    650,589; 650,564;
    1110,0; % Section 12
    960,429; 350,461; 350,549; 350,559; 350,610; 350,393;
    493,0; % Section 13
    680,625;
    373,0; % Section 14
    690,805; 930,397; 930,459;
    992,0; % Section 15
    870,504; 870,465;
    365,0; % Section 16
    290,672; 290,684;
    1638,0; % Section 17
    500,970;
    890,0; % Section 18
    745,698; 975,905; 2925,1101]; 

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
Track = TestTrack(TSArray,[Tmin75,TminAutoX,TminSkid,TminEnd,TminEndLap,Emin,EFmin],'FSAE West 2011');


end
