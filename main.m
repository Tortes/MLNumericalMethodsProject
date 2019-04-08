clear;
%Image1
img = imgRead('fishing_boat.bmp');
numSampleArray = [10, 20, 30, 40, 50];
eps1 = zeros(1,5);
n = 1;
for numSample = numSampleArray
    filename = "fishing_boat" + int2str(numSample) + ".fig";
    imgIn = double(getimage(openfig(filename, 'invisible')));
    eps1(n) = sum(sum((img-imgIn).^2))/size(imgIn,1)/size(imgIn,2);
    n=n+1;
end


%Image2
img = imgRead('lena.bmp');
numSampleArray = [10,30,50,100,150];
eps2 = zeros(1,5);
n = 1;
for numSample = numSampleArray
    filename = "lena" + num2str(numSample)+".fig";
    imgIn = double(getimage(openfig(filename, 'invisible')));
    eps2(n) = sum(sum((img-imgIn).^2))/size(imgIn,1)/size(imgIn,2);
    n=n+1;
end 

%Image3
img = imgRead('fishing_boat.bmp');
numSampleArray = [10, 20, 30, 40, 50];
eps3 = zeros(1,5);
n = 1;
for numSample = numSampleArray
    filename = "./fb/boat" + int2str(numSample) + ".fig";
    imgIn = double(getimage(openfig(filename, 'invisible')));
    eps3(n) = sum(sum((img-imgIn).^2))/size(imgIn,1)/size(imgIn,2);
    n=n+1;
end


%Image4
img = imgRead('lena.bmp');
numSampleArray = [10,30,50,100,150];
eps4 = zeros(1,5);
n = 1;
for numSample = numSampleArray
    filename = "./lena/lena" + num2str(numSample)+".fig";
    imgIn = double(getimage(openfig(filename, 'invisible')));
    eps4(n) = sum(sum((img-imgIn).^2))/size(imgIn,1)/size(imgIn,2);
    n=n+1;
end 

hold on;
grid off;
figure;
x=1:5;
plot(x,eps2,'-*b',x,eps4,'-or')
legend('midfit','recovered')
set(gca,'xtick',[],'xticklabel',[])
title('lena')