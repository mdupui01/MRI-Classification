%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function for any choice of Shannon, Focus Criterion, Tsallis entropy or
% Differential Image entropy
% mode = SH, FC, TS or DE
% 
% Performs exactly what the R-script does with the only difference that the
% R script automatically returns all entropies.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [entrop] = entropyCalc2(data,mode,q)

k = hist(data',256); % The transpose is simply to put the data in a MatLab's natural format
k = k';
[W,L] = size(k);
sumK = repmat(sum(k),1,W);

    if mode == 'SH'

        loga = log2(k./sumK');
        loga(~isfinite(loga))=0;

        entrop = -sum(k./sumK'.*loga);

    elseif mode == 'FC'
        
        B = data;
        [W,L] = size(B);
        
        Bmax = sqrt(sum(B.^2,2));
        Bmax = repmat(Bmax,1,L);

        loga = log2(B./Bmax);
        loga(~isfinite(loga))=0;
        
        entrop = -sum((B./Bmax).*loga,2);

    elseif mode == 'TS'
        
        if q == 1
        loga = log2(k./sumK');
        loga(~isfinite(loga))=0;

        entrop = -sum(k./sumK'.*loga);
            
        else

            entrop = (1/(q-1))*(1-sum((k./sumK').^q));
        end
        
    elseif mode == 'DE'
        
        for r = 1:W
            
        [~,b] = hist(data(r,:)',256);
        
        entrop = log(sum(b.*k(r,:),2));
        temp2 = abs(entrop);
        
        entro(r) = temp2;
        entrop = entro;
        
        end

    end
   
end