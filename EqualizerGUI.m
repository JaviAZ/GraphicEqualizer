function varargout = EqualizerGUI(varargin)
% EQUALIZERGUI MATLAB code for EqualizerGUI.fig
%      EQUALIZERGUI, by itself, creates a new EQUALIZERGUI or raises the existing
%      singleton*.
%
%      H = EQUALIZERGUI returns the handle to a new EQUALIZERGUI or the handle to
%      the existing singleton*.
%
%      EQUALIZERGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EQUALIZERGUI.M with the given input arguments.
%
%      EQUALIZERGUI('Property','Value',...) creates a new EQUALIZERGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before EqualizerGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to EqualizerGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help EqualizerGUI

% Last Modified by GUIDE v2.5 04-May-2018 04:31:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @EqualizerGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @EqualizerGUI_OutputFcn, ...
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


% --- Executes just before EqualizerGUI is made visible.
function EqualizerGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to EqualizerGUI (see VARARGIN)
global gPause gPlay gains y Fs player gMute gVol presetNames presetData
% Choose default command line output for EqualizerGUI
handles.output = hObject;
clc
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes EqualizerGUI wait for user response (see UIRESUME)
% uiwait(handles.gui1);
gains = zeros(1,10); y = 0; Fs = 0; player = 0;
set(handles.textError,'ForegroundColor',[0,0,0]);
set(handles.textError,'String','');
cla(handles.axes1);
[~,~,presetNames] = xlsread('presetNames.xls');
presetNames = presetNames(:,1);
presetData = csvread('presetData.csv');
set(handles.listPresets,'String',presetNames);
% https://uk.mathworks.com/matlabcentral/fileexchange/12033-placing-image-on-a-button
[a,map] = imread('Image_Files\play.png');
[r,c,d] = size(a); 
x1 = ceil(r/30); 
x2 = ceil(c/30); 
gPlay = a(1:x1:end, 1:x2:end, :);
gPlay(gPlay == 255) = 5.5*255;
set(handles.buttonPlay,'CData',gPlay);

[a,map] = imread('Image_Files\pause.png');
[r,c,d] = size(a); 
x1 = ceil(r/30); 
x2 = ceil(c/30); 
gPause = a(1:x1:end, 1:x2:end, :);
gPause(gPause == 255) = 5.5*255;

a = imread('Image_Files\stop.png');
[r,c,d] = size(a); 
x1 = ceil(r/30); 
x2 = ceil(c/30); 
gStop=a(1:x1:end, 1:x2:end, :);
gStop(gStop == 255) = 5.5*255;
set(handles.buttonStop,'CData',gStop);
 
 a = imread('Image_Files\volume.png');
 [r,c,d] = size(a); 
 x1 = ceil(r/30); 
 x2 = ceil(c/30); 
 gVol = a(1:x1:end, 1:x2:end, :);
 gVol(gVol == 255) = 5.5*255;
 set(handles.buttonMute,'CData',gVol);
 
 a = imread('Image_Files\mute.png');
 [r,c,d] = size(a); 
 x1 = ceil(r/30); 
 x2 = ceil(c/30); 
 gMute = a(1:x1:end, 1:x2:end, :);
 gMute(gMute == 255) = 5.5*255;


% --- Outputs from this function are returned to the command line.
function varargout = EqualizerGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in buttonLoadAudio.
function buttonLoadAudio_Callback(hObject, eventdata, handles)
% hObject    handle to buttonLoadAudio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global y yT Fs player currTime file
[y, Fs, player, currTime, file, colour, text] = LoadAudio(y, Fs);
set(handles.textError,'ForegroundColor',colour);
set(handles.textError,'String',text);
if(player == 0)
    cla(handles.axes1);
    buttonLoadAudio_Callback(hObject, eventdata, handles);
    return;
end
plotWave(handles);
    
% --- Executes on button press in buttonPlay.
function buttonPlay_Callback(hObject, eventdata, handles)
% hObject    handle to buttonPlay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global y player gPlay gPause currTime
if(y==0)
    set(handles.textError,'ForegroundColor',[1,0,0]);
    set(handles.textError,'String','No file has been input');
    buttonLoadAudio_Callback(hObject, eventdata, handles);
end
if(isplaying(player))
    pause(player);
    currTime = get(player,'CurrentSample');
    set(handles.buttonPlay,'CData',gPlay);
else
    set(handles.buttonPlay,'CData',gPause);
    sliderVolume_Callback(hObject, eventdata, handles);
end

