clear;
clc
for n = 2
    switch n    
        case 1
        %file_path='.\LOLdataset\eval15\low'
        file_path='.\LOLdataset\eval15\low\'
        output_path='.\enhancement\LOL\M3_1 Retinex'
        dataset = 'LOL'
        case 2
        file_path='.\MEFdataset\'
        output_path='.\enhancement\MEF\M3_1 Retinex'
        dataset = 'MEF'
        
    end

    if ~exist(output_path,'dir')
        mkdir(output_path);
    end
    
    
    img_path_list = dir(strcat(file_path,'*.PNG'));
    img_num = length(img_path_list);
    I=cell(1,img_num);
    
    if img_num > 0
        for j = 1:img_num %Read images one by one
            image_name = img_path_list(j).name; % 
            image =  imread(strcat(file_path,image_name));  
            I{j}=image;
            fprintf('%d %s\n',j,strcat(file_path,image_name));
            %---
            img_in  = im2double(imread(strcat(file_path,image_name)));
            scales = [2 120 240];
            alpha = 500;
            d = 1.5;
            img_out = MSRCR(img_in,scales,[],alpha,d);
            pathfilename_new=fullfile(output_path,image_name);
            imwrite(img_out,pathfilename_new);
            close all;
            figure;
            subplot(1,2,1);
            imhist(I{j});
            title("Original Image");
            subplot(1,2,2);
            imhist(img_out);
            str_scales = ['scale=[',num2str(scales(1)),',',num2str(scales(2)),',',num2str(scales(3)),']'];
            str_alpha  = ['alpha=',num2str(alpha)];
            str_d  = ['contrast=',num2str(d)];
    %         title(["MSRCR Brightened Image",str_scales,',',str_alpha,',',str_d]);
            title("MSRCR Brightened Image");
            pathfilehist=fullfile(output_path,"hist_"+image_name);
            saveas(gcf,pathfilehist);
    %         imshow(BInv);
    %         pathfilename_new=fullfile(output_path,image_name);
    %         saveas(gcf,pathfilename_new);
            close all
        end
    end
end