clear;close all;clc;

% ��ɫ�ռ��������֣�������RGB��CMY��HSV,HSI�ȡ�
% RGB��������������������ʶ�����ɫ������Ŀռ䣬�ɱ�ʾ�󲿷���ɫ�����ڿ�ѧ�о�һ�㲻����RGB��ɫ�ռ䣬��Ϊ����ϸ�����Խ������ֻ��ĵ���������ɫ�������ȣ����Ͷ�����������һ���ʾ�����ѷֿ���������ͨ�õ�����Ӳ���Ĳ�ɫģ�͡���ģ�����ڲ�ɫ��������һ�����ɫ��Ƶ����
% CMY�ǹ�ҵӡˢ���õ���ɫ�ռ䡣����RGB��Ӧ���򵥵����RGB��Դ�������巢�⣬��CMY�����ݷ����õ��ġ�����Ӧ�����ӡ����һ�������ɫī�У���CMY�Ӻ�ɫī�С�
% HSV,HSI������ɫ�ռ䶼��Ϊ�˸��õ����ֻ�������ɫ��������ġ���������HSX��ɫ�ռ䣬���е�X������V,Ҳ������I�����ݾ���ʹ�ö�X���岻ͬ��H��ɫ����S�Ǳ��Ͷȣ�I��ǿ�ȡ�
% L*a*b��ɫ�ռ����ڼ����ɫ�������Ͳ�ɫУ�������������豸�Ĳ�ɫģ��ʵ�֡���һ�����������豸ӳ�䵽ģ�ͼ�ģ�ͱ���Ĳ�ɫ�ֲ������仯��
rng(0)

% ��ȡ����ͼ��
im = imread('city.jpg');
imshow(im), title('Imput image');
% ת��ͼ�����ɫ�ռ�õ�����
cform = makecform('srgb2lab');
lab = applycform(im,cform);
ab = double(lab(:,:,2:3));
nrows = size(lab,1); ncols = size(lab,2);
X = reshape(ab,nrows*ncols,2)';
figure, scatter(X(1,:)',X(2,:)',3,'filled');  box on; %��ʾ��ɫ�ռ�ת����Ķ�ά�����ռ�ֲ�
%print -dpdf 2D1.pdf
%% �������ռ����Kmeans����
k = 5; % �������
max_iter = 100; %����������

[centroids, labels] = run_kmeans(X, k, max_iter); 
% [labels,centroids] = kmeans(X',k);


%% ��ʾ����ָ���
figure, scatter(X(1,:)',X(2,:)',3,labels,'filled'); %��ʾ��ά�����ռ����Ч��
hold on; scatter(centroids(1,:),centroids(2,:),60,'r','filled')
hold on; scatter(centroids(1,:),centroids(2,:),30,'g','filled')
box on; hold off;
%print -dpdf 2D2.pdf

pixel_labels = reshape(labels,nrows,ncols);
rgb_labels = label2rgb(pixel_labels);
figure, imshow(rgb_labels), title('Segmented Image');
%print -dpdf Seg.pdf

function [centroids, labels] = run_kmeans(X, k, max_iter)
% �ú���ʵ��Kmeans����
% ���������
%                   XΪ������������dxN
%                   kΪ�������ĸ���
%                   max_iterΪkemans������������Ĵ���
% ���������
%                   centroidsΪ�������� dxk
%                   labelsΪ�����������

%% ����K-means++�㷨��ʼ����������
  centroids = X(:,1+round(rand*(size(X,2)-1)));
  labels = ones(1,size(X,2));
  for i = 2:k
        D = X-centroids(:,labels);
        D = cumsum(sqrt(dot(D,D,1)));
        if D(end) == 0, centroids(:,i:k) = X(:,ones(1,k-i+1)); return; end
        centroids(:,i) = X(:,find(rand < D/D(end),1));
        [~,labels] = max(bsxfun(@minus,2*real(centroids'*X),dot(centroids,centroids,1).'));
  end
  
%% ��׼Kmeans�㷨
  for iter = 1:max_iter
        for i = 1:k, l = labels==i; centroids(:,i) = sum(X(:,l),2)/sum(l); end
        [~,labels] = max(bsxfun(@minus,2*real(centroids'*X),dot(centroids,centroids,1).'),[],1);
  end
  
end

