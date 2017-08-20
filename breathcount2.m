clear all
close all
clc

faceDetector = vision.CascadeObjectDetector();


%%%%%%%%%%%%%%%%%%% Read a frame from the video %%%%%%%%%%%%%%%%%%%%%%%%%%%
vid = VideoReader('sir.webm');
nframes=vid.NumberOfFrames;
videoFrame = read(vid,1);
BB = step(faceDetector, videoFrame);


%%%%%%%%%%%%%%% Draw the square around the detected face %%%%%%%%%%%%%%%%%%
videoOut = insertObjectAnnotation(videoFrame,'rectangle',BB,'Face');
%figure, imshow(videoOut), title('Detected face');

%%%%%%%%%%%%%% Finding the Region of interest %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
BB3 = [BB(1)-(1/2*BB(3)),BB(2)+(3/2*BB(4)),2*BB(3),2*BB(4)];
videoOut = insertObjectAnnotation(videoFrame,'rectangle',BB3,'Chest'); imshow(videoOut), title('Detected Chest');

for i=1:nframes
 frame = read(vid, i);
 grayImage = rgb2gray(frame);
 ROI =imcrop(grayImage,BB3);
 %figure;
 %imshow(ROI);
 %meanIntensity(j) = mean2(ROI);

 
%%%%%%%%%%%%%%%%%%%%%%%% laplacian pyramid of image %%%%%%%%%%%%%%%%%%%%%%%%
level=5
limga = genPyr(ROI,'lap',level);
im=limga{5};

meanIntensity(i) = mean(mean(ROI));
%meanIntensity2(i) = mean(mean(im));
%figure;
%imshow(limga{5});
end

figure;
x=1:nframes;
%x=1:50;
plot(x,meanIntensity(1:nframes));
% set(gca,'YLim',[103 109])
% set(gca,'XLim',[0 1000])
title('breathing rate');

% figure;
% x=1:200;
% %x=1:50;
% plot(x,meanIntensity2(1:200));
% % set(gca,'YLim',[103 109])
% % set(gca,'XLim',[0 1000])
% title('breathing rate2');

figure;
fs=60;
r=fft2(meanIntensity);
r=r(1:nframes);
r1=abs(r);
plot(r1);
title('calculation');
[maxY, indexOfMaxY] = max(r1);
 total=  (indexOfMaxY * 16 *30*30)/nframes ;
 disp(total);