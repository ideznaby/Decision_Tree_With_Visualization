function result=entropy(classVec)
% Calculates entropy of given vector
	totLen=length(classVec);
	class=1;
	subLen=length(find(classVec==class));
    logVal = 0;
	while(class<=3)
        if subLen ~= 0
            logVal(class)=-(subLen/totLen)*log2(subLen/totLen);
        end
        class=class+1;
        subLen=length(find(classVec==class));
	end
result=sum(logVal);
