function varargout = sviewer_channel_conf(varargin)
% SVIEWER_CHANNEL_CONF
% Select HELP in the Info menu 
%
% Version 1.0, November 2004
% Copyright by (C) Franz Einspieler <znarfi5@hotmail.com> and
%                  Alois Schloegl   <a.schloegl@ieee.org>
% University of Technology Graz, Austria
%
% This is part of the BIOSIG-toolbox http://biosig.sf.net/
% Comments or suggestions may be sent to the author.
% This Software is subject to the GNU public license.

% This library is free software; you can redistribute it and/or
% modify it under the terms of the GNU Library General Public
% License as published by the Free Software Foundation; either
% Version 2 of the License, or (at your option) any later version.
%
% This library is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
% Library General Public License for more details.
%
% You should have received a copy of the GNU Library General Public
% License along with this library; if not, write to the
% Free Software Foundation, Inc., 59 Temple Place - Suite 330,
% Boston, MA  02111-1307, USA.

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sviewer_channel_conf_OpeningFcn, ...
                   'gui_OutputFcn',  @sviewer_channel_conf_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

% End initialization code - DO NOT EDIT

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function sviewer_channel_conf_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for sviewer_channel_conf
handles.output = hObject;
set(gcf,'Color',[0.949,0.949,1]);
guidata(hObject, handles);

Data=get(findobj('Tag','sviewer'),'UserData');
if isempty(Data)
    return;
else
save matlab Data,
    button = Data.Channelconf.whichbutton;
    channel_name = Data.Channel{button,1};
    pos = Data.Channel{button,2};
    set(findobj('Tag', 'text_channel'), 'String',channel_name);
    phyMin = Data.HDR.PhysMin(pos);
    set(findobj('Tag', 'text_PhysicalMin'), 'String',phyMin);
    phyMax = Data.HDR.PhysMax(pos);
    set(findobj('Tag', 'text_PhysicalMax'), 'String',phyMax);
    display_min = Data.ChannelConf.Display_min(pos,:);
    set(findobj('Tag', 'edit_DisplayMin'), 'String',display_min);
    display_max = Data.ChannelConf.Display_max(pos,:);
    set(findobj('Tag', 'edit_DisplayMax'), 'String',display_max);
    try
        dimension = Data.HDR.PhysDim(pos,:);
    catch
        dimension = '[?]';
    end
    set(findobj('Tag', 'text_ph_min'), 'String',dimension);
    set(findobj('Tag', 'text_ph_max'), 'String',dimension);
    set(findobj('Tag', 'text_d_min'), 'String',dimension);
    set(findobj('Tag', 'text_d_max'), 'String',dimension);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function varargout = sviewer_channel_conf_OutputFcn(hObject, eventdata, handles)
% Get default command line output from handles structure
varargout{1} = handles.output;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pushbutton_OK_Callback(hObject, eventdata, handles)

value_auto = get(findobj('Tag', 'Applyall_auto'), 'Value');
value_disp = get(findobj('Tag', 'Applyall_disp'), 'Value');
if value_auto == 1
    select = 1;
elseif value_disp == 1
    select = 2;
else
    select = 0;
end
close_figure(select);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% close window
function pushbutton_Cancel_Callback(hObject, eventdata, handles)
close;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculate new range
function pushbutton_autoscale_Callback(hObject, eventdata, handles)
Data=get(findobj('Tag','sviewer'),'UserData');
button = Data.Channelconf.whichbutton
pos    = Data.Channel{button,2};
sample_min = min(Data.signal(:,pos));
sample_max = max(Data.signal(:,pos));
if sample_min == sample_max
    sample_min = sample_min -10;
    sample_max = sample_max +10;
end
set(findobj('Tag', 'edit_DisplayMin'), 'String',sample_min);
set(findobj('Tag', 'edit_DisplayMax'), 'String',sample_max);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% change the display minimum
function edit_DisplayMin_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
Data = get(findobj('Tag', 'sviewer'), 'UserData');
button = Data.Channelconf.whichbutton;
display_min = Data.ChannelConf.Display_min(button,:);
display_min = round(display_min*100)/100;
set(findobj('Tag', 'edit_DisplayMin'), 'String',display_min);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%change the display maximum
function edit_DisplayMax_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
Data = get(findobj('Tag', 'sviewer'), 'UserData');
button = Data.Channelconf.whichbutton;
display_max = Data.ChannelConf.Display_max(button,:);
display_max = round(display_max*100)/100;
set(findobj('Tag', 'edit_DisplayMax'), 'String',display_max);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% change the zoom factor
function edit_Zoomfactor_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
Data = get(findobj('Tag', 'sviewer'), 'UserData');
scale_factor = Data.ChannelConf.Scale;
set(findobj('Tag', 'edit_Zoomfactor'), 'String',scale_factor);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% close window
function close_figure(select)

