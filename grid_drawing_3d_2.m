function grid_drawing_3d
% grid mesh drawing function for grid option
% This function frequently used as a basemap for the other plotting
% functions.
% 
%   coded by Shinji Toda
%

global GRID
global XGRID YGRID
global H_MAIN A_GRID
global FUNC_SWITCH
global PREF
global ICOORD LON_GRID XY_RATIO
global COAST_DATA AFAULT_DATA EQ_DATA GTEXT_DATA ANNOTATION_CANCELED
global GPS_DATA

xstart = GRID(1,1);
ystart = GRID(2,1);
xfinish = GRID(3,1);
yfinish = GRID(4,1);

% the following comment lines should be uncommented when 3D rotation
% problems for lat/lon coordinates can be resolved.
%
if ICOORD == 2 && isempty(LON_GRID) ~= 1
    a  = xy2lonlat([GRID(1,1) GRID(2,1)]);
    xstart = a(1);
    ystart = a(2);
    a = xy2lonlat([GRID(3,1) GRID(4,1)]);
    xfinish = a(1);
    yfinish = a(2);
end

if ICOORD == 1
    XY_RATIO = 1;
end

% if FUNC_SWITCH ~= 1
figure(H_MAIN);
set(H_MAIN,'Menubar','figure','Toolbar','figure');
hold off;
    if ICOORD == 2 && isempty(LON_GRID) ~= 1
        A_GRID = plot3([xstart xfinish xfinish xstart xstart],...
        [ystart ystart yfinish yfinish ystart],[0.0 0.0 0.0 0.0 0.0]);
        set(gca,'DataAspectRatio',[XY_RATIO 1 1],...
        'Color',[0.9 0.9 0.9],...
        'PlotBoxAspectRatio',[1 1 1],...
        'XLim',[xstart,xfinish],...
        'YLim',[ystart,yfinish]);
        h = get(gca,'Parent');
    	hx = xlabel('Longitude (degree)');
        hy = ylabel('Latitude  (degree)');
    else
        A_GRID = plot3([xstart xfinish xfinish xstart xstart],...
        [ystart ystart yfinish yfinish ystart],[0.0 0.0 0.0 0.0 0.0]);
        set(gca,'DataAspectRatio',[XY_RATIO 1 1],...
        'Color',[0.9 0.9 0.9],...
        'PlotBoxAspectRatio',[1 1 1],...
        'XLim',[xstart,xfinish],...
        'YLim',[ystart,yfinish]);
        h = get(gca,'Parent');
        hx = xlabel('X (km)');
        hy = ylabel('Y (km)');
    end
	set(hx,'FontSize',[18]);
	set(hy,'FontSize',[18]);

if PREF(3,4)~=0.0 % if GRID line width is 0.0, skip the following block. 
for m = 1:length(XGRID)
    hold on;
	if ICOORD == 2 && isempty(LON_GRID) ~= 1
        a = xy2lonlat([XGRID(m) ystart]); % ystart is dummy
        gridln1 = plot3([a(1) a(1)],[ystart yfinish],[0.0 0.0]);
	else
        gridln1 = plot3([XGRID(m) XGRID(m)],[ystart yfinish],[0.0 0.0]);
	end
    if FUNC_SWITCH == 1 | FUNC_SWITCH == 10
        set(gridln1,'LineWidth',PREF(3,4),'Color',PREF(3,1:3));
    elseif FUNC_SWITCH == 2 | FUNC_SWITCH == 3
        set(gridln1,'LineWidth',PREF(3,4),'Color',PREF(3,1:3));
    else
        set(gridln1,'LineWidth',PREF(3,4),'Color',[0.5 0.5 0.5]);
    end
    set(gridln1,'Tag','ylines');
end

for n = 1:length(YGRID)
    hold on;
    if ICOORD == 2 && isempty(LON_GRID) ~= 1
        a = xy2lonlat([xstart YGRID(n)]); % xstart is dummy
        gridln2 = plot3([xstart xfinish],[a(2) a(2)],[0.0 0.0]);
    else
        gridln2 = plot3([xstart xfinish],[YGRID(n) YGRID(n)],[0.0 0.0]);
    end
    if FUNC_SWITCH == 1 | FUNC_SWITCH == 10
        set(gridln2,'LineWidth',PREF(3,4),'Color',PREF(3,1:3));
    elseif FUNC_SWITCH == 2 | FUNC_SWITCH == 3
        set(gridln2,'LineWidth',PREF(3,4),'Color',PREF(3,1:3));
    else
        set(gridln2,'LineWidth',PREF(3,4),'Color',[0.5 0.5 0.5]);
    end
    set(gridln2,'Tag','xlines');
