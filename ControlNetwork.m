function varargout = ControlNetwork(varargin)
%CONTROLNETWORK MATLAB code file for ControlNetwork.fig
%      CONTROLNETWORK, by itself, creates a new CONTROLNETWORK or raises the existing
%      singleton*.
%
%      H = CONTROLNETWORK returns the handle to a new CONTROLNETWORK or the handle to
%      the existing singleton*.
%
%      CONTROLNETWORK('Property','Value',...) creates a new CONTROLNETWORK using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to ControlNetwork_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      CONTROLNETWORK('CALLBACK') and CONTROLNETWORK('CALLBACK',hObject,...) call the
%      local function named CALLBACK in CONTROLNETWORK.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ControlNetwork

% Last Modified by GUIDE v2.5 17-Aug-2020 00:24:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ControlNetwork_OpeningFcn, ...
                   'gui_OutputFcn',  @ControlNetwork_OutputFcn, ...
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


% --- Executes just before ControlNetwork is made visible.
function ControlNetwork_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for ControlNetwork
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ControlNetwork wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ControlNetwork_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- ?????????????????????? ?????? ?????????????? ???? ???????????? btngraph - ??????????????????.
function btngraph_Callback(hObject, eventdata, handles)

%?????????? ???????????????????? ???????????????? ?????????? ???????????????????????????? ???????????? btngraph(????????????????????)
set(hObject, 'Enable', 'off')
%?????????? ???????????????????? ???????????????? ?????????? ???????????????????????????? ???????????? ptnMenu (????????????????????)?? ???????? ????????????????????
set(handles.ptnMenu, 'Enable', 'off')
%???????????????????????? ???????????? ptnclear - ????????????????
set(handles.ptnclear, 'Enable', 'on') 
%???????????????????????? ???????????? ptnclear - ???????????????? ?? ???????? ????????????????????
set(handles.clearMenu, 'Enable', 'on')
%???????????????????????? ???????????? ?????????????????????? ?????? ???????????? ?????????????????? ?????????????????????????? ??????????????
set(handles.radiobutton1, 'Enable', 'on');
set(handles.radiobutton2, 'Enable', 'on');

%?????????????????? ???????????? ???????????????? ?????????????? uitable5
set(handles.uitable5,'ColumnWidth', {200,'auto','auto'}); 

% ?????????????????????? ?????????? ?????????? ?????????????????? ?? ???????? ???????????????????????????? ???????????? editT ?? ???????????? 
a1=get(handles.editT, 'String');  %???????????????????? ???????????? ?? ?????????????? cell (???????????? ??????????)
t1=str2num(a1);  % str2num(cell2mat(a1))?????????????????????? ???????????? ?????????? ?? ???????????? ??????????
% 
b1=get(handles.editS, 'String');  %???????????????????? ???????????? ?? ?????????????? cell (???????????? ??????????)
s1=str2num(b1);  %?????????????????????? ???????????? ?????????? ?? ???????????? ??????????
% 
c1=get(handles.editW, 'String');  %???????????????????? ???????????? ?? ?????????????? cell (???????????? ??????????)
weights=str2num(c1);  %?????????????????????? ???????????? ?????????? ?? ???????????? ??????????

%t1=[0 1 1 1 1 1 1 2 3 4 5 6 7 8 9 9 10 11 12 13 14 15 16 17];
%s1=[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 17 18 18 18 18 18 18];
%weights=[0.057 0.105 0.007 0.008 0.11 0.257 0.027 0.523 0.062 0.08 0.138 0.058 0.11 0.025 0.023 0.097 0.009 0.009 0.027 0.027 0.027 0.027 0.027 0.027];

