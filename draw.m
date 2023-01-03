clear;
clc;

% Read data

fid=fopen("./rec.txt","r");
data=textscan(fid,"%d %s %f","Delimiter"," ");
fclose(fid);

% Prepare data

count=length(data{1});

times=zeros(1,count);
temps=zeros(1,count);

% We need to introduce an offset to make
% times start from 0
% and temps vary in several hundred.
initialTime=0;
tempScale=100;
for i=1:count
    day=data{1}(i);
    hourMinCell=data{2}(i);
    hour=str2double(hourMinCell{1}(1:2));
    minute=str2double(hourMinCell{1}(3:4));
    
    times(i)=(day*24+hour)*60+minute;
    temps(i)=data{3}(i)*tempScale;
    
    if i==1
        initialTime=times(i);
    end
    
    times(i)=times(i)-initialTime;
end

minTimes=min(times);
maxTimes=max(times);
minTemps=min(temps);
maxTemps=max(temps);

fitF=createFit(times,temps);

fitX=linspace(minTimes,maxTimes,1000);
fitY=fitF(fitX);

% Prepare image data

imageW=maxTimes;
imageH=maxTemps*1.01;
imageYLowLim=36*tempScale;
imageData=zeros(ceil(imageH),imageW);

for i=1:imageW
    fitValue=fitF(i);
    colorBoundaryY=round(fitValue);
    % Map value to [0,85](red-green range in hsv)
    imageValue=85*(1-(fitValue-minTemps)/(maxTemps-minTemps));
    
    % Fill color value
    imageData(imageYLowLim:colorBoundaryY,i)=imageValue;
    
    % Fill empty color value
    imageData(colorBoundaryY+1:imageH,i)=NaN;
end

% Draw image

im=image(imageData);
hold on;
plot(fitX,fitY,'Color','r','LineWidth',1.5);
title("体温监测图");
xlabel("时间");
ylabel("体温/℃");
ylim([imageYLowLim,imageH]);
set(gca,'YDir','normal');
% NaN values are transparent
set(im,'alphadata',~isnan(imageData));
grid on;
colormap hsv;
yticks([36,36.5,37,37.5,38,38.5,39,39.5,40]*tempScale);
yticklabels(["36","36.5","37","37.5","38","38.5","39","39.5","40"]);
xticks([18,24,30,36,42,48,54,60,66,72,78,84,90]*60-initialTime);
xticklabels(["18:00","12月26日","6:00","12:00","18:00","12月27日","6:00","12:00","18:00","12月28日","6:00","12:00","18:00"]);