end
end

% repetition ???
hold on;
% Define the context menu
cmenu = uicontextmenu;
    if ICOORD == 2 && isempty(LON_GRID) ~= 1
        A_GRID = plot3([xstart xfinish xfinish xstart xstart],...
        [ystart ystart yfinish yfinish ystart],[0.0 0.0 0.0 0.0 0.0]);
        set(gca,'DataAspectRatio',[XY_RATIO 1 1],...
        'Color',[0.9 0.9 0.9],...
        'PlotBoxAspectRatio',[1 1 1],...
        'XLim',[xstart,xfinish],...
        'YLim',[ystart,yfinish],...
        'UIContextMenu', cmenu);
        h = get(gca,'Parent');
    	hx = xlabel('Longitude (degree)');
        hy = ylabel('Latitude  (degree)');
    else
        A_GRID = plot3([xstart xfinish xfinish xstart xstart],...
        [ystart ystart yfinish yfinish ystart],[0.0 0.0 0.0 0.0 0.0]);
        set(gca,'DataAspectRatio',[XY_RATIO 1 1],...
        'Color',[0.9 0.9 0.9],...
        'PlotBoxAspectRatio',[1 1 1],...
        'XLim',[xstart,xfinish],...
        'YLim',[ystart,yfinish],...
        'UIContextMenu', cmenu);
        h = get(gca,'Parent');
        hx = xlabel('X (km)');
        hy = ylabel('Y (km)');
    end
	set(hx,'FontSize',[18]);
	set(hy,'FontSize',[18]);
    
    % Define the context menu items
items1 = uimenu(cmenu, 'Label', 'change study area',...
    'Callback','change_study_area');
items2 = uimenu(cmenu, 'Label', 'change coordinates',...
    'Callback','change_coordinates');

%---------------------------------------------
%	Coast line plot in 3D
%---------------------------------------------
h = findobj('Tag','menu_coastlines');
h1 = get(h,'Checked');
if isempty(COAST_DATA)~=1 && strcmp(h1,'on')
    [m,n] = size(COAST_DATA);
    if n == 9   % old format
        if ICOORD == 2 && isempty(LON_GRID) ~= 1
            x1 = [rot90(COAST_DATA(:,2));rot90(COAST_DATA(:,4))];
            y1 = [rot90(COAST_DATA(:,3));rot90(COAST_DATA(:,5))];
        else
            x1 = [rot90(COAST_DATA(:,6));rot90(COAST_DATA(:,8))];
            y1 = [rot90(COAST_DATA(:,7));rot90(COAST_DATA(:,9))];
        end
    else        % new format
        if ICOORD == 2 && isempty(LON_GRID) ~= 1
            x1 = COAST_DATA(:,1);
            y1 = COAST_DATA(:,2);
        else
            x1 = COAST_DATA(:,3);
            y1 = COAST_DATA(:,4);
        end
    end
	[mm,nn] = size(x1);
	z1 = zeros(mm,nn);
	hold on;    
    h = plot3(gca,x1,y1,z1,'Color',PREF(4,1:3),'LineWidth',PREF(4,4));
    set(gca,'DataAspectRatio',[XY_RATIO 1 1],...
    'Color',[0.9 0.9 0.9],...
    'PlotBoxAspectRatio',[1 1 1],...
    'XLim',[xstart,xfinish],'YLim',[ystart,yfinish]);
    set(h,'Tag','CoastlineObj');        % put a tag to remove them later
	hold on;
end

%---------------------------------------------
%	Active fault plot in 3D
%---------------------------------------------
h = findobj('Tag','menu_activefaults');
h1 = get(h,'Checked');
if isempty(AFAULT_DATA)~=1 && strcmp(h1,'on')
    [m,n] = size(AFAULT_DATA);
    if n == 9       % old format
        if ICOORD == 2 && isempty(LON_GRID) ~= 1
            x1 = [rot90(AFAULT_DATA(:,2));rot90(AFAULT_DATA(:,4))];
            y1 = [rot90(AFAULT_DATA(:,3));rot90(AFAULT_DATA(:,5))];
        else
            x1 = [rot90(AFAULT_DATA(:,6));rot90(AFAULT_DATA(:,8))];
            y1 = [rot90(AFAULT_DATA(:,7));rot90(AFAULT_DATA(:,9))];
        end
    else            % new format
        if ICOORD == 2 && isempty(LON_GRID) ~= 1
            x1 = AFAULT_DATA(:,1);
            y1 = AFAULT_DATA(:,2);
        else
            x1 = AFAULT_DATA(:,3);
            y1 = AFAULT_DATA(:,4);
        end
    end
	[mm,nn] = size(x1);
    z1 = zeros(mm,nn);
    hold on;
    h = plot3(gca,x1,y1,z1,'Color',PREF(6,1:3),'LineWidth',PREF(6,4));
    set(gca,'DataAspectRatio',[XY_RATIO 1 1],...
    'Color',[0.9 0.9 0.9],...
    'PlotBoxAspectRatio',[1 1 1],...
    'XLim',[xstart,xfinish],'YLim',[ystart,yfinish]);
    set(h,'Tag','AfaultObj');        % put a tag to remove them later 
    hold on;
