classdef TestTrack < handle
    %TestTrack is a class for a track object that a car class object will
    %be run on for the FE SAE lap simulator.  It is constructed of
    %several track section objects
    %   TestTrack, is constructed of several straight sections defined by
    %   length and several curved sections defined by length and radius.
    %   All dimensions are in inches and radians unless otherwise
    %   specified. Currently contains a light check for track geometric 
    %   consistency. The coder is trusted to input logical geometric 
    %   information when editing or creating track code.
    
    properties (SetAccess = private)
        Track % Array of track section objects
        Length % Total length of the track
        Sections % Number of track sections
        CurrentSection % Current section that the car is on
    end % properties
    
    methods
        function TT = TestTrack(SectionArray)
            % TestTrack Constructor method
            %
            % This method constructions an object of class TestTrack which
            % is defined by an array of TrackSection Objects.  Constructor
            % will make a basic geometry consistency check.
            %
            % INPUTS
            % Name          Type          Units   Description            
            %**************************************************************
            % SectionArray  [Nx1] array   N/A     Array of TrackSection
            %                                     objects.
            %
            % OUTPUTS
            % Name          Type          Units   Description            
            %**************************************************************
            % TT            TestTrack     N/A     TestTrack Object
            %
            % VARIABLES
            % Name          Type          Units   Description            
            %**************************************************************
            % i             int           N/A     Indexing variable 
            %
            % FUNCTIONS
            % Name          Location         Description            
            %**************************************************************
            % GeometryCheck GeometryCheck.m  Checks the geometry
            %                                consistency of the given test 
            %                                track
            
            TT.Track = SectionArray; % Define TT sections
            TT.CurrentSection = 1; % Initializes section index
            TT.Sections = length(SectionArray); % Defines the number of sections
            TT.Length = 0; % Initializes TT length as 0
            for i = 1:TT.Sections % For each section in the track
                % Adds individual section lengths to each other
                TT.Length = TT.Length + TT.Track(i).Length;
            end
            
            % Calls geometry check function
            if ~GeometryCheck(TT)
                disp('Warning: Track geometry possibly inconsistent.')
            end
            
        end % constructor function
        
        function Info = SectionInfo(TT,SectionNumber)
            % TestTrack section info retrieval method
            %
            % This method returns properties of the indicated track section
            %
            % INPUTS
            % Name          Type          Units   Description            
            %**************************************************************
            % TT            TestTrack     N/A     TestTrack Object
            % SectionNumber int           N/A     Index value of section
            %
            % OUTPUTS
            % Name          Type          Units   Description            
            %**************************************************************
            % Info          [Nx1] array   N/A     Array of section
            %                                     properties.
            %
            % VARIABLES
            % Name          Type          Units   Description            
            %**************************************************************
            % NONE
            %
            % FUNCTIONS
            % Name          Location         Description            
            %**************************************************************
            % SectionInfo   TrackSection.m   Returns section properties
            
            Info = SectionInfo(TT.Track(SectionNumber));
            
        end
    end % methods
    
end

function [ Consistent ] = GeometryCheck( TestTrack )
%GeometryCheck, validates the geometric consistency of a given track.
%   GeometryCheck currently only works by checking if the track circles
%   back on itself by checking if the total arc length of the track is a
%   multiple of 2 pi
%
% INPUTS
% Name          Type           Units   Description            
%**************************************************************
% TestTrack     TestTrack      N/A     Test track to be validated
%
% OUTPUTS
% Name          Type          Units   Description            
%**************************************************************
% Consistent    bool          N/A     Returns true if consistent, false
%                                     otherwise
%
% VARIABLES
% Name          Type          Units   Description            
%**************************************************************
% Check         float         rad     Summation of track sections arc
%                                     lengths
% i             int            N/A    Indexing variable
%
% FUNCTIONS
% Name          Location         Description            
%**************************************************************
% NONE


Check = 0; % Initializes check variable at 0
for i=1:TestTrack.Sections % For all of the TestTrack Sections
    if strcmp(TestTrack.Track(i).Type,'Curved') % If the section is curved
        Check = Check + TestTrack.Track(i).Angle; % Add the arc length
    end
end

if mod(Check,2*pi)  %If the summation of arc lengths is not a multiple of 2*pi
    Consistent = false; % Declare inconsistency
else
    Consistent = true; % Otherwise declare consistency
end

end



