clear;
clc
for n = 2
    switch n    
        case 1
        file_path='.\LOLdataset\eval15\low\'
        dataset = 'LOL'
        case 2
        file_path='.\MEFdataset\'
        dataset = 'MEF'
        
    end

    %file_path='.\LOLdataset\eval15\low'
    
    
    
    
    img_path_list = dir(strcat(file_path,'*.PNG'));
    img_num = length(img_path_list);
    I=cell(1,img_num);
    
    if img_num > 0
        for j = 1:img_num %Read images one by one
            image_name = img_path_list(j).name; % 
            image =  imread(strcat(file_path,image_name));  
            I{j}=image;
            fprintf('%d %s\n',j,strcat(file_path,image_name));
            for m =6
                switch m
                    case 1
                        % M1_1 haze removal algorithms 
                        AInv = imcomplement(I{j});
                        BInv = imreducehaze(AInv);
                        enhancement = imcomplement(BInv);
                        output_path=['.\enhancement\' dataset '\M2_1']
                    case 2
                        %2. imreducehaze Use optional parameters for better results
                        AInv = imcomplement(I{j});
                        BInv = imreducehaze(AInv);
                        BInv = imreducehaze(AInv, 'Method','approx','ContrastEnhancement','boost');
                        enhancement = imcomplement(BInv);
                        output_path=['.\enhancement\' dataset '\M2_2']
                    case 3
                        %3. Use a different color space to reduce color distortion 

                        Lab = rgb2lab(I{j});
                        LInv = imcomplement(Lab(:,:,1) ./ 100);
                        LEnh = imcomplement(imreducehaze(LInv,'ContrastEnhancement','none'));
                        LabEnh(:,:,1)   = LEnh .* 100;
                        LabEnh(:,:,2:3) = Lab(:,:,2:3) * 2; % Increase saturation
                        enhancement = lab2rgb(LabEnh);
                        clear LabEnh;
                        output_path=['.\enhancement\' dataset '\M2_3']
                    case 4
                        %4. Improve results with noise cancellation of M1_1
                        AInv = imcomplement(I{j});
                        BInv = imreducehaze(AInv);
                        BImp = imcomplement(BInv);
                        enhancement = imguidedfilter(BImp);
                        output_path=['.\enhancement\' dataset '\M2_4']
    
                    case 5
                        %5. Improve results with noise cancellation of M1_2
                        AInv = imcomplement(I{j});
%                         BInv = imreducehaze(AInv);
                        BInv = imreducehaze(AInv, 'Method','approx','ContrastEnhancement','boost');
                        BImp = imcomplement(BInv);
                        enhancement = imguidedfilter(BImp);
                        output_path=['.\enhancement\' dataset '\M2_5']
                    case 6
                        %6. Improve results with noise cancellation of M1_3
                        Lab = rgb2lab(I{j});
                        LInv = imcomplement(Lab(:,:,1) ./ 100);
                        LEnh = imcomplement(imreducehaze(LInv,'ContrastEnhancement','none'));
                        LabEnh(:,:,1)   = LEnh .* 100;
                        LabEnh(:,:,2:3) = Lab(:,:,2:3) * 2; % Increase saturation
                        BImp = lab2rgb(LabEnh);
                        enhancement = imguidedfilter(BImp);
                        clear LabEnh;
                        output_path=['.\enhancement\' dataset '\M2_6']
                end
    
                if ~exist(output_path,'dir')
                    mkdir(output_path);
                end
        
                figure;
                montage({I{j},enhancement},Size=[1 3],BorderSize=5,BackgroundColor="w");
                
                pathfilename_new=fullfile(output_path,image_name);
                imwrite(enhancement,pathfilename_new);
                figure;
        %         imshow(BInv);
        %         pathfilename_new=fullfile(output_path,image_name);
        %         saveas(gcf,pathfilename_new);
                close all
            end
        end
    end
end