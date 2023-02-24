function varargout = GoL(varargin)
%           GOL MATLAB code for GoL.fig
%           >>> EL JUEGO DE LA VIDA <<<
%           Compatible con Matlab 2015+
%           By:     German Pava
%                   Juan Cabezas
%{
        Todo ocurre en una matriz bidimensional
        en la que cada celda es una celula, muerta
        o viva, siguiendo las siguientes reglas:

        >>Una celula viva con menos de 2 vecinos
                   Muere de soledad
        >>Una celula viva con mas de 3 vecinos
                Muere de sobrepoblacion
        >>Una celula muerta con 3 vecinos
                     Recobra vida

           >>> PRESIONA F5 PARA COMENZAR <<<
%}
% Last Modified by GUIDE v2.5 12-Feb-2023 10:58:15
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GoL_OpeningFcn, ...
                   'gui_OutputFcn',  @GoL_OutputFcn, ...
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


% --- Opening Function
function GoL_OpeningFcn(hObject, eventdata, handles, varargin)
% Esta funcion se ejecuta en cuanto el programa se abre
% Aprovechamos esta propiedad para establecer valores por defecto.

% Choose default command line output for GoL
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

global pointSizeC tamano velocidad random flagCanvas flagSimulacion mundo generacion
%Valores por defecto
flagSimulacion = -1;
pointSizeC = 1200;
tamano = 24; 
velocidad = 0.06;
random = -0.5;
mundo = zeros(tamano);
mundo(11,11) = 1;
mundo(12,12) = 1;
mundo(12,13) = 1;
mundo(11,13) = 1;
mundo(10,13) = 1;
flagCanvas = 1;
generacion = 0;
puntito = round(pointSizeC/tamano);
set(handles.nGeneracion,'String',num2str(generacion))
set(handles.nCelulas, 'String',num2str(sum(sum(mundo))));

% Configuracion plot
spy(mundo,'.w',puntito)
set(gca,'color', [0 0 0]);
set(gca,'ButtonDownFcn',@editplot)
grid on
set(gca,'XTick',0.5:1:tamano+1)
set(gca,'YTick',0.5:1:tamano+1)
set(gca,'fontSize',1)
set(gca,'gridLineStyle','-')
set(gca,'gridColor','w') 
set(gca,'gridAlpha',0.05)

