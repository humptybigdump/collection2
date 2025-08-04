%EARTHQUAKE_PLOT2
%
%   This enables to plot earthquakes with different color and size
%   depending on hypocentral depth and M
%
%
%------ EQ_DATA format (17 columns) -------------------------------
% 1)lon, 2)lat, 3)year, 4)month, 5)day, 6)M, 7)depth, 8)hr, 9)min,
% 10)strike1, 11)dip1, 12)rake1, 13)strike2, 14)dip2, 15)rake2, 
% 16) x position, 17) y position
%------------------------------------------------------------------

% first set the handvisibility for the main window on
set(H_MAIN,'HandleVisibility','on');
% h = figure(H_MAIN);

if isempty(findobj('Tag','EqObj'))
    disp('No earthquakes plotted! Plot them first and excute this script');
    return
% else
%    delete(findobj('Tag','EqObj'));
end

% ----- interactive inputs in "Command Window" -----
reply = input('Use the default color saturation values (0,15km) for hypo depth? y/n [y]:','s');
if isempty(reply)
    reply = 'y';
end
switch reply
    case 'y'
        depLim = 12.0;
    case 'n'
        depLim = str2num(input('  New bottom depth for color saturation (km)?  ','s'));
    otherwise
        return
end
reply = input('Simpel circle (y) or filled (n)? y/n [y]:','s');
if isempty(reply)
    reply = 'y';
end
switch reply
    case 'y'
        flagFilled = 0;
    case 'n'
        flagFilled = 1;
    otherwise
        return
end

delete(findobj('Tag','EqObj'));
depSep = [0.0 5.0 10.0 15.0 20.0 25.0 30.0];
mmax = int16(max(EQ_DATA(:,6)));
magSep = 1.0:1.0:double(mmax);
% magSep = [1.0 2.0 3.0 4.0 5.0 6.0 7.0];
% depLim = 12.0;
% r = ones(length(EQ_DATA(:,7)),1);
% g = ones(length(EQ_DATA(:,7)),1);
% b = ones(length(EQ_DATA(:,7)),1);
b = EQ_DATA(:,7)./depLim;
    c1 = b <= 1.0;   c2 = b > 1.0;
b = b .* c1 + c2;
    c3 = b <= 0.5;  c4 = b > 0.5;
    g  = b.*c3*2.0 + abs(0.5-(b-0.5)).*c4*2.0;
r = (1.0 - b);
    clear c1 c2 c3 c4
    
sizeAdj = 0.2;
if isempty(EQ_DATA)~=1
    if ICOORD == 2 && isempty(LON_GRID) ~= 1
        hold on;
        if flagFilled == 1
        h = scatter3(EQ_DATA(:,1),EQ_DATA(:,2),-EQ_DATA(:,7),...
            sizeAdj*PREF(5,4)*EQ_DATA(:,6).*EQ_DATA(:,6).*EQ_DATA(:,6),...
            [r g b],'filled');
        else
        h = scatter3(EQ_DATA(:,1),EQ_DATA(:,2),-EQ_DATA(:,7),...
            sizeAdj*PREF(5,4)*EQ_DATA(:,6).*EQ_DATA(:,6).*EQ_DATA(:,6),...
            [r g b]);
        end
    else
        
        hold on;
        if flagFilled == 1
        h = scatter3(EQ_DATA(:,16),EQ_DATA(:,17),-EQ_DATA(:,7),...
            sizeAdj*PREF(5,4)*EQ_DATA(:,6).*EQ_DATA(:,6).*EQ_DATA(:,6),...
            [r g b],'filled');
        else
        h = scatter3(EQ_DATA(:,16),EQ_DATA(:,17),-EQ_DATA(:,7),...
            sizeAdj*PREF(5,4)*EQ_DATA(:,6).*EQ_DATA(:,6).*EQ_DATA(:,6),...
            [r g b]);
        end
    end
    set(h,'Tag','EqObj');
end
% legend
% hold on;
% legend(h,'EQ');

% ----- draw Legend -----
    if ICOORD == 2 && isempty(LON_GRID) ~= 1
        hold on;
 
    else
            maxm = max(rot90(magSep));
            tsep   = (GRID(4) - GRID(2)) / 20.0;
            xpos = zeros(1,length(magSep));
            ypos = zeros(1,length(magSep));
	  for i = 1:length(magSep)
        hold on;
        xpos(i) = GRID(3) - (GRID(3) - GRID(1)) / 10.0;
        ypos(i) = GRID(2) + magSep(i) * (GRID(4) - GRID(2)) / 20.0;
        eqsize = sizeAdj*PREF(5,4)*magSep(i)*magSep(i)*magSep(i);
        hold on;
        if flagFilled == 1
            h = scatter(xpos(i),ypos(i),...
            eqsize,...
            [0.1 0.2 0.1],'filled');
        else
            h = scatter(xpos(i),ypos(i),...
            eqsize,...
            [0.1 0.2 0.1]);
%         sizeAdj*PREF(5,4)*magSep(i).*magSep(i).*magSep(i);
        end
            hold on;
%            text(xpos(i)+tsep,ypos(i),'M=');
            text((xpos(i)+2),ypos(i),['M=' num2str(magSep(i),'%1i')]);

	  end
 
    end


set(H_MAIN,'HandleVisibility','callback');