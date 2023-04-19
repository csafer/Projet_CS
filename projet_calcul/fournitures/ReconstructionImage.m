%%  Application de la SVD : compression d'images

clear all
close all

% Lecture de l'image
I = imread('BD_Asterix_0.png');
I = rgb2gray(I);
I = double(I);

[q, p] = size(I)

% Décomposition par SVD
fprintf('Décomposition en valeurs singulières\n')
tic
[U, S, V] = svd(I);
toc

l = min(p,q);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% On choisit de ne considérer que 200 vecteurs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% vecteur pour stocker la différence entre l'image et l'image reconstuite
inter = 1:40:(200+40);
inter(end) = 200;
differenceSVD = zeros(size(inter,2), 1);

% images reconstruites en utilisant de 1 à 200 vecteurs (avec un pas de 40)
ti = 0;
td = 0;
for k = inter

    % Calcul de l'image de rang k
    Im_k = U_(:, 1:k)*S(1:k, 1:k)*U_(:, 1:k)';

    % Affichage de l'image reconstruite
    ti = ti+1;
    figure(ti)
    colormap('gray')
    imagesc(Im_k)
    
    % Calcul de la différence entre les 2 images
    td = td + 1;
    differenceSVD(td) = sqrt(sum(sum((I-Im_k).^2)));
    pause
end

% Figure des différences entre image réelle et image reconstruite
ti = ti+1;
figure(ti)% TODO
hold on 
plot(inter, differenceSVD, 'rx')
ylabel('RMSE')
xlabel('rank k')
pause


% Plugger les différentes méthodes : eig, puissance itérée et les 4 versions de la "subspace iteration method" 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% QUELQUES VALEURS PAR DÉFAUT DE PARAMÈTRES, 
% VALEURS QUE VOUS POUVEZ/DEVEZ FAIRE ÉVOLUER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% tolérance
eps = 1e-8;
% nombre d'itérations max pour atteindre la convergence
maxit = 10000;

% taille de l'espace de recherche (m)
search_space = 400;

% pourcentage que l'on se fixe
percentage = 0.995;

% p pour les versions 2 et 3 (attention p déjà utilisé comme taille)
puiss = 1;

%%%%%%%%%%%%%
% À COMPLÉTER
%%%%%%%%%%%%%

%%
% calcul des couples propres
[U_ou_V,D,k_,it,~,flag] = subspace_iter_v2(Im_k,search_space,percentage,puiss,eps,maxit);

%%
% calcul des valeurs singulières
S_ = sqrt(D);

%%
% calcul de l'autre ensemble de vecteurs


if (length(U_ou_V)==p) %U_ou_V==V
    V_ = U_ou_V;
    U_ = zeros(q,q);
    for i = 1:p
        U_(:,i) = 1/S_(i,i) * Im_k*U_ou_V(:,i);
    end
else
    U_ = U_ou_V;
    V_ = zeros(p,p);
    for i = 1:p
        V_(:,i) = 1/S_(i,i) * Im_k'*U_ou_V(:,i);
    end
    
end


%%
% calcul des meilleures approximations de rang faible
%TODO
for k = 1:k_ 
    
end