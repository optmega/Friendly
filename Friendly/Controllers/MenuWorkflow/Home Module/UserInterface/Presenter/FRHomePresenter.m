//
//  FRHomeInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 01.07.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRHomePresenter.h"
#import "FRHomeDataSource.h"
#import "BSHudHelper.h"


@interface FRHomePresenter () <FRHomeDataSourceDelegate>

@property (nonatomic, strong) FRHomeDataSource* tableDataSource;

@end

@implementation FRHomePresenter

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.tableDataSource = [FRHomeDataSource new];
        self.tableDataSource.delegate = self;
    }
    return self;
}

- (void)configurePresenterWithUserInterface:(UIViewController<FRHomeViewInterface>*)userInterface
{
    self.userInterface = userInterface;
    [self.userInterface updateDataSource:self.tableDataSource];
    [self.interactor loadData];
}

- (void)reloadData
{
    [self.userInterface updatedEvents];
}

#pragma mark - Output

- (void)dataLoaded
{
    [self.tableDataSource setupStorage];
}

- (void)showHudWithType:(FRHomeHudType)type title:(NSString*)title message:(NSString*)message
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

- (void)featuredLoaded:(NSArray *)eventEntitys
{
    BSDispatchBlockToMainQueue(^{
        
        [self.userInterface updateFeatured:eventEntitys];
    });
}

- (void)updateRequestStatus {
    
}
#pragma mark - Module Interface

- (void)backSelected
{
    [self.wireframe dismissHomeController];
}

- (void)updateOldEvent
{
    [self.interactor updateOldEvent];
}

- (void)updateNewEvent
{
    [self.interactor updateNewEvent];
}

- (void)showFilter
{
    [self.wireframe presentFilterController];
}

- (void)showFriendsEvents
{
    [self.wireframe presentFriendsEventsController];
}

- (void)showSearchEvents
{
    [self.wireframe presentSearchController];
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

- (void)showAddFriends {
    [self.wireframe showAddFriendsController];
}

- (void)willApear {
    [self.interactor willApear];
}

@end
