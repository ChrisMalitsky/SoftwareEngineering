%This is our machine learning code, it calls a function called
%trainClassifier which was made using the app classification learner

disp('Running...')

%load the data
load data.txt;

%Counters to be used later
compWrong = 0;
compRight = 0;
turbWrong = 0;
turbRight = 0;

%Arrays used to store decay coefficients
compBelowAvgPoints = [];
compAvgPoints = [];
compAboveAvgPoints = [];
turBelowAvgPoints = [];
turAvgPoints = [];
turAboveAvgPoints = [];

%normalizes the data
[normdata,PS] = mapminmax(data,-1,1);

%Finds the amount of rows and columns of the data
[l, h] = size(data);

%Adds a new classification column
normdata(l,h+1) = 0;

%adds all the values for each respective decay coefficient
sumCompressorDecay = 0;
sumTurbineDecay = 0;
for r = 1:l
sumCompressorDecay = sumCompressorDecay + data(r,17);
sumTurbineDecay = sumTurbineDecay + data(r, 18);
end

%finds the average of all the decay coefficients
AvgCompressorDecay = sumCompressorDecay/l;
AvgTurbineDecay = sumTurbineDecay/l;

%finds the IQR and Median of all the decay coefficients
CompressorIQR = iqr(data(:,17));
TurbineIQR = iqr(data(:,18));
CompressorMedian = median(data(:,17));
TurbineMedian = median(data(:,18));

%Checks the Compressor decay coefficients of the original data and puts 
%a 1 if its above average and a 0 if it is below average

for r = 1:l;
 if data(r, 17) < CompressorMedian - (CompressorIQR/2)
        compBelowAvgPoints(r,:) = data(r,17);
        normdata(r, 19) = 0;
 elseif data(r, 17) < CompressorMedian + (CompressorIQR/2)
        compAvgPoints(r,:) = data(r,17);
        normdata(r, 19) = 1;
 else
        compAboveAvgPoints(r,:) = data(r,17);
        normdata(r, 19) = 2;
 end
end

%p is the percentage of the data that you want to train, leaving the 
%difference as the percentage of the data you want to test
p = .7;
%this randomizes the data so that if the order matters according to the
%data it doesn't effect the outcome. Then it splits the data into two data
%sets for training and testing
tf = false(l,1);    % create logical index vector
tf(1:round(p*l)) = true;
tf = tf(randperm(l));   % randomise order
dataTrainingCompressor = normdata(tf,:);
dataTestingCompressor = normdata(~tf,:);

%Saves the original testing data and then eliminates the last two columns
dataTestingWithResponse = dataTestingCompressor;
dataTestingCompressor(:,19) = [];
dataTestingCompressor(:,18) = [];
dataTestingCompressor(:,17) = [];

%For iteration purposes, length and counters
[l, h] = size(dataTestingCompressor);

%Machine learns with the function we have made in preperation to predict
%the Compressor coefficient
[trainedClassifier, validationAccuracy] = trainClassifier(dataTrainingCompressor);

%Uses a function created by the classifier that takes in a data array with
%one less collumn than the data array that it was trained with. The output
%is what the classifier thinks the system should be classified as. "1" for
%above average and "2" for below average
yfit = trainedClassifier.predictFcn(dataTestingCompressor);

%Follows the prediction procedure and determines how many times
%the prediction was correct
for r = 1:l
    if dataTestingWithResponse(r, 19) == yfit(r,1)
        compRight = compRight + 1;
    else
        compWrong = compWrong + 1;
    end
end

%Finds number of compressor decay coefficients have a value of 0, 1, 2.
comp0 = 0;
comp1 = 0;
comp2 = 0;

for r = 1:l
    if yfit(r,1) == 0
        comp0 = comp0 + 1;
    else
        if yfit(r,1) == 1
            comp1 = comp1 + 1;
        else
            if yfit(r,1) == 2
                comp2 = comp2 + 1;
            end
        end
    end
end

comp0Percent = (comp0/l) * 100;
comp1Percent = (comp1/l) * 100;
comp2Percent = (comp2/l) * 100;


%Checks the Turbine decay coefficients of the original data
%and tests it against the average and puts a 1 if it is above average 
%and a 0 if it is below average

