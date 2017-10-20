FNames={'leaves_gray.jpg';
    'flower_pot_gray.jpg';
    'orchid_gray.jpg'};

for p=1:size(FNames)
    pic =imread(FNames{p});
    numRows = size(pic, 1);
    numCols = size(pic, 2);
    
    %Horizontal & Vertical edge strength
    gx = zeros(numRows,numCols);
    gy = zeros(numRows,numCols);

    %Computation of the strength
    for i = 1 : numRows-1
        for j = 1 : numCols-1
            gx(i,j)=double(pic(i+1,j)) - double(pic(i,j));
            gy(i,j)=double(pic(i,j+1)) - double(pic(i,j));
        end
    end

    %Product of derivatives
    Ixx = gx.*gx;
    Ixy = gx.*gy;
    Iyy = gy.*gy;
    
    %Gaussian kernel of size 13
    fullwin = 13;
    gkern = gausswin(fullwin)*gausswin(fullwin).';

    %convolve
    Wxx = conv2(Ixx,gkern);
    Wxy = conv2(Ixy,gkern);
    Wyy = conv2(Iyy,gkern);
    
%How much larger is the size of the output matrix compared to the input
%matrices?: 12x12 (comparing pic & W size)

    %Compute eigenvalues of W
    wRow = size(Wxx, 1);
    wCol = size(Wxx, 2);
    eig_min = zeros(wRow,wCol);

    %get eig_min value of the matrix
    for i = 1 : wRow
        for j = 1 : wCol
            W = [Wxx(i,j) Wxy(i,j); Wxy(i,j) Wyy(i,j)];
            eig_min(i,j) = min(eig(W));
        end
    end

    %Divide matrix into mosaic of 13x13 regions
    mosaic = zeros(13,13);
    for i = 1 : (wRow/13-1)
        for j = 1 : (wCol/13-1)
            for y = 1 : 13
                for x = 1 : 13
                    mosaic(x,y) = eig_min(x+(i*13),y+(j*13));
                end
            end
            [x_coor,y_coor]= find(mosaic == (max(mosaic(:))));
            
            %keeping the higest values and set all others to 0
            for y = 1 : 13
                for x = 1 : 13
                    if  ~(y == y_coor & x == x_coor)
                        eig_min(x+(i*13),y+(j*13)) = 0;
                    end
                end
            end
        
        end
    end

    [sortedVal,sortedIndex] = sort(eig_min(:),'descend');
    y_peak = zeros(200,1);
    x_peak = zeros(200,1);

    for i = 1 : 200
        [x_peak(i,1),y_peak(i,1)]= find(eig_min == sortedVal(i));
    end
    
    %shifting back to original image 
    x_peak = x_peak - 6;
    y_peak = y_peak - 6;

    fig1=figure;
    imshow(pic,[]);
    title('Result');
    
    %ploting
    for i = 1 : 200
        rectangle('Position', [(y_peak(i,1)-6) (x_peak(i,1)-6) 13 13],'EdgeColor','red');
    end
    
    baseName = FNames{p}(1:find(FNames{p}=='.')-1);
    figResult=strcat(baseName,'_results.jpg');
    print(fig1,'-djpeg',figResult);
end

%No we didn't miss out the double summation as we did a product of derivatives & convolution of the
%matrix. 