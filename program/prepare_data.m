%% Load data from database
%
% I_train is tensor with dimensions: 
% image_hight x image_width x no. of training images
%
% people_train is vector with identificaton which person is on image I_train(:, :, i) 
%
% I_test is tensor with dimensions: 
% image_hight x image_width x no. of testing images
%
% people_test is vector with identificaton which person is on image I_test(:, :, i) 
%
% Variable p represents no. of images p of same person that will be
% contained in training set. Variable set represents one of 50 testing sets
% possibilities for given p, ie one of 50 training sets.
%
function [I_train, I_test, people_train, people_test] = prepare_data( p, set )
    
    % Adding paths
    addpath('database');
    path_to_set = strcat('database/EXTdataYaleDB/', int2str(p), 'Train/');
    addpath( path_to_set );
    
    yale = load('eYale_32x32.mat');
    trainSet = load( strcat( int2str(set), '.mat' ) );
    
    images = yale.fea;
    people = yale.gnd;

    % Varijable koje pamte koja slika predstavlja koju osobu
    people_train = people(trainSet.trainIdx, : );
    people_test = people(trainSet.testIdx, : );
    
    % Dimenzija (broj_osoba) x 1024
    % Zelimo tenzor dimenzija  32 x 32 x (broj_osoba)
    images_train = images(trainSet.trainIdx, : );
    images_test = images(trainSet.testIdx, : );
    
    % Zelimo tenzor I_train dimenzija  32 x 32 x (broj_train_osoba)
    broj_osoba = size(images_train, 1);
    for i = 1 : broj_osoba
        I_train(:, :, i) = (reshape( images_train( i, :), 32, 32))';
    end
    
    % Zelimo tenzor I_test dimenzija  32 x 32 x (broj_test_osoba)
    broj_osoba = size(images_test, 1);
    for i = 1 : broj_osoba
        I_test(:, :, i) = (reshape( images_test( i, :), 32, 32))';
    end
    
end