function [] = AoM_PosDates(data)


%--------------------------------------------------------------------------
%- Display two graphs
%-  1. All mathematically possible dates
%-  2. Most probable dates
%--------------------------------------------------------------------------

%- Initialize str as values table
i=find(data(:,8)>0, 1, 'first');
j=find(data(:,8)>0, 1, 'last');
str={};
str{1,end+1}='+-------+--------+';
str{1,end+1}='! Date  ! Speed  !';
str{1,end+1}='! mm-dd ! (km/h) !';
str{1,end+1}='+-------+--------+';
for n=i:j
    s=sprintf('! %s !  %02.2f  !',datetime(data(n,6), 'ConvertFrom', 'datenum', 'Format', 'MM-dd'), data(n,8) );
    str{1,end+1}=s;
end
str{1,end+1}='+-------+--------+';

%- Create x as a sub vector of data
clear x;
x=data(1:286,:);  %- 286 is the dec-31 7BC 
x(:,2:5)=[];
Title='All mathematically possible dates';
figure('Name',Title, 'Position', [250 400 1000 500])
subplot(1,2,1);          %- 
v = all(data(:,8) > 0, 2);
x(v,9)=10;
clear v;
bar(x(:,2),x(:,9));grid off
ylim([0 10.5])
title(Title);

%--- Annotation
FixedWidth = get(0,'FixedWidthFontName');% Get a fixed-width font.
annotation(gcf,'Textbox','String',str,'Interpreter','Tex',...
    'FontName',FixedWidth,'Units','Normalized',...
    'Position',[0.2 0.3 0.9 0.5], 'EdgeColor','none');
xData = linspace(x(12,2),x(286,2),9); %- Force a date based x
ax = gca;
ax.XTick = xData;
datetick('x','mmm','keeplimits','keepticks')
xlabel('Fig 2: Year 7BC');

%--------------------------------------------------------------------------
%- 2. Display the selected dates
%--------------------------------------------------------------------------
%- Initialize str as values table
i=find(data(:,7)>0, 1, 'first');
j=find(data(:,7)>0, 1, 'last');
str={};
str{1,end+1}='+-------+--------+';
str{1,end+1}='! Date  ! Speed  !';
str{1,end+1}='! mm-dd ! (km/h) !';
str{1,end+1}='+-------+--------+';
for n=i:j
    s=sprintf('! %s !  %02.2f  !',datetime(data(n,6), 'ConvertFrom', 'datenum', 'Format', 'MM-dd'), data(n,8) );
    str{1,end+1}=s;
end
str{1,end+1}='+-------+--------+';
Title='Most probable dates';
clear x;
x=data(1:286,:);  %- 286 is the dec-31 7BC
x(:,2:5)=[];
subplot(1,2,2);          
bar(x(:,2),x(:,3));
ylim([0 105])
xData = linspace(x(12,2),x(286,2),9);
ax = gca;
ax.XTick = xData;
datetick('x','mmm','keeplimits','keepticks')
title(Title);
annotation(gcf,'Textbox','String',str,'Interpreter','Tex',...
    'FontName',FixedWidth,'Units','Normalized',...
    'Position',[0.65 0.3 0.9 0.5], 'EdgeColor','none');
xlabel('Fig 3: Year 7BC');
ylabel('%');


end
