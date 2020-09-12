%% Show image before and after HOSVD or TSVD
% 
% I is the orginal image.
% Variable k is truncated index.
% Variable method tells weather to use hosvd(1) or tsvd(2) method.
%
function truncated_images = image_before_and_after( I, k, method )

    %% HOSVD
    if method == 1
        
        [l, m, n] = size(I);
        
        % HOSVD
        [S, U1, U2, U3] = hosvd(I)
        
        truncated_images = fold(U1 * S, 1, l, m, n);
        truncated_images = fold(U2 * unfold(truncated_images,2), 2, l, m, n);
        truncated_images = fold(U3 * unfold(truncated_images,3), 3, l, m, n);
        
        for i = 1: size(I, 3)
            image( I(:,:,i) );  
            disp(i)
            image( squeeze(truncated_images(:,:,i)) );  
        end
    end    
    
    %% TSVD
    if method == 2
      
        [l, m, n] = size(I);
    
        % Matrix M represents mean image.
        M = zeros(l, m);

        for i = 1 : n
            L(:, i, :) = I(:, :, i);
            % Sum all images in one matrix M (mean image)
            % plus_minus function for big images 
            % M + I(:, :, i)
            M = plus_minus(M, I(:, :, i), 1);
        end

        % Mean image
        M = 1/n * M; 

        % Tensor A is mean-deviation form of L
        for i = 1 : n
            % L(:, j, :) - M
            A(:, i, :) = plus_minus(squeeze( L(:, i, :) ), M, 2) ; 
        end

        % TSVD
        U = tsvd(A);
        
        % Transposed U with truncated second dimension
        tU = tensor_transpose( U(:, 1:k, :) );

        % C - projecting a centered image onto a space with a smaller dimension
        C = tensor_tensor_product_fft( tU, A );
    
        ortho = tensor_tensor_product_fft( U(:,1:k,:), tU );
        truncated_images = tensor_tensor_product_fft( ortho, A );
        for i = 1: size(I, 3)
            image( I(:,:,i) ); 
            disp(i)
            image( squeeze(truncated_images(:,i,:)) );  
        end
        
    end


end

%% PLUS - MINUS FUNCTION 
% For bigger matrices - error?
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
