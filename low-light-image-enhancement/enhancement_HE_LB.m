clear;
clc

%LOLdataset 1
%MEFdataset 2




for m = 1:2

    switch m
        case 1
            file_path='.\LOLdataset\eval15\low\'
            ref_path='.\LOLdataset\eval15\high\'
            output = '.\enhancement\LOL' 
        case 2
            file_path='.\MEFdataset\'
             output = '.\enhancement\MEF' 
    end


    %%%%%  origal image 
    img_path_list = dir(strcat(file_path,'*.PNG'));
    img_num = length(img_path_list);
    I=cell(1,img_num);
    
    
    %%%%%  target image 
    ref_path_list = dir(strcat(ref_path,'*.PNG'));
    ref_num = length(ref_path_list);
    
   % n = input('Enter a number: ');


    if img_num > 0   
        for j = 1:img_num %Read images one by one
            image_name = img_path_list(j).name; % 
            image =  imread(strcat(file_path,image_name));  
            I{j}=image;
            fprintf('%d %s\n',j,strcat(file_path,image_name));
            
            if m == 1 
                ref_name = ref_path_list(j).name;  
                ref =  imread(strcat(ref_path,ref_name));         
                R{j}=ref;
                %ref = im2double(ref);
            end
            amt = 0.5;
    
          
            for n = 1:3
                switch n    
                    case 1
                %%%%%%%% B1: Brighten the low-light image in proportion to the darkness of the local region
                    enhancement = imlocalbrighten(I{j});
                    %output_path='.\M1_HE_LB1';
                    output_path = fullfile(output,'.\M1_HE_LB1');
                    case 2
                %%%%%%%% B2: Brighten the original low-light image again and specify a smaller brightening amount
                    enhancement = imlocalbrighten(I{j},amt);
                    %output_path='.\M1_HE_LB2';
                    output_path = fullfile(output,'.\M1_HE_LB2');
                    case 3
                %%%%%%%% B3: Reduce oversaturation of bright regions, apply alpha blending when brightening the image
                    enhancement = imlocalbrighten(I{j},amt,AlphaBlend=true);
                    %output_path='.\M1_HE_LB3';
                    output_path = fullfile(output,'.\M1_HE_LB3');
                end
            %         imshow(B1);
            %         title("Image with Alpha Blending");
                if ~exist(output_path,'dir')
                    mkdir(output_path);
                end


                figure;
                montage({I{j},enhancement},Size=[1 2],BorderSize=5,BackgroundColor="w");
                
            %     ssimval{j} = ssim(enhancement, ref);
            %     fprintf('ssimval: %d\n',ssimval{j});
            %     mean_ssimval = mean(ssimval{j});
                
                pathfilename_new=fullfile(output_path,image_name);
                imwrite(enhancement,pathfilename_new);
                figure;
                subplot(1,2,1);
                imhist(I{j});
                title("Original Image");
                subplot(1,2,2);
                imhist(enhancement);
                title("Brightened Image");
                pathfilehist=fullfile(output_path,"hist_"+image_name);
                saveas(gcf,pathfilehist);
                close all;
            end
        end
    end
    
end

