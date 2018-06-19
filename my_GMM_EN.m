clc; clear ; close all; 

% Choose image in a particular folder 
[FileName,PathName] = uigetfile('*.jpg' );
I= double(imread([PathName '\' FileName]));

%% Data initilisation

K = 4;                      % Number of Cluster
[n,m,d] = size(I);
data = reshape(I, n*m,3);   % Build 2D matrix

%% Clustering by Gaussian mixture:

gmm = fitgmdist(data, K,'Options',statset('MaxIter',500));

%% Replace each pixel with the value of his cluster center 

Postpp = posterior(gmm,data) ;
[~,mg] = max(Postpp,[],2);

% First method
img_label=reshape(mg,n,m);           % reshape pixel to [n,m]
im_res_1=label2rgb(img_label);       % transform label to RGB

imwrite(uint8(im_res_1), 'res_seg_mmg1.jpg');
figure('Name','First method','NumberTitle','off');
subplot(121); imshow(uint8(I)); title('Initial image') 
subplot(122); imshow(im_res_1); title([' K = ' num2str(K)])


% Second method
mg = reshape(mg, n,m);
im_res_2 = I;

for i = 1:n
    for j =1:m
       im_res_2(i,j,:) = gmm.mu(mg(i,j),:);
    end
end
imwrite(uint8(im_res_2), 'res_seg_mmg2.jpg');

figure('Name','Second method','NumberTitle','off');
subplot(121); imshow(uint8(I)); title('Initial image') 
subplot(122); imshow(uint8(im_res_2)); title([' K = ' num2str(K)])