%--------------------------------------------------------------------------
%                       ?????????????????? ?????????????? 
%???????????????????????? ?????????????? ?????????????????????????? ?????????? LA - ?????????????????????? ???????? ??????????
%???????????????????? ?????????? (?? ???????????????????? ????????????????????)
LA=min(t1); %?????????????????????? ???????????? - ???????????? ?????????? ???????????? ????????????????
p = fsor(t1, s1, LA); % ???????????????????? ???????????? ????????????????, ?????????????? ?????????????????? ???? ?????????? LA
LA=repmat(LA, 1, length(p)); %  ???????????????????? ?????????????? LA, ?????????????????? ???? 1xlength(p) ?????????? ?????????????? LA
LA=[LA; p];
while 1
    LB=[];
    LP=[];
    k=0;
    for i=p
        if i==0
            p1=0;
        else
            p1 = fsor(t1, s1, i); % ???????????????????? ???????????? ????????????????, ?????????????? ?????????????????? ???? ???????????????????? ???????????????? i 
        end
        if isempty(p1) %?????????????????????? ?????????????? ?????????????? p1
            p1=0;
        end
        k=k+1;
        LB=LA(:, k+1:end); %???????????? ?? ?????????????????????????????? ???????????? LB ???????????????? ????????????????  LA, ?????????????????????? ???????????? ???? ???????????????? k ??????????????
        LA(:, k+1:end)=[]; % ???????????????? ???? ?????????????? LA ????????????????, ???????????????????? ?? ???????????? LB
        LA=[LA repmat(LA(:, k), 1, length(p1)-1)]; % ?????????????????????? ???????????????????? ???????????????? LA 
        LA=[LA LB]; %???????????????????? ???????????????? ???????????????????????????????? ?????????????? LB ?? ?????????????? LA
        LP=[LP p1]; % ???????????? ?????????????? ???????????????? ?? ???????????? LP
    end
    
    if sum(LP)==0
        break
    end
    
    LA=[LA; LP]; % ???????????????????? ?????????????? ???????????????? (?????????????? ?????????????????? ???? ?????????????? ?????????? ???????????????? i) ?? ???????????? LA
    p=LP; % ???????????????????? ?????????????? ?????????????????????? ????????????????
end

%???????????????????? ???????????????????????? ???????? ?????????? LA
LS=LA';
LS(:,1)=[];
Lm=0;
LMsum=[];
for i=1:length(LS(:,1))  
    for j=1:length(LS(1,:))
        d=find(s1==LS(i,j), 1);
        if isempty(d) %???????????????? ?????????????? ?????????????? d
            continue
        end
        Lm=Lm+weights(d); %???????????????????? ???????????????????????? ?????????????? ???????????????????? ????????
    end
    LMsum(i, 1)=Lm; 
    Lm=0;  %?????????????????? Lm ?????? ???????????? ???????????????????????? ?????????????????? ???????? ???????????????? j
