function [data] = AoM_MainLoop(data,caravan,star,timespan,withDisplay)

%--------------------------------------------------------------------------
%- Perform further initialization of data 
%- --------------------------------------
%- data     : Already loaded. Contains ephemeris of Jupiter for the year 7-6BC
%- caravan  : Magi's caravan values. Initialized to 0 at start.
%- star     : All values of the star
%- timespan : Nb of minutes of tolerance to accept or reject a valid event 
%-            Star + Caravan arriving at Bethlehem. Initialized.
%- withDisplay : Display calculations or not
%-
%- Constants and variables
%- -----------------------
% caravan.arriveAt = 0;   %- (hh:mm) when the caravan arrive at point C
%                         %- start at first visibility of the star
% star.appearTime = 0;    %- Time (hh:mm) when the "star" appear in the 
%                         %- sky at any given date (point B)
% star.arriveAt   = 0;    %- (hh:mm) when the "star" arrive at point C
% star.appearDeg  = 0;    %- "star" appear in the sky at º (Degrees) 
% star.Altitude   = 0;    %- Altitude in degrees (at transit)
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%- data structure
%- --------------
%- data(:.1)=day nr : seq date number 1..301, mar-21 7BC .. jan-15 6BC
%- data(:,2)=star first visibility hour
%- data(:,3)=star first visibility position in degree (180º is the south)
%- data(:,4)=star altitude over the horizon at transit point (i.e 180º)
%- data(:,5)=star transit time (hh:mm:ss)
%- data(:,6)=datenum of the "day nr" date
%- data(:,7)=Evaluate the probability based on the star and caravan arrival
%-           time. Reported in a 100% base
%- data(:,8)=Optimal speed for the corresponding date (for 4=< speed <=7)
%--------------------------------------------------------------------------

DateOne=datetime('0002-03-21'); %- first date of data
                                %- (march 21, 7BC). 
                                %- use year 2 instead of 7BC
                                %- (invalid in Matlab)    
                         
if withDisplay
    fprintf('Simulation :\n');      %- Start by giving the actual
    fprintf('------------\n\n');    %- simulation's parameters
    fprintf('Caravan speed ..... : %1.2f Km/h\n',caravan.speed );
    fprintf('Distance to travel  : %1.2f Km\n',caravan.distance );
    fprintf('Time span tolerance : %d min.\n\n',timespan );
    fprintf('Possible dates : \n\n');
end

% caravan travel time at 5 and 7 km/h
T5 = datenum(minutes((caravan.distance * 60) / 5)); 
T7 = datenum(minutes((caravan.distance * 60) / 7)); 

%- Caravan time to travel (in minutes)
caravan.travelTime = (caravan.distance * 60) / caravan.speed; 

%--------------------------------------------------------------------------
%- Main loop from the march 21st, 7BC to January 15th 6BC
%--------------------------------------------------------------------------
for n=1:length(data)            %- Day nr 1 = march 21, 7BC
    dayNr   = data(n,1);        %- Keep the day nr
    if dayNr<287                %- 286 1st Jan -6 (Year nr change)
        date = DateOne + caldays(n-1);%- march 21, 7BC + n days
        Year=-7;
    else
        date = DateOne + (caldays(n-1)-(365*2));%- year -6 represented
        Year=-6;                                %- by year 0001
    end
    Day     = day(date);          %- Day value
    Month   = month(date);        %- Month value
    data(n,6)=datenum(date);      %- datenum in data col 6
    star.appearTime  = data(n,2); %- First visibility time
    star.appearDeg   = data(n,3); %- First visibility position º
    star.Altitude    = data(n,4); %- Altitude in º (at transit)
    star.arriveAt    = data(n,5); %- Transit time (180º) Point C
    if isnan(star.appearTime)     %- NaN value -> error in fprintf
        star.appearTime=0;        %- VisHour = NaN than =0
    end
    %- Magi's caravan arrive at point C
    caravan.arriveAt = star.appearTime ...
        + minutes(caravan.travelTime); %- time(hh:mm)
    TS = datenum(star.arriveAt ...%- Time the star needs to travel
        - star.appearTime);%- from star.appearTime to Transit
    %- at 180º. Point C
    
    %-------------------------------------------------------------
    %- Is the date selectable ?
    %- 1. The "star" travel time must be strictly : T7 < TS < T5
    %- 2. First visibility time of the star exists
    %-    The star appeared in the sky according to Matthew's Gospel.
    %-    (i.e. was not already visible in the sky at its rise time.)
    %- 3. The delta between the arrival time of the "star" and the
    %-    caravan at the point B (180º) must happen at the same time,
    %-    Here the "timespan" constant determine the limit.
    %-------------------------------------------------------------
    if  (T5>=TS) ...     % Star time strictly : T7 < TS < T5
            ...     % T7 and T5 are the caravan time at a speed
            ...     % of 7 and 5 km/h
            && (T7<=TS) ...
            && (star.appearTime~=0) ... % First visibility time of the star
            ... % exists. Means : The star appeared in the
            ... %- sky (according to Matthew's Gospel)
            ... %- i.e. was not already visible in the sky
            ... %- at its rise time.
            && abs(datenum(star.arriveAt-caravan.arriveAt))...
            <= datenum(minutes(timespan))
        %- here the time span <= 10 min between the
        %- caravan arriving and the star at the
        %- transit point C(180º)
        if withDisplay
            fprintf('  Date (mm-dd-yy)... : %02d-%02d-%02d BC\n',...
                Month,Day,abs(Year) );
            fprintf('  Caravan arrive at  : %s\n',...
                datestr(caravan.arriveAt,'HH:MM'));
            fprintf('  Star transit at .. : %s\n',...
                datestr(star.arriveAt,'HH:MM'));
        end
        
        %- Evaluate the probability based on the star and caravan arrival
        %- time. Reported in a 100% base
        data(n,7)=round((10 - abs(round(...
            minutes(star.arriveAt-caravan.arriveAt)))) *10);
        
        %- Consider a match , if the difference < 2 min.
        if abs(star.arriveAt-caravan.arriveAt) < duration(minutes(2))
            s=' <- Match';
        else
            s='';
        end
        
        %- Display the time difference, and
        %- best evaluated speed for the date
        if withDisplay
            fprintf('  Difference ....... : %2.0f min.%s\n',...
                round(minutes(star.arriveAt-caravan.arriveAt)),s);
            fprintf('  Caravan speed .... : %2.2f km/h\n\n',...
                caravan.distance/...
                ((star.arriveAt-star.appearTime)*24));
        end
    end
    
    %- Evaluate the optimal speed for each date -> data(n,8)
    %- Speed must be >= 4 and <=7
    cSpeed=caravan.distance/((star.arriveAt-star.appearTime)*24);
    if (star.appearTime~=0) && (cSpeed>=4) && (cSpeed<=7)
        data(n,8)=cSpeed;
    end
    
end
 

