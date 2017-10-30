%% Indicator Graph Test Code

% Takes graph with good and bad dsc and
% sets each point within three levels of danger:
% "OK, Warning, Alarm"

goodDSC = data1.GT_Comp_DSC == 1
badDSC = data1.GT_Comp_DSC == .98
gooddsctall = score(goodDSC,1:2)
baddsctall = score(badDSC,1:2)
%gathers into local memory
[gooddsc1, baddsc1] = gather(gooddsctall, baddsctall)

idxAlarm = score(:,1) > 10 | score(:,1) < -7 | score(:,2) > 5 | score(:,2) < -4;
idxWarn = score(:,1) > 5 | score(:,1) < -6.5 | score(:,2) > 2 | score(:,2) < -3 ...
    & ~idxAlarm;
    
figure 
hold on
patch([-10;-10;15;15;10;10;-7;-7;-10],...
    [-4,8,8,-4,-4,5,5,-4,-4], 'r', 'FaceAlpha',0.3)
patch([-7,-7,10,10,5,5,-6.5,-6.5,4.99,4.99,-6.5],...
    [-4,5,5,-4,-4,2,2,-3,-3,-4,-4],'y','FaceColor',[1 .8 0],'FaceAlpha',0.3)
patch([-6.5,-6.5,5,5,-6.5],[-3,2,2,-3,-3],'g','FaceAlpha',0.3)
plot(gooddsc1(:,1),baddsc1(:,2),'.')
hold off
