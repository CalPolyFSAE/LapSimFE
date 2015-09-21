classdef Telemetry < handle
    %Telemetry is a class for data storage and analysis from the FE SAE lap
    %simulator.  It is the only output from the simulator API and contains
    %lap data, and misellaneous information such as brake points, entry
    %speeds, and exit speeds.  Telemetry constains methods for combining
    %individual track section data into a complete lap data matrix and for
    %processing the lap data to give competition results.
    
    properties
        Miscellaneous = {}; %Msc data stored here, e.g. brake points etc
        Results = {}; % Processed simulator results, e.g. top speed, lap time etc
        LapData = []; % Lap data stored in a matrix with columns in the following order
                      % [Position,Velocity,Long. Gs, Lat. Gs, Traction
                      % Limit Reached, Wheel RPM, Motor RPM, Power, Motor
                      % Torque, Braking Torque, Time]
    end
    
    methods
        function Tele = Telemetry(M)
            % Telemetry class object is created when brake point, entry v,
            % and exit v, data is created by the simulator
            Tele.Miscellaneous = M;
        end
        
        function LapStitch(Tele,Track)
            % Telemetry LapStich method
            %
            % This method takes individual track section data and stitches
            % all the section data together to give a single coherant lap
            % data matrix that can be processed easily.  This is done by
            % matching each track sections throttle and brake curve with
            % the given entrance and exit velocities.
            %
            % INPUTS
            % Name          Type          Units   Description            
            %**************************************************************
            % Tele         Telemetry      N/A     Telemetry object with
            %                                     brake point, entry v, 
            %                                     exit v data
            % Track         Test Track    N/A     Test track object that
            %                                     has individual section 
            %                                     data from the simulator
            %
            % OUTPUTS
            % Name          Type          Units   Description            
            %**************************************************************
            % NONE
            %
            % VARIABLES
            % Name          Type          Units   Description            
            %**************************************************************
            % EntranceV     [Nx1] array   in/s    Entrance velocities for
            %                                     each track section
            % ExitV         [Nx1] array   in/s    Exit velocities for each 
            %                                     track section
            % BP            [Nx1] array   in      Braking points for each
            %                                     track section
            % S             int           N/A     Number of track sections
            % RL            [Nx2] array   in      Array of section lengths
            %                                     and total track length
            % LapDataStitch [Mx11]array   N/A     Lap Data Matrix
            % Acc           [Lx2] array   N/A     Throttle curve giving
            %                                     in/s vs in for each track 
            %                                     section
            % Dec           [Lx2] array   N/A     Braking curve for each
            %                                     track section
            % dx            float         in      Distance step size
            % L             float         in      Running total of track
            %                                     length
            % I             int           N/A     Indexing variable for
            %                                     positioning throttle and 
            %                                     brake curves on track
            %                                     section
            % dl             float        in      Distance throttle and 
            %                                     brake curves
            %                                     needs to be shifted to 
            %                                     match with entrance and 
            %                                     exit velocities
            % X             [Kx1] array   in      Array of position
            %                                     increments to append to 
            %                                     throttle/brake curves if 
            %                                     necessary
            %
            % FUNCTIONS
            % Name          Location         Description            
            %**************************************************************
            % NONE   
            
            % Pulls entrance and exit velocities, and brake points 
            % for each section from telemetry object.  
            EntranceV = cell2mat(Tele.Miscellaneous(1));
            ExitV = cell2mat(Tele.Miscellaneous(2));
            BP = cell2mat(Tele.Miscellaneous(3));
           
            % Find the number of track sections to properly size arrays and
            % for loop iterations
            S = Track.Sections;
            
            % Create array to store individual section lengths and running
            % total of length at the end of each section
            RL = zeros(S,2);
            RL(1,1) = Track.Track(1).Length; % First section length
            RL(1,2) = RL(1,1); % First running total
            for i = 2:S

                RL(i,2) = Track.Track(i).Length; % Current section length
                RL(i,1) = RL(i-1,1) + RL(i,2); % Running total is equal to 
                                               % the previous running total 
                                               % plus the current section 
                                               % length

            end


            LapDataStitch = []; % Initialize lap data matrix variable

            for i = 1:S % For each one of the track sections

                Acc = Track.Track(i).AccCurve; % Pull throttle curve
                Dec = Track.Track(i).DecCurve; % Pull brake curve

                dx = Acc(2,1) - Acc(1,1); % Determine the position 
                                          % increment that the simulator 
                                          % used
                                          
                %dx = 1;

                L = RL(i,2); % Pull the current section length
                
                % Find the point in the section throttle curve that matches 
                % the section's entrance velocity
                I = find(Acc(:,2) <= EntranceV(i),1,'last');
                % Find the length that the curve needs to be shifted to
                % match
                dl = Acc(I,1);
                Acc(:,1) = Acc(:,1) - dl; % Shift throttle curve positions

                % If the ending throttle curve position is less than the
                % length of the section
                if Acc(end,1) < round(L)
                    % Extend the length of the curve up to the end by
                    % carrying through the ending value for each data
                    % parameter
                    X = (Acc(end,1)+dx:dx:round(L))';
                    V = ones(length(X),1)*Acc(end,2);
                    FG = ones(length(X),1)*Acc(end,3);
                    LG = ones(length(X),1)*Acc(end,4);
                    TL = ones(length(X),1)*Acc(end,5);
                    WR = ones(length(X),1).*Acc(end,6);
                    MR = ones(length(X),1).*Acc(end,7);
                    P = ones(length(X),1).*Acc(end,8);
                    MT = ones(length(X),1).*Acc(end,9);
                    BT = zeros(length(X),1);
                    NewT  = ones(length(X),1).*Acc(end,11);
                    % Create data appendix
                    Appendix = [X,V,FG,LG,TL,WR,MR,P,MT,BT,NewT];
                    % Append data
                    Acc = [Acc;Appendix];
                end

                % If the end of the throttle curve is longer than the
                % length of the track, trim it to fit.
                if Acc(end,1) > L
                    I = find(Acc(:,1) <= L, 1, 'last');
                    I = I + 1;
                    Acc(I:end,:) = [];
                end

                % Find the point in the section brake curve that matches
                % with the section exit velocity
                I = find(Dec(:,2) >= ExitV(i),1,'last');
                if I
                    % find the length that the curve needs to be shifted
                    dl = Dec(I,1) - L;
                    dl = dx*round(dl/dx);
                else % if no index is found, then this implies that the 
                    % exit velocity is higher than the start of the brake
                    % curve likely due to rounding errors.  If this
                    % happens, then shift the brake curve to start at the
                    % end of the section
                    dl = L;
                end

                % shift curve
                Dec(:,1) = Dec(:,1) - dl;

                % If the brake curve has been shifted past the start of the
                % section, then append data to start.  
                if Dec(1,1) > 0
                    % Carry through the starting values of the curve up to
                    % the beginning
                    X = (0:dx:Dec(1,1)-dx)';
                    V = ones(length(X),1)*Dec(1,2);
                    FG = ones(length(X),1)*Dec(1,3);
                    LG = ones(length(X),1)*Dec(1,4);
                    TL = ones(length(X),1)*Dec(1,5);
                    WR = ones(length(X),1).*Dec(1,6);
                    MR = ones(length(X),1).*Dec(1,7);
                    P = zeros(length(X),1);
                    MT = zeros(length(X),1);
                    BT = ones(length(X),1).*Dec(1,10);
                    NewT  = ones(length(X),1).*Acc(1,11);
                    Appendix = [X,V,FG,LG,TL,WR,MR,P,MT,BT,NewT];
                    Dec = [Appendix;Dec];
                end

                % If the end of the brake curve is past the end of the
                % section, trim the end to match the total section length
                if Dec(end,1) > L
                    I = find(Dec(:,1) <= L, 1, 'last');
                    I = I + 1;
                    Dec(I:end,:) = [];
                end

                % Find the start and end indexes of the throttle curve
                % between the start of the section and up to the brake
                % point
                AccStartIndex = find(Acc(:,1) == 0);
                AccEndIndex = find(Acc(:,1) == BP(i,1));
                if AccEndIndex
                else
                    Acc(end+1,:) = Acc(end,:);
                    Acc(end,1) = Acc(end,1) + dx;
                    AccEndIndex = find(Acc(:,1) == BP(i,1));
                end
                % Find the start and end indexes of the brake curve
                % starting one step after the end of the throttle curve and
                % ending at the end of the section
                DecStartIndex = find(Dec(:,1) == Acc(AccEndIndex,1)+dx,1,'first');
                DecEndIndex = find(Dec(:,1) <= L,1,'last');

                % Append throttle and brake curve sections together for the
                % section data
                SectionData = [Acc(AccStartIndex:AccEndIndex,:);...
                    Dec(DecStartIndex:DecEndIndex,:)];

                % For all sections except for the first, add the running
                % total of the track length to the position column of the
                % data matrix 
                if i ~= 1
                    SectionData(:,1) = SectionData(:,1) + RL(i-1,1);
                end

                % If the end of the section data is equal to the length of
                % the running total of the track, then trim the last row of
                % the data matrix.  This eliminates duplicate points in the
                % final matrix
                if SectionData(end,1) == RL(i,1)
                    SectionData(end,:) = [];
                end

                % Appends section data to the end of the total track data
                % matrix
                LapDataStitch = [LapDataStitch;SectionData];

            end

            % Recalculates time increments to smooth out section borders
            % This is accomplished using dt = integrate(dx/V)
            
            % Create average velocity array for each position increment
            V1 = LapDataStitch(1:end-1,2);
            V2 = LapDataStitch(2:end,2);

            Vavg = (V2 + V1)/2;
            
            % Create new time increment array by dividing position
            % increment by average velocity array
            NewT = dx./Vavg;

            % Replace old time data with new time data
            LapDataStitch(2:end,11) = NewT;

            % Recalculates Gs to smooth out borders between lap sections
            % Section removed because in its current form it exacerbates
            % the problem
