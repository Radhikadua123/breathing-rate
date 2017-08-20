clear all
close all
clc

faceDetector = vision.CascadeObjectDetector();


%%%%%%%%%%%%%%%%%%% Read a frame from the video %%%%%%%%%%%%%%%%%%%%%%%%%%%
vid = VideoReader('breaths.webm');
nframes=vid.NumberOfFrame();
videoFrame = read(vid,1);
BB = step(faceDetector, videoFrame);


%%%%%%%%%%%%%%% Draw the square around the detected face %%%%%%%%%%%%%%%%%%
videoOut = insertObjectAnnotation(videoFrame,'rectangle',BB,'Face');
figure, imshow(videoOut), title('Detected face');


%%%%%%%%%%%%%% Finding the Region of interest %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
BB3 = [BB(1)-(1/2*BB(3)),BB(2)+(3/2*BB(4)),2*BB(3),2*BB(4)];

%%%%%%%%%%%%%% Cropping the region of interest from each frame %%%%%%%%%%%%
%%%%%%%%%%%%%% And finding the mean intensity for each frame %%%%%%%%%%%%%%
for j= 1:nframes
        frame = read(vid, j);
        grayImage = rgb2gray(frame); 
        ROI =imcrop(grayImage,BB3);
        %figure;
        %imshow(ROI);
       meanIntensity(j) = mean2(ROI);
end


%%%%%%%%%%%%%%%%%%% Plot mean intensity vs time %%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
x=1:nframes;
%x=1:50;
plot(x,meanIntensity);
% set(gca,'YLim',[103 109])
% set(gca,'XLim',[0 1000])
title('breathing rate');


%%%%%%%%%%%%  Fast fourier transformation of Mean intensity %%%%%%%%%%%%%%%
fs=60;
r=fft2(meanIntensity);
r=r(1:nframes);
r1=abs(r);


%%%%%%%%%%%%%%%%%% Plot the graph to find the peak value %%%%%%%%%%%%%%%%%%
n1=length(r1);
%fx=((0:1/n1:1-1/n1)*fs);
fx = (0:nframes-1)/nframes; 
figure;
fx=1:nframes;
%plot(fx(1:50),r1(1:50));
%set(gca,'XLim',[0 10]);
plot(fx,r1);
title('calculation');


%peak=max(r1);
[maxY, indexOfMaxY] = max(r1);
xAtMaxY = fx(indexOfMaxY);

total=xAtMaxY;