for r = 1:l
    if data(r, 18) < TurbineMedian - TurbineIQR/2
        turBelowAvgPoints(r,:) = data(r,18);
        normdata(r, 19) = 0;
    elseif data(r,18) < TurbineMedian + TurbineIQR/2
        turAvgPoints(r,:) = data(r,18);
        normdata(r,19) = 1;
    else
        turAboveAvgPoints(r,:) = data(r,18);
        normdata(r,19) = 2;
    end
end

dataTrainingTurbine = normdata(tf,:);
dataTestingTurbine = normdata(~tf,:);

%Saves the original testing data and then eliminates the last two columns
dataTestingWithResponse = dataTestingTurbine;
dataTestingTurbine(:,19) = [];
dataTestingTurbine(:,18) = [];
dataTestingTurbine(:,17) = [];

%Machine learns with the function we have made in preperation to predict
%the Compressor coefficient
[trainedClassifier, validationAccuracy] = trainClassifier(dataTrainingTurbine);

%Uses a function created by the classifier that takes in a data array with
%one less collumn than the data array that it was trained with. The output
%is what the classifier thinks the system should be classified as. "1" for
%above average and "2" for below average
yfit = trainedClassifier.predictFcn(dataTestingTurbine);

%Follows the testing procedure and counts how many times the prediction
%was correct in regards to the Turbine decay coefficient
for r = 1:l
    if dataTestingWithResponse(r, 19) == yfit(r,1)
        turbRight = turbRight + 1;
    else
        turbWrong = turbWrong + 1;
    end
end

%Displays how many times the compressor prediction was right and wrong
compRight;
compWrong;

%Displays how many times the turbine prediciton was right and wrong
turbRight;
turbWrong;

%Determines the accuracy for the compressor and turbine predictions
accComp = compRight/l;
accTurb = turbRight/l;

%Displays the compressor and turbine predictions
accComp;
accTurb;

fprintf('\nCompressor decay coefficient prediction ----> Correct: %d     Wrong: %d\n',compRight,compWrong)
fprintf('Turbine decay coefficient prediction ----> Correct: %d     Wrong: %d\n',turbRight,turbWrong)
fprintf('\nCompressor decay Prediction Accuracy: %f\n', accComp)
fprintf('Turbine decay Prediction Accuracy: %f\n', accTurb)
fprintf('Compressor decay coefficients: \n')
fprintf('Bad Points: \n');
disp(size(compBelowAvgPoints));
fprintf('Average Points: \n');
disp(size(compAvgPoints));
fprintf('Good Points: \n');
disp(size(compAboveAvgPoints));
fprintf('Turbine decay coefficients: \n');
fprintf('Bad Points: \n');
disp(size(turBelowAvgPoints));
fprintf('Average Points: \n');
disp(size(turAvgPoints));
fprintf('Good Points: \n');
disp(size(turAboveAvgPoints));

%Finds number of turbine decay coefficients have a value of 0, 1, 2.
turb0 = 0; 
turb1 = 0;
turb2 = 0;

for r = 1:l
    if yfit(r,1) == 0
        turb0 = turb0 + 1;
    else
        if yfit(r,1) == 1
            turb1 = turb1 + 1;
        else
            if yfit(r,1) == 2
                turb2 = turb2 + 1;
            end
        end
    end
end

turb0Percent = (turb0/l) * 100;
turb1Percent = (turb1/l) * 100;
turb2Percent = (turb2/l) * 100;
%% Creates pie graph for Compressor Decay
figure('Name','Compressor Decay','NumberTitle','off')
X = [comp0,comp1,comp2];
compLabels = {'DANGER: ','On the way: ', 'Fine: '};
cPercentages = {num2str(comp0Percent),num2str(comp1Percent),num2str(comp2Percent)};
cText = strcat(compLabels,cPercentages);
pie(X,cText);
colormap([1 0 0;      %// red
          1 1 0;      %// yellow
          0 1 0;])    %// green
%% Creates pie graph for Turbine Decay
figure('Name','Turbine Decay','NumberTitle','off')
Y = [turb0,turb1,turb2];
turbLabels = {'DANGER: ','On the way: ', 'Fine: '};
tPercentages = {num2str(turb0Percent),num2str(turb1Percent),num2str(turb2Percent)};
tText = strcat(turbLabels,tPercentages);
pie(Y,tText);
colormap([1 0 0;      %// red
          1 1 0;      %// yellow
          0 1 0;])    %// green