function varargout = equalizer_1(varargin)
% EQUALIZER_1 MATLAB code for equalizer_1.fig
%      EQUALIZER_1, by itself, creates a new EQUALIZER_1 or raises the existing
%      singleton*.
%
%      H = EQUALIZER_1 returns the handle to a new EQUALIZER_1 or the handle to
%      the existing singleton*.
%
%      EQUALIZER_1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EQUALIZER_1.M with the given input arguments.
%
%      EQUALIZER_1('Property','Value',...) creates a new EQUALIZER_1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before equalizer_1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to equalizer_1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help equalizer_1

% Last Modified by GUIDE v2.5 20-Apr-2023 16:52:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @equalizer_1_OpeningFcn, ...
                   'gui_OutputFcn',  @equalizer_1_OutputFcn, ...
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


% --- Executes just before equalizer_1 is made visible.
function equalizer_1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to equalizer_1 (see VARARGIN)

% Choose default command line output for equalizer_1
handles.output = hObject;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create recorder object when GUI starts
handles.Fs = 48000;   % Sampling frequency
handles.recObj = audiorecorder(handles.Fs, 24, 1);  % 24 bit resolution and 1 channel

% Disable all bands untill audio is available
for ii=1:10
    set(handles.(['band', num2str(ii), '_tag']), 'Enable', 'off');
end
set(handles.save_rec_tag, 'Enable', 'off');
set(handles.push_stop,'Enable','off');
set(handles.pushbutton14,'Enable','off');
set(handles.pushbutton12,'Enable','off');
set(handles.popupmenu1,'Enable','off');
set(handles.axes5,'Visible','off');
set(handles.axes6,'Visible','off');
set(handles.axes7,'Visible','off');
handles.player = [];  % Initialize player for filtered signal

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes equalizer_1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = equalizer_1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in browse.
function browse_Callback(hObject, eventdata, handles)
% hObject    handle to browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile({'*.wav'},'File Selector');
handles.fullpathname = strcat(pathname, filename);
[handles.y,handles.Fs] = audioread(handles.fullpathname);

% Resample audio file to 48 kHz
[p, q] = rat(48e3/handles.Fs);
handles.y = resample(handles.y, p, q);
handles.Fs = 48e3;

% Enable all bands when audio is available
for ii=1:10
    set(handles.(['band', num2str(ii), '_tag']), 'Enable', 'on');
end
set(handles.pushbutton14,'Enable','on');
set(handles.pushbutton12,'Enable','on');
set(handles.popupmenu1,'Enable','on');
set(handles.text3, 'String', filename) %showing fullpathname

axes(handles.axes5);
plot((0:length(handles.y)-1)/handles.Fs, handles.y);
title('Original audio');
axes(handles.axes6);
cla;
    
