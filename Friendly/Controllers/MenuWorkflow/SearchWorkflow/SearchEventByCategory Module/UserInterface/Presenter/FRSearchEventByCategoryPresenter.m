//
//  FRSearchEventByCategoryInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 24.04.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRSearchEventByCategoryPresenter.h"
#import "FRSearchEventByCategoryDataSource.h"
#import "BSHudHelper.h"


@interface FRSearchEventByCategoryPresenter () <FRSearchEventByCategoryDataSourceDelegate>

@property (nonatomic, strong) FRSearchEventByCategoryDataSource* tableDataSource;
@property (nonatomic, strong) NSString* category;

@end

@implementation FRSearchEventByCategoryPresenter

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.tableDataSource = [FRSearchEventByCategoryDataSource new];
        self.tableDataSource.delegate = self;
    }
    return self;
}

- (void)configurePresenterWithUserInterface:(UIViewController<FRSearchEventByCategoryViewInterface>*)userInterface category:(NSString*)category
{
    self.category = category;
    self.userInterface = userInterface;
    [self.userInterface updateDataSource:self.tableDataSource];
    [self.userInterface updateSaerchBarText:category];
    [self.interactor loadEventWithString:category];
    [self.interactor loadData];
    
    self.tableDataSource.tableView = [self.userInterface tableView];
}

-(void) updateRequestStatusWithModel:(FREventModel*)event
{
    event.request_status = @"1";
    [self.tableDataSource reloadModel:event];
    [self.interactor loadEventWithString:self.category];
    [self.interactor loadData];
//    [self.userInterface updateDataSource:self.tableDataSource];
}

#pragma mark - Output

- (void)dataLoaded
{
    [self.tableDataSource setupStorage];
}

- (void)showHudWithType:(FRSearchEventByCategoryHudType)type title:(NSString*)title message:(NSString*)message
{
    [BSHudHelper showHudWithType:(BSHudType)type view:self.userInterface title:title message:message];
}

- (void)loadedEvents:(NSArray*)eventList users:(NSArray *)users
{
    [self.tableDataSource updateStorageWithEvents:eventList users:users];
    [self.userInterface updateDataSource:self.tableDataSource];
    
}

- (void)userPhotoSelected:(NSString*)userId
{
    [self.wireframe showUserProfileController:userId];
}

- (void)showEventPreviewWithEvent:(FREvent *)event fromFrame:(CGRect)frame
{
    [self.wireframe showEventPreviewWithEvent:event fromFrame:frame];
}

- (void)selectedEvent:(FREvent*)event fromFrame:(CGRect)frame
{
    [self.wireframe showEventPreviewWithEvent:event fromFrame:frame];
}

- (void)shareEvent:(FREventModel *)event
{
    [self.wireframe showShareController:event];
}

- (void)joinSelectedWithEventId:(NSString*)eventId andModel:(FREventModel*)event
{
    [self.wireframe presentJoinController:eventId event:event];

}

- (void)settingSelected
{
    [self.wireframe presentFilterController];
}

- (void)showUserProfile:(UserEntity *)user {
    [self.wireframe presentUserProfile: user];
}

#pragma mark - Module Interface

- (void)backSelected
{
    [self.wireframe dismissSearchEventByCategoryController];
}

- (void)searchBar:(NSString*)string
{
    [self.interactor loadEventWithString:string];
}

- (void)selectedDiscoverPeopleWithTag:(NSString*)tag
{
    [self.wireframe presentSearchDiscoverPeopleControllerWithTag:tag];
}

- (void)selectedEvent:(FREvent*)event
{
    [self.wireframe presentPreviewEvent:event];
}

@end
