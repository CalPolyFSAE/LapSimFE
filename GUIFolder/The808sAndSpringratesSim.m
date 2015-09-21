function varargout = The808sAndSpringratesSim(varargin)
% THE808SANDSPRINGRATESSIM MATLAB code for The808sAndSpringratesSim.fig
%      THE808SANDSPRINGRATESSIM, by itself, creates a new THE808SANDSPRINGRATESSIM or raises the existing
%      singleton*.
%
%      H = THE808SANDSPRINGRATESSIM returns the handle to a new THE808SANDSPRINGRATESSIM or the handle to
%      the existing singleton*.
%
%      THE808SANDSPRINGRATESSIM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in THE808SANDSPRINGRATESSIM.M with the given input arguments.
%
%      THE808SANDSPRINGRATESSIM('Property','Value',...) creates a new THE808SANDSPRINGRATESSIM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before The808sAndSpringratesSim_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to The808sAndSpringratesSim_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help The808sAndSpringratesSim

% Last Modified by GUIDE v2.5 28-Feb-2014 11:02:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @The808sAndSpringratesSim_OpeningFcn, ...
                   'gui_OutputFcn',  @The808sAndSpringratesSim_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before The808sAndSpringratesSim is made visible.
function The808sAndSpringratesSim_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to The808sAndSpringratesSim (see VARARGIN)

% Choose default command line output for The808sAndSpringratesSim
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes The808sAndSpringratesSim wait for user response (see UIRESUME)
% uiwait(handles.figure1);

setappdata(0,'HandleMainGUI',hObject);

initialize_gui(hObject, handles, false);


% --- Outputs from this function are returned to the command line.
function varargout = The808sAndSpringratesSim_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in TrackSelect.
function TrackSelect_Callback(hObject, eventdata, handles)
% hObject    handle to TrackSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns TrackSelect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from TrackSelect

Track = get(hObject,'Value');
switch Track
    case 1
        handles.SimParameters.Track = FSG2013;
    case 2
        handles.SimParameters.Track = FSAEWest2011;
    case 3
        handles.SimParameters.Track = FSAELincoln2012;
end

% Update handles structure
guidata(handles.figure1, handles);




% --- Executes during object creation, after setting all properties.
function TrackSelect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TrackSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in LapSim.
function LapSim_Callback(hObject, eventdata, handles)
% hObject    handle to LapSim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles.SimParameters,'Car')
    errordlg('Car has not been loaded','Error')
    return
end

tic
Track = handles.SimParameters.Track;
Car = handles.SimParameters.Car;
dx = handles.SimParameters.Resolution;
StopV = handles.SimParameters.VCutOff;
Telemetry = Simulate(Car,Track,'On',StopV,dx);
t = toc;
msgbox(sprintf('Simulation Time (s): %2.3f', t))
Exports = handles.Exports.Checks;
if Exports(1)
    filename = handles.Exports.FileNames{1};
    save(filename,'Telemetry');
end



% --- Executes on button press in EnduranceSim.
function EnduranceSim_Callback(hObject, eventdata, handles)
% hObject    handle to EnduranceSim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isfield(handles.SimParameters,'Car')
    errordlg('Car has not been loaded','Error')
    return
end

tic
Track = handles.SimParameters.Track;
EnduranceTrack = TestTrack([Track.Track,Track.Track],Track.Scores,Track.Name);
Car = handles.SimParameters.Car;
Car.TF = handles.SimParameters.TorqueFactor;
Car.RPMLimit = handles.SimParameters.RPMLimit;
Car.Regen = handles.SimParameters.Regen;
Laps = handles.SimParameters.EnduranceLaps;
dx = handles.SimParameters.Resolution;
StopV = handles.SimParameters.VCutOff;

Tele = Simulate(Car,EnduranceTrack,'On',StopV,dx);
FirstLapIndex = find(Tele.LapData(:,1) >= Track.Length, 1, 'first');
FirstLapP = Tele.LapData(1:FirstLapIndex,8)*0.000112985;
FirstLapT = Tele.LapData(1:FirstLapIndex,11);
FirstLapE = sum(FirstLapP.*FirstLapT)/3600;
FirstLapT = sum(FirstLapT);

SecondLapP = Tele.LapData(FirstLapIndex+dx:end,8)*0.000112985;
SecondLapT = Tele.LapData(FirstLapIndex+dx:end,11);
SecondLapE = sum(SecondLapP.*SecondLapT)/3600;
SecondLapT = sum(FirstLapT);

