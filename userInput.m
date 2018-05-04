function varargout = UserInput(varargin)
% USERINPUT MATLAB code for userInput.fig
%      USERINPUT, by itself, creates a new USERINPUT or raises the existing
%      singleton*.
%
%      H = USERINPUT returns the handle to a new USERINPUT or the handle to
%      the existing singleton*.
%
%      USERINPUT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in USERINPUT.M with the given input arguments.
%
%      USERINPUT('Property','Value',...) creates a new USERINPUT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before userInput_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to userInput_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help userInput

% Last Modified by GUIDE v2.5 04-May-2018 02:34:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @userInput_OpeningFcn, ...
                   'gui_OutputFcn',  @userInput_OutputFcn, ...
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

% --- Executes just before userInput is made visible.
function userInput_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to userInput (see VARARGIN)
% Choose default command line output for userInput
handles.output = hObject;
global input
input = "";
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes userInput wait for user response (see UIRESUME)
% uiwait(handles.gui2);


% --- Outputs from this function are returned to the command line.
function varargout = userInput_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function userInput_Callback(hObject, eventdata, handles)
% hObject    handle to userInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of userInput as text
%        str2double(get(hObject,'String')) returns contents of userInput as a double
% --- Executes during object creation, after setting all properties.
function userInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to userInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in buttonUserInput.
function buttonUserInput_Callback(hObject, eventdata, handles)
% hObject    handle to buttonUserInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global input
if(handles.userInput == "")
    input = "No name";
else
    input = handles.userInput.String;
end
