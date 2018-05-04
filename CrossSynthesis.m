function varargout = CrossSynthesis(varargin)
% CROSSSYNTHESIS MATLAB code for CrossSynthesis.fig
%      CROSSSYNTHESIS, by itself, creates a new CROSSSYNTHESIS or raises the existing
%      singleton*.
%
%      H = CROSSSYNTHESIS returns the handle to a new CROSSSYNTHESIS or the handle to
%      the existing singleton*.
%
%      CROSSSYNTHESIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CROSSSYNTHESIS.M with the given input arguments.
%
%      CROSSSYNTHESIS('Property','Value',...) creates a new CROSSSYNTHESIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CrossSynthesis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CrossSynthesis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CrossSynthesis

% Last Modified by GUIDE v2.5 04-May-2018 04:49:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CrossSynthesis_OpeningFcn, ...
                   'gui_OutputFcn',  @CrossSynthesis_OutputFcn, ...
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


% --- Executes just before CrossSynthesis is made visible.
function CrossSynthesis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CrossSynthesis (see VARARGIN)
global y1 y2 y3 Fs1 Fs2 Fs3
% Choose default command line output for CrossSynthesis
handles.output = hObject;
clc
% Update handles structure
guidata(hObject, handles);
y1 = 0; Fs1 = 0; y2 = 0; Fs2 = 0; y3 = 0; Fs3 = 0;
set(handles.textFirst,'ForegroundColor',[0,0,0]); set(handles.textFirst,'String','');
set(handles.textSecond,'ForegroundColor',[0,0,0]); set(handles.textSecond,'String','');
cla(handles.axes1); cla(handles.axes2); cla(handles.axes3);
% UIWAIT makes CrossSynthesis wait for user response (see UIRESUME)
% uiwait(handles.gui3);


% --- Outputs from this function are returned to the command line.
function varargout = CrossSynthesis_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in buttonFirst.
function buttonFirst_Callback(hObject, eventdata, handles)
% hObject    handle to buttonFirst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global y1 Fs1
[y1, Fs1, player, currTime, file, colour, text] = LoadAudio(y1, Fs1);
set(handles.textFirst,'ForegroundColor',colour);
set(handles.textFirst,'String',text);
if(player == 0)
    buttonFirst_Callback(hObject, eventdata, handles);
    return;
end
axes(handles.axes1);
TotalTime = length(y1)./Fs1;
t = 0:TotalTime/(length(y1)):TotalTime-TotalTime/length(y1);
plot(t,y1);

% --- Executes on button press in buttonSecond.
function buttonSecond_Callback(hObject, eventdata, handles)
% hObject    handle to buttonSecond (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global y2 Fs2
[y2, Fs2, player, currTime, file, colour, text] = LoadAudio(y2, Fs2);
set(handles.textSecond,'ForegroundColor',colour);
set(handles.textSecond,'String',text);
if(player == 0)
    buttonSecond_Callback(hObject, eventdata, handles);
    return;
end
axes(handles.axes2);
TotalTime = length(y2)./Fs2;
t = 0:TotalTime/(length(y2)):TotalTime-TotalTime/length(y2);
plot(t,y2);

% --- Executes on button press in buttonPlot.
function buttonPlot_Callback(hObject, eventdata, handles)
% hObject    handle to buttonPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global y1 y2 y3 Fs1 Fs2 Fs3
if(y1 == 0)
    buttonFirst_Callback(hObject, eventdata, handles);
end
if(y2 == 0)
    buttonSecond_Callback(hObject, eventdata, handles);
end
[y3, Fs3] = XSynth(y1, Fs1, y2, Fs2);
TotalTime = length(y3)./Fs3;
t = 0:TotalTime/(length(y3)):TotalTime-TotalTime/length(y3);
axes(handles.axes3)
plot(t, y3);

% --- Executes on button press in buttonSave.
function buttonSave_Callback(hObject, eventdata, handles)
% hObject    handle to buttonSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global y3 Fs3 input
if(y3 == 0)
    buttonPlot_Callback(hObject, eventdata, handles);
end
waitfor(userInput);
filename = strcat('Audio_Files/',input,'.wav');
audiowrite(convertStringsToChars(filename), y3, Fs3);

% --- Executes on button press in buttonEq.
function buttonEq_Callback(hObject, eventdata, handles)
% hObject    handle to buttonEq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(CrossSynthesis);
run EqualizerGUI;


% --- Executes on button press in buttonPlay.
function buttonPlay_Callback(hObject, eventdata, handles)
% hObject    handle to buttonPlay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global y3 Fs3
if(y3 == 0)
    buttonPlot_Callback(hObject, eventdata, handles);
end
x = y3;
if(length(y3)>Fs3*5)
    x = y3(Fs3:Fs3*5);
end
soundsc(x, Fs3)