Energy = FirstLapE + SecondLapE*(Laps-1);
RemainingEnergy = Car.Battery.Capacity - Energy;
Time = FirstLapT + SecondLapT*(Laps-1);
t = toc;
TimeStr = datestr(Time/(24*3600),'MM:SS.FFF');
ResultStr = sprintf(['Event Time (mm:ss): ',TimeStr,'\n\nEnergy Consumed (kWh): %1.3f\nRemaining Energy (kWh): %1.3f'],Energy,RemainingEnergy);
msgbox(ResultStr)
msgbox(sprintf('Simulation Time (s): %2.3f', t))

Car.TF = 1;
Car.RPMLimit = Car.Motor.OutputCurve(end,1);
Car.Regen = 0;






% --- Executes on button press in CompSim.
function CompSim_Callback(hObject, eventdata, handles)
% hObject    handle to CompSim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isfield(handles.SimParameters,'Car')
    errordlg('Car has not been loaded','Error')
    return
end

tic
dx = handles.SimParameters.Resolution;
StopV = handles.SimParameters.VCutOff;
Track = handles.SimParameters.Track;
EnduranceTrack = TestTrack([Track.Track,Track.Track],Track.Scores,Track.Name);
Car = handles.SimParameters.Car;
Tele = Simulate(Car,Track,'Off',StopV,dx);
TimeAutoX = Tele.Results{1};
Time75 = Tele.Results{4};
MaxG = Car.Tire.MaxLateralAcceleration;
TimeSkid = 2*pi*sqrt(9.1/(9.81*MaxG));
Car.TF = handles.SimParameters.TorqueFactor;
Car.RPMLimit = handles.SimParameters.RPMLimit;
Car.Regen = handles.SimParameters.Regen;

Laps = handles.SimParameters.EnduranceLaps;

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
t = toc;

ScoreMessage = sprintf('75 Meter Dash Score: %2.1f\nAutocross Score: %2.1f\nSkidpad Score: %2.1f\nEndurance Score: %2.1f\nEfficiency Score: %2.1f\nTotal Score: %2.1f',Score75,ScoreAutoX,ScoreSkid,ScoreEnd,ScoreEF,ScoreTotal);
msgbox(ScoreMessage,'Competition Results')
msgbox(sprintf('Simulation Time (s): %2.3f', t))


Car.TF = 1;
Car.RPMLimit = Car.Motor.OutputCurve(end,1);
Car.Regen = 0;


% --- Executes on button press in MatExportCheck.
function MatExportCheck_Callback(hObject, eventdata, handles)
% hObject    handle to MatExportCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of MatExportCheck

ExportMat = get(hObject,'Value');
handles.Exports.Checks(1) = ExportMat;

% Update handles structure
guidata(handles.figure1, handles);


% --- Executes on button press in XLSExportCheck.
function XLSExportCheck_Callback(hObject, eventdata, handles)
% hObject    handle to XLSExportCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of XLSExportCheck
ExportXLS = get(hObject,'Value');
handles.Exports.Checks(2) = ExportXLS;

% Update handles structure
guidata(handles.figure1, handles);


% --- Executes on button press in TXTExportCheck.
function TXTExportCheck_Callback(hObject, eventdata, handles)
% hObject    handle to TXTExportCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of TXTExportCheck
ExportTxt = get(hObject,'Value');
handles.Exports.Checks(3) = ExportTxt;

% Update handles structure
guidata(handles.figure1, handles);



function MATFileName_Callback(hObject, eventdata, handles)
% hObject    handle to MATFileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MATFileName as text
%        str2double(get(hObject,'String')) returns contents of MATFileName as a double

Filename = get(hObject,'String');
handles.Exports.FileNames(1) = {Filename};

% Update handles structure
guidata(handles.figure1, handles);


% --- Executes during object creation, after setting all properties.
function MATFileName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MATFileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function XLSFileName_Callback(hObject, eventdata, handles)
% hObject    handle to XLSFileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of XLSFileName as text
%        str2double(get(hObject,'String')) returns contents of XLSFileName as a double

Filename = get(hObject,'String');
handles.Exports.FileNames(2) = {Filename};

% Update handles structure
guidata(handles.figure1, handles);


