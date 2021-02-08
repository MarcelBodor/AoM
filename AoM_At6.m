function [data] = AoM_At6(data,caravan,map)

%--------------------------------------------------------------------------
%- Create a short table (x) based on the selected dates/results, 
%- and add some dates before and after (cosmetic)
%--------------------------------------------------------------------------
clear x;
BlanksDates=2;             %- Number of empty dates before and after
i=find(data(:,7)>0, 1, 'first')  - BlanksDates;
j=find(data(:,7)>0, 1, 'last') + ( 5 -length(find(data(:,7)>0)) );
x=data(i:j,:);
x(:,2:5)=[];

SelDateMatchInd=find(x(:,3)>=95, 1, 'first'); % select >= 95%

%--------------------------------------------------------------------------
%-- plot the map and the graph of the selected dates. 
%--------------------------------------------------------------------------
figure('Renderer', 'painters', 'Position', [250 200 1000 500])
subplot(1,2,1);          %- Picture / map
pos = [0.01 0.11 0.45 0.9 ];    %- [left bottom width height]
subplot('Position',pos);
imshow(map);
title('Region of Jerusalem to Bethlehem'); 
xlabel({ ['Magi travel from A to C at ' num2str(caravan.speed)...
          ' km/h, the "Star" travel from B to C ' ]
         ['The Magi begin their journey when the star becomes visible in the sky.']});

subplot(1,2,2);
pos = [0.55 0.3 0.42 0.5 ];    %- [left bottom width height]
subplot('Position',pos);
b=bar(x(:,2),x(:,3));
datetick('x', 'dd-mmm','keeplimits','keepticks');
if ~isempty(SelDateMatchInd)
 b.FaceColor = 'flat';
 b.CData(SelDateMatchInd,:) = [.5 0 .5];  
end
ylim([0 105])
title('Probability graph of possible days.')
xlabel('Selection of possible dates from March 7 BC to January 6 BC');
ylabel('%');

% for i=1:3 %- Page break workaround
%  fprintf('\n');
% end


end