% --- Executes on selection change in buttonStop.
function buttonStop_Callback(hObject, eventdata, handles)
% hObject    handle to buttonStop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global player gPlay currTime
if(player==0)
    set(handles.textError,'ForegroundColor',[1,0,0]);
    set(handles.textError,'String','No file has been input');
    buttonLoadAudio_Callback(hObject, eventdata, handles);
end
stop(player);
currTime = 1;
set(handles.buttonPlay,'CData',gPlay);

% --- Executes on button press in buttonPlotSpectral.
function buttonPlotSpectral_Callback(hObject, eventdata, handles)
% hObject    handle to buttonPlotSpectral (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global y Fs file
if(y==0)
    set(handles.textError,'ForegroundColor',[1,0,0]);
    set(handles.textError,'String','No file has been input');
    buttonLoadAudio_Callback(hObject, eventdata, handles);
end
x = y(:,1);
% perform spectral analysis
N = length(x);
w = hanning(N, 'periodic');
[Xamp, f] = periodogram(x, w, N, Fs, 'power');
Xamp = 20*log10(sqrt(Xamp)*sqrt(2));
% spectral envelope extraction
Xenv = specenv(Xamp, f);
% plot the spectrum
figure('Name', strcat('Spectral Envelope of->',file));
plot(f, Xamp)
grid on
hold on;
plot(f, Xenv, 'r', 'LineWidth', 1.5);
xlim([0 max(f)]);
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14);
xlabel('Frequency, Hz');
ylabel('Magnitude, dB');
title('Amplitude spectrum of the signal and its envelope');
legend('Original spectrum', 'Spectral envelope');

% --- Executes on button press in buttonReset.
function buttonReset_Callback(hObject, eventdata, handles)
% hObject    handle to buttonReset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gains
gains = zeros(1,10);
setSliders(handles);
handles.listPresets.Value = 1;
plotWave(handles);

% --- Executes on button press in buttonMute.
function buttonMute_Callback(hObject, eventdata, handles)
% hObject    handle to buttonMute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gMute gVol player y Fs currTime gains wasplaying
if(y==0)
    set(handles.textError,'ForegroundColor',[1,0,0]);
    set(handles.textError,'String','No file has been input');
    buttonLoadAudio_Callback(hObject, eventdata, handles);
end
if(isplaying(player))
    pause(player);
    currTime = get(player,'CurrentSample');
    wasplaying = 1;
end
if(get(handles.buttonMute,'CData')==gMute)
    set(handles.buttonMute,'CData',gVol);   
    set(handles.sliderVolume,'Value',3);
    if(any(gains))
        doFiltering(y);
    else
        player = audioplayer(y, Fs);
    end
else
    set(handles.buttonMute,'CData',gMute);
    set(handles.sliderVolume,'Value',0);
    player = audioplayer(zeros(length(y),1), Fs);
end
if(currTime~=1 & wasplaying)
    tempTime = currTime;
    playblocking(player,currTime);
    if(currTime == tempTime)
        currTime = 1;
    end
end

% --- Executes on button press in buttonSavePreset.
function buttonSavePreset_Callback(hObject, eventdata, handles)
% hObject    handle to buttonSavePreset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gains presetNames presetData input
waitfor(userInput);
presetNames = get(handles.listPresets,'String');
presetNames{end+1} = input;
tempGains = zeros(1,10);
for i = 1:10
    if(gains(1,i) ~= 0)
          tempGains(1,i) = mag2db(gains(1,i))
    end
end
presetData = [presetData; tempGains];
set(handles.listPresets,'String',presetNames);
handles.listPresets.Value = length(handles.listPresets.String);
xlswrite('presetNames.xls', presetNames);
csvwrite('presetData.csv', presetData);

% --- Executes on button press in buttonDeletePreset.
function buttonDeletePreset_Callback(hObject, eventdata, handles)
% hObject    handle to buttonDeletePreset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global presetNames presetData
val = handles.listPresets.Value;
if(val == 1)
    "Custom preset can't be deleted"
else
    if(val == size(presetData,1))
        presetData = presetData(1:val-1,:);
    else
        presetData = [presetData(1:val-2,:);presetData(val:size(presetData,1),:)];
    end
     presetNames(val) = [];

    handles.listPresets.Value = handles.listPresets.Value-1;
    set(handles.listPresets,'String',presetNames);
    delete('presetNames.xls');
    xlswrite('presetNames.xls',[presetNames;[]]);
    csvwrite('presetData.csv', presetData);
end

% --- Executes on button press in buttonXSynth.
function buttonXSynth_Callback(hObject, eventdata, handles)
% hObject    handle to buttonXSynth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(EqualizerGUI);
run CrossSynthesis;