Data = get(findobj('Tag', 'sviewer'), 'UserData');
display_min_t = get(findobj('Tag', 'edit_DisplayMin'), 'String');
display_max_t = get(findobj('Tag', 'edit_DisplayMax'), 'String');
scale_factor_t = get(findobj('Tag', 'edit_Zoomfactor'), 'String');
display_min = str2num(display_min_t);
display_max = str2num(display_max_t);
scale_factor = str2num(scale_factor_t);

if length(display_min) > 1 | length(display_min) == 0
    errordlg('The value for Display-Min is Not a Number!', 'Error');
    return;
end
if length(display_max) > 1 | length(display_max) == 0
    errordlg('The value for Display-Max is Not a Number!', 'Error');
    return;
end
if length(scale_factor) > 1 | length(scale_factor) == 0
    errordlg('The value for Zoom-Factor is Not a Number!', 'Error');
    return;
end
if display_min > display_max
    errordlg('Display-Min is larger than Display-Max !', 'Error');
    return;
end
if scale_factor <= 1
    errordlg('Zoom-Factor must be larger than 1 (e.g. 1.1) !', 'Error');
    return;
end

if select == 0
    button = Data.Channelconf.whichbutton;
    channel_name = Data.Channel{button};
    pos = strmatch(channel_name,Data.allChannel);
    Data.ChannelConf.Display_min(pos,:) = display_min;
    Data.ChannelConf.Display_max(pos,:) = display_max;
    Data.ChannelConf.Scale = scale_factor; 
    set(findobj('Tag','sviewer'),'UserData',Data);
    close;
elseif select == 1
    for k = 1:length(Data.ChannelConf.Display_min)
        sample_min = min(Data.signal(:,k));
        sample_max = max(Data.signal(:,k));
        if sample_min == sample_max
            sample_min = sample_min -10;
            sample_max = sample_max +10;
        end
        Data.ChannelConf.Display_min(k,:) = sample_min;
        Data.ChannelConf.Display_max(k,:) = sample_max;
    end
    Data.ChannelConf.Scale = scale_factor; 
    set(findobj('Tag','sviewer'),'UserData',Data);
    close;
elseif select == 2
    Data.ChannelConf.Display_min(1:end,:) = display_min;
    Data.ChannelConf.Display_max(1:end,:) = display_max;
    Data.ChannelConf.Scale = scale_factor; 
    set(findobj('Tag','sviewer'),'UserData',Data);
    close;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in Applyall_disp.
function Applyall_disp_Callback(hObject, eventdata, handles)

set(findobj('Tag', 'Applyall_auto'), 'Value', 0);
set(findobj('Tag', 'edit_DisplayMin'), 'Enable', 'on');
set(findobj('Tag', 'edit_DisplayMax'), 'Enable', 'on');
set(findobj('Tag', 'pushbutton_autoscale'), 'Enable', 'on');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in Applyall_auto.
function Applyall_auto_Callback(hObject, eventdata, handles)

active = get(findobj('Tag', 'Applyall_auto'), 'Value');
if active
    set(findobj('Tag', 'Applyall_disp'), 'Value', 0);
    set(findobj('Tag', 'edit_DisplayMin'), 'Enable', 'off');
    set(findobj('Tag', 'edit_DisplayMax'), 'Enable', 'off');
    set(findobj('Tag', 'pushbutton_autoscale'), 'Enable', 'off');
else
    set(findobj('Tag', 'Applyall_auto'), 'Value', 0);
    set(findobj('Tag', 'edit_DisplayMin'), 'Enable', 'on');
    set(findobj('Tag', 'edit_DisplayMax'), 'Enable', 'on');
    set(findobj('Tag', 'pushbutton_autoscale'), 'Enable', 'on');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



