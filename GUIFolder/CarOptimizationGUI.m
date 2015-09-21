function varargout = CarOptimizationGUI(varargin)
% CAROPTIMIZATIONGUI MATLAB code for CarOptimizationGUI.fig
%      CAROPTIMIZATIONGUI, by itself, creates a new CAROPTIMIZATIONGUI or raises the existing
%      singleton*.
%
%      H = CAROPTIMIZATIONGUI returns the handle to a new CAROPTIMIZATIONGUI or the handle to
%      the existing singleton*.
%
%      CAROPTIMIZATIONGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CAROPTIMIZATIONGUI.M with the given input arguments.
%
%      CAROPTIMIZATIONGUI('Property','Value',...) creates a new CAROPTIMIZATIONGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CarOptimizationGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CarOptimizationGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CarOptimizationGUI

% Last Modified by GUIDE v2.5 03-Mar-2014 19:52:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CarOptimizationGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @CarOptimizationGUI_OutputFcn, ...
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


% --- Executes just before CarOptimizationGUI is made visible.
function CarOptimizationGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CarOptimizationGUI (see VARARGIN)

% Choose default command line output for CarOptimizationGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CarOptimizationGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

initialize_gui(hObject, handles, false);


% --- Outputs from this function are returned to the command line.
function varargout = CarOptimizationGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in GRCheck.
function GRCheck_Callback(hObject, eventdata, handles)
% hObject    handle to GRCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of GRCheck


% --- Executes on button press in TFCheck.
function TFCheck_Callback(hObject, eventdata, handles)
% hObject    handle to TFCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of TFCheck


% --- Executes on button press in RPMCheck.
function RPMCheck_Callback(hObject, eventdata, handles)
% hObject    handle to RPMCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RPMCheck


% --- Executes on button press in RegenCheck.
function RegenCheck_Callback(hObject, eventdata, handles)
% hObject    handle to RegenCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RegenCheck



function GRLowerEdit_Callback(hObject, eventdata, handles)
% hObject    handle to GRLowerEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of GRLowerEdit as text
%        str2double(get(hObject,'String')) returns contents of GRLowerEdit as a double


% --- Executes during object creation, after setting all properties.
function GRLowerEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GRLowerEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function GRUpperEdit_Callback(hObject, eventdata, handles)
% hObject    handle to GRUpperEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of GRUpperEdit as text
%        str2double(get(hObject,'String')) returns contents of GRUpperEdit as a double


% --- Executes during object creation, after setting all properties.
function GRUpperEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GRUpperEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function TFLowerEdit_Callback(hObject, eventdata, handles)
% hObject    handle to TFLowerEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TFLowerEdit as text
%        str2double(get(hObject,'String')) returns contents of TFLowerEdit as a double


% --- Executes during object creation, after setting all properties.
function TFLowerEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TFLowerEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function TFUpperEdit_Callback(hObject, eventdata, handles)
% hObject    handle to TFUpperEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TFUpperEdit as text
%        str2double(get(hObject,'String')) returns contents of TFUpperEdit as a double


% --- Executes during object creation, after setting all properties.
function TFUpperEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TFUpperEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function RPMLowerEdit_Callback(hObject, eventdata, handles)
% hObject    handle to RPMLowerEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RPMLowerEdit as text
%        str2double(get(hObject,'String')) returns contents of RPMLowerEdit as a double


% --- Executes during object creation, after setting all properties.
function RPMLowerEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RPMLowerEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function RPMUpperEdit_Callback(hObject, eventdata, handles)
% hObject    handle to RPMUpperEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RPMUpperEdit as text
%        str2double(get(hObject,'String')) returns contents of RPMUpperEdit as a double


% --- Executes during object creation, after setting all properties.
function RPMUpperEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RPMUpperEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function RegenLowerEdit_Callback(hObject, eventdata, handles)
% hObject    handle to RegenLowerEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RegenLowerEdit as text
%        str2double(get(hObject,'String')) returns contents of RegenLowerEdit as a double


% --- Executes during object creation, after setting all properties.
function RegenLowerEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RegenLowerEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function RegenUpperEdit_Callback(hObject, eventdata, handles)
% hObject    handle to RegenUpperEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RegenUpperEdit as text
%        str2double(get(hObject,'String')) returns contents of RegenUpperEdit as a double


% --- Executes during object creation, after setting all properties.
function RegenUpperEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RegenUpperEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in StartButton.
function StartButton_Callback(hObject, eventdata, handles)
% hObject    handle to StartButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function GRResolutionEdit_Callback(hObject, eventdata, handles)
% hObject    handle to GRResolutionEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of GRResolutionEdit as text
%        str2double(get(hObject,'String')) returns contents of GRResolutionEdit as a double


% --- Executes during object creation, after setting all properties.
function GRResolutionEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GRResolutionEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function TFResolutionEdit_Callback(hObject, eventdata, handles)
% hObject    handle to TFResolutionEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TFResolutionEdit as text
%        str2double(get(hObject,'String')) returns contents of TFResolutionEdit as a double


% --- Executes during object creation, after setting all properties.
function TFResolutionEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TFResolutionEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function RPMResolutionEdit_Callback(hObject, eventdata, handles)
% hObject    handle to RPMResolutionEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RPMResolutionEdit as text
%        str2double(get(hObject,'String')) returns contents of RPMResolutionEdit as a double


% --- Executes during object creation, after setting all properties.
function RPMResolutionEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RPMResolutionEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function RegenResolutionEdit_Callback(hObject, eventdata, handles)
% hObject    handle to RegenResolutionEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RegenResolutionEdit as text
%        str2double(get(hObject,'String')) returns contents of RegenResolutionEdit as a double


% --- Executes during object creation, after setting all properties.
function RegenResolutionEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RegenResolutionEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function initialize_gui(fig_handle, handles, isreset)


HandleMainGUI = getappdata(0,'HandleMainGUI');
if isappdata(HandleMainGUI,'Exports')
    handles.Exports = getappdata(HandleMainGUI,'Exports');
    guidata(handles.figure1,handles);
else
    close(fig_handle)
end

if isappdata(HandleMainGUI,'SimParameters')
    handles.SimParameters = getappdata(HandleMainGUI,'SimParameters');
    guidata(handles.figure1,handles);
else
    close(fig_handle)
end

RPMLimit = handles.SimParameters.Car.Motor.OutputCurve(end,1);
set(handles.RPMUpperEdit,'String',num2str(RPMLimit));

handles.ParameterSelection = [0 0 0 0];
handles.GearRatioBounds = [2 5 0.1];
handles.TorqueFactorBounds = [0.1 1 0.1];
handles.RPMLimitBounds = [100 RPMLimit 50];
handles.Regen = [0 100 5];

% Update handles structure
guidata(handles.figure1, handles);


% --- Executes during object creation, after setting all properties.
function RPMResolutionEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RPMResolutionEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
