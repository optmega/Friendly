//
//  FRFriendsEventsInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 03.07.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRFriendsEventsPresenter.h"
#import "FRFriendsEventsDataSource.h"
#import "BSHudHelper.h"


@interface FRFriendsEventsPresenter () <FRFriendsEventsDataSourceDelegate>

@property (nonatomic, strong) FRFriendsEventsDataSource* tableDataSource;

@end

@implementation FRFriendsEventsPresenter

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.tableDataSource = [FRFriendsEventsDataSource new];
        self.tableDataSource.delegate = self;
    }
    return self;
}

- (void)configurePresenterWithUserInterface:(UIViewController<FRFriendsEventsViewInterface>*)userInterface
{
    self.userInterface = userInterface;
    [self.userInterface updateDataSource:self.tableDataSource];
    [self.interactor loadData];
}


#pragma mark - Output

- (void)dataLoaded
{
    [self.tableDataSource setupStorage];
}

- (void)showHudWithType:(FRFriendsEventsHudType)type title:(NSString*)title message:(NSString*)message
{
    [BSHudHelper showHudWithType:(BSHudType)type view:self.userInterface title:title message:message];
}

- (void)eventUpdated
{
    [self.userInterface updatedEvents];
}

- (void)userProfileLoaded:(UserEntity*)user
{
    [self.wireframe presentUserProfile:user];
}

#pragma mark - Module Interface

- (void)backSelected
{
    [self.wireframe dismissFriendsEventsController];
}

- (void)updateOldEventWithCount:(NSInteger)countEvents
{
    [self.interactor updateOldEvent:countEvents];
}

- (void)updateNewEvent
{
    [self.interactor updateNewEvent];
}

- (void)selectedFriendsInvite
{
    
}
- (void)updateRequestStatus {
}

- (void)userPhotoSelected:(NSString*)userId
{
    [self.interactor selectedUserId:userId];
}

- (void)joinSelectedWithEventId:(NSString*)eventId andModel:(FREvent*)event
{
    [self.wireframe presentJoinController:event];
}

- (void)selectedShareEvent:(FREvent*)event
{
    [self.wireframe presentShareControllerWithEvent:event];
}

- (void)selectedEvent:(FREvent*)event fromFrame:(CGRect)frame
{
    [self.wireframe presentEventController:event fromFrame:frame];
}

- (void)selectedFriend:(UserEntity*)user {
    [self.wireframe presentUserProfile:user];
}

- (void)updateAvailableFriends:(NSInteger)count {
    [self.interactor updateAvailableFriends:count];
}

- (void)showAddUsers {
    [self.wireframe showAddUser];
}

@end
