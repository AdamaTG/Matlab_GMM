clc; clear ; close all; 

% Lecture de l'image
% I = double(imread('image.jpg'));

% Lecture de l'image dans un dossier particulier 
[FileName,PathName] = uigetfile('*.jpg' );
I= double(imread([PathName '\' FileName]));

%% Initialisation des données

K = 4;
[n,m,d] = size(I);
data = reshape(I, n*m,3); %% contruire une matrice 2D

%% Regroupement par mélange Gaussien:

gmm = fitgmdist(data, K,'Options',statset('MaxIter',500));

% Enregistrement de l'image segmentée: Remplacer chaque pixel par la valeur
% du centre de son groupe (si le groupe est k, la moyenne est mu_k(:).
Postpp = posterior(gmm,data) ;
[~,mg] = max(Postpp,[],2);

% Première méthode
img_label=reshape(mg,n,m);              % reshape pixel to [n,m]
img_final_1=label2rgb(img_label);       % transform label to RGB

figure; imshow(img_final_1); title(['Number of Cluster K=' num2str(K)])

% Deuxième méthode
mg = reshape(mg, n,m);
img_final_2 = I;
for i = 1:n
    for j =1:m
       img_final_2(i,j,:) = gmm.mu(mg(i,j),:);
    end
end

figure; imshow(uint8(img_final_2)); title(['Number of Cluster K=' num2str(K)])