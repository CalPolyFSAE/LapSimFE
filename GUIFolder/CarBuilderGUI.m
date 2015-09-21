function varargout = CarBuilderGUI(varargin)
%CARBUILDERGUI M-file for CarBuilderGUI.fig
%      CARBUILDERGUI, by itself, creates a new CARBUILDERGUI or raises the existing
%      singleton*.
%
%      H = CARBUILDERGUI returns the handle to a new CARBUILDERGUI or the handle to
%      the existing singleton*.
%
%      CARBUILDERGUI('Property','Value',...) creates a new CARBUILDERGUI using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to CarBuilderGUI_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      CARBUILDERGUI('CALLBACK') and CARBUILDERGUI('CALLBACK',hObject,...) call the
%      local function named CALLBACK in CARBUILDERGUI.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CarBuilderGUI

% Last Modified by GUIDE v2.5 19-Feb-2014 15:49:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CarBuilderGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @CarBuilderGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before CarBuilderGUI is made visible.
function CarBuilderGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for CarBuilderGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CarBuilderGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CarBuilderGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

initialize_gui(hObject, handles, false);


% --- Executes on button press in BuildCarButton.
function BuildCarButton_Callback(hObject, eventdata, handles)
% hObject    handle to BuildCarButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Torque(1) = handles.CarParameters.FrontBrakeTorque;
Toruqe(2) = handles.CarParameters.RearBrakeTorque;
J = handles.CarParameters.BrakeRotationalInertia;

Brakes = CarBrakes(Torque,J);

Capacity = handles.CarParameters.BatteryCapacity;

Battery = CarBattery(Capacity);

TrackWidth(1) = handles.CarParameters.FrontTrack;
TrackWidth(2) = handles.CarParameters.RearTrack;
WheelBase = handles.CarParameters.WheelBase;

Chassis = CarChassis(TrackWidth,WheelBase);

GearRatio = handles.CarParameters.GearRatio;
Efficiency = handles.CarParameters.DrivelineEfficiency;
J = handles.CarParameters.DrivelineRotationInertia;

Driveline = CarDriveline(GearRatio,Efficiency,J);