%             NewGs = (LapDataStitch(2:end,2) - LapDataStitch(1:end-1,2))./LapDataStitch(2:end,11);
%             LapDataStitch(2:end,3) = NewGs/(12*32.174);
            
            Tele.LapData = LapDataStitch;
            
        end
        
        function LapResultCalculator(Tele,Track,DisplayFlag)
            
            S = Track.Sections;

            Time = Tele.LapData(:,11);

            TotalTime = sum(Time);

            Power = Tele.LapData(:,8);
            Power = Power*0.000112985;
            Energy = (Power.*Time);

            TotalEnergy = sum(Energy)/3600;
            
            I = Tele.LapData(:,5) == 1;

            TimeTTL = sum(Tele.LapData(I,11));

            PercentTL = TimeTTL/TotalTime * 100;

            avgLongG = mean(abs(Tele.LapData(:,3)));
            avgLatG  = mean(abs(Tele.LapData(:,4)));
            
            V = Tele.LapData(:,2)*(3600/(5280*12));
            X = Tele.LapData(:,1)/12;

            if DisplayFlag
                figure
                plot(X,V);
                xlabel('Distance (ft)')
                ylabel('Speed (mph)')
                title('Lap Speeds')

                figure
                hist(Tele.LapData(:,7),100);
                xlabel('Motor Speed (RPM)')
                ylabel('Number of Occurrences')
                title('Motor RPM Histogram')
            end

            for i = 1:S

                R = Track.Track(i).Radius;

                if ~R
                    Acc = Track.Track(i).AccCurve;

                    TopV = (Acc(end,2))*(3600/(5280*12));
                    TimeV = sum(Acc(:,11));
                    DistV = (Acc(end,1))/(12*3.281);
                    TopA = max(Acc(:,3));

                    dl = 75 - DistV;
                    if dl < 0
                        D = Acc(:,1)/(12*3.281);
                        I1 = find(D <= 75, 1, 'last');
                        I2 = find(D >= 75, 1, 'first');
                        if abs(75 - D(I1)) > abs(75 - D(I2))
                            TotalAccTime = sum(Acc(1:I2,11));
                        else
                            TotalAccTime = sum(Acc(1:I1,11));
                        end
                    else
                        dt = dl/(TopV*0.44704);

                        TotalAccTime = TimeV + dt;
                    end

                    if DisplayFlag
                        figure
                        plot(Acc(:,1)/(12*3.281),Acc(:,2)*3600/(5280*12))
                        xlabel('Distance (m)')
                        ylabel('Speed (mph)')
                        title('Straight Line Acceleration')

                        LapTimeStr =  'Total Lap Time (s): %2.3f\n';
                        EnergyStr =   'Total Lap Energy (kWh): %0.4f\n';
                        TractionStr = '%% Traction Limit: %2.2f\n';
                        AvgLongGStr = 'Average Long Gs: %1.3f\n';
                        AvgLatGStr =  'Average Lat Gs: %1.3f\n';
                        AccTimeStr =  '75m Run Time (s): %1.3f\n';
                        TTTSStr =     'Time to Top Speed (s): %1.3f\n';
                        TopVStr =     'Top Speed (mph): %2.3f\n';
                        DTTSStr =     'Distance to Top Speed (m): %3.3f\n';
                        MaxGStr =     'Max Long G: %1.3f\n';
                        
                        resultstr = sprintf([LapTimeStr,EnergyStr,TractionStr,'\n',...
                            AvgLongGStr,AvgLatGStr,MaxGStr,'\n',...
                            AccTimeStr,TopVStr,TTTSStr,DTTSStr],...
                            TotalTime,TotalEnergy,PercentTL,avgLongG,avgLatG,...
                            TopA,TotalAccTime,TopV,TimeV,DistV);
                        msgbox(resultstr,'Lap Results')
                    end

                    break
                end

            end
            
            Tele.Results = {TotalTime,TopV,TimeV,TotalAccTime,DistV,TopA,TotalEnergy,PercentTL};
            
        end
    end
    
end

