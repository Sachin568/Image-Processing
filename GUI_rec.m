function varargout = GUI_rec(varargin)
% GUI_REC MATLAB code for GUI_rec.fig
%      GUI_REC, by itself, creates a new GUI_REC or raises the existing
%      singleton*.
%
%      H = GUI_REC returns the handle to a new GUI_REC or the handle to
%      the existing singleton*.
%
%      GUI_REC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_REC.M with the given input arguments.
%
%      GUI_REC('Property','Value',...) creates a new GUI_REC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_rec_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_rec_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_rec

% Last Modified by GUIDE v2.5 05-May-2018 21:17:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_rec_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_rec_OutputFcn, ...
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


% --- Executes just before GUI_rec is made visible.
function GUI_rec_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_rec (see VARARGIN)

% Choose default command line output for GUI_rec
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_rec wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_rec_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



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

% --- Executes on button press in load Database.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cd('database');
myfile=dir('E:\projects\matlab codes for learning\iris recognition\database\*.jpg');
numOfFiles = length(myfile);                                                %display(numOfFiles);
for k = 1 : numOfFiles
    thisFileName = fullfile(myfile(k).name);
    thisImage = imread(thisFileName);
end

msgbox('Database Loaded');
cd('E:\projects\matlab codes for learning\iris recognition')
guidata(hObject, handles);

% --- Executes on button press in select image.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname] = uigetfile('*.*', 'Pick a MATLAB code file');
    if isequal(filename,0) || isequal(pathname,0)
       warndlg('User pressed cancel')
    else
      a=imread(filename);
      axes(handles.axes1);
      imshow(a);
      handles.filename=filename;
    end
guidata(hObject, handles);

% --- Executes on button press in create template.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename1='Template';
filename2='Mask';

filename=handles.filename;
[segmentediris,template, mask, polar_array] = templete(filename);
str1=[filename1,'.bmp'];
str2=[filename2,'.bmp'];

axes(handles.axes2);
imshow(segmentediris);
%imwrite(x,str1);
%imwrite(y,str2);

axes(handles.axes3);
imshow(polar_array);

axes(handles.axes4)                                                         %figure;imshow(template);
imshow(template);                                                           %display(template);
handles.template = template;
handles.mask = mask;

msgbox('template Generated');
guidata(hObject, handles);


% --- Executes on button press in save template.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
toBeSaved = handles.template;
saveMask = handles.mask;
filename = handles.filename;                                                %display(filename);

[path,name,ext] = fileparts(filename);

assignin('base','saveMask',saveMask);
assignin('base','toBeSaved',toBeSaved);
                                                                            %[fileName, filePath]=uiputfile('*.jpg*', 'save template as');fileName = fullfile(filePath, fileName);
cd('E:\projects\matlab codes for learning\iris recognition\database');
imwrite(toBeSaved,[name,'-template.jpg'],'jpg')                              %(imagewithnoise2,[eyeimage_filename,'-noise.jpg'],'jpg')
imwrite(saveMask,[name,'-mask.jpg'],'jpg')

msgbox('template saved');
guidata(hObject, handles);

cd('E:\projects\matlab codes for learning\iris recognition')

% --- Executes on button press in match.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

template1 = handles.template;
mask1 = handles.mask;

addpath 'E:\projects\matlab codes for learning\iris recognition\database';
myfile=dir('E:\projects\matlab codes for learning\iris recognition\database\*.jpg');
numOfFiles = length(myfile);                                                %display(numOfFiles);
yes = 0;

for k = 1 : 2 : numOfFiles
    FN = fullfile(myfile(k).name);
    FN2 = fullfile(myfile(k+1).name);
    I = imread(FN);
    j = imread(FN2);
    
    mask2 = im2bw(I);                                                       %imshow(mask2);
    template2 = im2bw(j);                                                   %imshow(template22);
    
    hd = gethd(template1, mask1, template2, mask2, 1);                      %display(hd);
    
    if(hd < 0.3)
    msgbox({'authorized user';'access granted' })
    yes = 1;
    break;
    elseif(hd>0.3 && hd < 0.38)
    msgbox('please try again');
    yes = 1;
    break;
    end
    
end

if(yes == 0)
warndlg({'unauthorized user'; 'Access denied'});
end
