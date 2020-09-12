%% Face recognition using tensor SVD with fixed truncated index k
% 
% Varaible k is fixed truncated index.
% Variable p represents no. of images p of same person that will be
% contained in training set. Variable set represents one of 50 testing sets
% possibilities for given p, ie one of 50 training sets.
%
% Variable acc will return accuracy of face recognition for test images
% from database.
%
function acc = face_recognition_using_tsvd_1( p, set, k )

    %% Load data from database
    % I_train is tensor with dimensions: height x width x no. of training images
    % people_train is vector with identificaton which person is on image I_train(:, :, i) 
    % I_test is tensor with dimensions: height x width x no. of testing images
    % people_test is vector with identificaton which person is on image I_test(:, :, i) 
    [I_train, I_test, people_train, people_test] = prepare_data( p, set );
    
    %% TRAIN
    [ U, M, A ] = train(I_train);
    
    % Transposed U with truncated second dimension
    tU = tensor_transpose( U(:, 1:k, :) );

    % C - projecting a centered image onto a space with a smaller dimension
    C = tensor_tensor_product_fft( tU, A );
    
    ortho = tensor_tensor_product_fft( U(:,1:k,:), tU );
    truncated_images = tensor_tensor_product_fft( ortho, A );
    %for i = 1: size(people_train)
    %    image( squeeze(truncated_images(:,i,:)) );
    %    disp(i)
    %end
    
    
    %% TEST
    acc = test(I_test, people_train, people_test, M, C, tU, ortho, truncated_images);

end

%% TRAIN
%
% Training images I_train, i = 1, 2, 3, ..., n
% There are n images with dimension of l x m.
%
function [ U, M, A ] = train(I_train)
    [l, m, n] = size(I_train);
    
    % Matrix M represents mean image.
    M = zeros(l, m);
  
    for i = 1 : n
        L(:, i, :) = I_train(:, :, i);
        % Sum all images in one matrix M (mean image)
        M = M + I_train(:, :, i);
    end
    
    % Mean image
    M = 1/n * M; 
    
    % Tensor A is mean-deviation form of L
    for i = 1 : n
        A(:, i, :) = squeeze( L(:, i, :) ) - M ; 
    end
    
    % TSVD
    U = tsvd(A); 

end


%% TEST
%
function acc = test(I_test, people_train, people_test, M, C, tU, ortho, truncated_images )
    
    n = size(I_test, 3);

    correct = 0;
    for p = 1 : n
                
        % Tetsing image J
        J = I_test( :, :, p );
        %image(J)
        
        % T
        T(:,1,:) = J - M ;
        
        % Truncated image
        truncated_image = tensor_tensor_product_fft(ortho,T);
        %image(squeeze(truncated_image))
        
        % B
        B = tensor_tensor_product_fft( tU, T );
        B = squeeze(B); 
        
        R = zeros(size(people_train,1),1);
        for j = 1 : size(people_train)
            F = B - squeeze(C(:,j,:)) ;
            R(j) = trace( F' * F );
        end
        % Claiming that training image whose coefficient is closest to image J 
        % is the person on the image J 
        [~, person] = min(R);

        if people_train(person) == people_test(p)
            correct = correct + 1;
        %else
        %    image(J)
        %    image(squeeze(truncated_image))
        %    person
        %    people_train(person)
        %    people_test(p)
        %    disp(1)
        end
        
    end
    
    acc = correct / n;
    
end