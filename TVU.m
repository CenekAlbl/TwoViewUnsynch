function varargout = TVU(varargin)
% TVU MATLAB code for TVU.fig
%      TVU, by itself, creates a new TVU or raises the existing
%      singleton*.
%
%      H = TVU returns the handle to a new TVU or the handle to
%      the existing singleton*.
%
%      TVU('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TVU.M with the given input arguments.
%
%      TVU('Property','Value',...) creates a new TVU or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TVU_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TVU_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TVU

% Last Modified by GUIDE v2.5 24-Jul-2017 10:24:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TVU_OpeningFcn, ...
                   'gui_OutputFcn',  @TVU_OutputFcn, ...
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


% --- Executes just before TVU is made visible.
function TVU_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TVU (see VARARGIN)

% Choose default command line output for TVU
handles.output = hObject;

% Program data
handles.data.imcell1 = {};
handles.data.imcell2 = {};
handles.data.nframes1 = 0;
handles.data.nframes2 = 0;
handles.data.currframe1 = 0;
handles.data.currframe2 = 0;
handles.data.imagepts1 = {};
handles.data.imagepts2 = {};
handles.data.tracks = {};
handles.data.draw_tracks = 0;
handles.data.imh1 = 1;
handles.data.imw1 = 1;
handles.data.imh2 = 1;
handles.data.imw2 = 1;
% synchronization data
handles.data.fps1 = 1;
handles.data.fps2 = 1;
handles.data.offset1 = 0;
handles.data.offset2 = 0;
handles.data.currtime = 0;
%synchronization options
handles.options.ransac_rounds = 500;
handles.options.ransac_treshold = 2;
handles.options.kmax = 6;
handles.options.kmin = 0;
handles.options.max_iter = 50;
% default GUI data
handles.indexSlider1=0;
handles.indexSlider2=0;
handles.indexSlider3=0;
handles.status_bar.String = {};
% Update handles structure
guidata(hObject, handles);

% add folders
addpath('functions')

% UIWAIT makes TVU wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TVU_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
    handles.data.offset1 = get(hObject, 'Value');
    handles = update_current_frame(handles);
    redraw(handles);
    update_labels(handles,hObject);
    guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
    handles.data.offset2 = round(get(hObject, 'Value'));
    handles = update_current_frame(handles);
    redraw(handles);
    update_labels(handles,hObject);
    guidata(hObject, handles);


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
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
    % handles.indexSlider3 = get(hObject, 'Value');
    % imshow(handles.data.video(handles.indexSlider3 + handles.indexSlider1).vdata, 'Parent', handles.axes1);
    % imshow(handles.data.imcell{handles.indexSlider3 + handles.indexSlider2}, 'Parent', handles.axes2);
    % handles.indexSlider1 = handles.indexSlider1 + handles.indexSlider3;
    % handles.indexSlider2 = handles.indexSlider2 + handles.indexSlider3;
    % guidata(hObject, handles);
    
    handles.data.currtime = get(hObject, 'Value');
    handles = update_current_frame(handles);
    redraw(handles);
    update_labels(handles,hObject);
    guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    [filenames, pathname] = uigetfile({'*.*'}, 'Pick MP4 video or image sequence', 'MultiSelect', 'on');
    if(length(filenames)~=0)
        if iscell(filenames)
            handles.data.imcell1 = cell(1,length(filenames));
            for i = 1:length(handles.data.imcell1)
                handles.data.imcell1{i} = imread(strcat(pathname, '\', filenames{i}));
            end
        else
            v = VideoReader([pathname, filenames]);
            vHeight = v.Height;
            vWidth = v.Width;
            i = 1;
            while hasFrame(v)
                handles.data.imcell1{i} = readFrame(v);
                i = i + 1;
            end
        end
    handles.data.nframes1 = numel(handles.data.imcell1);
    handles.data.currframe1 = 1;
    handles.data.imw1 = size(handles.data.imcell1{1},2);
    handles.data.imh1 = size(handles.data.imcell1{1},1);
    update_sliders(handles,hObject);
    handles.indexSlider1 = 1;
    handles.indexSlider3 = 1;
    update_labels(handles,hObject);
    redraw(handles);
    guidata(hObject, handles);
    end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)    
    [filenames, pathname] = uigetfile({'*.*'}, 'Pick MP4 video or image sequence', 'MultiSelect', 'on');
    if(length(filenames)~=0)
        if iscell(filenames)

            handles.data.imcell2 = cell(1,length(filenames));
            for i = 1:length(handles.data.imcell2)
                handles.data.imcell2{i} = imread(strcat(pathname, '\', filenames{i}));
            end
        elseif(filenames~=0)
            v = VideoReader([pathname, filenames]);
            vHeight = v.Height;
            vWidth = v.Width;
            i = 1;
            while hasFrame(v)
                handles.data.imcell2{i} = readFrame(v);
                i = i + 1;
            end            
        end
        handles.data.nframes2 = numel(handles.data.imcell2);
        handles.data.currframe2 = 1;
        handles.data.imw2 = size(handles.data.imcell2{1},2);
        handles.data.imh2 = size(handles.data.imcell2{1},1);
        update_sliders(handles,hObject);
        handles.indexSlider2 = 1;
        handles.indexSlider3 = 1;
        update_labels(handles,hObject);
        redraw(handles);
        guidata(hObject, handles);  
    end

% --- Executes on button press in load_tracks_button.
function load_tracks_button_Callback(hObject, eventdata, handles)
% hObject    handle to load_tracks_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    [filenames, pathname] = uigetfile({'*.*'}, 'Pick file containing image tracks', 'MultiSelect', 'off');
    length(filenames)
    if(filenames~=0)
        handles.data.tracks = load_tracks([pathname filenames]);
        handles.data.imagepts1 = {};
        handles.data.imagepts2 = {};
        maxw = 0;
        maxh = 0;
        imgpts_total=0;
        for i=1:length(handles.data.tracks{1})
            imgpts_total = imgpts_total+size(handles.data.tracks{1}{i},1);
            for j=1:size(handles.data.tracks{1}{i},1)
                if(round(max(handles.data.tracks{1}{i}(:,1)))>length(handles.data.imagepts1))
                    handles.data.imagepts1{round(max(handles.data.tracks{1}{i}(:,1)))} = [];
                end
                handles.data.imagepts1{handles.data.tracks{1}{i}(j,1)}(:,end+1) = handles.data.tracks{1}{i}(j,2:3)';
                if(max(handles.data.tracks{1}{i}(j,2))>maxw)
                   maxw =  max(handles.data.tracks{1}{i}(j,2));
                end
                if(max(handles.data.tracks{1}{i}(j,3))>maxh)
                   maxh =  max(handles.data.tracks{1}{i}(j,2));
                end
            end
        end
        handles.data.imw1 = maxw;
        handles.data.imh1 = maxh;
        maxw = 0;
        maxh = 0;
        for i=1:length(handles.data.tracks{2})
            imgpts_total = imgpts_total+size(handles.data.tracks{2}{i},1);
            for j=1:size(handles.data.tracks{2}{i},1)        
                if(round(max(handles.data.tracks{2}{i}(:,1)))>length(handles.data.imagepts2))
                    handles.data.imagepts2{round(max(handles.data.tracks{2}{i}(:,1)))} = [];
                end
                handles.data.imagepts2{handles.data.tracks{2}{i}(j,1)}(:,end+1) = handles.data.tracks{2}{i}(j,2:3)';
                if(max(handles.data.tracks{2}{i}(j,2))>maxw)
                   maxw =  max(handles.data.tracks{2}{i}(j,2));
                end
                if(max(handles.data.tracks{2}{i}(j,3))>maxh)
                   maxh =  max(handles.data.tracks{2}{i}(j,2));
                end
            end
        end
        handles.data.imw2 = maxw;
        handles.data.imh2 = maxh;
        if(handles.data.currframe1 == 0)
            handles.data.currframe1 = 1;
            handles.data.nframes1 = length(handles.data.imagepts1);
            update_sliders(handles,hObject);
        end
        if(handles.data.currframe2 == 0)
            handles.data.currframe2 = 1;
            handles.data.nframes2 = length(handles.data.imagepts2);
            update_sliders(handles,hObject);
        end
        redraw(handles);
        status_msg(handles,sprintf('Tracks loaded - %d image points total',imgpts_total));
        guidata(hObject, handles);
    end
        
        

% --- Executes on button press in imagePointsCheckBox.
function imagePointsCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to imagePointsCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of imagePointsCheckBox
if(~isempty(handles.data.tracks))
    if(get(hObject,'Value'))
        handles.data.draw_tracks = 1;
    else
        handles.data.draw_tracks = 0;
    end
    guidata(hObject, handles);
    redraw(handles)
end

function handles = update_current_frame(handles)
if((time2frame(handles.data.currtime,handles.data.fps1,handles.data.offset1))>handles.data.nframes1)
    handles.data.currframe1 = handles.data.nframes1;
elseif((time2frame(handles.data.currtime,handles.data.fps1,handles.data.offset1))<1)
    handles.data.currframe1 = 1;
else
    handles.data.currframe1 = time2frame(handles.data.currtime,handles.data.fps1,handles.data.offset1);
end
if((time2frame(handles.data.currtime,handles.data.fps2,handles.data.offset2))>handles.data.nframes2)
    handles.data.currframe2 = handles.data.nframes2;
elseif((time2frame(handles.data.currtime,handles.data.fps2,handles.data.offset2))<1)
    handles.data.currframe2 = 1;        
else
     handles.data.currframe2 = time2frame(handles.data.currtime,handles.data.fps2,handles.data.offset2);
end 


function redraw(handles)
cla(handles.axes2);
cla(handles.axes1);
if(~isempty(handles.data.imcell1)&&handles.data.currframe1~=0)
    imshow(handles.data.imcell1{handles.data.currframe1}, 'Parent', handles.axes1);
end
if(~isempty(handles.data.imcell2)&&handles.data.currframe2~=0)
    imshow(handles.data.imcell2{handles.data.currframe2}, 'Parent', handles.axes2);
end
xlim(handles.axes1,[0 handles.data.imw1]);
ylim(handles.axes1,[0 handles.data.imh1]);
hold(handles.axes1,'on');
xlim(handles.axes2,[0 handles.data.imw2]);
ylim(handles.axes2,[0 handles.data.imh2]);
hold(handles.axes2,'on');
if(~isempty(handles.data.tracks)&&handles.data.draw_tracks)
    if(length(handles.data.imagepts1)>=handles.data.currframe1)
        if(~isempty(handles.data.imagepts1{handles.data.currframe1}))
            plot(handles.axes1,handles.data.imagepts1{handles.data.currframe1}(1,:),handles.data.imagepts1{handles.data.currframe1}(2,:),'xr');
        end
    end
    if(length(handles.data.imagepts2)>=handles.data.currframe2)
        if(~isempty(handles.data.imagepts2{handles.data.currframe2}))
            plot(handles.axes2,handles.data.imagepts2{handles.data.currframe2}(1,:),handles.data.imagepts2{handles.data.currframe2}(2,:),'xr');
        end
    end
    hold(handles.axes1,'off');
    hold(handles.axes2,'off');
end

function update_labels(handles,hObject)
handles.label_frame1.String = sprintf('Frame %d',handles.data.currframe1);
handles.label_frame2.String = sprintf('Frame %d',handles.data.currframe2);
handles.edit_offset1.String = sprintf('%f',handles.data.offset1);
handles.edit_offset2.String = sprintf('%f',handles.data.offset2);
handles.label_time.String = sprintf('Time: %0.2f s',handles.data.currtime);
guidata(hObject, handles);

function update_sliders(handles,hObject)
set(handles.slider1, 'Min', 0, 'Max', handles.data.nframes1/handles.data.fps1, 'SliderStep', [1 1]/(max(handles.data.nframes1,1)), 'Value', handles.data.offset1);
set(handles.slider2, 'Min', 0, 'Max', handles.data.nframes2/handles.data.fps2, 'SliderStep', [1 1]/(max(handles.data.nframes2,2)), 'Value', handles.data.offset2);
set(handles.slider3, 'Min', 0, 'Max', max(frame2time(handles.data.nframes1,handles.data.fps1,handles.data.offset1),frame2time(handles.data.nframes2,handles.data.fps2,handles.data.offset2)), 'SliderStep', [1 1]/max([handles.data.nframes1,handles.data.nframes2]), 'Value', handles.data.currtime);
guidata(hObject, handles);
update_labels(handles,hObject);
redraw(handles);


function set_fps(handles,hObject,fps,sequence_id)
if(sequence_id==1)
    handles.data.fps1 = fps;
    handles.data.offset1 = 0;
else
    handles.data.fps2 = fps;
    handles.data.offset2 = 0;
end
handles.data.currtime = 0;
handles = update_current_frame(handles);
update_sliders(handles,hObject);
update_labels(handles,hObject);
guidata(hObject, handles);

function handles = set_offset(handles,hObject,offset,sequence_id)
if(sequence_id==1)
    handles.data.offset1 = offset;
else
    handles.data.offset2 = offset;
end
handles = update_current_frame(handles);
update_sliders(handles,hObject);
update_labels(handles,hObject);
guidata(hObject, handles);

function edit_fps1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_fps1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_fps1 as text
%        str2double(get(hObject,'String')) returns contents of edit_fps1 as a double
set_fps(handles,hObject,str2double(get(hObject,'String')),1)



% --- Executes during object creation, after setting all properties.
function edit_fps1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_fps1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_fps2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_fps2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_fps2 as text
%        str2double(get(hObject,'String')) returns contents of edit_fps2 as a double
set_fps(handles,hObject,str2double(get(hObject,'String')),2)

% --- Executes during object creation, after setting all properties.
function edit_fps2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_fps2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in synchronizeFbutton.
function synchronizeFbutton_Callback(hObject, eventdata, handles)
% hObject    handle to synchronizeFbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%generate_corresp(handles.data.tracks,handles.data.fps1,handles.data.fps2,handles.data.offset1,handles.data.offset2);

thr = 2;
rounds_ransac = 500;
rounds_iter = 50;
algorithm = '8pt';
err_fcn='epipolar_distance';

kmax = 6;
kmin = 0;
offset2 = 0;
[Ftres,dts,offset2,Ft_inliers,corresp,emin_Ft,step,info] = compute_Ft_iter(handles.data.tracks,handles.data.fps1,handles.data.fps2,handles.data.offset1,handles.data.offset2,handles.options.ransac_treshold,handles.options.ransac_rounds,handles.options.max_iter,algorithm,err_fcn,handles.options.kmax,handles.options.kmin,@(x)status_msg(handles,x),@(x)iteration_update(handles,hObject,x));
status_msg(handles,sprintf('Found offset for sequence 2 %fs',offset2));

function status_msg(handles,msg)
handles.status_bar.String = [ {msg}; handles.status_bar.String];

function iteration_update(handles,hObject,offset2)
if(offset2<0)
    handles = set_offset(handles,hObject,0,2);
    set_offset(handles,hObject,-offset2,1);
else
    handles = set_offset(handles,hObject,offset2,2);
    set_offset(handles,hObject,0,1);
end




function edit_offset1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_offset1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_offset1 as text
%        str2double(get(hObject,'String')) returns contents of edit_offset1 as a double
set_offset(handles,hObject,str2double(get(hObject,'String')),1)

% --- Executes during object creation, after setting all properties.
function edit_offset1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_offset1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_offset2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_offset2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_offset2 as text
%        str2double(get(hObject,'String')) returns contents of edit_offset2 as a double
set_offset(handles,hObject,str2double(get(hObject,'String')),2)


% --- Executes during object creation, after setting all properties.
function edit_offset2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_offset2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ransac_rounds_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ransac_rounds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ransac_rounds as text
%        str2double(get(hObject,'String')) returns contents of edit_ransac_rounds as a double
handles.options.ransac_rounds = str2double(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_ransac_rounds_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ransac_rounds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_inliers_treshold_Callback(hObject, eventdata, handles)
% hObject    handle to edit_inliers_treshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_inliers_treshold as text
%        str2double(get(hObject,'String')) returns contents of edit_inliers_treshold as a double
handles.options.ransac_treshold = str2double(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_inliers_treshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_inliers_treshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_generate_tracks.
function pushbutton_generate_tracks_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_generate_tracks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(~isempty(handles.data.imcell1)&&~isempty(handles.data.imcell1))
%     status_msg(handles,'Generating image files...');
%     mkdir('temp');
%     for i=1:length(handles.data.imcell1)
%        imwrite(handles.data.imcell1{i},sprintf('temp/1_%06d.jpg',i));
%     end
%     for i=1:length(handles.data.imcell2)
%        imwrite(handles.data.imcell2{i},sprintf('temp/2_%06d.jpg',i));
%     end
%     status_msg(handles,'Image files generated');
%     status_msg(handles,'Initializing OpenMVG data structure...');
%     [status,result] = system('3rdparty\openMVG_main_SfMInit_ImageListing.exe --imageDirectory temp  --outputDirectory temp');
%     status_msg(handles,'OpenMVG structure initialized');
%     status_msg(handles,'OpenMVG extracting features...');
%     [status,result] = system('3rdparty\openMVG_main_ComputeFeatures.exe -i temp\sfm_data.json -o temp');
%     status_msg(handles,'OpenMVG features extracted');
%     status_msg(handles,'OpenMVG matching...');
    [status,result] = system('3rdparty\openMVG_main_ComputeMatches.exe -i temp\sfm_data.json -o temp -n BRUTEFORCEL2');
    status_msg(handles,'OpenMVG matching complete');
    status_msg(handles,'OpenMVG making tracks...');
    [status,result] = system(sprintf('3rdparty\\openMVG_main_exportTracks.exe -i temp\\sfm_data.json -d temp -m temp\\matches.f.bin -k %d -l %d -o temp\\tracks.txt',handles.data.nframes1,handles.data.nframes2));
    status_msg(handles,'OpenMVG tracks done');
    status_msg(handles,'Loading tracks');
    handles.data.tracks = load_tracks('temp\tracks.txt');
    imgpts_total=0;
    for i=1:length(handles.data.tracks{1})
            imgpts_total = imgpts_total+size(handles.data.tracks{1}{i},1);
            for j=1:size(handles.data.tracks{1}{i},1)
                if(round(max(handles.data.tracks{1}{i}(:,1)))>length(handles.data.imagepts1))
                    handles.data.imagepts1{round(max(handles.data.tracks{1}{i}(:,1)))} = [];
                end
                handles.data.imagepts1{handles.data.tracks{1}{i}(j,1)}(:,end+1) = handles.data.tracks{1}{i}(j,2:3)';
            end
        end
    for i=1:length(handles.data.tracks{2})
        imgpts_total = imgpts_total+size(handles.data.tracks{2}{i},1);
        for j=1:size(handles.data.tracks{2}{i},1)        
            if(round(max(handles.data.tracks{2}{i}(:,1)))>length(handles.data.imagepts2))
                handles.data.imagepts2{round(max(handles.data.tracks{2}{i}(:,1)))} = [];
            end
            handles.data.imagepts2{handles.data.tracks{2}{i}(j,1)}(:,end+1) = handles.data.tracks{2}{i}(j,2:3)';
        end
    end
    status_msg(handles,sprintf('Tracks loaded - %d image points total',imgpts_total));
    guidata(hObject, handles);
    redraw(handles);
else
    status_msg(handles,'Image data not loaded');
end





function edit_kmax_Callback(hObject, eventdata, handles)
% hObject    handle to edit_kmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_kmax as text
%        str2double(get(hObject,'String')) returns contents of edit_kmax as a double
handles.options.kmax = round(str2double(get(hObject,'String')));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_kmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_kmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
clear


function edit_kmin_Callback(hObject, eventdata, handles)
% hObject    handle to edit_kmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_kmin as text
%        str2double(get(hObject,'String')) returns contents of edit_kmin as a double
handles.options.kmin = round(str2double(get(hObject,'String')));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_kmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_kmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