% --- Executes on button press in buttonSave.
function buttonSave_Callback(hObject, eventdata, handles)
% hObject    handle to buttonSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global y yT Fs input
if(y == 0)
    buttonLoadAudio_Callback(hObject, eventdata, handles);
end
if(isempty(yT))
    doFiltering(y)
end
yT;
waitfor(userInput);
filename = strcat('Audio_Files/',input,'.wav');
audiowrite(convertStringsToChars(filename), yT, Fs);


% --- Executes on selection change in listPresets.
function listPresets_Callback(hObject, eventdata, handles)
% hObject    handle to listPresets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global y gains presetData
% Hints: contents = cellstr(get(hObject,'String')) returns listPresets contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listPresets

gains = presetData(hObject.Value,:);
setSliders(handles);
if(any(y~=0))
    plotWave(handles);
end
% --- Executes during object creation, after setting all properties.
function listPresets_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listPresets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function sliderVolume_Callback(hObject, eventdata, handles)
% hObject    handle to sliderVolume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global player y Fs currTime gVol gPlay gains wasplaying
if(y==0)
    set(handles.textError,'ForegroundColor',[1,0,0]);
    set(handles.textError,'String','No file has been input');
    buttonLoadAudio_Callback(hObject, eventdata, handles);
end
wasplaying = 0;
if(isplaying(player))
    wasplaying = 1;
    pause(player);
    currTime = get(player,'CurrentSample');
end
volume = get(handles.sliderVolume, 'Value')-7;
y1 = y;
if(volume == -7)
    y1 = zeros(1,length(y));
    buttonMute_Callback(hObject, eventdata, handles);
elseif(volume < 0)
    set(handles.buttonMute,'CData',gVol);   
    y1 = y/abs(volume);
elseif(volume > 0)
    set(handles.buttonMute,'CData',gVol);   
    y1 = y*abs(volume);
end
if(any(gains))
    doFiltering(y1);
else
    player = audioplayer(y1, Fs);
end
if(wasplaying | strcmp(get(hObject, 'Tag'),'buttonPlay'))
    tempTime = currTime;
    playblocking(player,currTime);
    if(currTime == tempTime)
        currTime = 1;
        set(handles.buttonPlay,'CData',gPlay); 
    end
end

% --- Executes during object creation, after setting all properties.
function sliderVolume_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderVolume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function slider250Hz_Callback(hObject, eventdata, handles)
% hObject    handle to slider20kHz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global gains y
gains(1,1) = db2mag(get(hObject,'Value'));
handles.listPresets.Value = 1;
if(any(y~=0))
    plotWave(handles);
end
% --- Executes during object creation, after setting all properties.
function slider250Hz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider20kHz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function slider500Hz_Callback(hObject, eventdata, handles)
% hObject    handle to slider44kHz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global gains y
gains(1,2) = db2mag(get(hObject,'Value'));
handles.listPresets.Value = 1;
if(any(y~=0))
    plotWave(handles);
end
% --- Executes during object creation, after setting all properties.
function slider500Hz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider44kHz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function slider1kHz_Callback(hObject, eventdata, handles)
% hObject    handle to slider6kHz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global gains y
gains(1,3) = db2mag(get(hObject,'Value'));
handles.listPresets.Value = 1;
if(any(y~=0))
    plotWave(handles);
end
% --- Executes during object creation, after setting all properties.
function slider1kHz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider6kHz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function slider2kHz_Callback(hObject, eventdata, handles)
% hObject    handle to slider20kHz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global gains y
gains(1,4) = db2mag(get(hObject,'Value'));
handles.listPresets.Value = 1;
if(any(y~=0))
    plotWave(handles);
end
% --- Executes during object creation, after setting all properties.
function slider2kHz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider20kHz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function slider4kHz_Callback(hObject, eventdata, handles)
% hObject    handle to slider44kHz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global gains y
gains(1,5) = db2mag(get(hObject,'Value'));
handles.listPresets.Value = 1;
if(any(y~=0))
    plotWave(handles);
end
% --- Executes during object creation, after setting all properties.
function slider4kHz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider44kHz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function slider6kHz_Callback(hObject, eventdata, handles)
% hObject    handle to slider6kHz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global gains y
gains(1,6) = db2mag(get(hObject,'Value'));
handles.listPresets.Value = 1;
if(any(y~=0))
    plotWave(handles);
end
% --- Executes during object creation, after setting all properties.
function slider6kHz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider6kHz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function slider8kHz_Callback(hObject, eventdata, handles)
% hObject    handle to slider20kHz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global gains y
gains(1,7) = db2mag(get(hObject,'Value'));
handles.listPresets.Value = 1;
if(any(y~=0))
    plotWave(handles);