% --- Executes during object creation, after setting all properties.
function XLSFileName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to XLSFileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function TXTFileName_Callback(hObject, eventdata, handles)
% hObject    handle to TXTFileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TXTFileName as text
%        str2double(get(hObject,'String')) returns contents of TXTFileName as a double

Filename = get(hObject,'String');
handles.Exports.FileNames(3) = {Filename};

% Update handles structure
guidata(handles.figure1, handles);


% --- Executes during object creation, after setting all properties.
function TXTFileName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TXTFileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function TopSpeedSlide_Callback(hObject, eventdata, handles)
% hObject    handle to TopSpeedSlide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

VCutOff = get(hObject,'Value');
handles.SimParameters.VCutOff = VCutOff;
str = sprintf('%3.1f%%',VCutOff*100);

set(handles.TopSpeedPercentString,'String',str)

% Update handles structure
guidata(handles.figure1, handles);



% --- Executes during object creation, after setting all properties.
function TopSpeedSlide_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TopSpeedSlide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function ResolutionSlide_Callback(hObject, eventdata, handles)
% hObject    handle to ResolutionSlide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

Resolution = round(get(hObject,'Value'));
handles.SimParameters.Resolution = Resolution;
StringSet = [num2str(Resolution),' in'];

set(handles.SimResolutionString,'String',StringSet)

% Update handles structure
guidata(handles.figure1, handles);



% --- Executes during object creation, after setting all properties.
function ResolutionSlide_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ResolutionSlide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in CarOptOpen.
function CarOptOpen_Callback(hObject, eventdata, handles)
% hObject    handle to CarOptOpen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Car = handles.SimParameters.Car;
% Track = handles.SimParameters.Track;
% Resolution = handles.SimParameters.Resolution;
% VCutOff = handles.SimParameters.VCutOff;
% TorqueFactor = handles.SimParameters.TorqueFactor;
% RPMLimit = handles.SimParameters.RPMLimit;
% Regen = handles.SimParameters.Regen;
% EnduranceLaps = handles.SimParameters.EnduranceLaps;
% FileNames = handles.Exports.FileNames;
% Checks = handles.Exports.Checks;

HandleMainGUI = getappdata(0,'HandleMainGUI');
setappdata(HandleMainGUI,'SimParameters',handles.SimParameters);
setappdata(HandleMainGUI,'Exports',handles.Exports);

h = CarOptimizationGUI;
waitfor(h)


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function LoadFile_Callback(hObject, eventdata, handles)
% hObject    handle to LoadFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function TrackImport_Callback(hObject, eventdata, handles)
% hObject    handle to TrackImport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function CarImport_Callback(hObject, eventdata, handles)
% hObject    handle to CarImport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Save_Callback(hObject, eventdata, handles)
% hObject    handle to Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function SaveCar_Callback(hObject, eventdata, handles)
% hObject    handle to SaveCar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function EditMenu_Callback(hObject, eventdata, handles)
% hObject    handle to EditMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function TrackEdit_Callback(hObject, eventdata, handles)
% hObject    handle to TrackEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function CarEdit_Callback(hObject, eventdata, handles)
% hObject    handle to CarEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function TrackSave_Callback(hObject, eventdata, handles)
% hObject    handle to TrackSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in BuildCar.
function BuildCar_Callback(hObject, eventdata, handles)
% hObject    handle to BuildCar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = CarBuilderGUI;
waitfor(h)
HandleMainGUI = getappdata(0,'HandleMainGUI');
if isappdata(HandleMainGUI,'CarData')
    Car = getappdata(HandleMainGUI,'CarData');
    handles.SimParameters.Car = Car;
    rmappdata(HandleMainGUI,'CarData');
    Name = handles.SimParameters.Car.Name;
    set(handles.CarSelectionText,'String',Name)
    RPMLimit = handles.SimParameters.Car.Motor.OutputCurve(end,1);
    set(handles.RPMEdit,'String',num2str(RPMLimit));
end

% Update handles structure
guidata(handles.figure1, handles);