handles.player = [];
guidata(hObject,handles)
set(handles.axes5,'Visible','on');
function handles = play_equalizer(hObject, handles)
%global player;
if ~ isempty(handles.y)
%     handles.Volume=get(handles.slider15,'value');
    %handles.y=handles.y(NewStart:end,:); 
    handles.g1=get(handles.band1_tag,'value');
    handles.g2=get(handles.band2_tag,'value');
    handles.g3=get(handles.band3_tag,'value');
    handles.g4=get(handles.band4_tag,'value');
    handles.g5=get(handles.band5_tag,'value');
     handles.g6=get(handles.band6_tag,'value');
     handles.g7=get(handles.band7_tag,'value');
     handles.g8=get(handles.band8_tag,'value');
     handles.g9=get(handles.band9_tag,'value');
    handles.g10=get(handles.band10_tag,'value');
    
    set(handles.band1_edit_tag, 'String',handles.g1);
    set(handles.band2_edit_tag, 'String',handles.g2);
    set(handles.band3_edit_tag, 'String',handles.g3);
    set(handles.band4_edit_tag, 'String',handles.g4);
    set(handles.band5_edit_tag, 'String',handles.g5);
    set(handles.band6_edit_tag, 'String',handles.g6);
    set(handles.band7_edit_tag, 'String',handles.g7);
    set(handles.band8_edit_tag, 'String',handles.g8);
    set(handles.band9_edit_tag, 'String',handles.g9);
    set(handles.band10_edit_tag, 'String',handles.g10);

    cut_off=200; %cut off low pass dalama Hz
    orde=16;
    a=fir1(orde,cut_off/(handles.Fs/2),'low');
    y1=handles.g1*filter(a,1,handles.y);

    % %bandpass1
    f1=201;
    f2=400;
    b1=fir1(orde,[f1/(handles.Fs/2) f2/(handles.Fs/2)],'bandpass');
    y2=handles.g2*filter(b1,1,handles.y);
    % 
    % %bandpass2
    f3=401;
    f4=800;
    b2=fir1(orde,[f3/(handles.Fs/2) f4/(handles.Fs/2)],'bandpass');
    y3=handles.g3*filter(b2,1,handles.y);
    % 
    % %bandpass3
     f4=801;
    f5=1500;
     b3=fir1(orde,[f4/(handles.Fs/2) f5/(handles.Fs/2)],'bandpass');
     y4=handles.g4*filter(b3,1,handles.y);
    % 
    % %bandpass4
     f5=1501;
    f6=3000;
     b4=fir1(orde,[f5/(handles.Fs/2) f6/(handles.Fs/2)],'bandpass');
     y5=handles.g5*filter(b4,1,handles.y);
    % 
    % %bandpass5
      f7=3001;
    f8=5000;
      b5=fir1(orde,[f7/(handles.Fs/2) f8/(handles.Fs/2)],'bandpass');
      y6=handles.g6*filter(b5,1,handles.y);
    % 
    % %bandpass6
      f9=5001;
    f10=7000;
      b6=fir1(orde,[f9/(handles.Fs/2) f10/(handles.Fs/2)],'bandpass');
      y7=handles.g7*filter(b6,1,handles.y);
    % 
    % %bandpass7
      f11=7001;
    f12=10000;
      b7=fir1(orde,[f11/(handles.Fs/2) f12/(handles.Fs/2)],'bandpass');
      y8=handles.g8*filter(b7,1,handles.y);
    % 
     % %bandpass8
      f13=10001;
    f14=15000;
      b8=fir1(orde,[f13/(handles.Fs/2) f14/(handles.Fs/2)],'bandpass');
      y9=handles.g9*filter(b8,1,handles.y);
    % 
     %highpass
    cut_off2=15000;
    c=fir1(orde,cut_off2/(handles.Fs/2),'high');
    y10=handles.g10*filter(c,1,handles.y);
    %handles.yT=y1+y2+y3+y4+y5+y6+y7;
    handles.yT=y1+y2+y3+y4+y5+y6+y7+y8+y9+y10;

    handles.yT = handles.yT/max(handles.yT);

    handles.player = audioplayer(handles.yT, handles.Fs);
    % player.play()
    axes(handles.axes5);
    plot((0:length(handles.y)-1)/handles.Fs, handles.y);
    title('Original audio');
    axes(handles.axes6);
    plot((0:length(handles.yT)-1)/handles.Fs,handles.yT);
    title('Filtered audio');
    guidata(hObject,handles)
end


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton14_Callback(hObject, eventdata, handles)
% global player;
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%equalizer_play();
% persistent chk
if isempty(handles.player)
    handles = play_equalizer(hObject, handles); 
    guidata(hObject,handles)
    play(handles.player)
    set(handles.push_stop,'Enable','on');
elseif ~handles.player.isplaying()
    resume(handles.player);
    set(handles.push_stop,'Enable','on');
    guidata(hObject,handles)
%     [handles.yT,handles.Fs] = audioread(handles.fullpathname);
else
%     play_equalizer(hObject, handles); 
    pause(handles.player);
    set(handles.push_stop,'Enable','on');
    guidata(hObject,handles)
end

%t=0:1/handles.Fs:(length(handles.player)-1)/handles.Fs;
%plot(handles.yT,handles.axes2);
%set(handles.axes2);
%handles.yT(handles.axes2);


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.g2=get(handles.slider2_tag,'value');
set(handles.band2_edit_tag, 'String',handles.g2);
handles.player =[];
guidata(hObject,handles);
plot_mag(handles);


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function band1_tag_Callback(hObject, eventdata, handles)
% hObject    handle to band1_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.g1=get(handles.band1_tag,'value');
set(handles.band1_edit_tag, 'String',handles.g1);
handles.player =[];
guidata(hObject,handles);
plot_mag(handles);


