load data.txt

%this is just a tool to see obvious trends but not really good for much
%else. Will work for any 16 dimensional system but can be mins
figure
for ii = 1:16
subplot(4,4,ii)
%can switch with any variable just type data1.variablename
scatter(data1.GT_Turb_DSC,data1{:,ii})
title(data1.Properties.VariableNames{ii})
xlabel('DSC')
end;

%Tall arrays are for data that doesn't fit into memory also works best with
%binscatter[ot
data3 = tall(data)
%Does a principal components analysis, score(:,1) calls the first principal
%component, score(:,2) calls the second
[coeff, score, latent] = pca(data3)

% Plot the individual and cumulative variance explained by PCA components
figure
plot([cumsum(latent(1:10))/sum(latent) latent(1:10)/sum(latent)]*100,'o');
xlabel('Number of Principal Components','FontSize', 12);
ylabel('Explained Variance [%]','FontSize', 12);
legend({'Cumulative','Individual'},'FontSize', 12);
title('Individual and Cumulative Variance Explained by PCA','FontSize', 12);

figure
%50/50 meanshow many different bins you want, the higher the number the
%more bins
binScatterPlot(score(:,1),score(:,2), [50,50])
xlabel('First PC')
ylabel('Second PC');

%uses the principal components to see how the points with certain Decay
%coefficients affect the data
goodDSC = data1.GT_Comp_DSC == 1
badDSC = data1.GT_Comp_DSC == .98
gooddsctall = score(goodDSC,1:2)
baddsctall = score(badDSC,1:2)
%gathers into local memory
[gooddsc1, baddsc1] = gather(gooddsctall, baddsctall)
figure
hold on
%plots the good data in blue and bad in red
plot(gooddsc1(:,1), gooddsc1(:,2),'.','MarkerSize',16)
plot(baddsc1(:,1), baddsc1(:,2),'r.','MarkerSize',16)
legend('goodDSC', 'badDSC')
xlabel('First PCA')
ylabel('second PCA');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%makes normalizes the data and put it into a tall array
[normdata,PS] = mapminmax(data,-1,1);
normdatatall = tall(normdata);


%Does a principal components analysis, score(:,1) calls the first principal
%component, score(:,2) calls the second
[coeff, score, latent] = pca(normdatatall);

% Plot the individual and cumulative variance explained by PCA components
figure
plot([cumsum(latent(1:10))/sum(latent) latent(1:10)/sum(latent)]*100,'o');
xlabel('Number of Principal Components','FontSize', 12);
ylabel('Explained Variance [%]','FontSize', 12);
legend({'Cumulative','Individual'},'FontSize', 12);
title('Individual and Cumulative Variance Explained by PCA','FontSize', 12);

figure
%50/50 meanshow many different bins you want, the higher the number the
%more bins
binScatterPlot(score(:,1),score(:,2), [50,50])
xlabel('First PC')
ylabel('Second PC');

%uses the principal components to see how the points with certain Decay
%coefficients affect the data
goodDSC = data1.GT_Comp_DSC == 1
badDSC = data1.GT_Comp_DSC == .98
gooddsctall = score(goodDSC,1:2)
baddsctall = score(badDSC,1:2)
%gathers into local memory
[gooddsc1, baddsc1] = gather(gooddsctall, baddsctall)
figure
hold on
%plots the good data in blue and bad in red
plot(gooddsc1(:,1), gooddsc1(:,2),'.','MarkerSize',16)
plot(baddsc1(:,1), baddsc1(:,2),'r.','MarkerSize',16)
legend('goodDSC', 'badDSC')
xlabel('First PCA')
ylabel('second PCA');

[l, h] = size(data)

for r = 1:l
if data(r, 18) < .98
normdata(r, 18) = 0;
else
normdata(r, 18) = 1;
end
end

 N = size(normdata,1)  % total number of rows
tf = false(N,1)    % create logical index vector
tf(1:round(p*N)) = true
tf = tf(randperm(N))   % randomise order
dataTraining = normdata(tf,:)
dataTesting = normdata(~tf,:);

dataTestingWithResponse = dataTesting
dataTesting(:,18) = [];

[trainedClassifier, validationAccuracy] = trainClassifier(dataTraining)

yfit = trainedClassifier.predictFcn(dataTesting)

[l, h] = size(dataTesting)

wrong = 0

right = 0

for r = 1:l
if dataTestingWithResponse(r, 18) == yfit(r,1)
right = right + 1;
else
wrong = wrong + 1;
end
end