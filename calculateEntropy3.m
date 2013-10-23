clear all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is the main script that calls all the other custom built functions.
% It performs the following steps in order:
% - Load data using loadData2()
% - Threshold data at 120 (only full and background images)
% - Calculate the entropies using entropyCalc()
% - Store all the values in a variable called export
% - export the data as a .csv
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Select the number of pass and fail images along with the slices to
% select. In this code the images are not shuffled (it was built to load
% all images)
numberPass = 268;
numberFail = 2;
slices = 80:83;

% Section to load the data
passBrain = loadData2('Pass','Brai',numberPass,slices);
passFull = loadData2('Pass','Full',numberPass,slices);
passBackground = loadData2('Pass','Back',numberPass,slices);
% passInskull = loadData2('Pass','Insk',numberPass,slices);
fprintf('Load Pass Checkpoint\n') % fprintf points are just to see the progress of the script

passBrain = double(passBrain./repmat(max(passBrain')',1,length(passBrain(1,:))));
passFull = passFull./repmat(max(passFull')',1,length(passFull(1,:)));
passBackground = passBackground./repmat(max(passBackground')',1,length(passBackground(1,:)));
passInskull = passInskull./repmat(max(passInskull')',1,length(passInskull(1,:)));

for m = 1:numberPass
    passBrain(m,:) = histeq(passBrain(m,:));
    passFull(m,:) = histeq(passFull(m,:));
    passBackground(m,:) = histeq(passBackground(m,:));
    passInskull(m,:) = histeq(passInskull(m,:));
end

failBrain = loadData2('Fail','Brai',numberFail,slices);
failFull = loadData2('Fail','Full',numberFail,slices);
failBackground = loadData2('Fail','Back',numberFail,slices);
failInskull = loadData2('Fail','Insk',numberFail,slices);
fprintf('Load Fail Checkpoint\n')

failBrain = failBrain./repmat(max(failBrain')',1,length(failBrain(1,:)));
failFull = failFull./repmat(max(failFull')',1,length(failFull(1,:)));
failBackground = failBackground./repmat(max(failBackground')',1,length(failBackground(1,:)));
failInskull = failInskull./repmat(max(failInskull')',1,length(failInskull(1,:)));

for m = 1:numberFail
    failBrain(m,:) = histeq(failBrain(m,:));
    failFull(m,:) = histeq(failFull(m,:));
    failBackground(m,:) = histeq(failBackground(m,:));
    failInskull(m,:) = histeq(failInskull(m,:));
end

%% Section to set the threshold and calculate the entropies
% Note that the threshold is only applied to full and background images
threshold = 120;
passBackground(passBackground<threshold)= 0;
failBackground(failBackground<threshold)= 0;
passFull(passFull<threshold)= 0;
failFull(failFull<threshold)= 0;
fprintf('Thresholding Checkpoint\n')

%% Section to calculate the entropy criterions
% entropyCalc() is a custom built function that has three inputs: image
% data, type of entropy to calculate and q if the entropy is Tsallis

entBackPass = zeros(numberPass,1);
entCritBackPass = zeros(numberPass,1);
entFullPass = zeros(numberPass,1);
entCritFullPass = zeros(numberPass,1);
entBrainPass = zeros(numberPass,1);
entCritBrainPass = zeros(numberPass,1);
entInskullPass = zeros(numberPass,1);
entCritInskullPass = zeros(numberPass,1);

entBackFail = zeros(numberFail,1);
entCritBackFail = zeros(numberFail,1);
entFullFail = zeros(numberFail,1);
entCritFullFail = zeros(numberFail,1);
entBrainFail = zeros(numberFail,1);
entCritBrainFail = zeros(numberFail,1);
entInskullFail = zeros(numberFail,1);
entCritInskullFail = zeros(numberFail,1);

for m=1:numberPass
    entBackPass(m,1) = entropyCalc2(passBackground(m,:),'SH');
    entCritBackPass(m,1) = entropyCalc2(passBackground(m,:),'FC');
    entFullPass(m,1) = entropyCalc2(passFull(m,:),'SH');
    entCritFullPass(m,1) = entropyCalc2(passFull(m,:),'FC');
    entBrainPass(m,1) = entropyCalc2(passBrain(m,:),'SH');
    entCritBrainPass(m,1) = entropyCalc2(passBrain(m,:),'FC');
    entInskullPass(m,1) = entropyCalc2(passInskull(m,:),'SH');
    entCritInskullPass(m,1) = entropyCalc2(passInskull(m,:),'FC');
end
fprintf('Pass images checkpoint\n')

for m = 1:numberFail
    entBackFail(m,1) = entropyCalc2(failBackground(m,:),'SH');
    entCritBackFail(m,1) = entropyCalc2(failBackground(m,:),'FC');
    entFullFail(m,1) = entropyCalc2(failFull(m,:),'SH');
    entCritFullFail(m,1) = entropyCalc2(failFull(m,:),'FC');
    entBrainFail(m,1) = entropyCalc2(failBrain(m,:),'SH');
    entCritBrainFail(m,1) = entropyCalc2(failBrain(m,:),'FC');
    entInskullFail(m,1) = entropyCalc2(failInskull(m,:),'SH');
    entCritInskullFail(m,1) = entropyCalc2(failInskull(m,:),'FC');
end
fprintf('Fail images checkpoint\n')
sizePass = size(passBackground);
sizeFail = size(failBackground);

entTsaBackPass = zeros(sizePass(1),6);
entTsaFullPass = zeros(sizePass(1),6);
entTsaBrainPass = zeros(sizePass(1),6);
entTsaInskullPass = zeros(sizePass(1),6);

entTsaBackFail = zeros(sizeFail(1),6);
entTsaFullFail = zeros(sizeFail(1),6);
entTsaBrainFail = zeros(sizeFail(1),6);
entTsaInskullFail = zeros(sizeFail(1),6);

% A loop is used for the Tsallis entropy because it runs through 6
% different values.
m=0;
for n = 1:6
    
    values = 0.001:0.6:3.001;
    q = values(n);
    
    for m = 1:numberPass
        entTsaBackPass(m,n) = entropyCalc2(passBackground(m,:), 'TS',q);
        entTsaFullPass(m,n) = entropyCalc2(passFull(m,:), 'TS',q);
        entTsaBrainPass(m,n) = entropyCalc2(passBrain(m,:), 'TS',q);
        entTsaInskullPass(m,n) = entropyCalc2(passInskull(m,:), 'TS',q);
    end
    for m = 1:numberFail
        entTsaBackFail(m,n) = entropyCalc2(failBackground(m,:), 'TS',q);
        entTsaFullFail(m,n) = entropyCalc2(failFull(m,:), 'TS',q);
        entTsaBrainFail(m,n) = entropyCalc2(failBrain(m,:), 'TS',q);
        entTsaInskullFail(m,n) = entropyCalc2(failInskull(m,:), 'TS',q);
    end
    m = m + 1;
    fprintf('m = %i\n',m);
    
end
fprintf('Entropy Tsallis Checkpoint\n')

for m = 1:numberPass
    passBackgroundQ1(m,1) = mean(passBackground(m,:));
    fprintf('Q1 Pass Checkpoint\n')
end

for m = 1:numberFail
    failBackgroundQ1(m,1) = mean(failBackground(m,:));
    fprintf('Q1 Fail Checkpoint\n')
end

%% Section to concatenate entropy form all images in a single variable: export

entTsaFail = [entTsaBackFail];
entropyfail = [entBackFail entCritBackFail entTsaFail failBackgroundQ1];

entTsaPass = [entTsaBackPass];
entropypass = [entBackPass entCritBackPass entTsaPass passBackgroundQ1];

% This section labels the rows as pass or fail. The reason they are labeled
% either 11223 or 66778 is because I was having trouble having Weka
% recognize 1 or -1 as a class and I couldn't export strings mixed with
% variables. This should be possible and should be fixed if this script is
% to be used more.
export = [entropyfail ones(sizeFail(1),1)*11223; entropypass ones(sizePass(1),1)*66778];

% csvwrite('entropies.csv',exportData);
%% Section to export data as .csv
header=['SH Back,SH Full, SH Brain, SH Inskull, FC Back, FC Full, FC Brain, FC Inskull, TS Back1, TS Back2, TS Back3, TS Back4, TS Back5, TS Back6, TS Full1, TS Full2, TS Full3, TS Full4, TS Full5, TS Full6, TS Brain1, TS Brain2, TS Brain3, TS Brain4, TS Brain5, TS Brain6, TS Inskull1, TS Inskull2, TS Inskull3, TS Inskull4, TS Inskull5, TS Inskull6, Q1, Class'];
outid = fopen('temp120_morphed_background_replacement.csv', 'w+');
fprintf(outid, '%s', header);
fclose(outid);
dlmwrite ('temp120_morphed_background_replacement.csv',export,'roffset',1,'-append')
