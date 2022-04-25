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

% --- Выполняется при нажатии на кнопку btngraph - Расчитать.
function btngraph_Callback(hObject, eventdata, handles)

%После построения сетевого графа деактивируется кнопка btngraph(Рассчитать)
set(hObject, 'Enable', 'off')
%После построения сетевого графа деактивируется кнопка ptnMenu (Рассчитать)в Меню приложения
set(handles.ptnMenu, 'Enable', 'off')
%Активируется кнопка ptnclear - Очистить
set(handles.ptnclear, 'Enable', 'on') 
%Активируется кнопка ptnclear - Очистить в Меню приложения
set(handles.clearMenu, 'Enable', 'on')
%Активируется панель радиокнопок для выбора вариантов представления расчета
set(handles.radiobutton1, 'Enable', 'on');
set(handles.radiobutton2, 'Enable', 'on');

%настройка ширины столбцов таблицы uitable5
set(handles.uitable5,'ColumnWidth', {200,'auto','auto'}); 

% Преобразует набор чисел введенные в окно редактируемого текста editT в вектор 
a1=get(handles.editT, 'String');  %записывает данные в формате cell (массив ячеек)
t1=str2num(a1);  % str2num(cell2mat(a1))Преобразует вектор чисел в массив ячеек
% 
b1=get(handles.editS, 'String');  %записывает данные в формате cell (массив ячеек)
s1=str2num(b1);  %Преобразует вектор чисел в массив ячеек
% 
c1=get(handles.editW, 'String');  %записывает данные в формате cell (массив ячеек)
weights=str2num(c1);  %Преобразует вектор чисел в массив ячеек

%t1=[0 1 1 1 1 1 1 2 3 4 5 6 7 8 9 9 10 11 12 13 14 15 16 17];
%s1=[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 17 18 18 18 18 18 18];
%weights=[0.057 0.105 0.007 0.008 0.11 0.257 0.027 0.523 0.062 0.08 0.138 0.058 0.11 0.025 0.023 0.097 0.009 0.009 0.027 0.027 0.027 0.027 0.027 0.027];

%--------------------------------------------------------------------------
%                       ПРОГРАММА РАСЧЕТА 
%Формирование массива выполненяемых работ LA - определение всех путей
%выполнения работ (с фиктивными операциями)
LA=min(t1); %определение истока - номера самой первой операции
p = fsor(t1, s1, LA); % возвращает номера операций, которые опираются на исток LA
LA=repmat(LA, 1, length(p)); %  возвращает матрицу LA, состоящую из 1xlength(p) копий матрицы LA
LA=[LA; p];
while 1
    LB=[];
    LP=[];
    k=0;
    for i=p
        if i==0
            p1=0;
        else
            p1 = fsor(t1, s1, i); % возвращает номера операций, которые опираются на предыдущую операцию i 
        end
        if isempty(p1) %определение пустоты массива p1
            p1=0;
        end
        k=k+1;
        LB=LA(:, k+1:end); %запись в вспомогательный массив LB значений столбцов  LA, находящихся справа от текущего k столбца
        LA(:, k+1:end)=[]; % удаление из массива LA столбцов, записанных в массив LB
        LA=[LA repmat(LA(:, k), 1, length(p1)-1)]; % копирование оставшихся столбцов LA 
        LA=[LA LB]; %добавление значений вспомогательного массива LB к матрице LA
        LP=[LP p1]; % запись номеров операций в массив LP
    end
    
    if sum(LP)==0
        break
    end
    
    LA=[LA; LP]; % добавление номеров операций (которые опираются на текущий номер операции i) в массив LA
    p=LP; % обновление номеров последующих операций
end

%Вычисление трудоемкости всех путей LA
LS=LA';
LS(:,1)=[];
Lm=0;
LMsum=[];
for i=1:length(LS(:,1))  
    for j=1:length(LS(1,:))
        d=find(s1==LS(i,j), 1);
        if isempty(d) %проверка пустоты вектора d
            continue
        end
        Lm=Lm+weights(d); %вычисление трудоемкости каждого отдельного пути
    end
    LMsum(i, 1)=Lm; 
    Lm=0;  %обнуление Lm для записи трудоемкости следущего пути операций j
