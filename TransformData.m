function [Z,SumLogdZ]= TransformData(SS,phi,ZNBC)

if ZNBC==0 %Indentity transformation
    Z=SS;   
    dZ=ones(size(SS));
    
elseif ZNBC==1      % Box-Cox transformation
    if phi~=0
        Z=(SS.^phi-1)/phi;
        dZ=SS.^(phi-1);
    elseif phi==0
        Z=log(SS);    
        dZ=1./SS;
    end
elseif ZNBC==2 %Squared root transformation
    Z=SS.^0.5;    
    dZ=ones(size(SS));
end

SumLogdZ=sum(log(abs(dZ))); %log of absolute of Jacobian

end