RPMS = (0:1:3500)';
T = ones(3001,1)*1637.39; % in lbf
T = [T;(((3001:1:3500)'-3000)/(3500-3000))*(0-1637.39)+1637.39];
E = ones(length(RPMS),1)*0.95; 
OutputCurve = [RPMS,T,E];
NMotors = handles.CarParameters.NumberofMotors;
switch handles.CarParameters.Drive
    case 1
        Drive = 'RWD';
    case 2
        Drive = 'AWD';
end

Motor = CarMotor(OutputCurve,NMotors,Drive);

SpringRate(1) = handles.CarParameters.FrontSpringRate;
SpringRate(2) = handles.CarParameters.RearSpringRate;
ARBRate(1) = handles.CarParameters.FrontARBRate;
ARBRate(2) = handles.CarParameters.RearARBRate;
UnsprungH(1) = handles.CarParameters.FrontUnsprungCGHeight;
UnsprungH(2) = handles.CarParameters.RearUnsprungCGHeight;
RollCenter(1) = handles.CarParameters.FrontRollCenter;
RollCenter(2) = handles.CarParameters.RearRollCenter;
PitchCenter(1) = handles.CarParameters.PitchCenterHeight;
PitchCenter(2) = handles.CarParameters.PitchCenterFromFront;

Suspension = CarSuspension(SpringRate,ARBRate,UnsprungH,RollCenter,PitchCenter);

K = handles.CarParameters.TireSpringRate;
R = handles.CarParameters.TireRadius;
RollingResistance = handles.CarParameters.TireRollingResistance;
J = handles.CarParameters.TireRotationalInertia;
TireModel = @Hoosier13;

Tire = CarTire(TireModel,K,R,RollingResistance,J);

Drag = handles.CarParameters.DragCoefficient;
CrossArea = handles.CarParameters.CrossSectionArea;
CG = handles.CarParameters.CarCG;
UnsprungMass(1) = handles.CarParameters.UnsprungWeightFront;
UnsprungMass(2) = handles.CarParameters.UnsprungWeightRear;
SprungMass = handles.CarParameters.SprungWeight;

C = Car(Brakes,Driveline,Motor,Chassis,Battery,Suspension,Tire,UnsprungMass,SprungMass,CG,Drag,CrossArea);
    
C.Name = handles.CarParameters.CarName;

HandleMainGUI = getappdata(0,'HandleMainGUI');
setappdata(HandleMainGUI,'CarData',C);

close(handles.figure1); 


function KfEdit_Callback(hObject, eventdata, handles)
% hObject    handle to KfEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of KfEdit as text
%        str2double(get(hObject,'String')) returns contents of KfEdit as a double

Kf = str2double(get(hObject,'String'));

if Kf <= 0 || isnan(Kf)
    set(handles.KfEdit,'String',num2str(handles.CarParameters.FrontSpringRate));
    errordlg('Spring rates must be a postive number','Error');
else
    handles.CarParameters.FrontSpringRate = Kf;
    guidata(hObject,handles)
end


% --- Executes during object creation, after setting all properties.
function KfEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to KfEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function KrEdit_Callback(hObject, eventdata, handles)
% hObject    handle to KrEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of KrEdit as text
%        str2double(get(hObject,'String')) returns contents of KrEdit as a double

Kr = str2double(get(hObject,'String'));

if Kr <= 0 || isnan(Kr)
    set(handles.KrEdit,'String',num2str(handles.CarParameters.RearSpringRate));
    errordlg('Spring rates must be a postive number','Error');
else
    handles.CarParameters.RearSpringRate = Kr;
    guidata(hObject,handles)
end


% --- Executes during object creation, after setting all properties.
function KrEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to KrEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ARBFEdit_Callback(hObject, eventdata, handles)
% hObject    handle to ARBFEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ARBFEdit as text
%        str2double(get(hObject,'String')) returns contents of ARBFEdit as a double

ARBF = str2double(get(hObject,'String'));

if ARBF < 0 || isnan(ARBF)
    set(handles.ARBFEdit,'String',num2str(handles.CarParameters.FrontARBRate*pi/180));
    errordlg('Roll bar stiffnesses must be a non negative number','Error');
else
    handles.CarParameters.FrontARBRate = ARBF*180/pi;
    guidata(hObject,handles)
end


% --- Executes during object creation, after setting all properties.
function ARBFEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ARBFEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ARBREdit_Callback(hObject, eventdata, handles)
% hObject    handle to ARBREdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ARBREdit as text
%        str2double(get(hObject,'String')) returns contents of ARBREdit as a double

ARBR = str2double(get(hObject,'String'));

if ARBR < 0 || isnan(ARBR)
    set(handles.ARBREdit,'String',num2str(handles.CarParameters.RearARBRate*pi/180));
    errordlg('Roll bar stiffnesses must be a non negative number','Error');
else
    handles.CarParameters.RearARBRate = ARBR*180/pi;
    guidata(hObject,handles)
end


% --- Executes during object creation, after setting all properties.
function ARBREdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ARBREdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MusFCGEdit_Callback(hObject, eventdata, handles)
% hObject    handle to MusFCGEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MusFCGEdit as text
%        str2double(get(hObject,'String')) returns contents of MusFCGEdit as a double

MusCG = str2double(get(hObject,'String'));

if MusCG <= 0 || isnan(MusCG)
    set(handles.MusFCGEdit,'String',num2str(handles.CarParameters.FrontUnsprungCGHeight));
    errordlg('CG heights must be a postive number','Error');
else
    handles.CarParameters.FrontUnsprungCGHeight = MusCG;
    guidata(hObject,handles)
end


% --- Executes during object creation, after setting all properties.
function MusFCGEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MusFCGEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MusRCGEdit_Callback(hObject, eventdata, handles)
% hObject    handle to MusRCGEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MusRCGEdit as text
%        str2double(get(hObject,'String')) returns contents of MusRCGEdit as a double

MusCG = str2double(get(hObject,'String'));

if MusCG <= 0 || isnan(MusCG)
    set(handles.MusRCGEdit,'String',num2str(handles.CarParameters.RearUnsprungCGHeight));
    errordlg('CG heights must be a postive number','Error');
else
    handles.CarParameters.RearUnsprungCGHeight = MusCG;
    guidata(hObject,handles)
end


% --- Executes during object creation, after setting all properties.
function MusRCGEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MusRCGEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PCFEdit_Callback(hObject, eventdata, handles)
% hObject    handle to PCFEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PCFEdit as text
%        str2double(get(hObject,'String')) returns contents of PCFEdit as a double

PC = str2double(get(hObject,'String'));

if isnan(PC)
    set(handles.PCFEdit,'String',num2str(handles.CarParameters.PitchCenterHeight));
    errordlg('Pitch center height must be a number','Error');
else
    handles.CarParameters.PitchCenterHeight = PC;
    guidata(hObject,handles)
end


% --- Executes during object creation, after setting all properties.
function PCFEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PCFEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PCREdit_Callback(hObject, eventdata, handles)
% hObject    handle to PCREdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PCREdit as text
%        str2double(get(hObject,'String')) returns contents of PCREdit as a double

PC = str2double(get(hObject,'String'));

if isnan(PC)
    set(handles.PCREdit,'String',num2str(handles.CarParameters.PitchCenterFromFront));
    errordlg('Pitch center location must be a number','Error');
else
    handles.CarParameters.PitchCenterFromFront = PC;
    guidata(hObject,handles)
end


% --- Executes during object creation, after setting all properties.
function PCREdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PCREdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function RCFEdit_Callback(hObject, eventdata, handles)
% hObject    handle to RCFEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RCFEdit as text
%        str2double(get(hObject,'String')) returns contents of RCFEdit as a double

RC = str2double(get(hObject,'String'));

if isnan(RC)
    set(handles.RCFEdit,'String',num2str(handles.CarParameters.FrontRollCenter));
    errordlg('Roll center height must be a number','Error');
else
    handles.CarParameters.FrontRollCenter = RC;
    guidata(hObject,handles)
end


% --- Executes during object creation, after setting all properties.
function RCFEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RCFEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function RCREdit_Callback(hObject, eventdata, handles)
% hObject    handle to RCREdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RCREdit as text
%        str2double(get(hObject,'String')) returns contents of RCREdit as a double

RC = str2double(get(hObject,'String'));

if isnan(RC)
    set(handles.RCREdit,'String',num2str(handles.CarParameters.RearRollCenter));
    errordlg('Roll center height must be a number','Error');
else
    handles.CarParameters.RearRollCenter = RC;
    guidata(hObject,handles)
end


% --- Executes during object creation, after setting all properties.
function RCREdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RCREdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function DragCEdit_Callback(hObject, eventdata, handles)
% hObject    handle to DragCEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DragCEdit as text
%        str2double(get(hObject,'String')) returns contents of DragCEdit as a double

C = str2double(get(hObject,'String'));

if C < 0 || isnan(C)
    set(handles.DragCEdit,'String',num2str(handles.CarParameters.DragCoefficient));
    errordlg('Drag coefficient must be a non negative number','Error');
else
    handles.CarParameters.DragCoefficient = C;
    guidata(hObject,handles)
end


% --- Executes during object creation, after setting all properties.
function DragCEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DragCEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function DragAEdit_Callback(hObject, eventdata, handles)
% hObject    handle to DragAEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DragAEdit as text
%        str2double(get(hObject,'String')) returns contents of DragAEdit as a double

A = str2double(get(hObject,'String'));

if A < 0 || isnan(A)
    set(handles.DragAEdit,'String',num2str(handles.CarParameters.CrossSectionArea));
    errordlg('Drag area must be a non negative number','Error');
else
    handles.CarParameters.CrossSectionArea = A;
    guidata(hObject,handles)
end


% --- Executes during object creation, after setting all properties.
function DragAEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DragAEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function CGXEdit_Callback(hObject, eventdata, handles)
% hObject    handle to CGXEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CGXEdit as text
%        str2double(get(hObject,'String')) returns contents of CGXEdit as a double

CG = str2double(get(hObject,'String'));

if CG <= 0 || isnan(CG)
    set(handles.CGXEdit,'String',num2str(handles.CarParameters.CarCG(1)));
    errordlg('CG X location must be a postive number','Error');
else
    handles.CarParameters.CarCG(1) = CG;
    guidata(hObject,handles)
end


% --- Executes during object creation, after setting all properties.
function CGXEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CGXEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function CGYEdit_Callback(hObject, eventdata, handles)
% hObject    handle to CGYEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CGYEdit as text
%        str2double(get(hObject,'String')) returns contents of CGYEdit as a double

CG = str2double(get(hObject,'String'));

if isnan(CG)
    set(handles.CGYEdit,'String',num2str(handles.CarParameters.CarCG(2)));
    errordlg('CG Y location must be a number','Error');
else
    handles.CarParameters.CarCG(2) = CG;
    guidata(hObject,handles)
end


% --- Executes during object creation, after setting all properties.
function CGYEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CGYEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function CGZEdit_Callback(hObject, eventdata, handles)
% hObject    handle to CGZEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CGZEdit as text
%        str2double(get(hObject,'String')) returns contents of CGZEdit as a double

CG = str2double(get(hObject,'String'));

if CG <= 0 || isnan(CG)
    set(handles.CGZEdit,'String',num2str(handles.CarParameters.CarCG(3)));
    errordlg('CG Z location must be a postive number','Error');
else
    handles.CarParameters.CarCG(3) = CG;
    guidata(hObject,handles)
end


% --- Executes during object creation, after setting all properties.
function CGZEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CGZEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MusFEdit_Callback(hObject, eventdata, handles)
% hObject    handle to MusFEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MusFEdit as text
%        str2double(get(hObject,'String')) returns contents of MusFEdit as a double

Mus = str2double(get(hObject,'String'));

if Mus <= 0 || isnan(Mus)
    set(handles.MusFEdit,'String',num2str(handles.CarParameters.UnsprungWeightFront));
    errordlg('Unsprung weight must be a postive number','Error');
else
    handles.CarParameters.UnsprungWeightFront = Mus;
    guidata(hObject,handles)
end


% --- Executes during object creation, after setting all properties.
function MusFEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MusFEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MusREdit_Callback(hObject, eventdata, handles)
% hObject    handle to MusREdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MusREdit as text
%        str2double(get(hObject,'String')) returns contents of MusREdit as a double

Mus = str2double(get(hObject,'String'));

if Mus <= 0 || isnan(Mus)
    set(handles.MusREdit,'String',num2str(handles.CarParameters.UnsprungWeightRear));
    errordlg('Unsprung weight must be a postive number','Error');
else
    handles.CarParameters.UnsprungWeightRear = Mus;
    guidata(hObject,handles)
end


% --- Executes during object creation, after setting all properties.
function MusREdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MusREdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MsEdit_Callback(hObject, eventdata, handles)
% hObject    handle to MsEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MsEdit as text
%        str2double(get(hObject,'String')) returns contents of MsEdit as a double

Ms = str2double(get(hObject,'String'));

if Ms <= 0 || isnan(Ms)
    set(handles.MsEdit,'String',num2str(handles.CarParameters.SprungWeight));
    errordlg('Sprung weight must be a postive number','Error');
else
    handles.CarParameters.SprungWeight = Ms;
    guidata(hObject,handles)
end


% --- Executes during object creation, after setting all properties.
function MsEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MsEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function KtEdit_Callback(hObject, eventdata, handles)
% hObject    handle to KtEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of KtEdit as text
%        str2double(get(hObject,'String')) returns contents of KtEdit as a double

Kt = str2double(get(hObject,'String'));

if Kt <= 0 || isnan(Kt)
    set(handles.KtEdit,'String',num2str(handles.CarParameters.TireSpringRate));
    errordlg('Spring rate must be a postive number','Error');
else
    handles.CarParameters.TireSpringRate = Kt;
    guidata(hObject,handles)
end


% --- Executes during object creation, after setting all properties.
function KtEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to KtEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function TireREdit_Callback(hObject, eventdata, handles)
% hObject    handle to TireREdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TireREdit as text
%        str2double(get(hObject,'String')) returns contents of TireREdit as a double

R = str2double(get(hObject,'String'));

if R <= 0 || isnan(R)
    set(handles.TireREdit,'String',num2str(handles.CarParameters.TireRadius));
    errordlg('Tire radius must be a postive number','Error');
else
    handles.CarParameters.TireRadius = R;
    guidata(hObject,handles)
end


% --- Executes during object creation, after setting all properties.
function TireREdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TireREdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function RollCEdit_Callback(hObject, eventdata, handles)
% hObject    handle to RollCEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RollCEdit as text
%        str2double(get(hObject,'String')) returns contents of RollCEdit as a double

C = str2double(get(hObject,'String'));

if C < 0 || isnan(C)
    set(handles.RollCEdit,'String',num2str(handles.CarParameters.TireRollingResistance));
    errordlg('Tire resistance must be a non negative number','Error');
else
    handles.CarParameters.TireRollingResistance = C;
    guidata(hObject,handles)
end


% --- Executes during object creation, after setting all properties.
function RollCEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RollCEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function TireJEdit_Callback(hObject, eventdata, handles)
% hObject    handle to TireJEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TireJEdit as text
%        str2double(get(hObject,'String')) returns contents of TireJEdit as a double

J = str2double(get(hObject,'String'));

if J < 0 || isnan(J)
    set(handles.TireJEdit,'String',num2str(handles.CarParameters.TireRotationalInertia));
    errordlg('Tire inertia must be a non negative number','Error');
else
    handles.CarParameters.TireRotationalInertia = J;
    guidata(hObject,handles)
end


% --- Executes during object creation, after setting all properties.
function TireJEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TireJEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in TireMenu.
function TireMenu_Callback(hObject, eventdata, handles)
% hObject    handle to TireMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns TireMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from TireMenu

Tire = get(hObject,'Value');
handles.CarParameters.TireChoice = Tire;
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function TireMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TireMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in MotorMenu.
function MotorMenu_Callback(hObject, eventdata, handles)
% hObject    handle to MotorMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns MotorMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from MotorMenu

Motor = get(hObject,'Value');
handles.CarParameters.MotorChoice = Motor;
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function MotorMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MotorMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function NMotorEdit_Callback(hObject, eventdata, handles)
% hObject    handle to NMotorEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NMotorEdit as text
%        str2double(get(hObject,'String')) returns contents of NMotorEdit as a double

N = str2double(get(hObject,'String'));

if N <= 0 || isnan(N)
    set(handles.NMotorEdit,'String',num2str(handles.CarParameters.NumberofMotors));
    errordlg('Car must have at least one motor','Error');
else
    handles.CarParameters.NumberofMotors = N;
    guidata(hObject,handles)
end


% --- Executes during object creation, after setting all properties.
function NMotorEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NMotorEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in DriveMenu.
function DriveMenu_Callback(hObject, eventdata, handles)
% hObject    handle to DriveMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns DriveMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from DriveMenu

Drive = get(hObject,'Value');
handles.CarParameters.Drive = Drive;
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function DriveMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DriveMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function GREdit_Callback(hObject, eventdata, handles)
% hObject    handle to GREdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of GREdit as text
%        str2double(get(hObject,'String')) returns contents of GREdit as a double

Gr = str2double(get(hObject,'String'));

if Gr <= 0 || isnan(Gr)
    set(handles.GREdit,'String',num2str(handles.CarParameters.GearRatio));
    errordlg('Gear ratio must be a positive number','Error');
else
    handles.CarParameters.GearRatio = Gr;
    guidata(hObject,handles)
end




% --- Executes during object creation, after setting all properties.
function GREdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GREdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function DrEEdit_Callback(hObject, eventdata, handles)
% hObject    handle to DrEEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DrEEdit as text
%        str2double(get(hObject,'String')) returns contents of DrEEdit as a double

E = str2double(get(hObject,'String'))/100;

if E <= 0 || isnan(E)
    set(handles.DrEEdit,'String',num2str(handles.CarParameters.DrivelineEfficiency*100));
    errordlg('Efficiency must be a positive number','Error');
else
    handles.CarParameters.DrivelineEfficiency = E;
    guidata(hObject,handles)
end


% --- Executes during object creation, after setting all properties.
function DrEEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DrEEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function DrJEdit_Callback(hObject, eventdata, handles)
% hObject    handle to DrJEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DrJEdit as text
%        str2double(get(hObject,'String')) returns contents of DrJEdit as a double

J = str2double(get(hObject,'String'));

if J < 0 || isnan(J)
    set(handles.DrJEdit,'String',num2str(handles.CarParameters.DrivelineRotationInertia));
    errordlg('Driveline inertia must be a non negative number','Error');
else
    handles.CarParameters.DrivelineRotationInertia = J;
    guidata(hObject,handles)
end


% --- Executes during object creation, after setting all properties.
function DrJEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DrJEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function TFEdit_Callback(hObject, eventdata, handles)
% hObject    handle to TFEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TFEdit as text
%        str2double(get(hObject,'String')) returns contents of TFEdit as a double

T = str2double(get(hObject,'String'));

if T <= 0 || isnan(T)
    set(handles.TFEdit,'String',num2str(handles.CarParameters.FrontTrack));
    errordlg('Track width must be a positive number','Error');
else
    handles.CarParameters.FrontTrack = T;
    guidata(hObject,handles)
end


% --- Executes during object creation, after setting all properties.
function TFEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TFEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function TREdit_Callback(hObject, eventdata, handles)
% hObject    handle to TREdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TREdit as text
%        str2double(get(hObject,'String')) returns contents of TREdit as a double

T = str2double(get(hObject,'String'));

if T <= 0 || isnan(T)
    set(handles.TREdit,'String',num2str(handles.CarParameters.RearTrack));
    errordlg('Track width must be a positive number','Error');
else
    handles.CarParameters.RearTrack = T;
    guidata(hObject,handles)
end


% --- Executes during object creation, after setting all properties.
function TREdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TREdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function TBEdit_Callback(hObject, eventdata, handles)
% hObject    handle to TBEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TBEdit as text
%        str2double(get(hObject,'String')) returns contents of TBEdit as a double

B = str2double(get(hObject,'String'));

if B <= 0 || isnan(B)
    set(handles.TBEdit,'String',num2str(handles.CarParameters.WheelBase));
    errordlg('Wheel base must be a positive number','Error');
else
    handles.CarParameters.WheelBase = B;
    guidata(hObject,handles)
end


% --- Executes during object creation, after setting all properties.
function TBEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TBEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BatCapEdit_Callback(hObject, eventdata, handles)
% hObject    handle to BatCapEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BatCapEdit as text
%        str2double(get(hObject,'String')) returns contents of BatCapEdit as a double

C = str2double(get(hObject,'String'));

if C <= 0 || isnan(C)
    set(handles.BatCapEdit,'String',num2str(handles.CarParameters.BatteryCapacity));
    errordlg('Battery capacity must be a positive number','Error');
else
    handles.CarParameters.BatteryCapacity = C;
    guidata(hObject,handles)
end


% --- Executes during object creation, after setting all properties.
function BatCapEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BatCapEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BrakeTFEdit_Callback(hObject, eventdata, handles)
% hObject    handle to BrakeTFEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BrakeTFEdit as text
%        str2double(get(hObject,'String')) returns contents of BrakeTFEdit as a double

T = str2double(get(hObject,'String'));

if T <= 0 || isnan(T)
    set(handles.BrakeTFEdit,'String',num2str(handles.CarParameters.FrontBrakeTorque));
    errordlg('Brake torque must be a positive number','Error');
else
    handles.CarParameters.FrontBrakeTorque = T;
    guidata(hObject,handles)
end


% --- Executes during object creation, after setting all properties.
function BrakeTFEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BrakeTFEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BrakeTREdit_Callback(hObject, eventdata, handles)
% hObject    handle to BrakeTREdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BrakeTREdit as text
%        str2double(get(hObject,'String')) returns contents of BrakeTREdit as a double

T = str2double(get(hObject,'String'));

if T <= 0 || isnan(T)
    set(handles.BrakeTREdit,'String',num2str(handles.CarParameters.RearBrakeTorque));
    errordlg('Brake torque must be a positive number','Error');
else
    handles.CarParameters.RearBrakeTorque = T;
    guidata(hObject,handles)
end


% --- Executes during object creation, after setting all properties.
function BrakeTREdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BrakeTREdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BrakeJEdit_Callback(hObject, eventdata, handles)
% hObject    handle to BrakeJEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BrakeJEdit as text
%        str2double(get(hObject,'String')) returns contents of BrakeJEdit as a double

J = str2double(get(hObject,'String'));

if J < 0 || isnan(J)
    set(handles.BrakeJEdit,'String',num2str(handles.CarParameters.BrakeRotationalInertia));
    errordlg('Brake inertia must be a non negative number','Error');
else
    handles.CarParameters.BrakeRotationalInertia = J;
    guidata(hObject,handles)
end


% --- Executes during object creation, after setting all properties.
function BrakeJEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BrakeJEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function NameEdit_Callback(hObject, eventdata, handles)
% hObject    handle to NameEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NameEdit as text
%        str2double(get(hObject,'String')) returns contents of NameEdit as a double

Name = get(hObject,'String');
handles.CarParameters.CarName = Name;
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function NameEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NameEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function initialize_gui(fig_handle, handles, isreset)

if isfield(handles, 'CarParameters') && ~isreset
    return;
end

handles.CarParameters.CarName = 'Car1';
handles.CarParameters.DragCoefficient = 0.6;
handles.CarParameters.CrossSectionArea = 2015;
handles.CarParameters.SprungWeight = 513;
handles.CarParameters.UnsprungWeightFront = 60;
handles.CarParameters.UnsprungWeightRear = 60;
handles.CarParameters.CarCG = [ 33.28 0 10.7];
handles.CarParameters.FrontTrack = 48;
handles.CarParameters.RearTrack = 48;
handles.CarParameters.WheelBase = 64;
handles.CarParameters.GearRatio = 3.5;
handles.CarParameters.DrivelineEfficiency = 0.9;
handles.CarParameters.DrivelineRotationInertia = 20;
handles.CarParameters.TireSpringRate = 900;
handles.CarParameters.TireRadius = 10.5;
handles.CarParameters.TireRollingResistance = 0.03;
handles.CarParameters.TireRotationalInertia = 120.628;
handles.CarParameters.TireChoice = 1;
handles.CarParameters.FrontSpringRate = 200;
handles.CarParameters.RearSpringRate = 250;
handles.CarParameters.FrontARBRate = 0;
handles.CarParameters.RearARBRate = 0;
handles.CarParameters.FrontUnsprungCGHeight = 10.5;
handles.CarParameters.RearUnsprungCGHeight = 10.5;
handles.CarParameters.FrontRollCenter = -1.88;
handles.CarParameters.RearRollCenter = -0.88;
handles.CarParameters.PitchCenterHeight = 0;
handles.CarParameters.PitchCenterFromFront = 33.28;
handles.CarParameters.BatteryCapacity = 6.3;
handles.CarParameters.MotorChoice = 1;
handles.CarParameters.NumberofMotors = 1;
handles.CarParameters.Drive = 1;
handles.CarParameters.FrontBrakeTorque = 8259;
handles.CarParameters.RearBrakeTorque = 2743;
handles.CarParameters.BrakeRotationalInertia = 0.967;

% Update handles structure
guidata(handles.figure1, handles);