end
% --- Executes during object creation, after setting all properties.
function slider8kHz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider20kHz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function slider16kHz_Callback(hObject, eventdata, handles)
% hObject    handle to slider44kHz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global gains y
gains(1,8) = db2mag(get(hObject,'Value'));
handles.listPresets.Value = 1;
if(any(y~=0))
    plotWave(handles);
end
% --- Executes during object creation, after setting all properties.
function slider16kHz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider44kHz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function slider20kHz_Callback(hObject, eventdata, handles)
% hObject    handle to slider20kHz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global gains y
gains(1,9) = db2mag(get(hObject,'Value'));
handles.listPresets.Value = 1;
if(any(y~=0))
    plotWave(handles);
end
% --- Executes during object creation, after setting all properties.
function slider20kHz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider20kHz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function slider44kHz_Callback(hObject, eventdata, handles)
% hObject    handle to slider20kHz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global gains y
gains(1,10) = db2mag(get(hObject,'Value'));
handles.listPresets.Value = 1;
if(any(y~=0))
    plotWave(handles);
end
% --- Executes during object creation, after setting all properties.
function slider44kHz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider20kHz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function doFiltering(y)
    global Fs gains yT player
    cut_off=250; %cut off low pass dalama Hz
    orde=2;
    a=fir1(orde,cut_off/(Fs/2),'low');
    y1=gains(1)*filter(a,1,y);
    
    f1=250; f2=500;
    b1=fir1(orde,[(f1/(Fs/2)) (f2/(Fs/2))],'bandpass');
    y2=gains(2)*filter(b1,1,y);
    
    f3=500; f4=1000;
    b2=fir1(orde,[(f3/(Fs/2)) (f4/(Fs/2))],'bandpass');
    y3=gains(3)*filter(b2,1,y);
   
    f5=1000;  f6=2000;
    b3=fir1(orde,[(f5/(Fs/2)) (f6/(Fs/2))],'bandpass');
    y4=gains(4)*filter(b3,1,y);
    
    f7=2000; f8=4000;
    b4=fir1(orde,[(f7/(Fs/2)) (f8/(Fs/2))],'bandpass');
    y5=gains(5)*filter(b4,1,y);
    
    f9=4000; f10=6000;
    b5=fir1(orde,[(f9/(Fs/2)) (f10/(Fs/2))],'bandpass');
    y6=gains(6)*filter(b5,1,y);

    f11=6000; f12=8000;
    b6=fir1(orde,[(f11/(Fs/2)) (f12/(Fs/2))],'bandpass');
    y7=gains(7)*filter(b6,1,y);

    f13=8000; f14=16000;
    b7=fir1(orde,[(f13/(Fs/2)) (f14/(Fs/2))],'bandpass');
    y8=gains(8)*filter(b7,1,y);

    f15=16000; f16=20000;
    b8=fir1(orde,[(f15/(Fs/2)) (f16/(Fs/2))],'bandpass');
    y9=gains(9)*filter(b8,1,y);
    
    %highpass
    cut_off2=20000;
    c=fir1(orde,cut_off2/(Fs/2),'high');
    y10=gains(10)*filter(c,1,y);
    yT=y1+y2+y3+y4+y5+y6+y7+y8+y9+y10;
    player = audioplayer(yT, Fs);
function setSliders(handles)
global gains
set(handles.slider250Hz,'Value',gains(1,1)); 
set(handles.slider500Hz,'Value',gains(1,2)); 
set(handles.slider1kHz,'Value',gains(1,3)); 
set(handles.slider2kHz,'Value',gains(1,4)); 
set(handles.slider4kHz,'Value',gains(1,5)); 
set(handles.slider6kHz,'Value',gains(1,6)); 
set(handles.slider8kHz,'Value',gains(1,7)); 
set(handles.slider16kHz,'Value',gains(1,8));
set(handles.slider20kHz,'Value',gains(1,9)); 
set(handles.slider44kHz,'Value',gains(1,10));
function plotWave(handles)
global y yT Fs gains
TotalTime = length(y)./Fs;
t = 0:TotalTime/(length(y)):TotalTime-TotalTime/length(y);
if(any(gains))
    doFiltering(y);
    axes(handles.axes1)
    plot(psd(spectrum.periodogram,[y,yT],'Fs',Fs,'NFFT',length(y(:,1))));
else
    axes(handles.axes1)
    plot(psd(spectrum.periodogram,y(:,1),'Fs',Fs,'NFFT',length(y(:,1))));
end
handles.axes1.Visible = 'off';
