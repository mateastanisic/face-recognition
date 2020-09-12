%% Function that shows vieo before and after TSVD application on video tensor
%
% Variable filename is string that represents path to .avi video
% k is truncation index
% Function returns original tensor, and tensor withapplicated tsvd - for
% storage usage and quicker reruning showing of result.
%
function [videoTensor, videoTSVDTensor ] = video_before_and_after_tsvd( filename, k )
    
    %% LOAD VIDEO TO TENSOR
    obj = VideoReader(filename);
    vid = read(obj);
 
    mImage=obj.Width;  
    nImage=obj.Height;
    frames = obj.NumberOfFrames; %moze se staviti i manje ako je video predug

    videoTensor = zeros(nImage, mImage, frames, 'uint8');
    for x = 1 : frames
        videoTensor(:, :, x) = vid(:, :, 1, x);
    end
    
    videoTensor = rot90(videoTensor); 
    videoTensor = flipud(videoTensor);
      
    niftiwrite(videoTensor,filename);    
    
    %% DO THE TSVD
    [l, m, n] = size(videoTensor)
 
    % Matrix M represents mean image.
    M = zeros(l, m);
  
    for i = 1 : n
        L(:, i, :) = videoTensor(:, :, i);
        % Sum all images in one matrix M (mean image)
        % plus
        M = plus_minus(M, videoTensor(:, :, i), 1);
    end
    
    % Mean image
    M = 1/n * M; 
    
    % Tensor A is mean-deviation form of L
    for i = 1 : n
        % minus
        A(:, i, :) = plus_minus(squeeze( L(:, i, :) ), M, 2) ; 
    end
    
    % TSVD
    U = tsvd(A); 
    
    % Transposed U with truncated second dimension
    tU = tensor_transpose( U(:, 1:k, :) );
    
    ortho = tensor_tensor_product_fft( U(:,1:k,:), tU );
    truncated_video = tensor_tensor_product_fft( ortho, A );

    for i = 1 : size(truncated_video, 2)
        videoTSVDTensor(:,:,i) = truncated_video(:,i,:);
    end 
    
    show_3dtensors(videoTensor,videoTSVDTensor)
end

%% PLUS - MINUS FUNCTION
function C = plus_minus(A, B, w)
    if w == 1
        for i = 1 : size(A,1)
            for j = 1: size(A,2)
                C(i,j) = A(i,j) + B(i,j);
            end
        end
    elseif w == 2
        for i = 1 : size(A,1)
            for j = 1: size(A,2)
                C(i,j) = A(i,j) - B(i,j);
            end
        end          
    end

end

