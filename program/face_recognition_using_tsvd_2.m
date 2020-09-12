%% Face recognition using T-SVD - 2nd method
% 
% Varaible treshold is treshold for calculating k_i-s.
% Variable p represents no. of images p of same person that will be
% contained in training set. Variable set represents one of 50 testing sets
% possibilities for given p, ie one of 50 training sets.
%
% Variable acc will return accuracy of face recognition for test images
% from database.
%
function acc = face_recognition_using_tsvd_2(p, set, treshold)

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
    
    % TSVD 
    % we assume m is even - our case, with extended yale db it really is ( m = 32 )
    do_pola = m / 2 + 1;
    [A_, U, S] = tsvd_half(A);
    
    % Employ drop strategy 
    k = calculate_truncated_indices(S, treshold);
    
    % Printaout K, and calculated k_i-s
    K = sum(k) 
    k'
    
    % Keep only U^(i)(:, 1:k(i)) = U(:, 1 : k(i) , i )
    U_ = cut( U, k );
    
    % C
    for i = 1 : m

       for t = 1 : k(i)
          for j = 1 : n
             C( t, j, i ) =  U_{i}( :, t )' * A_( : , j, i );
          end
       end
       
    end
    
    
    %% TEST
    correct = 0;
    for p = 1 : size(I_test, 3)
        
        % Tetsing image J
        J = I_test( :, :, p );
        
        % T
        T( : , 1, : ) = J - M ;

        % B
        for i = 1 : m
       
            for t = 1 : k(i)
                B( t, i ) =   U_{i}( :, t )'  * T( : , 1, i );
            end
            
        end

        R = zeros(n,1);
        for j = 1 : n
            F = B - squeeze( C( :, j, : ) );
            R(j) = frobenius_norm( F ) ;
        end

        % Claiming that training image whose coefficient is closest to image J 
        % is the person on the image J 
        [~, person] = min(R);

        if people_train(person) == people_test(p)
            correct = correct + 1;
        end
    end
    
    % Return accuracy
    acc = correct / size(I_test, 3)
    
end

%% Cut second dimension to k(i) for every i = 1 : size(U, 2) 
function tensor = cut(U, k)
    m = size(U, 3);
    tensor{1} = U( :, 1 : k(1) , 1);
    
    for i = 2 : m
       tensor{i} = U( :, 1 : k(i) , i);
    end

end



%% Calculate truncated indices ki using eigenvalues 
function k = calculate_truncated_indices(S_, treshold)
    
    % Dimensions
    [l, n, m] = size(S_);
    do_pola = m / 2 + 1;
    min_ln = min(l, n);
    min_ln = do_pola;
    
    % Array with values k_i
    k = zeros(m, 1);
    
    % First, calculate the term on the right * treshold
    vece_od = 0;
    for i = 1 : do_pola
        for j = 1 : min_ln
            % Summing eigenvalues that are on diagonal of S
            vece_od = vece_od + ( abs(S_( j, j, i)) )^2;
        end
        
    end
    vece_od =  vece_od * treshold ;
    

    
    % Define array q with descending order of all 
    % (first m/2 + 1 of all frontal slices )  eigenvalues
    
    q = [];
    for i = 1 : do_pola
        svojstvene_vrijednosti = diag( abs(S_( 1 : min_ln, 1 : min_ln, i )) );
        q = [ q, (svojstvene_vrijednosti) ];
    end
    q = reshape( q, 1, size(q,1)*size(q,2) );
    q  = sort( q, 'descend' );
    
    
    %% FIND index t
    % by summing all singular values (^2) in q until condition has been met
    sum  = 0;
    for t = 1 : size( q, 2 )
        sum = sum + q(t)^2;
        if sum > vece_od
            break;
        end
        
    end
    
    % either we found t or t == size( q, 2)
    if t == size(q, 2)
      k = ones(m, 1) * l;
    else
      % We found t. Now we need to check how many eigenvalues from frontal slice 
      % i (for every i) are in array q(1:t-1). 
      % Possible bug -> two same eigenvalues on positions t and t-1 of array q.
      for i = 1 : do_pola
        svojstvene_vrijednosti = diag( abs(S_( 1 : min_ln, 1 : min_ln, i )) );
        for j = 2 : size( svojstvene_vrijednosti, 1 )
            if (svojstvene_vrijednosti(j)) <= q(t) 
                k(i) = j - 1;
                break;
            end
        end
        
        if k(i) == 0
            k(i) = size( svojstvene_vrijednosti, 1 );
        end
        
      end
      
      % Calculate rest.
      for i = do_pola + 1 : m
          k(i) = k( m - i + 2 );
      end
      
    end
end


%% Frobenius norm of a tensor
function result = frobenius_norm(A)
    result = 0;
    l = size(A,1);
    m = size(A,2);
    
    for i = 1: l
        for j = 1: m
            result = result + A(i,j)*A(i,j);
        end
    end
end
