FNames = {'leaves_gray.jpg';
          'flower_pot_gray.jpg';
          'orchid_gray.jpg'};
   
      
for p=1 : size(FNames)
    figH = figure;
    pic = imread(FNames{p});
    subplot(3,2,1), imshow(pic,[0 255]);
    title('original image');
    
    numofpixels = size(pic,1)*size(pic,2);
    hPic = zeros(size(pic));
    freq = zeros(256,1);
    probf = zeros(256,1);
    probc = zeros(256,1);
    cum = zeros(256,1);
    output = zeros(256,1);
    
    for i=1:size(pic,1)
        for j=1:size(pic,2)
            value = pic(1,j);
            freq(value+1) = freq(value+1)+1;
            probf(value+1) = freq(value+1)/numofpixels;
        end
    end
    
    sum = 0;
    num_bins=255;
            
    
    for i=1:size(probf)
        sum=sum+freq(i);
        cum(i) = sum;
        probc(i)=cum(i)/numofpixels;
        output(i)=round(probc(i)*num_bins);
    end
    c_before = output;
    for i=1:size(pic,1)
        for j=1:size(pic,2)
            hPic(i,j)=output(pic(i,j)+1);
        end
    end
    subplot(3,2,2), imshow(hPic,[0 255]);
    title('hist equalized image');
    
    
    subplot(3,2,3),plot(pic);
    title('original histogram');
    subplot(3,2,4),plot(hPic);
    title('equalized hist');
    subplot(3,2,5),plot(c_before);
    title('orignal cumu hist');
    %subplot(3,2,6),plot(c_after);
    %title('equalized cumu hist');
    
    baseName = FNames{p}(1:find(FNames{p}=='.')-1);
    figName = strcat(baseName, '_histogram_eq_results.jpg');
    
    print(figH,'-djpeg',figName);
end