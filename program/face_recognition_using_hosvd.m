%% Face recognition using HOSVD
%
% Varaible k is fixed truncated index.
% Variable p represents no. of images p of same person that will be
% contained in training set. Variable trainSet represents one of 50 testing sets
% possibilities for given p, ie one of 50 training sets.
%
% Variable average will return accuracy of face recognition for test images
% from database, and variable correct will return number of correct recognized faces.
%
function [correct, average] = face_recognition_using_hosvd(p, trainSet, k)
  
    %% Load data from database
    % I_train is tensor with dimensions: height x width x no. of training images
    % people_train is vector with identificaton which person is on image I_train(:, :, i) 
    % I_test is tensor with dimensions: height x width x no. of testing images
    % people_test is vector with identificaton which person is on image I_test(:, :, i) 
    [I_train, I_test, people_train, people_test] = prepare_data( p, trainSet );


    %% TRAIN
    % We need to sort people in train set, and then do the HOSVD for every person.
    for p = 1 : size(unique(people_train))
        
        % personTensor is tensor where every frontal slice represents one image.
        personTensor = I_train(:, :, people_train == p);

        % HOSVD
        [S, U1, U2] = hosvd(personTensor);
        
        [l, m, n] = size(S);

        % Calculatin Av = S(:,:,v) mod1 U1 mod2 U2
        for v = 1 : n
           Av{v} =  (U1 * S(:,:,v)) * U2'; 
        end
        Avs{p} = Av;
    end
    
    
    %% TEST
    correct = 0;
 
    for p = 1 : size(people_test)
        % Yet unknown image
        Z = I_test(:, :, p);
        
        % R represents array where value with some index i represents number of 
        % similaritiy between unknown face on image Z and with face of person i
        R = zeros( size(unique(people_train), 1) , 1 );

        % Normalize image Z
        Z = Z/norm(Z,'fro');
        
        % Calculate R(i) for every person i 
        for i = 1 : size( unique(people_train) )
            Av = Avs{i};
            sum = 0;
        
            k = min( k, n );
            for j = 1 : k
                % Normalize Av{j}
                nAv = Av{j}/norm(Av{j},'fro');
                sum = sum + trace( Z' * nAv )^2;
            end
            R(i) = 1 - sum;
        end
        
        % Face on unknown image is person i so that R(i) is the smallest in array R
        [~, person] = min(R);

        if person == people_test(p)
            correct = correct + 1;
        end
    
    end
    
    % Return accuracy
    average = correct / size(people_test,1);
end
