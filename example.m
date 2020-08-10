
I = imread('example.png');
gray = rgb2gray(I);

radiuses = [4 8 16];
N = length(radiuses);

figure;
subplot(2, N+1, 1);
imshow(I);
title('Original');
for i = 1:N
    r = radiuses(i);
    J = kuwaharafilt(I, r);
    subplot(2, N+1, i+1);
    imshow(J);
    title(['r = ' num2str(r)]);
end

subplot(2, N+1, N+2);
imshow(gray);
title('Gray');
for i = 1:N
    r = radiuses(i);
    J = kuwaharafilt(gray, r);
    subplot(2, N+1, i+N+2);
    imshow(J);
    title(['r = ' num2str(r)]);
end
