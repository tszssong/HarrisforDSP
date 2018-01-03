clear all;
% I1=imread('E:\502\picture\SAD_test_data\group1/img1.png');
%  I2=imread('E:\502\picture\SAD_test_data\group1/img2.png');
 I1=imread('I:\E\502\picture\SAD_test_data\group1/img1.png');
 I2=imread('I:\E\502\picture\SAD_test_data\group1/img2.png');
%  I1=imread('D:\502pic/KITTI110926130226 - 512.png');
%  I2=imread('D:\502pic/KITTI110926130227 - 512.png');
sss = 4; 
scale = 8;
[m,n,d]=size(I1);
SI1 = zeros(m/sss, n/sss);
%%%%%%%%%%%%�²���%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:m/sss
    for j=1:n/sss
   %     simg(i,j) = mean( mean( img(i*4-3:i*4,j*4-3:j*4) ) );
         SI1(i,j) = I1((i-1)*sss+1,(j-1)*sss+1);
    end
end
SI1 = uint8(SI1);
SI2 = zeros(m/sss, n/sss);
for i=1:m/sss
    for j=1:n/sss
   %     simg(i,j) = mean( mean( img(i*4-3:i*4,j*4-3:j*4) ) );
         SI2(i,j) =  I2((i-1)*sss+1,(j-1)*sss+1) ;
    end
end
SI2 = uint8(SI2);

Option.TH = 0.002;
Option.Edge = ceil(scale/sss);
% Option.Edge = scale;
Ipts1 = HarrisCorner(SI1,Option);
Ipts2 = HarrisCorner(SI2,Option);
%%%%%%%%�ǵ����²������ͼ�����꣬����Ŵ󣬻ָ���ԭ��ͼ������%%%%%%%%%%%%
for i = 1:1:length(Ipts1)
    Ipts1(i).x = min(m-scale, Ipts1(i).x*sss);
    Ipts1(i).y = min(n-scale, Ipts1(i).y*sss);
end
for i = 1:1:length(Ipts2)
    Ipts2(i).x =  min(m-scale, Ipts2(i).x*sss);
    Ipts2(i).y = min(n-scale, Ipts2(i).y*sss);
end
%%%%��ʾͼ��2�ͼ�⵽�Ľǵ�
figure, imshow(I2); hold on;
for i=1:length(Ipts2)
     plot(Ipts2(i).x,Ipts2(i).y,'or');
 end

tic;
  errTH=0.1;        %ƥ�������ֵ
Distance = zeros( length(Ipts2),length(Ipts1) );
signedI1 = double(I1);
signedI2 = double(I2);

for i = 1:1:length(Ipts1)
    for j = 1:1:length(Ipts2)
        
%         a = signedI1(Ipts1(i).y-scale:Ipts1(i).y+scale , Ipts1(i).x-scale:Ipts1(i).x+scale);
%         b = signedI2(Ipts2(j).y-scale:Ipts2(j).y+scale , Ipts2(j).x-scale:Ipts2(j).x+scale);
        
        a = signedI1( (max(Ipts1(i).y-scale , 0):min(Ipts1(i).y+scale , n) ), ( max(0,Ipts1(i).x-scale) : min(m, Ipts1(i).x+scale) ) );
        b = signedI2( (max(0 , Ipts2(j).y-scale):min(n , Ipts2(j).y+scale) ) , (max(0,Ipts2(j).x-scale):min(m, Ipts2(j).x+scale) ) );
%         a = a-mean2(a);
%         b = b-mean2(b);
        Region = abs( a - b );
        %Region = (a - b).^2/sqrt( sum( sum(a.^2) ) )/sqrt( sum( sum(b.^2) ) );
       % ncc = abs(a-mean2(a))*abs(b-mean2(b))/std2(a)/std2(b);
        % Distance(j,i) = sum(sum(ncc))/((2*scale+1)^2-1);
       % Distance(j,i) =  abs( sum(sum(a.*b))/(norm(a)*norm(b)) - 1 );%
        %�н�����
       Distance(j,i) = sum( sum(Region) )/sum(sum(a));
        % Distance(j,i) = corr2(a,b);
    end
end
[minD,cor2] = min(Distance);
toc;


I(:,1:size(I1,2),:)=I1; 
I(:,size(I1,2)+1:size(I1,2)+size(I2,2),:)=I2;
  figure, imshow(I); hold on;
matched = zeros(length(Ipts1),4);
 hold on;
% Show the best matches
for i=1:length(Ipts1)
      if (minD(i)<errTH)
        c=rand(1,3);  %���ڻ���ͬ��ɫͼ [ 0.1933,    0.0263,    0.4688];
        plot([Ipts1(i).x Ipts2(cor2(i)).x+size(I1,2)],[Ipts1(i).y Ipts2(cor2(i)).y],'-','Color',c)
        plot([Ipts1(i).x Ipts2(cor2(i)).x+size(I1,2)],[Ipts1(i).y Ipts2(cor2(i)).y],'o','Color',c,'MarkerSize',8)
        text([Ipts1(i).x Ipts2(cor2(i)).x+size(I1,2)],[Ipts1(i).y Ipts2(cor2(i)).y],[num2str(i)],'color','b');
        matched(i,:) = [Ipts1(i).x, Ipts1(i).y, Ipts2(cor2(i)).x,Ipts2(cor2(i)).y]; 
      end
end
 matched(all(matched==0,2),:) = []; %ɾ��ȫ����
%%%%%%%%%%%%%%%%%%%%%%%%%1024ͼ���²����Ժ���ʾҪ�Ŵ�4��%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % Show the best matches
%   for i=1:length(Ipts1)
%       if (minD(i)<errTH)
%         c=rand(1,3);  %���ڻ���ͬ��ɫͼ [ 0.1933,    0.0263,    0.4688];
%         plot([Ipts1(i).x*sss Ipts2(cor2(i)).x*sss+size(I1,2)],[Ipts1(i).y*sss Ipts2(cor2(i)).y*sss],'-','Color',c)
%         plot([Ipts1(i).x*sss Ipts2(cor2(i)).x*sss+size(I1,2)],[Ipts1(i).y*sss Ipts2(cor2(i)).y*sss],'o','Color',c,'MarkerSize',8)
%         text([Ipts1(i).x*sss Ipts2(cor2(i)).x*sss+size(I1,2)],[Ipts1(i).y*sss Ipts2(cor2(i)).y*sss],[num2str(i)],'color','b');
%         matched(i,:) = [Ipts1(i).x, Ipts1(i).y, Ipts2(cor2(i)).x,Ipts2(cor2(i)).y]; 
%       end
%   end