% --- Outputs from this function are returned to the command line.
function varargout = GoL_OutputFcn(hObject, eventdata, handles) 
% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function tamano_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function plotSpace_CreateFcn(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function velocidad_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function random_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Tamaño Slider.
function tamano_Callback(hObject, eventdata, handles)
%Tamaño de matriz desde el Slider

global tamano random pointSizeC mundo generacion flagSimulacion
%Detiene la matriz en caso de que este corriendo.
%Para evitar errores de indices en matrices.
flagSimulacion = -1;
set(handles.start,'String','START!');
tamano = round(get(hObject,'Value')+16);
mundo = round(rand(tamano ,tamano )+ random);

%Plotea
spy(mundo,'.w',(pointSizeC/tamano))
set(gca,'color', [0 0 0]);
set(gca,'ButtonDownFcn',@editplot)
grid on
set(gca,'XTick',0.5:1:tamano+1)
set(gca,'YTick',0.5:1:tamano+1)
set(gca,'fontSize',1)
set(gca,'gridLineStyle','-')
set(gca,'gridColor','w') 
set(gca,'gridAlpha',0.05)
set(handles.nCelulas, 'String',num2str(sum(sum(mundo))));
generacion = 0;

% --- Slider Velocidad.
function velocidad_Callback(hObject, eventdata, handles)
% Establece la velocidad de iteracion.
global velocidad
velocidad = 0.60 -(get(hObject,'Value')+0.01);

% --- Slider Random
function random_Callback(hObject, eventdata, handles)
% Establece la densidad de puntos aleatorios.
global random tamano pointSizeC mundo generacion
random = (get(hObject,'Value'))-0.5;

%Plotea 
mundo = round(rand(tamano ,tamano )+random);
spy(mundo,'.w',pointSizeC/tamano)
set(gca,'color', [0 0 0]);
set(gca,'ButtonDownFcn',@editplot)
grid on
set(gca,'XTick',0.5:1:tamano+1)
set(gca,'YTick',0.5:1:tamano+1)
set(gca,'fontSize',1)
set(gca,'gridLineStyle','-')
set(gca,'gridColor','w') 
set(gca,'gridAlpha',0.05)
set(handles.nCelulas, 'String',num2str(sum(sum(mundo))));
generacion = 0;


% Inicia/Detiene la iteracion.
function start_Callback(hObject, eventdata, handles)
% 
global flagSimulacion tamano pointSizeC velocidad mundo nuevoMundo generacion

%Actualiza texto de el boton START/STOP
flagSimulacion = -flagSimulacion;
if flagSimulacion > 0
    set(handles.start,'String','STOP!');
else
    set(handles.start,'String','START!');
end

%Inicia Iteracion.
while flagSimulacion > 0 
  generacion = generacion +1;
  %Plotea la matriz
  spy(mundo,'.w',pointSizeC/tamano)
  %Copia la matriz en nuevoMundo, preparando la miguiente iteracion.
  nuevoMundo = mundo;
  
  %Par de ciclos para contar los vecinos de una celda.
  for i = 1:tamano 
    mi = i-1;
    Mi = i+1;
    veci = mi:Mi;
    veci(veci==0)=tamano ;
    veci(veci==tamano +1)=1;
    for j = 1:tamano 
      sj = j-1;
      ej = j+1;
      vecj = sj:ej;
      vecj(vecj==0)=tamano ;
      vecj(vecj==tamano +1)=1;
      nVecinos = sum(sum(mundo(veci,vecj)))-mundo(i,j);
      if mundo(i,j) %Sera true si la celda esta viva.
          % Cualquier celda con menos de dos vecinos muere de "soledad".
          if nVecinos < 2
              nuevoMundo(i,j) = 0;
          end
          %Cualquier celda con mas de 3 vecinos, muere de "sobrepoblacion".
          if nVecinos > 3
              nuevoMundo(i,j) = 0;
          end
          %Asi, quedan vivas las celdas con 2 o 3 vecinos.
      else
          %Tambien, si una celda tiene 3 vecinos, toma vida, "reproduccion".
          if nVecinos == 3
              nuevoMundo(i,j) = 1;
          end
      end
    end
  end
  % plot 
  set(gca,'color', [0 0 0]);
  set(gca,'ButtonDownFcn',@editplot)
  grid on
  set(gca,'XTick',0.5:1:tamano+1)
  set(gca,'YTick',0.5:1:tamano+1)
  set(gca,'fontSize',1)
  set(gca,'gridLineStyle','-')
  set(gca,'gridColor','w') 
  set(gca,'gridAlpha',0.05)
  %Actualizar valores.
  set(handles.nGeneracion,'String',num2str(generacion))
  set(handles.nCelulas, 'String',num2str(sum(sum(mundo))));
  drawnow
  % A estas alturas de codigo, esta ploteado mundo y en nuevoMundo esta 
  % almacenada la siguiente "generacion".
  % Asi, la siguiente iteracion toma como mundo a nuevomundo y se va 
  % actualizando vez a vez el mundo.
  mundo = nuevoMundo;
  pause(velocidad);  
end

%Nada que ver aqui.
function gun_ButtonDownFcn(hObject, eventdata, handles)
global tamano random pointSizeC mundo generacion flagSimulacion
%Detiene la matriz en caso de que este corriendo.
%Para evitar errores de indices en matrices.
flagSimulacion = -1;
set(handles.start,'String','START!');
tamano = 33;
mundo = zeros(tamano);

mundo(13,16:18) = 1;
mundo(10:13,17) = 1;
mundo(31,3) = 1;
mundo(32,4) = 1;
mundo(30,2) = 1;
mundo(29,3:4) = 1;
mundo(30:31,5) = 1;

mundo(31,31) = 1;
mundo(32,30) = 1;
mundo(30,32) = 1;
mundo(29,30:31) = 1;
mundo (30:31,29) = 1;

mundo(2:3,2)= 1;
mundo(2,3) = 1;
mundo(4,3) = 1;
mundo(3,4) = 1;

mundo(2:3,32)=1;
mundo(2,31) = 1;
mundo(3,30) = 1;
mundo(4,31) = 1;

%Plotea
spy(mundo,'.w',(pointSizeC/tamano))
set(gca,'color', [0 0 0]);
set(gca,'ButtonDownFcn',@editplot)
grid on
set(gca,'XTick',0.5:1:tamano+1)
set(gca,'YTick',0.5:1:tamano+1)
set(gca,'fontSize',1)
set(gca,'gridLineStyle','-')
set(gca,'gridColor','w') 
set(gca,'gridAlpha',0.05)
set(handles.nCelulas, 'String',num2str(sum(sum(mundo))));
generacion = 0;
