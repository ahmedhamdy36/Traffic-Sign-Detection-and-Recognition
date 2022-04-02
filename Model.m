clear,clc,close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Sign Detection%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%load the input image
image = imread('12.jpg');
figure, imshow(image);
title('Original image');

%convert it to blue scale
b = image(:,:,3);
%convert the blue scaled image to binary scale
bw1 = im2bw(b);
%inverse the binary scale
bw = imcomplement(bw1);
%fill any free hole
bwfill = imfill(bw,'holes');
%creates a disk-shaped structuring element
seD = strel('disk',10);
BWfinal = imopen(bwfill,seD);

%calculate the bounds of all objects in the image
[v,num] = bwlabel(BWfinal);
s = regionprops(v, 'BoundingBox');

if num>1
    %this for loop removes any another object in the image  
    for i = 1:num
       width = s(i).BoundingBox(3);
       hight = s(i).BoundingBox(4);
       diff = abs(width - hight);
       area = width * hight;
       if diff < 50
           BWfinal = bwareaopen(BWfinal, area);
       end
    end
end

[~,num] =bwlabel(BWfinal);

%in case still some objects we clear the borders
if num>1
   BWnobord = imclearborder(bw,4);
   seD = strel('rectangle',[20 ,20]);
   BWfinal=imopen(BWnobord,seD);
end
   
%to determine the center of the sign  
s = regionprops(BWfinal,'Centroid','BoundingBox');
cen = cat(1,s.Centroid);
bbox = cat(1,s.BoundingBox);

hold on
plot(cen(:,1),cen(:,2),'g*');
hold on

image= insertShape(image,'rectangle',bbox,'color','g');
arr=s(1).BoundingBox();
Im = imcrop(image,arr);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Recognition%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Convert RGB image to chosen color space
I = rgb2hsv(Im);
%%%%%%%%%%%%%%%red recognition%%%%%%%%%%%%%%%%%%%%
% Define thresholds for channel 1 based on histogram settings
channel1Min = 0.942;
channel1Max = 0.069;


% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.455;
channel2Max = 1.000;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.575;
channel3Max = 1.000;

% Create mask based on chosen histogram thresholds
sliderBW = ( (I(:,:,1) >= channel1Min) | (I(:,:,1) <= channel1Max) ) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
BW = sliderBW;

[~,num]=bwlabel(BW);
if num>0
    figure,imshow(Im);title('Light:Red');
end

%%%%%%%%%%%%%yellow recognition%%%%%%%%%
if num==0
    % Define thresholds for channel 1 based on histogram settings
    channel1Min = 0.078;
    channel1Max = 0.168;

    % Define thresholds for channel 2 based on histogram settings
    channel2Min = 0.455;
    channel2Max = 1.000;

    % Define thresholds for channel 3 based on histogram settings
    channel3Min = 0.575;
    channel3Max = 1.000;

    % Create mask based on chosen histogram thresholds
    sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
        (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
        (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
    BW = sliderBW;
   % figure,imshow(BW);
    [~,num]=bwlabel(BW);
    if num>0
        figure,imshow(Im);title('Light:Yellow');
    end

    %%%%%%%%%%%%%green recognition%%%%%%%%%
    if num==0
        % Define thresholds for channel 1 based on histogram settings
        channel1Min = 0.245;
        channel1Max = 0.498;
        

        % Define thresholds for channel 2 based on histogram settings
        channel2Min = 0.455;
        channel2Max = 1.000;

        % Define thresholds for channel 3 based on histogram settings
        channel3Min = 0.575;
        channel3Max = 1.000;

        % Create mask based on chosen histogram thresholds
        sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
            (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
            (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
        BW = sliderBW;
        figure,imshow(Im);title('Light:Green');
    end
    
end