% --- Executes during object creation, after setting all properties.
function band1_tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to band1_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function band2_tag_Callback(hObject, eventdata, handles)
% hObject    handle to band2_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.g2=get(handles.band2_tag,'value');
set(handles.band2_edit_tag, 'String',handles.g2);
handles.player =[];
plot_mag(handles)
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function band2_tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to band2_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function band3_tag_Callback(hObject, eventdata, handles)
% hObject    handle to band3_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.g3=get(handles.band3_tag,'value');
set(handles.band3_edit_tag, 'String',handles.g3);
handles.player =[];
guidata(hObject,handles);
plot_mag(handles)


% --- Executes during object creation, after setting all properties.
function band3_tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to band3_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function band9_tag_Callback(hObject, eventdata, handles)
% hObject    handle to band9_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.g9=get(handles.band9_tag,'value');
set(handles.band7_edit_tag, 'String',handles.g9);
handles.player =[];
guidata(hObject,handles);
plot_mag(handles);


% --- Executes during object creation, after setting all properties.
function band9_tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to band9_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function band4_tag_Callback(hObject, eventdata, handles)
% hObject    handle to band4_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.g4=get(handles.band4_tag,'value');
set(handles.band4_edit_tag, 'String',handles.g4);
handles.player =[];
guidata(hObject,handles);
plot_mag(handles)


% --- Executes during object creation, after setting all properties.
function band4_tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to band4_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



% --- Executes on slider movement.
function band5_tag_Callback(hObject, eventdata, handles)
% hObject    handle to band5_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.g5=get(handles.band5_tag,'value');
set(handles.band5_edit_tag, 'String',handles.g5);
handles.player =[];
plot_mag(handles);
guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function band5_tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to band5_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



% --- Executes on slider movement.
function band6_tag_Callback(hObject, eventdata, handles)
% hObject    handle to band6_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.g6=get(handles.band6_tag,'value');
set(handles.band6_edit_tag, 'String',handles.g6);
handles.player =[];
guidata(hObject,handles);
plot_mag(handles)


% --- Executes during object creation, after setting all properties.
function band6_tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to band6_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



% --- Executes on slider movement.
function band7_tag_Callback(hObject, eventdata, handles)
% hObject    handle to band7_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.g7=get(handles.band7_tag,'value');
set(handles.band7_edit_tag, 'String',handles.g7);
handles.player =[];
plot_mag(handles)
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function band7_tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to band7_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function band8_tag_Callback(hObject, eventdata, handles)
% hObject    handle to band8_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.g8=get(handles.band8_tag,'value');
set(handles.band8_edit_tag, 'String',handles.g8);
handles.player =[];
plot_mag(handles);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function band8_tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to band8_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global player;
play_equalizer(hObject, handles); 
stop(player);
guidata(hObject,handles)

% --- Executes on slider movement.
function band10_tag_Callback(hObject, eventdata, handles)
% hObject    handle to band10_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.g10=get(handles.band10_tag,'value');
set(handles.band10_edit_tag, 'String',handles.g10);
handles.player =[];
plot_mag(handles);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function band10_tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to band10_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in Pop.
function Pop_Callback(hObject, eventdata, handles)
% hObject    handle to Pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
g1 = -1.5;
g2 = 3.9;
g3 = 5.4;
g4 = 4.5;
g5 =  0.9;
g6 = -1.5;
g7 = -1.8;
g8= -2.1;
g9 = -2.1;
g10 = -0.3;
set(handles.band1_tag,'value',g1);
set(handles.band2_tag,'value',g2);
set(handles.band3_tag,'value',g3);
set(handles.band4_tag,'value',g4);
set(handles.band5_tag,'value',g5);
set(handles.band6_tag,'value',g6);
set(handles.band7_tag,'value',g7);
set(handles.band8_tag,'value',g8);
set(handles.band9_tag,'value',g9);
set(handles.band10_tag,'value',g10);
set(handles.band1_edit_tag, 'String',g1);
set(handles.band2_edit_tag, 'String',g2);
set(handles.band3_edit_tag, 'String',g3);
set(handles.band4_edit_tag, 'String',g4);
set(handles.band5_edit_tag, 'String',g5);
set(handles.band6_edit_tag, 'String',g6);
set(handles.band7_edit_tag, 'String',g7);
set(handles.band8_edit_tag, 'String',g8);
set(handles.band9_edit_tag, 'String',g9);
set(handles.band10_edit_tag, 'String',g10);


 


