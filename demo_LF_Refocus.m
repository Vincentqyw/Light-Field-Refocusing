
%% This is a demo of light field refocusing
% input: LF 
% ouput: refocused pinhole image
% Writen by: Vincent Qin
% Data: 2018 May 17th 21:35:14

%% Note: the input is 5D LF data  decoded from Matlab Light field Toolbox

clc;

addpath(genpath(pwd));
%% mex function
cd('src'); 
mex REMAP2REFOCUS_mex.c 
mex BLOCKMEAN_mex.c 
cd ..

use_vincent_data=1;

if use_vincent_data
    disp('Downloading LF data, please wait...');

    URL='http://p8vl2tjcq.bkt.clouddn.com/LF.mat';
    [f, status] = urlwrite(URL,'input/LF_web.mat');
    if status == 1;
        fprintf(1,'Success£¡\n');
    else
        fprintf(1,'Failed£¡\n');
    end
    load('input/LF_web.mat');
else
    load('input/your_LF_data.mat');
end

disp('Processing LF to Remap image...');

LF=LF(:,:,:,:,1:3);
[UV_diameter,~,y_size,x_size,c]=size(LF);

%  get LF remap and pinhole image before refocusing
LF_Remap = LF2Remap(LF);
% IM_Refoc_1 = zeros(y_size, x_size,3);temp = zeros(y_size, x_size);
% BLOCKMEAN_mex(x_size, y_size, UV_diameter, LF_Remap(:,:,1), temp);IM_Refoc_1(:,:,1)=temp;
% BLOCKMEAN_mex(x_size, y_size, UV_diameter, LF_Remap(:,:,2), temp);IM_Refoc_1(:,:,2)=temp;
% BLOCKMEAN_mex(x_size, y_size, UV_diameter, LF_Remap(:,:,3), temp);IM_Refoc_1(:,:,3)=temp;

% get params
LF_x_size = x_size * UV_diameter;
LF_y_size = y_size * UV_diameter;
UV_radius = (UV_diameter-1)/2;
UV_size   = UV_diameter*UV_diameter;

% collect data
LF_parameters       = struct(...
                             'LF_x_size',LF_x_size,...
                             'LF_y_size',LF_y_size,...
                             'x_size',x_size,...
                             'y_size',y_size,...
                             'UV_radius',(UV_diameter-1)/2,...
                             'UV_diameter',UV_diameter,...
                             'UV_size',UV_diameter*UV_diameter) ;

% predefine output
LF_Remap_alpha   = zeros(LF_y_size,LF_x_size,3) ;
IM_Refoc_alpha   = zeros(y_size,x_size,3)       ;

% here begins refocusing
disp('Processing refocusing...');
alpha=0.5;    %¡¡shearing number
REMAP2REFOCUS_mex(x_size,y_size,UV_diameter,UV_radius,LF_Remap,LF_Remap_alpha,IM_Refoc_alpha,alpha);  

% show figure
central_view=squeeze(LF(UV_radius+1,UV_radius+1,:,:,:));
figure; imshow(central_view);
title('central view');set(gcf,'color',[1 1 1]);  
figure; imshow(IM_Refoc_alpha);
title(['refocused image pinhole at alpha = ' num2str(alpha)]);
set(gcf,'color',[1 1 1]);  

% concat them
concatImg=[central_view,IM_Refoc_alpha];
figure;imshow(concatImg);set(gcf,'color',[1 1 1]); 
imwrite(concatImg,'concatImg.png');