end
L=[LA' LMsum]; %???????????? ?????????????? ???????? ?????????? ?? ??????????????????????????
time1=L(:, end); %???????????????????????? ?????????? ????????????????
AllIndex =fnlabin(L); %?????????????????????? ???????????????????????? ???????????????????????? ???????? ?? ?????? ???????????? ???????????? Index ?? ?????????????? ???????????? ?????????? ??

Mb2=fnpath(L); %?????????????? ?????????????? ???????????? ?????????? ?? ???? ?????????? ?? ?????????? ?????????? ?? ???????????????????????????? ?? ???????????? ?????????? ???????? string

%?????????????????????? ???????????? ?????????? (?????? ?????????? ?? ????????????????????  ????????????????????)
M=L;
for j=length(M(1,:))-1:-1:3 %???????????????????? 1 ?? 2 ???????????????? ???? ???????????? ???????????????????????????? ?????????????? ????????????????
    m=M(:, j); %???????????? ???????????????? ?????????????? ?? ???????????? m
    p=unique(m); %?????????????????????? ???????????????????? ???????????????? ?? ?????????????? m (???????????????????? ???? ???? ???????????? ?????? ?? m, ???? ?????? ???????????????????? ?? ?????????????????????????????? ??????????????)
    Is=[];
    for i=p' %?????????????? ???????????????????? ?????????????? ???????????????? ?? ?????????????? m
        if i==0 || i==max(s1) % ???????????????? ???????????????????? ???????????? ?? ?????????? ?? ?????????????? ?????????????? j
            continue
        end
        
        u=find(m==i); %?????????????????????? ???????????????? ?????????????? ???????????????? ???????????? ???????????????? ?? ?????????????? m
        u1=unique(M(u, j-1));
        r=unique(M(u, j+1));
        
        if length(u1)>1 && length(r)==1      %???????????????? ?????????? ????????????????
            k=max(M(u,end)); % ?????????????????????? ????????. ???????????????????????? ???? u
            I=find(M(:,end)==k); % ?????????????????????? ??????????????-???????????? ???????? ?? ????????. ??????????????????????????
            for in=u'
                if in~=I
                    Is(end+1)=in; % ???????????? ???????? ?????????????? ?????????? (??????????????????), ?????????? ???????? ?? ????????. ??????????????????????????
                end
            end
        end
    end
    M(Is, :)=[]; %???????????????? ???????? ?????????????????? ??????????, ?????????? ???????? ?? ????????. ??????????????????????????
end
M; %???????????? ???????????? ?????????? (???????? ?????? ?????????????????? ????????????????) ?? ?????????????????????????? 
time=M(:, end); %???????????????????????? ?????????? ????????????????

%?????????????????????? ???????????????????????? ???????????????????????? ???????? time ?? ?????? ???????????? ???????????? Index ?? ?????????????? ???????????? ?????????? ??
[Index, pathmax]=fnlabin(M); 
%???????????????????? ???????????????? ?????????????? ???????????????????? ????????????????
Reserv=fnreserv(time, Index);
%???????????????????? ???????????????? ?????????????? ???????????????????? ????????????????
Reserv1=fnreserv(time1, AllIndex);
%???????????? ???????????? ??????????, ???????????????????? ??????????????????
Mb3=fnpath(M); 
 
%???????????????????????? ?????????????? ?????????? ???????? ?????????? (?? ???????????????????? ????????????????) d1 ?? ???????????? ?????????? (?????? ?????????????????? ??????????) d2 ??????
%???????????????????????? ???????????? ?? ?????????????? uitable5 ????????????????????

N1=1:length(L(:, 1));
for i=N1
    d1{i,1}=char(Mb2(i));
    d1{i,2}=time1(i);
    d1{i,3}=Reserv1(i);
end

N2=1:length(M(:, 1));
for i=N2
    d2{i,1}=char(Mb3(i));
    d2{i,2}=time(i);
    d2{i,3}=Reserv(i);
end
%???????????????????? ???????????????????? d1  ?? d2 ?? ?????????? ???????? ?????????????????? handles ????????
%???????????????????? ???????????????????? (?????? ?????????????????????? ?????????????? ?? ????????????????????
%d1  ?? d2 ???? ???????? ?????????????????????? ????????????????????).
handles.d1=d1; 
guidata(gcbo, handles); % ???????????????????? ?????????????????????? ?????????????????? handles
handles.d2=d2;
guidata(gcbo, handles);

% ?????????????? ?? ?????????????? uitable5 ???????????????????? ?????????????? ?? ?????????????????????? ???? ??????????????????
% ?????????????????????? radiobutton
if get(handles.radiobutton1, 'Value')
    set(handles.uitable5,'Data', d1);
end

if get(handles.radiobutton2, 'Value')
    set(handles.uitable5,'Data', d2);
end

 %???????????????????? ??????????????
name=min(t1):max(s1);
name=string(name);
name=cellstr(name);
if t1(1)==0
    t1=t1+1;
    s1=s1+1;
    pathmax=pathmax+1;
    G=digraph(t1, s1, weights, name);
else
    G=digraph(t1, s1, weights);
end

h=plot(G, 'Layout','layered','Direction','right'); 
title('???????????? ????????');
labeledge(h,1:numedges(G),weights); % ?????????????? ?????????? ??????????
h.LineWidth=2; %?????????????? ??????????-?????????? ??????????
h.MarkerSize=8; %???????????? ??????????-????????????????
h.ArrowSize=12; %???????????? ??????????????????
h.NodeFontSize=12; %???????????? ???????????????? ??????????
h.NodeFontWeight= 'bold'; %?????????????? ???????????? ?? ???????????? ???????? 'normal'- ???????????????? ???? ??????????????????  'bold' - ????????????
h.NodeFontAngle='normal'; %???????????????????? ???????????? ???????????? ?? ???????? 'normal' (???????????????? ???? ??????????????????)  'italic' ?? ????????????????
h.EdgeFontSize=10; %???????????? ???????????? ?????? ?????????? ??????????
h.ArrowPosition=0.8; %?????????????????? ???????????? ?????????? ?????????? ?? ???????? ???????????????? ???? 0 ???? 1
highlight(h,pathmax,'EdgeColor','r'); % ???????????????? ???????????????????????? ???????? ?? ?????????????? ???????? ???? ?????????? G


function [f]=fsor(A, B, n)
   %???????????????????????? ???????????? ???????????????? (??????????????????????????), ?????????????? ?????????????????? ???? ?????????????? ???????????????? n
    c=A==n;
    f=B(c);


function [Mb3]=fnpath(M)
%?????????????? ???????????? ?????????? ?? ???? ?????????? ?? ?????????? ?????????? ?? ???????????????????????????? ?? ???????????? ?????????? ???????? string

    M1=M(:, 1:end-1); %???????????? ???????? ?? ???????? ?????????????? ???????????????? ?????? ??????????????????????????
    for i=1:length(M1(:, 1))
        Mb=[];
        for j=1:length(M1(1, :))
            if M1(i, j)==0 && j>1 %???????????????? ???????????????? ?????????????? M1 ???? 0 ?? ?????????? ??????????????
                continue
            else
                Mb(j)=M1(i, j); %???????????? ?????????????? ???????????????? ?? ??????????????. ???????????? Mb, ?????????? 0 (?????????? ????????????????????)
            end
        end
        Mb1=string(Mb); %???????????????????????????? ?????????????? Mb1 ?? ???????????? ?????????????????? ????????????????
        names = join(Mb1); %?????????????????????? ?????????????? ???????????????? ?? 1 ???????????? ????????????????
        Mb3(i, 1)=replace(names(1,:)," "," --> "); % ???????????? ???????????????? ?????????? ?????????????? ???? -->
    end
    Mb3; %???????????? ???????????? ??????????, ???????????????????? ??????????????????

function [Line, pathmax]=fnlabin(L)
%?????????????????????? ???????????? ???????????? Line ???????????????????????? ???????? (????????. ????????????????????????) ??
%?????????????? ???????????? ?????????? L ??  ???????????????????????? ???????? ?? ???????? ?????????????? ???????????????? pathmax
    [~, Line]=max(L(:,end)); % ~ ???????????? Path, ?????????????? ???? ???????????????????????? ?? ??????????????
    pathmax=L(Line, 1:end-1); %?????????????????????? ???????? ?? ???????? ?????????????? ?????????????? ????????????????

function [Reserv]=fnreserv(time, Index)
    %?????????????????????? ???????????????? ??????????????
    for i=1:length(time)
        Reserv(i,1)=time(Index)-time(i);
    end
%--------------------------------------------------------------------------
%                       ?????????? ?????????????????? ??????????????





% --- ?????????????????????? ?????? ?????????????? ???????????? ?? ptnclear ??????????????.
function ptnclear_Callback(hObject, eventdata, handles)
cla % ?????????????? ?????????????? ???????? ??????????
set(handles.uitable5, 'Data', NaN); %?????????????? ?????????????? ?????????? uitable5
set(hObject, 'Enable', 'off') % ???????????????????????? ???????????? clear ?????????? ???? ??????????????
set(handles.btngraph, 'Enable', 'on') % ???????????????????? ???????????? btngraph - ???????????? ?????????? ?????????????? ???????????? ptnclear
set(handles.ptnMenu, 'Enable', 'on'); % ???????????????????? ?? ???????? ???????????? ptnMenu - ?????????????????? ?????????? ?????????????? ???????????? ptnclear
set(handles.clearMenu, 'Enable', 'off'); % ???????????????????????? ?? ???????? ???????????? clearMenu - ???????????????? ?????????? ?????????????? ???????????? ptnclear
set(handles.radiobutton1, 'Enable', 'off'); %???????????????????????????? ???????????? ??????????????????????
set(handles.radiobutton2, 'Enable', 'off');

function editT_Callback(hObject, eventdata, handles)
% Hints: get (hObject, 'String') ???????????????????? ???????????????????? editFun ?? ???????? ????????????
%str2double (get(hObject, 'String')) %???????????????????? ???????????????????? editFun ?? ???????? double
% ?????????????????? ????????????, ???????????????? ?? ???????? ???????????????????????????? ???????????? ?? ???????????????????? ?? btngraph
%btngraph_Callback(handles.btngraph, eventdata, handles)

% --- ?????????????????????? ???? ?????????? ???????????????? ??????????????, ?????????? ?????????????????? ???????? ??????????????.
function editT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- ?????????????????????? ???? ?????????? ???????????????? ??????????????, ?????????? ?????????????????? ???????? ??????????????.
function editT_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to editT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function editS_Callback(hObject, eventdata, handles)
% Hints: get (hObject, 'String') ???????????????????? ???????????????????? editFun ?? ???????? ????????????
%str2double (get(hObject, 'String')) %???????????????????? ???????????????????? editFun ?? ???????? double
% ?????????????????? ????????????, ???????????????? ?? ???????? ???????????????????????????? ???????????? ?? ???????????????????? ?? btngraph
%btngraph_Callback(handles.btngraph, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function editS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editW_Callback(hObject, eventdata, handles)
% Hints: get (hObject, 'String') ???????????????????? ???????????????????? editFun ?? ???????? ????????????
%str2double (get(hObject, 'String')) %???????????????????? ???????????????????? editFun ?? ???????? double
% ?????????????????? ????????????, ???????????????? ?? ???????? ???????????????????????????? ???????????? ?? ???????????????????? ?? btngraph
%btngraph_Callback(handles.btngraph, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function editW_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double

% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function uitable5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- ?????????????????????? ?????? ?????????????? ???? ???????????? ?????????? ?????? ???????????????? radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
%?????? ???????????? ???????????? ?????????????????????? ???????????????? ???????????????????? ???????????? ???? ???????????????????? d1
% ?? ?????????????? uitable5.
set(handles.uitable5, 'Data', handles.d1);

% --- ?????????????????????? ?????? ?????????????? ???? ???????????? ?????????? ?????? ???????????????? radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
%?????? ???????????? ???????????? ?????????????????????? ???????????????? ???????????????????? ???????????? ???? ???????????????????? d1
% ?? ?????????????? uitable5.
set(handles.uitable5, 'Data', handles.d2);


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ptnMenu_Callback(hObject, eventdata, handles)
% hObject    handle to ptnMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
btngraph_Callback(handles.btngraph, eventdata, handles);

% --------------------------------------------------------------------
function clearMenu_Callback(hObject, eventdata, handles)
% hObject    handle to clearMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ptnclear_Callback(handles.ptnclear, eventdata, handles);

% --------------------------------------------------------------------
function Untitled_4_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
f1=uifigure;
edit1 = uicontrol(f1, 'Style','text');

data1 = importdata('file1.txt','') %// Import all text as a cell array with each cell for each line
set(handles.edit1, 'Max', 2); %// Enable multi-line string input to the editbox 