% --- Executes on button press in Reggae.
function Reggae_Callback(hObject, eventdata, handles)
g1 = 0;
g2 = 0;
g3 = -0.3;
g4 = -2.7;
g5 =  0;
g6 = 2.1;
g7 = 4.5;
g8= 3;
g9 = 0.6;
g10 = 0;
set(handles.band1_tag,'value',g1);
set(handles.band2_tag,'value',g2);
set(handles.band3_tag,'value',g3);
set(handles.band4_tag,'value',g4);
set(handles.band5_tag,'value',g5);
set(handles.band6_tag,'value',g6);
set(handles.band7_tag,'value',g7);
set(handles.band8_tag,'value',g8);
set(handles.band9_tag,'value',g9);
set(handles.band10_tag,'value',g10);

set(handles.band1_edit_tag, 'String',g1);
set(handles.band2_edit_tag, 'String',g2);
set(handles.band3_edit_tag, 'String',g3);
set(handles.band4_edit_tag, 'String',g4);
set(handles.band5_edit_tag, 'String',g5);
set(handles.band6_edit_tag, 'String',g6);
set(handles.band7_edit_tag, 'String',g7);
set(handles.band8_edit_tag, 'String',g8);
set(handles.band9_edit_tag, 'String',g9);
set(handles.band10_edit_tag, 'String',g10);



