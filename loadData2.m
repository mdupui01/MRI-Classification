%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Custom code to load the NIfTI data into MatLab. This code is fairly
% straightforward and redundant. It loads the data according to slices
% chosen and returns an NxM matrix where N is the number of images and M
% the number of voxels selected.
%
% This script relies on the naming of the data. Has to be changed if data
% name isn't structured as
% 'ADNIBeneQUALITY0000_oriented_norm_EXTENSION.nii' where QUALITY is Pass
% or Fail, 0000 is the number of the images and EXTENSION indicates the
% section of the images (Brain, background etc.)
%
% load_nii is a script built by a user to load NIfTI images into MatLab and
% shared on the MatLab exchange forum.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [trainData] = loadData2(Quality,section,totNum,slices)

if Quality == 'Pass'
    
    indexes = [1:1000];
    N2 = totNum; % Number of train images to load
    trainImageIndex = indexes(1:N2);
    slices = slices;

    trainData = zeros(totNum,length(slices)*182*218+1);

    if section == 'Brai'
        extension = 'MNI_brain.nii.gz';
    elseif section == 'Full'
        extension = 'MNI.nii.gz';
    elseif section == 'Back'
        extension = 'MNI_background_morphedImage.nii.gz';
    elseif section == 'Insk'
        extension = 'MNI_brain_outskin.nii.gz';
    end
    
    trainDataTemp = cell(1,N2);
    for n = 1:N2

        X = trainImageIndex(n);

        if X < 10
        temp = load_nii(['ADNIReplacement000' num2str(X) '_oriented_norm_',extension]);
        trainDataTemp{n} = temp.img(:,:,slices);
        trainData(n,:) = [trainDataTemp{n}(:)' 10000];
        end
        if X < 100 && X >= 10
        temp = load_nii(['ADNIReplacement00' num2str(X) '_oriented_norm_',extension]);
        trainDataTemp{n} = temp.img(:,:,slices);
        trainData(n,:) = [trainDataTemp{n}(:)' 10000];
        end
        if X >= 100
        temp = load_nii(['ADNIReplacement0' num2str(X) '_oriented_norm_',extension]);
        trainDataTemp{n} = temp.img(:,:,slices);
        trainData(n,:) = [trainDataTemp{n}(:)' 10000];
        end

    end
end

if Quality == 'Fail'
    
    indexes = [1:1000];
    N2 = totNum; % Number of train images to load
    trainImageIndex = indexes(1:N2);
    slices = slices;

    trainData = zeros(totNum,length(slices)*182*218+1);
    
    if section == 'Brai'
        extension = 'MNI_brain.nii.gz';
    elseif section == 'Full'
        extension = 'MNI.nii.gz';
    elseif section == 'Back'
        extension = 'MNI_background_morphedImage.nii.gz';
    elseif section == 'Insk'
        extension = 'MNI_brain_outskin.nii.gz';
    end
    
    trainDataTemp = cell(1,N2);
    for n = 1:N2

        X = trainImageIndex(n);

        if X < 10
        temp = load_nii(['ADNIBeneFail000' num2str(X) '_oriented_norm_',extension]);
        trainDataTemp{n} = temp.img(:,:,slices);
        trainData(n,:) = [trainDataTemp{n}(:)' 10000];
        end
        if X < 100 && X >= 10
        temp = load_nii(['ADNIBeneFail00' num2str(X) '_oriented_norm_',extension]);
        trainDataTemp{n} = temp.img(:,:,slices);
        trainData(n,:) = [trainDataTemp{n}(:)' 10000];
        end
        if X >= 100
        temp = load_nii(['ADNIBeneFail0' num2str(X) '_oriented_norm_',extension]);
        trainDataTemp{n} = temp.img(:,:,slices);
        trainData(n,:) = [trainDataTemp{n}(:)' 10000];
        end

    end
    
end

trainData = double(trainData);

end