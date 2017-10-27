%This is our machine learning code, it calls a function called
%trainClassifier which was made using the app classification learner

%load the data
load data.txt;

%normalizes the data
[normdata,PS] = mapminmax(data,-1,1);

%Finds the amount of rows and collumns of the data
[l, h] = size(data);
%adds all the decay coefficients
sum = 0;
for r = 1:l
sum = sum + data(r,18)
end;

%finds the average of all the decay coefficients
Avg = sum/l;

%Checks the decay coefficients of the original data and puts a 1 if it's
%above average and a 0 if it is below average
for r = 1:l
if data(r, 18) < Avg
normdata(r, 18) = 0;
else
normdata(r, 18) = 1;
end
end

%p is the percentage of the code that you want to train
p = .7;
%this randomizes the data so that if the order matters according to the
%data it doesn't effect the outcome. Then it splits the data into two data
%sets for training and testing
tf = false(l,1)    % create logical index vector
tf(1:round(p*l)) = true
tf = tf(randperm(l))   % randomise order
dataTraining = normdata(tf,:)
dataTesting = normdata(~tf,:);

%Saves the original testing data and then eliminates the last collumn
dataTestingWithResponse = dataTesting
dataTesting(:,18) = [];

%Machine learns with the function we have made
[trainedClassifier, validationAccuracy] = trainClassifier(dataTraining)

%Uses a function created by the classifier that takes in a data array with
%one less collumn than the data array that it was trained with. The output
%is what the classifier thinks the system should be classified as. "1" for
%above average and "2" for below average
yfit = trainedClassifier.predictFcn(dataTesting)

%For iteration purposes, length and counters
[l, h] = size(dataTesting)
wrong = 0
right = 0

%It checks the output of the classifier compared to the actual answers. If
%the classifier got it right it increments right, if the classifier got it
%wrong it increments wrong
for r = 1:l
if dataTestingWithResponse(r, 18) == yfit(r,1)
right = right + 1;
else
wrong = wrong + 1;
end
end

%Tells you how much it got right and wrong and the accuracy
right
wrong
right/l