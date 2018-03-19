% Leif Wesche
% Singular Value Decomposition Facial Recognition

%% 1a) Import Cropped Images

clear all
close all
clc

cropped=dir('CroppedYale');
k={cropped.name};
for j=[1:length(k)-2];
p=strcat('CroppedYale\', k{j+2});
fold=dir(p);
b={fold.name};
for i=[1:length(b)-2] 
im=strcat('CroppedYale\', k{j+2}, '\',  b{i+2}); 
face_dummy{i}=imresize(double(imread(im)), [192/2, 168/2]);
end
faces{j}=face_dummy;
end

clc
disp('finished compiling faces')

%% 1b) Import Uncroppped Images

clc
clear all
close all

untar('yalefaces_uncropped');
for i=[1:9]
faces{i}{1}=imresize(double(imread(['yalefaces\subject0', num2str(i), '.centerlight'])), [75, 50]);
faces{i}{2}=imresize(double(imread(['yalefaces\subject0', num2str(i), '.glasses'])), [75, 50]);
faces{i}{3}=imresize(double(imread(['yalefaces\subject0', num2str(i), '.happy'])), [75, 50]);
faces{i}{4}=imresize(double(imread(['yalefaces\subject0', num2str(i), '.leftlight'])), [75, 50]);
faces{i}{5}=imresize(double(imread(['yalefaces\subject0', num2str(i), '.noglasses'])), [75, 50]);
faces{i}{6}=imresize(double(imread(['yalefaces\subject0', num2str(i), '.normal'])), [75, 50]);
faces{i}{7}=imresize(double(imread(['yalefaces\subject0', num2str(i), '.rightlight'])), [75, 50]);
faces{i}{8}=imresize(double(imread(['yalefaces\subject0', num2str(i), '.sad'])), [75, 50]);
faces{i}{9}=imresize(double(imread(['yalefaces\subject0', num2str(i), '.sleepy'])), [75, 50]);
faces{i}{10}=imresize(double(imread(['yalefaces\subject0', num2str(i), '.surprised'])), [75, 50]);
faces{i}{11}=imresize(double(imread(['yalefaces\subject0', num2str(i), '.wink'])), [75, 50]);
end
for i=[10:15]
faces{i}{1}=imresize(double(imread(['yalefaces\subject', num2str(i), '.centerlight'])), [75, 50]);
faces{i}{2}=imresize(double(imread(['yalefaces\subject', num2str(i), '.glasses'])), [75, 50]);
faces{i}{3}=imresize(double(imread(['yalefaces\subject', num2str(i), '.happy'])), [75, 50]);
faces{i}{4}=imresize(double(imread(['yalefaces\subject', num2str(i), '.leftlight'])), [75, 50]);
faces{i}{5}=imresize(double(imread(['yalefaces\subject', num2str(i), '.noglasses'])), [75, 50]);
faces{i}{6}=imresize(double(imread(['yalefaces\subject', num2str(i), '.normal'])), [75, 50]);
faces{i}{7}=imresize(double(imread(['yalefaces\subject', num2str(i), '.rightlight'])), [75, 50]);
faces{i}{8}=imresize(double(imread(['yalefaces\subject', num2str(i), '.sad'])), [75, 50]);
faces{i}{9}=imresize(double(imread(['yalefaces\subject', num2str(i), '.sleepy'])), [75, 50]);
faces{i}{10}=imresize(double(imread(['yalefaces\subject', num2str(i), '.surprised'])), [75, 50]);
faces{i}{11}=imresize(double(imread(['yalefaces\subject', num2str(i), '.wink'])), [75, 50]);  
end

clc
disp('finished compiling faces')

%% 2) Compile D
clc
D=[];
for j=[1:length(faces)]
for i=[1:length(faces{j})]
img=faces{j}{i}(:);    
D=[D, img];
end
end

disp('finished compiling D')

%% 3) SVD Decomposition
clc

[U,S,V]=svd(D, 'econ');

%U = equivilant to eigen vectors
%S = singular values, sqrt of eigen values
%V = image project onto the eigen values

disp('finished svd decomp')

%% 4) Plot First SVD Faces
clc

figure
subplot(2,3,1)
scatter([1:20], diag(S(1:20,1:20)/sum(diag(S))), 'filled')
title('Fig. 1a) 20 Largest Singular Values'); xlabel('Singular Value Index Number'); ylabel('Singular Value Percentage')
subplot(2,3,2)
semilogy(diag(S(1:end-1,1:end-1)/sum(diag(S))), 'linewidth', 3)
title('Fig. 1b) Singular Values'); xlabel('Singular Value Index Number'); ylabel('Singular Value Percentage')

SVD_face={};
for i=[1:length(U(1,:))]
SVD_face{i}=reshape(U(:,i), size(faces{1,1}{1,1}));    
end

subplot(2,3,3)
pcolor(flipud(SVD_face{1})), colormap(gray), shading interp
title('Fig. 1c) Mode 1')
subplot(2,3,4)
pcolor(flipud(SVD_face{20})), colormap(gray), shading interp
title('Fig. 1d) Mode 20')
subplot(2,3,5)
pcolor(flipud(SVD_face{50})), colormap(gray), shading interp
title('Fig. 1e) Mode 50')
subplot(2,3,6)
pcolor(flipud(SVD_face{500})), colormap(gray), shading interp
title('Fig. 1f) Mode 500')