% --- Executes during object creation, after setting all properties.
function CarSelectionText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CarSelectionText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --------------------------------------------------------------------
function ViewMenu_Callback(hObject, eventdata, handles)
% hObject    handle to ViewMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ToolsMenu_Callback(hObject, eventdata, handles)
% hObject    handle to ToolsMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function GenerateGGCurve_Callback(hObject, eventdata, handles)
% hObject    handle to GenerateGGCurve (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function GenerateCPForces_Callback(hObject, eventdata, handles)
% hObject    handle to GenerateCPForces (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ViewTrack_Callback(hObject, eventdata, handles)
% hObject    handle to ViewTrack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ViewCar_Callback(hObject, eventdata, handles)
% hObject    handle to ViewCar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ViewCarParameters_Callback(hObject, eventdata, handles)
% hObject    handle to ViewCarParameters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ViewMotor_Callback(hObject, eventdata, handles)
% hObject    handle to ViewMotor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ViewGGCurve_Callback(hObject, eventdata, handles)
% hObject    handle to ViewGGCurve (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function TopSpeedPercentString_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TopSpeedPercentString (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes during object creation, after setting all properties.
function SimResolutionString_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SimResolutionString (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --------------------------------------------------------------------
function SteerGrad_Callback(hObject, eventdata, ~)
% hObject    handle to SteerGrad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function RPMEdit_Callback(hObject, eventdata, handles)
% hObject    handle to RPMEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RPMEdit as text
%        str2double(get(hObject,'String')) returns contents of RPMEdit as a double

RPMLimit = str2double(get(hObject,'String'));
if RPMLimit <= 0 || isnan(RPMLimit)
    set(handles.RPMEdit,'String',num2str(handles.SimParameters.RPMLimit));
    errordlg('RPM limit must be a positive number','Error');
else
    handles.SimParameters.RPMLimit = RPMLimit;
    guidata(hObject,handles)
end


% --- Executes during object creation, after setting all properties.
function RPMEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RPMEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function TorqueFactorEdit_Callback(hObject, eventdata, handles)
% hObject    handle to TorqueFactorEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TorqueFactorEdit as text
%        str2double(get(hObject,'String')) returns contents of TorqueFactorEdit as a double

TF = str2double(get(hObject,'String'));
if TF <= 0 || TF > 1 || isnan(TF)
    set(handles.TorqueFactorEdit,'String',num2str(handles.SimParameters.TorqueFactor));
    errordlg('Torque factor must be a positive number less than 1','Error');
else
    handles.SimParameters.TorqueFactor = TF;
    guidata(hObject,handles)
end
    



% --- Executes during object creation, after setting all properties.
function TorqueFactorEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TorqueFactorEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function RegenEdit_Callback(hObject, eventdata, handles)
% hObject    handle to RegenEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RegenEdit as text
%        str2double(get(hObject,'String')) returns contents of RegenEdit as a double

Regen = str2double(get(hObject,'String'));
if Regen < 0 || Regen > 100 || isnan(Regen)
    set(handles.RegenEdit,'String',num2str(handles.SimParameters.Regen));
    errordlg('Regen percentage must be a number between 100 and 0','Error');
else
    handles.SimParameters.Regen = Regen;
    guidata(hObject,handles)
end




% --- Executes during object creation, after setting all properties.
function RegenEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RegenEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EndLapsEdit_Callback(hObject, eventdata, handles)
% hObject    handle to EndLapsEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EndLapsEdit as text
%        str2double(get(hObject,'String')) returns contents of EndLapsEdit as a double

Laps = str2double(get(hObject,'String'));
if Laps <= 0 || isnan(Laps) || round(Laps) ~= Laps
    set(handles.EndLapsEdit,'String',num2str(handles.SimParameters.EnduranceLaps));
    errordlg('Endurance event laps must be a positive integer','Error');
else
    handles.SimParameters.EnduranceLaps = Laps;
    guidata(hObject,handles)
end


% --- Executes during object creation, after setting all properties.
function EndLapsEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EndLapsEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function initialize_gui(fig_handle, handles, isreset)
% If the metricdata field is present and the reset flag is false, it means
% we are we are just re-initializing a GUI by calling it from the cmd line
% while it is up. So, bail out as we dont want to reset the data.
if isfield(handles, 'SimParameters') && ~isreset
    return;
elseif isfield(handles, 'Exports') && ~isreset
    return;
end

imshow('Logo.jpg')

handles.SimParameters.VCutOff = 0.95;
handles.SimParameters.Resolution = 1;
handles.SimParameters.Track = FSG2013;
handles.SimParameters.TorqueFactor = 1;
handles.SimParameters.RPMLimit = Inf;
handles.SimParameters.Regen = 0;
handles.SimParameters.EnduranceLaps = 1;
handles.Exports.FileNames = {'SimulationData','SimulationData','SimulationData'};
handles.Exports.Checks = [0,0,0];

% Update handles structure
guidata(handles.figure1, handles);
