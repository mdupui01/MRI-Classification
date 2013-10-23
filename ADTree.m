clear all

% m = csvread('entropiesT120S4bis.csv');
% m1 = csvread('training1bis.csv');
m2 = csvread('split2.csv');

[L1,~] = size(m2);
m = m2(:,:);

[L,W] = size(m);

trainIndex = randperm(L);
m = m(trainIndex(1:L),:);

SHFull = 1;
SHBrain = 2;
SHInskull = 3;
FCFull = 4;
FCBrain = 5;
FCInskull = 6;
TSFull1 = 7;
TSFull2 = 8;
TSFull3 = 9;
TSFull4 = 10;
TSFull5 = 11;
TSFull6 = 12;
TSBrain1 = 13;
TSBrain2 = 14;
TSBrain3 = 15;
TSBrain4 = 16;
TSBrain5 = 17;
TSBrain6 = 18;
TSInskull1 = 19;
TSInskull2 = 20;
TSInskull3 = 21;
TSInskull4 = 22;
TSInskull5 = 23;
TSInskull6 = 24;
SHBack = 25;
FCBack = 26;
TSBack1 = 27;
TSBack2 = 28;
TSBack3 = 29;
TSBack4 = 30;
TSBack5 = 31;
TSBack6 = 32;
Q1 = 33;
SHBackMorph = 34;
FCBackMorph = 35;
TSBackMorph1 = 36;
TSBackMorph2 = 37;
TSBackMorph3 = 38;
TSBackMorph4 = 39;
TSBackMorph5 = 40;
TSBackMorph6 = 41;
Q1Morph = 42;

decision = zeros(length(1:L),10);

X = length(1:L);
for n = 1:X

    if m(n,TSBack2) < 2.378 % First branch
        decision(n,1) = 2.05;
    else
        decision(n,1) = -0.645;
        if m(n,FCFull) < 2615.45
            decision(n,3) = 0.615;
            if m(n,SHBackMorph) < 0.068
                decision(n,4) = -1.139;
            else
                decision(n,4) = 1.241;
            end
        else
            decision(n,3) = -0.731;
        end
        
        if m(n,TSInskull2) < 14.236
            decision(n,6) = -0.663;
        else
            decision(n,6) = 0.639;
        end
        
        if m(n,TSBrain3) < 1.961
            decision(n,9) = 0.419;
        else
            decision(n,9) = -0.475
        end
    end
    
    if m(n,FCBackMorph) < 387.695
        decision(n,2) = 0.823;
        if m(n,TSBrain2) < 12.688
            decision(n,5) = 1.157;
        else
            decision(n,5) = -0.288;
        end
        
        if m(n,Q1) < 64.869
            decision(n,7) = -0.047;
        else
            decision(n,7) = 0.873;
        end
    else
        decision(n,2) = -0.825;
        if m(n,FCFull) < 2661.15
            decision(n,8) = -0.385;
        else
            decision(n,8) = -0.698;
        end
    end
    
    if m(n,TSFull6) < 0.5
        decision(n,10) = 0.375;
    else
        decision(n,10) = -0.341;
    end
    
end

decision(:,11) = ones(368,1)*1.485;

% decision = decision + 1.42;
class = sign(sum(decision,2));

% falseNeg = abs(m(1:40,end) - class(1:40));
% falseNeg(falseNeg~=0) = 1;
% falseNeg = sum(falseNeg);
% falsePos = abs(m(40:end,end) - class(40:end));
% falsePos(falsePos~=0) = 1;
% falsePos = sum(falsePos);

C = 2;
for n = 1:X
    if m(n,SHFull)-5.977 < -std(m(:,SHFull))/C ||  m(n,SHFull)-5.977 > std(m(:,SHFull))/C% First branch
        flag(n,1) = 0;
    else
        flag(n,1) = 1;
    end
    
    
    
    if m(n,TSFull2)-12.031 < -std(m(:,TSFull2))/C || m(n,TSFull2)-12.031 > std(m(:,TSFull2))/C% Second branch
        flag(n,2) = 0;
    else
        flag(n,2) = 1;
    end
    
    
    
    if m(n,TSBack2)-3.008 < -std(m(:,TSBack2))/C || m(n,TSBack2)-3.008 > std(m(:,TSBack2))/C% Third branch
        flag(n,3) = 0;
    else
        flag(n,3) = 1;
    end
    
    
    
    if m(n,FCFull)-2629.45 < -std(m(:,FCFull))/C || m(n,FCFull)-2629.45 > std(m(:,FCFull))/C
        flag(n,4) = 0;
    else
        flag(n,4) = 1;
    end
    
end

for n = 1:X
    if sum(flag(n,:)) >= 3
        check(n) = trainIndex(n);
    else
        check(n) = 0;
    end
end

for n = 1:X
    if sign(m(n,end))~=class(n,:)
        miss(n,:) = 1;
        standardDevs(n,1) = (m(n,TSFull3)-2.762);
        standardDevs(n,2) = (m(n,TSFull2)-14.801);
        standardDevs(n,3) = (m(n,TSFull4)-1.171);
        standardDevs(n,4) = (m(n,TSFull2)-14.822);
        standardDevs(n,5) = (m(n,TSBrain3)-1.943);
        standardDevs(n,6) = (m(n,FCFull)-2579.75);
        standardDevs(n,7) = (m(n,FCInskull)-2484.75);
        standardDevs(n,8) = (m(n,TSBackMorph2)-0.799);
        standardDevs(n,9) = (m(n,TSInskull3)-2.606);
        standardDevs(n,10) = (m(n,TSFull2)-14.613);
        standardDevs(n,11) = 11223;
    else
        miss(n,:) = 0;
        standardDevs(n,1) = (m(n,TSFull3)-2.762);
        standardDevs(n,2) = (m(n,TSFull2)-14.801);
        standardDevs(n,3) = (m(n,TSFull4)-1.171);
        standardDevs(n,4) = (m(n,TSFull2)-14.822);
        standardDevs(n,5) = (m(n,TSBrain3)-1.943);
        standardDevs(n,6) = (m(n,FCFull)-2579.75);
        standardDevs(n,7) = (m(n,FCInskull)-2484.75);
        standardDevs(n,8) = (m(n,TSBackMorph2)-0.799);
        standardDevs(n,9) = (m(n,TSInskull3)-2.606);
        standardDevs(n,10) = (m(n,TSFull2)-14.613);
        standardDevs(n,11) = 66778;
    end
end

%%
header=['1,2,3,4,5,6,7,8,9,10, Class'];
outid = fopen('standardDevs_T120S4.csv', 'w+');
fprintf(outid, '%s', header);
fclose(outid);
dlmwrite ('standardDevs_T120S4.csv',standardDevs,'roffset',1,'-append')