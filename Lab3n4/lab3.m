

close all
clear all

FNames={'leaves_gray.jpg';
    'flower_pot_gray.jpg';
    'orchid_gray.jpg'};

 for p=1:size(FNames)
    pic =imread(FNames{p});
    numberRows = size(pic, 1);
    numberCols = size(pic, 2);
    hPic = zeros(numberRows,numberCols);
    h = zeros(256,1);
    h_stretch = zeros(256,1);

    for i = 1 : numberRows
        for j = 1 : numberCols
            hPic(i,j) = round((double(pic(i,j))-10)/140*255);
            if hPic(i,j) < 0
                hPic(i,j) = 0;
            end
            if hPic(i,j) >255
                hPic(i,j) = 255;
            end
            h(pic(i,j)+1) = h(pic(i,j)+1) + 1;
            h_stretch(hPic(i,j)+1) = h_stretch(hPic(i,j)+1) + 1;
        end
    end
  
    edgeH = zeros(numberRows,numberCols);
    edgeV = zeros(numberRows,numberCols);
    edgeStr = zeros(numberRows,numberCols);
    
    filterH = [-1 0 1; -1 0 1; -1 0 1];
    filterV = [-1 -1 -1; 0 0 0; 1 1 1];
        
    for i = 2: numberRows-1
        for j = 2 : numberCols -1;
            smallWindow = [hPic(i-1,j-1) hPic(i,j-1) hPic(i+1,j-1);
                           hPic(i-1,j) hPic(i,j) hPic(i+1,j);
                           hPic(i-1,j+1) hPic(i,j+1) hPic(i+1,j+1)];
%           smallWindow already double
            edgeH(i,j) = double((sum(sum(filterH.*smallWindow))));
            edgeV(i,j) = double((sum(sum(filterV.*smallWindow))));
            edgeStr(i,j) = round(sqrt(edgeH(i,j).^2 + edgeV(i,j).^2));
        end
    end
        
    figH=figure;
    subplot(2,3,1),imshow(pic,[0 255]);
    title('original image');
    subplot(2,3,2),imshow(hPic,[0 255]);
    title('stretched image');
    subplot(2,3,3),imshow(edgeStr,[0 255]);
    title('edge strength image');
    subplot(2,3,4),plot(h);
    title('original histogram');
    subplot(2,3,5),plot(h_stretch);
    title('stretched histogram');
    
    baseName = FNames{p}(1:find(FNames{p}=='.')-1);
    figName=strcat(baseName,'_stretch_edge_results.jpg');
    
    print(figH,'-djpeg',figName);
 end