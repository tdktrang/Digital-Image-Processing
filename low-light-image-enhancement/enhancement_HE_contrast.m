clear;
clc

%file_path='.\LOLdataset\eval15\low'
% file_path='.\LOLdataset\eval15\low\'
% ref_path='.\LOLdataset\eval15\high\'





% n = input('Enter a number: ');

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

    img_path_list = dir(strcat(file_path,'*.PNG'));
    img_num = length(img_path_list);
    I=cell(1,img_num);
    
    ref_path_list = dir(strcat(ref_path,'*.PNG'));
    ref_num = length(ref_path_list);

    if img_num > 0
      
        for j = 1:img_num %Read origal images one by one
            image_name = img_path_list(j).name; % 
            image =  imread(strcat(file_path,image_name));  
            I{j}=image;
            fprintf('%d %s\n',j,strcat(file_path,image_name));
          
            if m == 1 
                ref_name = ref_path_list(j).name;  
                ref =  imread(strcat(ref_path,ref_name));         
                R{j}=ref;
                ref = im2double(ref);
                %fprintf('ref %d %s\n',j,strcat(file_path,image_name));
            end

            shadow_lab = rgb2lab(image);
            max_luminosity = 100;
            L = shadow_lab(:,:,1)/max_luminosity;
%             figure,imshow(shadow_lab);
%             title("covert to color space");
        
           for n = 1:3
                switch n
                    case 1
                        %%%%%%%%%    M3_1  %%%%%%%%%%%%
                        shadow_imadjust = shadow_lab;
                        shadow_imadjust(:,:,1) = imadjust(L)*max_luminosity;
                        shadow_imadjust = lab2rgb(shadow_imadjust);                       
                        enhancement = shadow_imadjust;
                        %output_path ='.\M1_HE_C1'
                        output_path = fullfile(output,'.\M1_HE_C1');
                    case 2    
                        %%%%%%%%%    M3_2  %%%%%%%%%%%%
                        shadow_histeq = shadow_lab;
                        shadow_histeq(:,:,1) = histeq(L)*max_luminosity;
                        shadow_histeq = lab2rgb(shadow_histeq);
                        enhancement = shadow_histeq;        
                       % output_path =  '.\M1_HE_C2'
                        output_path = fullfile(output,'.\M1_HE_C2');
                    case 3    
                        %%%%%%%%%    M3_3  %%%%%%%%%%%%
                        shadow_adapthisteq = shadow_lab;
                        shadow_adapthisteq(:,:,1) = adapthisteq(L)*max_luminosity;
                        shadow_adapthisteq = lab2rgb(shadow_adapthisteq);
                        enhancement = shadow_adapthisteq;
                        output_path = fullfile(output,'.\M1_HE_C3');
                       % output_path= '.\M1_HE_C3'
                 end
    
                if ~exist(output_path,'dir')
                    mkdir(output_path);
                end
        
                figure;
                montage({I{j},enhancement},Size=[1 2],BorderSize=5,BackgroundColor="w");
                title("Original Image              enhancenment image               target image ");
        
                
%                 ssimval{j} = ssim(enhancement, ref);
%                 fprintf('ssimval: %d\n',ssimval{j});
%                 mean_ssimval = mean(ssimval{j});
        
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

