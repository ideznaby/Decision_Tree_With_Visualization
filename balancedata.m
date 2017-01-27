function [ balanceddata ] = balancedata( data )
%BALANCEDATA removes extra instances of class 3 to match the number of
%instances in class 2
classthree = find(data(:,size(data,2)) == 3);
classtwo = find(data(:,size(data,2)) == 2);
randomperm = randperm(length(classthree));
rowstoremove = classthree(randomperm(1:length(classthree) - length(classtwo)));
balanceddata = removerows(data,'ind',rowstoremove);
size(balanceddata);
end

