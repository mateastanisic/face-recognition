%% Face recognition using TENSOR QR decomposition
%
% Varaible k is fixed truncated index.
% Variable p represents no. of images p of same person that will be
% contained in training set. Variable trainSet represents one of 50 testing sets
% possibilities for given p, ie one of 50 training sets.
%
% Variable acc will return accuracy of face recognition for test images
% from database.
%
function acc = face_recognition_using_qr(p, set, k)

    %% Load data from database
    % I_train is tensor with dimensions: height x width x no. of training images
    % people_train is vector with identificaton which person is on image I_train(:, :, i) 
    % I_test is tensor with dimensions: height x width x no. of testing images
    % people_test is vector with identificaton which person is on image I_test(:, :, i) 
    [I_train, I_test, people_train, people_test] = prepare_data( p, set );
    
    %% TRAIN
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
    for j = 1 : n
        A(:, j, :) = squeeze( L(:, j, :) ) - M ; 
    end
    
    % Tensor (pivoted) QR decomposition of A
    Q = tqr(A); 
    
    % transpose Q
    tQ = tensor_transpose( Q(:, 1:k, :) );
    
    % C - projecting a centered image onto a space with a smaller dimension
    C = tensor_tensor_product_fft( tQ, A );
    
    %% TEST
    correct = 0;
    for p = 1 : size(I_test, 3)
        
        % Tetsing image J
        J = I_test( :, :, p );
        
        % T
        T(:, 1, :) = J - M ;

        % B
        B = tensor_tensor_product_fft( tQ, T );
        B = squeeze(B);
        
        R = zeros(n,1);
        for j = 1 : n
            F = B - squeeze(C(:,j,:));
            R(j) = trace( F' * F );
        end

        % Claiming that training image whose coefficient is closest to image J 
        % is the person on the image J 
        [~, person] = min(R);

        if people_train(person) == people_test(p)
            correct = correct + 1;
        end
    end
    
    % Return accuracy
    acc = correct / size(I_test, 3);
    
end