% hObject    handle to Reggae (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Rock.
function Rock_Callback(hObject, eventdata, handles)
% hObject    handle to Rock (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
g1 = 4.5;
g2 = -3.6;
g3 = -6.6;
g4 = -2.7;
g5 =  2.1;
g6 = 6;
g7 = 7.5;
g8= 7.8;
g9 =7.8;
g10 = 8.1;
set(handles.band1_tag,'value',g1);
set(handles.band2_tag,'value',g2);
set(handles.band3_tag,'value',g3);
set(handles.band4_tag,'value',g4);
set(handles.band5_tag,'value',g5);
set(handles.band6_tag,'value',g6);
set(handles.band7_tag,'value',g7);
set(handles.band8_tag,'value',g8);
set(handles.band9_tag,'value',g9);
set(handles.band10_tag,'value',g10);

set(handles.band1_edit_tag, 'String',g1);
set(handles.band2_edit_tag, 'String',g2);
set(handles.band3_edit_tag, 'String',g3);
set(handles.band4_edit_tag, 'String',g4);
set(handles.band5_edit_tag, 'String',g5);
set(handles.band6_edit_tag, 'String',g6);
set(handles.band7_edit_tag, 'String',g7);
set(handles.band8_edit_tag, 'String',g8);
set(handles.band9_edit_tag, 'String',g9);
set(handles.band10_edit_tag, 'String',g10);



% --- Executes on button press in Techno.
function Techno_Callback(hObject, eventdata, handles)
% hObject    handle to Techno (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
g1 = 4.8;
g2 = 4.2;
g3 = 1.5;
g4 = -2.4;
g5 =  -3.3;
g6 = -1.5;
g7 = 1.5;
g8= 5.1;
g9 = 5.7;
g10 = 5.4;
set(handles.band1_tag,'value',g1);
set(handles.band2_tag,'value',g2);
set(handles.band3_tag,'value',g3);
set(handles.band4_tag,'value',g4);
set(handles.band5_tag,'value',g5);
set(handles.band6_tag,'value',g6);
set(handles.band7_tag,'value',g7);
set(handles.band8_tag,'value',g8);
set(handles.band9_tag,'value',g9);
set(handles.band10_tag,'value',g10);

set(handles.band1_edit_tag, 'String',g1);
set(handles.band2_edit_tag, 'String',g2);
set(handles.band3_edit_tag, 'String',g3);
set(handles.band4_edit_tag, 'String',g4);
set(handles.band5_edit_tag, 'String',g5);
set(handles.band6_edit_tag, 'String',g6);
set(handles.band7_edit_tag, 'String',g7);
set(handles.band8_edit_tag, 'String',g8);
set(handles.band9_edit_tag, 'String',g9);
set(handles.band10_edit_tag, 'String',g10);


% --- Executes on button press in Party.
function Party_Callback(hObject, eventdata, handles)
% hObject    handle to Party (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
g1 = 5.4;
g2 = 0;
g3 = 0;
g4 = 0;
g5 =  0;
g6 = 0;
g7 = 0;
g8= 0;
g9 = 0;
g10 = 5.4;
set(handles.band1_tag,'value',g1);
set(handles.band2_tag,'value',g2);
set(handles.band3_tag,'value',g3);
set(handles.band4_tag,'value',g4);
set(handles.band5_tag,'value',g5);
set(handles.band6_tag,'value',g6);
set(handles.band7_tag,'value',g7);
set(handles.band8_tag,'value',g8);
set(handles.band9_tag,'value',g9);
set(handles.band10_tag,'value',g10);

set(handles.band1_edit_tag, 'String',g1);
set(handles.band2_edit_tag, 'String',g2);
set(handles.band3_edit_tag, 'String',g3);
set(handles.band4_edit_tag, 'String',g4);
set(handles.band5_edit_tag, 'String',g5);
set(handles.band6_edit_tag, 'String',g6);
set(handles.band7_edit_tag, 'String',g7);
set(handles.band8_edit_tag, 'String',g8);
set(handles.band9_edit_tag, 'String',g9);
set(handles.band10_edit_tag, 'String',g10);



% --- Executes on button press in Classical.
function Classical_Callback(hObject, eventdata, handles)
% hObject    handle to Classical (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
g1 = 0;
g2 = 0;
g3 = 0;
g4 = 0;
g5 =  0;
g6 = 0;
g7 = -0.3;
g8= -5.7;
g9 = -6;
g10 = -8.1;
set(handles.band1_tag,'value',g1);
set(handles.band2_tag,'value',g2);
set(handles.band3_tag,'value',g3);
set(handles.band4_tag,'value',g4);
set(handles.band5_tag,'value',g5);
set(handles.band6_tag,'value',g6);
set(handles.band7_tag,'value',g7);
set(handles.band8_tag,'value',g8);
set(handles.band9_tag,'value',g9);
set(handles.band10_tag,'value',g10);

set(handles.band1_edit_tag, 'String',g1);
set(handles.band2_edit_tag, 'String',g2);
set(handles.band3_edit_tag, 'String',g3);
set(handles.band4_edit_tag, 'String',g4);
set(handles.band5_edit_tag, 'String',g5);
set(handles.band6_edit_tag, 'String',g6);
set(handles.band7_edit_tag, 'String',g7);
set(handles.band8_edit_tag, 'String',g8);
set(handles.band9_edit_tag, 'String',g9);
set(handles.band10_edit_tag, 'String',g10);


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject ,eventdata,handles)
% hObject    handle to Pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles.y,handles.Fs] = audioread(handles.fullpathname);
soundsc(handles.y,handles.Fs)



% --- Executes on button press in push_stop.
function push_stop_Callback(hObject, eventdata, handles)
% hObject    handle to push_stop (see )
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 stop(handles.player);
 
% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.y)
    sound(handles.y, handles.Fs);
end

% --- Executes on button press in save_rec_tag.
function save_rec_tag_Callback(hObject, eventdata, handles)
% hObject    handle to save_rec_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.y)
    [fname, pname] = uiputfile('*.wav', 'Save original file', 'Recorded');
    audiowrite(fullfile(pname, fname), handles.y, handles.Fs);
end

% --- Executes during object creation, after setting all properties.
function rec_tag_Callback(hObject, eventdata, handles)
% hObject    handle to rec_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~handles.recObj.isrecording()  % if not recording then start 
    record(handles.recObj)
    set(handles.save_rec_tag, 'Enable', 'off');
    set(handles.rec_tag, 'String', 'Stop');
    guidata(hObject,handles)
else    % if recording then stop
    stop(handles.recObj)
    set(handles.rec_tag, 'String', 'Record');
    set(handles.save_rec_tag, 'Enable', 'on');
    handles.y = getaudiodata(handles.recObj,'double');
    
    % Enable all bands when audio is available
    for ii=1:10
        set(handles.(['band', num2str(ii), '_tag']), 'Enable', 'on');
    end
    guidata(hObject,handles)
end

% Saving can eb a different button.
% audiowrite('newfile.wav', handles.x, handles.Fs)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes during object creation, after setting all properties.
function rec_tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rec_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

contents = cellstr(get(hObject,'String'));
contents{get(hObject,'Value')};
handles.player = [];
guidata(hObject,handles)
eval([contents{get(hObject,'Value')}, '_Callback(hObject, eventdata, handles)'])

if ~ isempty(handles.y)
%     handles.Volume=get(handles.slider15,'value');
    %handles.y=handles.y(NewStart:end,:); 
    handles.g1=get(handles.band1_tag,'value');
    handles.g2=get(handles.band2_tag,'value');
    handles.g3=get(handles.band3_tag,'value');
    handles.g4=get(handles.band4_tag,'value');
    handles.g5=get(handles.band5_tag,'value');
     handles.g6=get(handles.band6_tag,'value');
     handles.g7=get(handles.band7_tag,'value');
     handles.g8=get(handles.band8_tag,'value');
     handles.g9=get(handles.band9_tag,'value');
    handles.g10=get(handles.band10_tag,'value');
    
    set(handles.band1_edit_tag, 'String',handles.g1);
    set(handles.band2_edit_tag, 'String',handles.g2);
    set(handles.band3_edit_tag, 'String',handles.g3);
    set(handles.band4_edit_tag, 'String',handles.g4);
    set(handles.band5_edit_tag, 'String',handles.g5);
    set(handles.band6_edit_tag, 'String',handles.g6);
    set(handles.band7_edit_tag, 'String',handles.g7);
    set(handles.band8_edit_tag, 'String',handles.g8);
    set(handles.band9_edit_tag, 'String',handles.g9);
    set(handles.band10_edit_tag, 'String',handles.g10);
    
    H_total = [];
    cut_off=200; %cut off low pass dalama Hz
    orde=16;
    a=fir1(orde,cut_off/(handles.Fs/2),'low');
    y1=handles.g1*filter(a,1,handles.y);

    % %bandpass1
    f1=201;
    f2=400;
    b1=fir1(orde,[f1/(handles.Fs/2) f2/(handles.Fs/2)],'bandpass');
    y2=10^(handles.g2/20)*filter(b1,1,handles.y);
    % 
    % %bandpass2
    f3=401;
    f4=800;
    b2=fir1(orde,[f3/(handles.Fs/2) f4/(handles.Fs/2)],'bandpass');
    y3=10^(handles.g3)*filter(b2,1,handles.y);
    % 
    % %bandpass3
     f4=801; 
    f5=1500;
     b3=fir1(orde,[f4/(handles.Fs/2) f5/(handles.Fs/2)],'bandpass');
     y4=10^(handles.g4)*filter(b3,1,handles.y);
    % 
    % %bandpass4
     f5=1501;
    f6=3000;
     b4=fir1(orde,[f5/(handles.Fs/2) f6/(handles.Fs/2)],'bandpass');
     y5=10^(handles.g5)*filter(b4,1,handles.y);
    % 
    % %bandpass5
      f7=3001;
    f8=5000;
      b5=fir1(orde,[f7/(handles.Fs/2) f8/(handles.Fs/2)],'bandpass');
      y6=10^(handles.g6/20)*filter(b5,1,handles.y);
    % 
    % %bandpass6
      f9=5001;
    f10=7000;
      b6=fir1(orde,[f9/(handles.Fs/2) f10/(handles.Fs/2)],'bandpass');
      y7=10^(handles.g7/20)*filter(b6,1,handles.y);
    % 
    % %bandpass7
      f11=7001;
    f12=10000;
      b7=fir1(orde,[f11/(handles.Fs/2) f12/(handles.Fs/2)],'bandpass');
     y8=10^(handles.g8/20)*filter(b7,1,handles.y);
    % 
     % %bandpass8
      f13=10001;
    f14=15000;
      b8=fir1(orde,[f13/(handles.Fs/2) f14/(handles.Fs/2)],'bandpass');
      y9=10^(handles.g9/20)*filter(b8,1,handles.y);
    % 
     %highpass
    cut_off2=15000;
    c=fir1(orde,cut_off2/(handles.Fs/2),'high');
    y10=10^(handles.g10/20)*filter(c,1,handles.y);
    %handles.yT=y1+y2+y3+y4+y5+y6+y7;
    handles.yT=y1+y2+y3+y4+y5+y6+y7+y8+y9+y10;

    handles.yT = handles.yT/max(handles.yT);

    handles.player = audioplayer(handles.yT, handles.Fs);
    % player.play()
    axes(handles.axes5);
    plot((0:length(handles.y)-1)/handles.Fs, handles.y);
    title('Original audio');
    axes(handles.axes6);
    plot((0:length(handles.yT)-1)/handles.Fs,handles.yT);
    title('Filtered audio');
    guidata(hObject,handles)
end
set(handles.axes6,'Visible','on');
set(handles.axes7,'Visible','on');

if ~ isempty(handles.y)
   g1= get(handles.band1_tag,'value');
   g2= get(handles.band2_tag,'value');
   g3 = get(handles.band3_tag,'value');
   g4 = get(handles.band4_tag,'value');
   g5= get(handles.band5_tag,'value');
   g6 = get(handles.band6_tag,'value');
   g7 = get(handles.band7_tag,'value');
   g8 = get(handles.band8_tag,'value');
   g9 = get(handles.band9_tag,'value');
   g10 = get(handles.band10_tag,'value');

   handles.g1=get(handles.band1_tag,'value');
   handles.g2=get(handles.band2_tag,'value');
   handles.g3=get(handles.band3_tag,'value');
   handles.g4=get(handles.band4_tag,'value');
   handles.g5=get(handles.band5_tag,'value');
   handles.g6=get(handles.band6_tag,'value');
   handles.g7=get(handles.band7_tag,'value');
   handles.g8=get(handles.band8_tag,'value');
   handles.g9=get(handles.band9_tag,'value');
   handles.g10=get(handles.band10_tag,'value');
      
   plot_mag(handles)
end

function H_total = plot_mag(handles)
    cut_off=200;
    orde=16;
     f1=201;
    f2=400;
    f3=401;
    f4=800;
    f5=1501;
    f6=3000;
     f7=3001;
    f8=5000;
     f9=5001;
    f10=7000;
     f11=7001;
    f12=10000;
    f13=10001;
    f14=15000;
    cut_off2=15000;
    a=fir1(orde,cut_off/(handles.Fs/2),'low');
    H_total = 10^(handles.g1/20)*abs(freqz(a, 1, 1024));
    
    b1=fir1(orde,[f1/(handles.Fs/2) f2/(handles.Fs/2)],'bandpass');
    H_total = H_total + 10^(handles.g2/20)*abs(freqz(b1, 1, 1024));
    
    b2=fir1(orde,[f3/(handles.Fs/2) f4/(handles.Fs/2)],'bandpass');
    H_total = H_total + 10^(handles.g3/20)*abs(freqz(b2, 1, 1024));
    
    b3=fir1(orde,[f4/(handles.Fs/2) f5/(handles.Fs/2)],'bandpass');
    H_total = H_total + 10^(handles.g4/20)*abs(freqz(b3, 1, 1024));
    
    b4=fir1(orde,[f5/(handles.Fs/2) f6/(handles.Fs/2)],'bandpass');
    H_total = H_total + 10^(handles.g5/20)*abs(freqz(b4, 1, 1024));
    
    b5=fir1(orde,[f7/(handles.Fs/2) f8/(handles.Fs/2)],'bandpass');
    H_total = H_total + 10^(handles.g6/20)*abs(freqz(b5, 1, 1024));
    
    b6=fir1(orde,[f9/(handles.Fs/2) f10/(handles.Fs/2)],'bandpass');
    H_total = H_total + 10^(handles.g7/20)*abs(freqz(b6, 1, 1024));
    
    b7=fir1(orde,[f11/(handles.Fs/2) f12/(handles.Fs/2)],'bandpass');
    H_total = H_total + 10^(handles.g8/20)*abs(freqz(b7, 1, 1024));
    
    b8=fir1(orde,[f13/(handles.Fs/2) f14/(handles.Fs/2)],'bandpass');
    H_total = H_total + 10^(handles.g9/20)*abs(freqz(b8, 1, 1024));
    
    c=fir1(orde,cut_off2/(handles.Fs/2),'high');
    H_total = H_total + 10^(handles.g10/20)*abs(freqz(c, 1, 1024));
    
    axes(handles.axes7);
    N = length(H_total);
    plot((0:N-1)/(N-1)*handles.Fs/2, abs(H_total));
    axis tight
    title('Filter')


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