end

%---------------------------------------------
%	Earthquake plot in 3D
%---------------------------------------------
h = findobj('Tag','menu_earthquakes');
h1 = get(h,'Checked');
if isempty(EQ_DATA)~=1 && strcmp(h1,'on')
    hold on;
    if ICOORD == 2 && isempty(LON_GRID) ~= 1                % lon.lat.coordinates
        h = scatter3(EQ_DATA(:,1),EQ_DATA(:,2),-EQ_DATA(:,7),5*PREF(5,4));
    else
        h = scatter3(EQ_DATA(:,16),EQ_DATA(:,17),-EQ_DATA(:,7),5*PREF(5,4));
    end
    set(h,'MarkerEdgeColor',PREF(5,1:3)); % white edge color for earthquakes 
    set(h,'Tag','EqObj');        % put a tag to remove them later
    hold on;
end

%---------------------------------------------
%	GPS station plot in 3D
%---------------------------------------------
% h = findobj('Tag','menu_gps');
% h1 = get(h,'Checked');
% if isempty(GPS_DATA)~=1 && strcmp(h1,'on')
%     zero = zeros(size(GPS_DATA,1),1);
%     hold on;
%     if ICOORD == 2 && isempty(LON_GRID) ~= 1                % lon.lat.coordinates
%         h = scatter3(GPS_DATA(:,1),GPS_DATA(:,2),zero,5*PREF(5,4));
%     else
%         h = scatter3(GPS_DATA(:,6),GPS_DATA(:,7),zero,5*PREF(5,4));
%     end
%     set(h,'MarkerEdgeColor','r'); % white edge color for GPS station 
%     set(h,'Tag','GPSObj');        % put a tag to remove them later
%     hold on;
% end

%---------------------------------------------
%	Annotations in 3D
%---------------------------------------------
% *** PROBLEM *** cannot be solved so far
% in 3D, we cannot use "[x,y] = ginput(n)" in "main_menu_window.m"
% so now under construction unfortunately
%
h = findobj('Tag','menu_annotations');
h1 = get(h,'Checked');
if isempty(GTEXT_DATA)~=1 && strcmp(h1,'on')
    hold on;
    if ICOORD == 2 && isempty(LON_GRID) ~= 1                % lon.lat.coordinates
        return; % so far under construction
%        h = scatter3(EQ_DATA(:,1),EQ_DATA(:,2),-EQ_DATA(:,7),5*PREF(5,4));
    else
        if isempty(GTEXT_DATA) ~= 1
    	n = length(GTEXT_DATA);
        for k = 1:n
        GTEXT_DATA(k).handle = text(GTEXT_DATA(k).x,GTEXT_DATA(k).y,...
            0.0,GTEXT_DATA(k).text);                % Now 3D text...
        set(GTEXT_DATA(k).handle,'Tag',num2str(k,'%3i'));
        set(GTEXT_DATA(k).handle,'FontSize',GTEXT_DATA(k).font);
        end
        end
        h = annotation_window;
        waitfor(h);
        figure(H_MAIN);
        if ANNOTATION_CANCELED == 1
            ANNOTATION_CANCELED == 0;
            return
        end
        [m n] = size(GTEXT_DATA);
        if m == 0 && n == 0
            n = 1;
        end
        [x,y] = ginput(1);
        GTEXT_DATA(n).x = x;
        GTEXT_DATA(n).y = y;
        GTEXT_DATA(n).handle = text(x,y,0.0,GTEXT_DATA(n).text);
        set(GTEXT_DATA(n).handle,'Tag',num2str(n,'%3i'));
        set(GTEXT_DATA(n).handle,'FontSize',GTEXT_DATA(n).font);
    end
end


