clc; clear ; close all; 

% Lecture de l'image dans un dossier particulier 
[FileName,PathName] = uigetfile('*.jpg' );
I= double(imread([PathName '\' FileName]));

%% Initialisation des données

K = 4;                      % Nombre de groupe
[n,m,d] = size(I);
data = reshape(I, n*m,d);   % Transformer I en une matrice 2D

%% Regroupement par mélange Gaussien:

gmm = fitgmdist(data, K,'Options',statset('MaxIter',1000));

%% Remplacer chaque pixel par la valeur du centre de son groupe 

Postpp = posterior(gmm,data) ;
[~,mg] = max(Postpp,[],2);

% Première méthode
img_label=reshape(mg,n,m);           % Transformer mg en [n,m]
im_res_1=label2rgb(img_label);       % Transformer en RGB
imwrite(uint8(im_res_1), 'res_seg_mmg1.jpg');

figure('Name','Première méthode','NumberTitle','off');
subplot(121); imshow(uint8(I)); title('Image initiale ') 
subplot(122); imshow(im_res_1); title([' K = ' num2str(K)])


% Deuxième méthode
mg = reshape(mg, n,m);
im_res_2 = I;

for i = 1:n
    for j =1:m
       im_res_2(i,j,:) = gmm.mu(mg(i,j),:);
    end
end
imwrite(uint8(im_res_2), 'res_seg_mmg2.jpg');

figure('Name','Deuxième méthode','NumberTitle','off');
subplot(121); imshow(uint8(I)); title('Image initiale') 
subplot(122); imshow(uint8(im_res_2)); title([' K = ' num2str(K)])