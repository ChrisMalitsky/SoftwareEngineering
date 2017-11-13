%% Load data

load data.txt

%% Create 1st plot

goodDSC = data1.GT_Comp_DSC == 1
badDSC = data1.GT_Comp_DSC == .98
gooddsctall = score(goodDSC,1:2)
baddsctall = score(badDSC,1:2)
%gathers into local memory
[gooddsc1, baddsc1] = gather(gooddsctall, baddsctall)

figure
hold on
%plots the good data in blue and bad in red
%plots different boxes around data indicating maintenance time
%Green = Normal, Yellow = Warning, Red = Alert
plot(gooddsc1(:,1), gooddsc1(:,2),'.','MarkerSize',16)
plot(baddsc1(:,1), baddsc1(:,2),'r.','MarkerSize',16)
patch([-1,-1,0.5,0.5],...
      [-1.2,0.6,0.6,-1.2], 'r', 'FaceAlpha',0.3) %Create Alert Box
patch([2,2,0.5,0.5,1,1,1.7,1.7],...
      [0.6,-1.2,-1.2,0.6,0.6,-1.1,-1.1,0.6],...
       'y','FaceColor',[1 .8 0],'FaceAlpha',0.3) %Create Warning Box
patch([1,1,1.7,1.7],...
      [-1.1,0.6,0.6,-1.1],'g','FaceAlpha',0.3) %Create Normal box
legend('goodDSC', 'badDSC', 'Alert', 'Warning', 'Normal')
xlabel('First PCA')
ylabel('second PCA')
hold off

%%%%TEST CODE BEYOND THIS POINT, DOES NOT WORK!!!%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Create second plot
% 
% goodDSC = data1.GT_Comp_DSC == 1
% badDSC = data1.GT_Comp_DSC == .98
% gooddsctall = score(goodDSC,1:2)
% baddsctall = score(badDSC,1:2)
% %gathers into local memory
% [gooddsc1, baddsc1] = gather(gooddsctall, baddsctall)
% 
% idxAlarm = score(:,1) > 10 | score(:,1) < -7 | score(:,2) > 5 | score(:,2) < -4;
% idxWarn = score(:,1) > 5 | score(:,1) < -6.5 | score(:,2) > 2 | score(:,2) < -3 ...
%     & ~idxAlarm;
%     
% figure 
% hold on
% patch([-10;-10;15;15;10;10;-7;-7;-10],...
%     [-4,8,8,-4,-4,5,5,-4,-4], 'r', 'FaceAlpha',0.3)
% patch([-7,-7,10,10,5,5,-6.5,-6.5,4.99,4.99,-6.5],...
%     [-4,5,5,-4,-4,2,2,-3,-3,-4,-4],'y','FaceColor',[1 .8 0],'FaceAlpha',0.3)
% patch([-6.5,-6.5,5,5,-6.5],[-3,2,2,-3,-3],'g','FaceAlpha',0.3)
% plot(gooddsc1(:,1),baddsc1(:,2),'.')
% hold off
% 
% %% Create third plot
% 
% goodDSC = data1.GT_Comp_DSC == 1
% badDSC = data1.GT_Comp_DSC == .98
% gooddsctall = score(goodDSC,1:2)
% baddsctall = score(badDSC,1:2)
% %gathers into local memory
% [gooddsc1, baddsc1] = gather(gooddsctall, baddsctall)
% 
% idxAlarm = score(:,1) > 10 | score(:,1) < -7 | score(:,2) > 5 | score(:,2) < -4;
% idxWarn = score(:,1) > 5 | score(:,1) < -6.5 | score(:,2) > 2 | score(:,2) < -3 ...
%     & ~idxAlarm;
%     
% figure 
% hold on
% patch([-1;-1;3;3;5;5;-5;-5;-5],...
%     [-4,3,3,-4,-4,5,5,-4,-4], 'r', 'FaceAlpha',0.3)
% patch([-3,-3,1,1,3,3,-1,-1,3,3,-4.5],...
%     [-4,5,5,-4,-4,2,2,-3,-3,-4,-4],'y','FaceColor',[1 .8 0],'FaceAlpha',0.3)
% patch([-6.5,-6.5,5,5,-6.5],[-3,2,2,-3,-3],'g','FaceAlpha',0.3)
% plot(gooddsc1(:,1),baddsc1(:,2),'.')
% hold off