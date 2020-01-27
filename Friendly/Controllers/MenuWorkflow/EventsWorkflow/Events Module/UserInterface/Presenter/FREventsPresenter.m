//
//  FREventsInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 29.02.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FREventsPresenter.h"
#import "FREventsDataSource.h"
#import "BSHudHelper.h"


@interface FREventsPresenter () <FREventsDataSourceDelegate>

@property (nonatomic, strong) FREventsDataSource* tableDataSource;

@end

@implementation FREventsPresenter

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.tableDataSource = [FREventsDataSource new];
        self.tableDataSource.delegate = self;
    }
    return self;
}

- (void)configurePresenterWithUserInterface:(UIViewController<FREventsViewInterface>*)userInterface
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

- (void)featuredEventsLoaded:(FREventModels*)eventsModel
{
    [self.tableDataSource featuredModelsUpdate:eventsModel];
}

- (void)showHudWithType:(FREventsHudType)type title:(NSString*)title message:(NSString*)message
{
    [BSHudHelper showHudWithType:(BSHudType)type view:self.userInterface title:title message:message];
}


#pragma mark - JoinVCDelegate

-(void) updateRequestStatus
{
    [self.interactor updateEvents];
}

#pragma mark - Module Interface

- (void)backSelected
{
    [self.wireframe dismissEventsController];
}

- (void)showProfileVC
{
    [self.wireframe presentProfileController];
}

- (void)showFilter
{
    [self.wireframe presentFilterController];
}

- (void)selectedEvent:(FREventModel*)event image:(UIImage*)eventImage
{
    [self.wireframe presentPreviewControllerWithEvent:event image:eventImage];
}

- (void)updateEvents
{
    [self.interactor updateEvents];
}

- (void)selectedSegment:(NSInteger)segment
{
    [self.interactor updateEventsWithType:segment];
}

- (void)friendEventsLoaded:(FRFriendEventsModel*)eventModel
{
    [self.tableDataSource friendEventsUpdate:eventModel];
}

#pragma mark - DataSource

- (void)showUserProfile:(NSString *)userId
{
    [self.wireframe presentProfileUserControlletWithUserId:userId];
}

- (void)joinEventViewSelectedWithEventId:(NSString*)eventId andModel:(FREventModel *)event
{
    [self.wireframe presentJoinController:eventId];
}

- (void)shareEvent:(FREvent *)model
{
    [self.wireframe presentShareControllerWithEvent:model];
}

@end