%% 5) Plot less domiant SVD faces
figure
subplot(2,3,1)
pcolor(flipud(SVD_face{10})), colormap(gray), shading interp
title('SVD Face 10')
subplot(2,3,2)
pcolor(flipud(SVD_face{20})), colormap(gray), shading interp
title('SVD Face 20')
subplot(2,3,3)
pcolor(flipud(SVD_face{100})), colormap(gray), shading interp
title('SVD Face 100')
subplot(2,3,4)
pcolor(flipud(SVD_face{250})), colormap(gray), shading interp
title('SVD Face 250')
subplot(2,3,5)
pcolor(flipud(SVD_face{500})), colormap(gray), shading interp
title('SVD Face 500')
subplot(2,3,6)
pcolor(flipud(SVD_face{1000})), colormap(gray), shading interp
title('SVD Face 1000')

%% 6) Facial Reconstruction From n modes
clc
close all

index=[10, 20, 100, 500, 1000];
figure
subplot(2,3,1)
pcolor(flipud(faces{1}{1})), colormap(gray), shading interp
title('Fig. 2a) Person 1 Picture 1 Original')

letters=['b', 'c', 'd', 'e', 'f'];
for i=[1:length(index)]
Ure=U(1:end, 1:index(i));
Sre=S(1:index(i), 1:index(i));
Vre=V(1:end, 1:index(i));
Dre=Ure*Sre*(Vre.');

imre= reshape(Dre(:,1), size(faces{1}{1}));

subplot(2,3,i+1)
pcolor(flipud(imre)), colormap(gray), shading interp
title(['Fig. 2', letters(i), ') Reconstructed From ', num2str(index(i)), ' Modes'])
end


%% 7) Calculate 38 average faces

j=1;
ave_faces={};
ave_faces_vec={};
for j=[1:length(faces)]
ave=zeros(size(faces{1,1}{1,1}));

for i=[1:length(faces{j})]
im=faces{j};    
img=im{i};
ave=ave+img;
% pcolor(flipud(img)), colormap(gray)
% img=double(im{i});
% img=imresize(img, [192/2, 168/2]);
end
ave=ave./length(faces{j});
ave_faces{j}=ave;
ave_faces_vec{j}=ave(:);
% figure
% pcolor(flipud(ave_faces{j})), colormap(gray), shading interp
end
clc
disp('finished compiling Average Faces')

%% 8) Project Average Faces for each person onto U
clc
close all

proj={};
for i=[1:length(ave_faces_vec)]
   %proj{i}=U*ave_faces_vec{i};
   proj{i}=((ave_faces_vec{i}).')*U;
end

figure
subplot(2,2,1)
bar(proj{1}(1:19)), set(gca, 'Ylim', [-350, 350])
title('Average Face 1 Projection onto U')
subplot(2,2,2)
bar(proj{2}(1:19)), set(gca, 'Ylim', [-350, 350])
title('Average Face 2 Projection onto U')
subplot(2,2,3)
bar(proj{3}(1:19)), set(gca, 'Ylim', [-350, 350])
title('Average Face 3 Projection onto U')
subplot(2,2,4)
bar(proj{4}(1:19)), set(gca, 'Ylim', [-350, 350])
title('Average Face 4 Projection onto U')

% figure
% subplot(2,2,1)
% V1=V(1,:);
% bar(V1(1:20))
% title('First 20 values of V colum 1')
% subplot(2,2,2)
% V2=V(2,:);
% bar(V2(1:20))
% title('First 20 values of V colum 2')
% subplot(2,2,3)
% V3=V(3,:);
% bar(V3(1:20))
% title('First 20 values of V colum 3')
% subplot(2,2,4)
% V4=V(4,:);
% bar(V4(1:20))
% title('First 20 values of V colum 4')


%% 9) Compare Average Face 1 Projection with Person 1 Picure 1 Projection
clc
close all

figure
subplot(2,2,1)
pcolor(flipud(faces{1}{1})), colormap(gray), shading interp
title('Fig. 3a) Person 1, Picture 1')
subplot(2,2,2)
pcolor(flipud(ave_faces{1})), colormap(gray), shading interp
title('Fig. 3b) Average Face 1')

proj11=((faces{1}{1}(:)).')*U;

subplot(2,2,3)
bar(proj11(1:19)), set(gca, 'Ylim', [-350, 350])
title('Fig. 3c) Person 1 Photo 1 Projection onto U')
subplot(2,2,4)
bar(proj{1}(1:19)), set(gca, 'Ylim', [-350, 350])
title('Fig. 3d) Average Face 1 Projection onto U')



%% 10) Test Faces

clc
close all

% Select photo to test faces
Person=13;
Photo=1;
test_photo=faces{Person}{Photo};
pcolor(flipud(test_photo)), colormap(gray), shading interp
title(['Test Person ', num2str(Person), ', Photo ', num2str(Photo)])

for i=[1:length(proj)]
    %proj_test=U*test_photo(:);
    proj_test=((test_photo(:)).')*U;
    test(i)=abs(mean(norm(proj_test(10:100) - proj{i}(10:100))));
end
test_mins=sort(test);
for i=[1:5]
    test_mins(1:i);
    ind(i)=find(test==test_mins(i));
end

disp(['Best Fit = Person ',num2str(ind(1))])
disp(['Second Best Fit = Person ',num2str(ind(2))])
disp(['Third Best Fit = Person ',num2str(ind(3))])






