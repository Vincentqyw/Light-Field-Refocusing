function Remap_Construct=LF2Remap(LF,win_begin)


%% �ü����ڴ�С��ɣ���UV_diameter-win_begin��*��UV_diameter-win_begin��
%  ��win_begin=1ʱ���൱��ȡ����angular patch

if ~exist('win_begin','var')
    win_begin=1;
end


[N,~,x_size,y_size,~]=size(LF);
UV_diameter   = N      ;


win_end=UV_diameter-win_begin+1;     
step=UV_diameter-2*(win_begin-1);    
Remap_Construct=zeros(x_size*step,y_size*step,3);


for i=win_begin:win_end
    for j=win_begin:win_end     
        view=squeeze(LF(i,j,:,:,1:3));
        Remap_Construct((i-win_begin+1):step:x_size*step,...
                                     (j-win_begin+1):step:y_size*step,:)=view;
    end
end



