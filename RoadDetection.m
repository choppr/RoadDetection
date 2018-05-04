clear all
warning('off','all');
warning;

video=VideoReader('driving.avi');
frame = 0;
Errorlines = 0;
Correctlines = 0;
Totallines = 0;
%frame 40 - 540
for K = 40: 1:541
    videoFrame=read(video,K);
    if frame>=1
        imwrite(videoFrame,'img.jpg');
        a  = imread('img.jpg');
        b = size(a);
        row = b(1);
        I=rgb2gray(a);
        rn = wiener2(I,[3 3]);  
        rn = floor(rn);
        d = graythresh(rn);         
        e = im2bw(rn,d);              
        BW  = edge(e,'canny',[],1.5);  
        BW(1:7*row/10, :, :)=0;
        [H,theta,rho] = hough(BW,'Theta',-65:1:65);
        P = houghpeaks(H,15,'threshold',ceil(0.3*max(H(:))));
        lines = houghlines(BW,theta,rho,P,'FillGap',50,'MinLength',1);
        imshow(a), hold on
        max_len = 0;
        for k = 1:length(lines)
            xy = [lines(k).point1; lines(k).point2];
            if(lines(k).rho < 10 && (lines(k).theta > 64 || lines(k).theta < -60))
                Errorlines = Errorlines + 1;
            else 
                Correctlines = Correctlines + 1;
            end
             plot(xy(:,1),xy(:,2),'LineWidth',5,'Color','green');
            Totallines = Totallines + 1;
        end
        frame=0;
   else 
        frame=frame+1;
        pause(0.00001);
    end
end