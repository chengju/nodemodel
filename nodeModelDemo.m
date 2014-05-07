function varargout = nodeModelDemo(varargin)
% NODEMODELDEMO MATLAB code for nodeModelDemo.fig
%      NODEMODELDEMO, by itself, creates a new NODEMODELDEMO or raises the existing
%      singleton*.
%
%      H = NODEMODELDEMO returns the handle to a new NODEMODELDEMO or the handle to
%      the existing singleton*.
%
%      NODEMODELDEMO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NODEMODELDEMO.M with the given input arguments.
%
%      NODEMODELDEMO('Property','Value',...) creates a new NODEMODELDEMO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before nodeModelDemo_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to nodeModelDemo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help nodeModelDemo

% Last Modified by GUIDE v2.5 06-Mar-2014 00:46:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @nodeModelDemo_OpeningFcn, ...
                   'gui_OutputFcn',  @nodeModelDemo_OutputFcn, ...
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


% --- Executes just before nodeModelDemo is made visible.
function nodeModelDemo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to nodeModelDemo (see VARARGIN)

% Choose default command line output for nodeModelDemo
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes nodeModelDemo wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = nodeModelDemo_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function split_ratio_Callback(hObject, eventdata, handles)
% hObject    handle to split_ratio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% --- Executes during object creation, after setting all properties.
function split_ratio_CreateFcn(hObject, eventdata, handles)
% hObject    handle to split_ratio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in RUN.
function RUN_Callback(hObject, eventdata, handles)
% hObject    handle to RUN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Creat data to plot
k = 1:96;
beta = get(handles.split_ratio,'Value'); % split ratio

% constant flow profile
% ML_inflow = 5000*ones(1,96);
% OR_flow = [100*ones(1,20), zeros(1,96-20)];

% time-varying flow profile
ML_inflow = abs(sin(k));
OR_flow = [100*ones(1,20), zeros(1,96-20)];

ML_outflow = ML_inflow + OR_flow;
FR_flow = (1-beta)*ML_inflow;
axes(handles.ML_inflow)
plot(k,ML_inflow)
xlabel('time (hr)')
ylabel('flow (veh/h)')

axes(handles.OR_flow)
plot(k,OR_flow)
xlabel('time (hr)')
ylabel('flow (veh/h)')

axes(handles.ML_outflow)
plot(k,ML_outflow)
xlabel('time (hr)')
ylabel('flow (veh/h)')

axes(handles.FR_flow)
plot(k,FR_flow)
xlabel('time (hr)')
ylabel('flow (veh/h)')


% --- Executes on selection change in ModelType.
function ModelType_Callback(hObject, eventdata, handles)
% hObject    handle to ModelType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ModelType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ModelType


% --- Executes during object creation, after setting all properties.
function ModelType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ModelType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function WeavingFactor_Callback(hObject, eventdata, handles)
% hObject    handle to text9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function WeavingFactor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in CLEAR.
function CLEAR_Callback(hObject, eventdata, handles)
% hObject    handle to CLEAR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in STOP.
function STOP_Callback(hObject, eventdata, handles)
% hObject    handle to STOP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
