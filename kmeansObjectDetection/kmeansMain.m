clear;close all;clc;

% 颜色空间有许多种，常用有RGB，CMY，HSV,HSI等。
% RGB（红绿蓝）是依据人眼识别的颜色定义出的空间，可表示大部分颜色。但在科学研究一般不采用RGB颜色空间，因为它的细节难以进行数字化的调整。它将色调，亮度，饱和度三个量放在一起表示，很难分开。它是最通用的面向硬件的彩色模型。该模型用于彩色监视器和一大类彩色视频摄像。
% CMY是工业印刷采用的颜色空间。它与RGB对应。简单的类比RGB来源于是物体发光，而CMY是依据反射光得到的。具体应用如打印机：一般采用四色墨盒，即CMY加黑色墨盒。
% HSV,HSI两个颜色空间都是为了更好的数字化处理颜色而提出来的。有许多种HSX颜色空间，其中的X可能是V,也可能是I，依据具体使用而X含义不同。H是色调，S是饱和度，I是强度。
% L*a*b颜色空间用于计算机色调调整和彩色校正。它独立于设备的彩色模型实现。这一方法用来把设备映射到模型及模型本社的彩色分布质量变化。
rng(0)

% 读取测试图像
im = imread('city.jpg');
imshow(im), title('Imput image');
% 转换图像的颜色空间得到样本
cform = makecform('srgb2lab');
lab = applycform(im,cform);
ab = double(lab(:,:,2:3));
nrows = size(lab,1); ncols = size(lab,2);
X = reshape(ab,nrows*ncols,2)';
figure, scatter(X(1,:)',X(2,:)',3,'filled');  box on; %显示颜色空间转换后的二维样本空间分布
%print -dpdf 2D1.pdf
%% 对样本空间进行Kmeans聚类
k = 5; % 聚类个数
max_iter = 100; %最大迭代次数

[centroids, labels] = run_kmeans(X, k, max_iter); 
% [labels,centroids] = kmeans(X',k);


%% 显示聚类分割结果
figure, scatter(X(1,:)',X(2,:)',3,labels,'filled'); %显示二维样本空间聚类效果
hold on; scatter(centroids(1,:),centroids(2,:),60,'r','filled')
hold on; scatter(centroids(1,:),centroids(2,:),30,'g','filled')
box on; hold off;
%print -dpdf 2D2.pdf

pixel_labels = reshape(labels,nrows,ncols);
rgb_labels = label2rgb(pixel_labels);
figure, imshow(rgb_labels), title('Segmented Image');
%print -dpdf Seg.pdf

function [centroids, labels] = run_kmeans(X, k, max_iter)
% 该函数实现Kmeans聚类
% 输入参数：
%                   X为输入样本集，dxN
%                   k为聚类中心个数
%                   max_iter为kemans聚类的最大迭代的次数
% 输出参数：
%                   centroids为聚类中心 dxk
%                   labels为样本的类别标记

%% 采用K-means++算法初始化聚类中心
  centroids = X(:,1+round(rand*(size(X,2)-1)));
  labels = ones(1,size(X,2));
  for i = 2:k
        D = X-centroids(:,labels);
        D = cumsum(sqrt(dot(D,D,1)));
        if D(end) == 0, centroids(:,i:k) = X(:,ones(1,k-i+1)); return; end
        centroids(:,i) = X(:,find(rand < D/D(end),1));
        [~,labels] = max(bsxfun(@minus,2*real(centroids'*X),dot(centroids,centroids,1).'));
  end
  
%% 标准Kmeans算法
  for iter = 1:max_iter
        for i = 1:k, l = labels==i; centroids(:,i) = sum(X(:,l),2)/sum(l); end
        [~,labels] = max(bsxfun(@minus,2*real(centroids'*X),dot(centroids,centroids,1).'),[],1);
  end
  
end