end
L=[LA' LMsum]; %Запись массива всех путей с трудоемкостью
time1=L(:, end); %Трудоемкость путей операции
AllIndex =fnlabin(L); %Определение трудоемкости критического пути и его номера строки Index в матрице полных путей М

Mb2=fnpath(L); %Очистка матрицы полных путей М от нулей в конце строк и преобразование в массив ячеек типа string

%Определение полных путей (без путей с фиктивными  операциями)
M=L;
for j=length(M(1,:))-1:-1:3 %исключение 1 и 2 столбцов из поиска предшествующих номеров операций
    m=M(:, j); %запись текущего столбца в вектор m
    p=unique(m); %определение уникальных значений в векторе m (возвращает те же данные как в m, но без повторений в отсортированном порядке)
    Is=[];
    for i=p' %перебор уникальных номеров операций в векторе m
        if i==0 || i==max(s1) % проверка нахождения истока и стока в текущем столбце j
            continue
        end
        
        u=find(m==i); %определение индексов позиций текущего номера операции в векторе m
        u1=unique(M(u, j-1));
        r=unique(M(u, j+1));
        
        if length(u1)>1 && length(r)==1      %проверка числа операций
            k=max(M(u,end)); % определение макс. трудоемкости из u
            I=find(M(:,end)==k); % определение индекса-номера пути с макс. трудоемкостью
            for in=u'
                if in~=I
                    Is(end+1)=in; % запись всех номеров путей (фиктивных), кроме пути с макс. трудоемкостью
                end
            end
        end
    end
    M(Is, :)=[]; %удаление всех фиктивных путей, кроме пути с макс. трудоемкостью
end
M; %массив полных путей (пути без фиктивных операций) с трудоемкостью 
time=M(:, end); %Трудоемкость путей операции

%Определение трудоемкости критического пути time и его номера строки Index в матрице полных путей М
[Index, pathmax]=fnlabin(M); 
%Вычисление резервов времени выполнения операций
Reserv=fnreserv(time, Index);
%Вычисление резервов времени выполнения операций
Reserv1=fnreserv(time1, AllIndex);
%Массив полных путей, записанных символьно
Mb3=fnpath(M); 
 
%Формирование массива ячеек всех путей (с фиктивными работами) d1 и полных путей (без фиктивных работ) d2 для
%последующего вывода в таблицу uitable5 приложения

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
%Сохранение переменных d1  и d2 в новые поля структуры handles всех
%подфункции приложения (для возможности доступа к переменным
%d1  и d2 во всех подфункциях приложения).
handles.d1=d1; 
guidata(gcbo, handles); % сохранение обновленной структуры handles
handles.d2=d2;
guidata(gcbo, handles);

% Выводит в таблицу uitable5 результаты расчета в зависимости от положения
% радиокнопок radiobutton
if get(handles.radiobutton1, 'Value')
    set(handles.uitable5,'Data', d1);
end

if get(handles.radiobutton2, 'Value')
    set(handles.uitable5,'Data', d2);
end

 %Построение орграфа
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
title('Орграф сети');
labeledge(h,1:numedges(G),weights); % Задание весов графа
h.LineWidth=2; %Толщина линий-ребер графа
h.MarkerSize=8; %Размер узлов-маркеров
h.ArrowSize=12; %Размер стрелочек
h.NodeFontSize=12; %Размер подписей уздов
h.NodeFontWeight= 'bold'; %Толщина текста в метках узла 'normal'- значение по умолчанию  'bold' - жирный
h.NodeFontAngle='normal'; %Символьный наклон текста в узле 'normal' (значение по умолчанию)  'italic' с наклоном
h.EdgeFontSize=10; %Размер шрифта для меток ребра
h.ArrowPosition=0.8; %Положение стрелы вдоль ребра в виде значения от 0 до 1
highlight(h,pathmax,'EdgeColor','r'); % покраска критического пути в красный цвет на графе G


function [f]=fsor(A, B, n)
   %Определяются номера операций (последователи), которые опираются на текущую операцию n
    c=A==n;
    f=B(c);


function [Mb3]=fnpath(M)
%Очистка масива путей М от нулей в конце строк и преобразование в массив ячеек типа string

    M1=M(:, 1:end-1); %Полные пути в виде массива операций без трудоемкостей
    for i=1:length(M1(:, 1))
        Mb=[];
        for j=1:length(M1(1, :))
            if M1(i, j)==0 && j>1 %проверка значений массива M1 на 0 и номер столбца
                continue
            else
                Mb(j)=M1(i, j); %запись номеров операций в вспомог. массив Mb, кроме 0 (исток исключение)
            end
        end
        Mb1=string(Mb); %преобразование вектора Mb1 в строку отдельных символов
        names = join(Mb1); %объединение вектора символов в 1 строку символов
        Mb3(i, 1)=replace(names(1,:)," "," --> "); % замена пробелов между цифрами на -->
    end
    Mb3; %массив полных путей, записанных символьно

function [Line, pathmax]=fnlabin(L)
%Определение номера строки Line критического пути (макс. трудоемкость) в
%массиве полных путей L и  критического пути в виде вектора операций pathmax
    [~, Line]=max(L(:,end)); % ~ вместо Path, который не используется в функции
    pathmax=L(Line, 1:end-1); %критический путь в виде вектора номеров операций

function [Reserv]=fnreserv(time, Index)
    %Определение резервов времени
    for i=1:length(time)
        Reserv(i,1)=time(Index)-time(i);
    end
%--------------------------------------------------------------------------
%                       КОНЕЦ ПРОГРАММЫ РАСЧЕТА





% --- Выполняется при нажатии кнопки в ptnclear Очистка.
function ptnclear_Callback(hObject, eventdata, handles)
cla % команда очистки осей графа
set(handles.uitable5, 'Data', NaN); %очистка таблицы путей uitable5
set(hObject, 'Enable', 'off') % деактивирует кнопку clear после ее нажатия
set(handles.btngraph, 'Enable', 'on') % активирует кнопку btngraph - Расчет после нажатия кнопки ptnclear
set(handles.ptnMenu, 'Enable', 'on'); % активирует в Меню кнопку ptnMenu - Расчитать после нажатия кнопки ptnclear
set(handles.clearMenu, 'Enable', 'off'); % деактивирует в Меню кнопку clearMenu - Очистить после нажатия кнопки ptnclear
set(handles.radiobutton1, 'Enable', 'off'); %деактивируется панель радиокнопок
set(handles.radiobutton2, 'Enable', 'off');

function editT_Callback(hObject, eventdata, handles)
% Hints: get (hObject, 'String') возвращает содержимое editFun в виде текста
%str2double (get(hObject, 'String')) %возвращает содержимое editFun в виде double
% Фиксирует данные, вводимые в окно редактируемого текста и направляет в btngraph
%btngraph_Callback(handles.btngraph, eventdata, handles)

% --- Выполняется во время создания объекта, после установки всех свойств.
function editT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Выполняется во время удалнгия объекта, после установки всех свойств.
function editT_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to editT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function editS_Callback(hObject, eventdata, handles)
% Hints: get (hObject, 'String') возвращает содержимое editFun в виде текста
%str2double (get(hObject, 'String')) %возвращает содержимое editFun в виде double
% Фиксирует данные, вводимые в окно редактируемого текста и направляет в btngraph
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
% Hints: get (hObject, 'String') возвращает содержимое editFun в виде текста
%str2double (get(hObject, 'String')) %возвращает содержимое editFun в виде double
% Фиксирует данные, вводимые в окно редактируемого текста и направляет в btngraph
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

% --- Выполняется при нажатии на кнопку задав ему значение radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
%При выборе данной радиокнопки передает результаты расчет из переменной d1
% в таблицу uitable5.
set(handles.uitable5, 'Data', handles.d1);

% --- Выполняется при нажатии на кнопку задав ему значение radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
%При выборе данной радиокнопки передает результаты расчет из переменной d1
% в таблицу uitable5.
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
